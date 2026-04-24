#!/usr/bin/env python3

import argparse
import csv
import os
import re
import shlex
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SUITE_INPUT_NAME = "suite_input.txt"
SUITE_EXPECTED_NAME = "suite_expected.txt"
DEFAULT_COVERAGE_SKIP = "-"

CASE_METRIC_RE = re.compile(r"\[[A-Z_]+\]\[CASE_METRIC\]\s+launch_cycle=(\d+)\s+done_cycle=(\d+)\s+cycles=(\d+)")
POWER_RE = re.compile(
    r"\[[A-Z_]+\]\[POWER\].*A_nz=(\d+)/(\d+)\s+B_nz=(\d+)/(\d+)\s+active_mac=(\d+)/(\d+)\s+zero_gated=(\d+)\s+skip_ratio=([0-9.]+)%"
)
PASS_RE = re.compile(r"\[[A-Z_]+\]\[PASS\]\s+(\S+)")
FAIL_RE = re.compile(r"\[[A-Z_]+\]\[FAIL\]\s+(\S+)")


class GateCaseResult(object):
    def __init__(
        self,
        stage,
        case,
        status,
        input_path,
        expected_path,
        launch_cycle,
        done_cycle,
        cycles,
        a_nz,
        a_total,
        b_nz,
        b_total,
        active_mac,
        total_mac,
        zero_gated,
        skip_ratio_pct,
        run_log,
        vcd_path,
    ):
        self.stage = stage
        self.case = case
        self.status = status
        self.input_path = input_path
        self.expected_path = expected_path
        self.launch_cycle = launch_cycle
        self.done_cycle = done_cycle
        self.cycles = cycles
        self.a_nz = a_nz
        self.a_total = a_total
        self.b_nz = b_nz
        self.b_total = b_total
        self.active_mac = active_mac
        self.total_mac = total_mac
        self.zero_gated = zero_gated
        self.skip_ratio_pct = skip_ratio_pct
        self.run_log = run_log
        self.vcd_path = vcd_path


def die(message):
    raise SystemExit(message)


def use_color():
    return sys.stdout.isatty() and os.environ.get("TERM", "") not in {"", "dumb"}


class Color(object):
    if use_color():
        BOLD = "\033[1m"
        GREEN = "\033[32m"
        RED = "\033[31m"
        RESET = "\033[0m"
    else:
        BOLD = GREEN = RED = RESET = ""


def color_status(ok):
    if ok:
        return "{}{}PASS{}".format(Color.BOLD, Color.GREEN, Color.RESET)
    return "{}{}FAIL{}".format(Color.BOLD, Color.RED, Color.RESET)


def env_or_die(name):
    value = os.environ.get(name, "").strip()
    if not value:
        die("Missing required environment variable: {}".format(name))
    return value


def resolve_path(raw):
    path = Path(raw)
    return path if path.is_absolute() else (ROOT / path).resolve()


def split_path_list(raw):
    return [item for item in raw.split() if item]


def parse_suite_case_names(path):
    case_names = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("CASE "):
            _, case_name = line.split(None, 1)
            case_names.append(case_name.strip())
    return case_names


def discover_cases(vector_dir):
    suite_input = vector_dir / SUITE_INPUT_NAME
    suite_expected = vector_dir / SUITE_EXPECTED_NAME
    if suite_input.exists() and suite_expected.exists():
        return [(case_name, suite_input.resolve(), suite_expected.resolve()) for case_name in parse_suite_case_names(suite_input)]

    cases = []
    for input_path in sorted(vector_dir.glob("*_input.txt")):
        case_name = input_path.stem[:-6]
        expected_path = vector_dir / "{}_expected.txt".format(case_name)
        cases.append((case_name, input_path.resolve(), expected_path.resolve()))
    return cases


def vcs_env():
    env = os.environ.copy()
    license_file = env.get("VCS_LICENSE_FILE")
    if license_file:
        env["SNPSLMD_LICENSE_FILE"] = license_file
        env["SYNOPSYS_LICENSE_FILE"] = license_file
        env["LM_LICENSE_FILE"] = license_file
    return env


def run(cmd, cwd, env, check=True):
    result = subprocess.run(cmd, cwd=str(cwd), universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env)
    if check and result.returncode != 0:
        raise subprocess.CalledProcessError(result.returncode, cmd, output=result.stdout, stderr=result.stderr)
    return result


def prepare_gate_netlist(netlist_path, output_dir):
    text = netlist_path.read_text(encoding="utf-8", errors="ignore")
    replacements = 0

    def replace_icg_test_pin(match):
        nonlocal replacements
        replacements += 1
        return ".SE(1'b0)"

    prepared_text = re.sub(r"\.SE\s*\(\s*TE\s*\)", replace_icg_test_pin, text)
    prepared_path = output_dir / "prepared_gate_netlist.v"
    prepared_path.write_text(prepared_text, encoding="utf-8")

    if replacements:
        sys.stderr.write(
            "INFO: tied {} unconnected clock-gating test-enable pins low in {}\n".format(
                replacements, prepared_path
            )
        )

    return prepared_path


def compile_once(output_dir):
    vcs_bin = os.environ.get("VCS_BIN", "vcs")
    tb_top = env_or_die("POSTSIM_TB_TOP")
    tb_file = resolve_path(env_or_die("POSTSIM_TB_FILE"))
    netlist = resolve_path(env_or_die("POSTSIM_NETLIST"))
    prepared_netlist = prepare_gate_netlist(netlist, output_dir)
    compile_log = output_dir / "compile.log"
    simv = output_dir / "build" / "{}.simv".format(tb_top)
    simv.parent.mkdir(parents=True, exist_ok=True)

    compile_cmd = [
        vcs_bin,
        "-full64",
        "-sverilog",
        "+define+TB_SKIP_SDF_ANNOTATE",
        "+incdir+{}".format(ROOT),
        "-timescale=1ns/1ps",
        "-debug_access+all",
        "-kdb",
        "-l",
        str(compile_log),
        "-top",
        tb_top,
    ]

    for raw in split_path_list(os.environ.get("SIM_LIBRARY_VERILOG", "")):
        compile_cmd.append(str(resolve_path(raw)))
    for raw in split_path_list(os.environ.get("ADDITIONAL_SIM_VERILOGS", "")):
        compile_cmd.append(str(resolve_path(raw)))

    compile_cmd.extend([str(prepared_netlist), str(tb_file), "-o", str(simv)])

    sdf_path = os.environ.get("POSTSIM_SDF", "").strip()
    if sdf_path:
        compile_cmd.extend(["-sdf", "max:{}.dut:{}".format(tb_top, resolve_path(sdf_path))])

    compile_cmd_text = " ".join(shlex.quote(part) for part in compile_cmd)
    result = run(compile_cmd, ROOT, env=vcs_env(), check=False)
    compile_text = (result.stdout or "") + (result.stderr or "")
    if compile_text:
        previous = ""
        if compile_log.exists():
            previous = compile_log.read_text(errors="ignore")
        compile_log.write_text(previous + compile_text, encoding="utf-8")
    if result.returncode == 0:
        simv.chmod(simv.stat().st_mode | 0o111)
    return {
        "simv": simv,
        "compile_log": compile_log,
        "prepared_netlist": prepared_netlist,
        "compile_cmd": compile_cmd_text,
        "compile_rc": result.returncode,
    }


def parse_case_output(stage, case_name, input_path, expected_path, run_log, vcd_path, text):
    metric_match = CASE_METRIC_RE.search(text)
    power_match = POWER_RE.search(text)

    status = "UNKNOWN"
    if FAIL_RE.search(text):
        status = "FAIL"
    elif PASS_RE.search(text):
        status = "PASS"

    return GateCaseResult(
        stage=stage,
        case=case_name,
        status=status,
        input_path=str(input_path),
        expected_path=str(expected_path),
        launch_cycle=int(metric_match.group(1)) if metric_match else None,
        done_cycle=int(metric_match.group(2)) if metric_match else None,
        cycles=int(metric_match.group(3)) if metric_match else None,
        a_nz=int(power_match.group(1)) if power_match else None,
        a_total=int(power_match.group(2)) if power_match else None,
        b_nz=int(power_match.group(3)) if power_match else None,
        b_total=int(power_match.group(4)) if power_match else None,
        active_mac=int(power_match.group(5)) if power_match else None,
        total_mac=int(power_match.group(6)) if power_match else None,
        zero_gated=int(power_match.group(7)) if power_match else None,
        skip_ratio_pct=float(power_match.group(8)) if power_match else None,
        run_log=str(run_log),
        vcd_path=str(vcd_path) if vcd_path else DEFAULT_COVERAGE_SKIP,
    )


def write_csv(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            [
                "stage",
                "case",
                "status",
                "input_path",
                "expected_path",
                "launch_cycle",
                "done_cycle",
                "cycles",
                "a_nz",
                "a_total",
                "b_nz",
                "b_total",
                "active_mac",
                "total_mac",
                "zero_gated",
                "skip_ratio_pct",
                "run_log",
                "vcd_path",
            ]
        )
        for row in rows:
            writer.writerow(
                [
                    row.stage,
                    row.case,
                    row.status,
                    row.input_path,
                    row.expected_path,
                    row.launch_cycle,
                    row.done_cycle,
                    row.cycles,
                    row.a_nz,
                    row.a_total,
                    row.b_nz,
                    row.b_total,
                    row.active_mac,
                    row.total_mac,
                    row.zero_gated,
                    row.skip_ratio_pct,
                    row.run_log,
                    row.vcd_path,
                ]
            )


def write_summary(path, rows, stage, vector_dir, compile_log):
    total = len(rows)
    passed = [row for row in rows if row.status == "PASS"]
    failed = [row for row in rows if row.status != "PASS"]
    avg_cycles = sum((row.cycles or 0) for row in passed) / float(len(passed)) if passed else 0.0
    total_mac = sum((row.total_mac or 0) for row in passed)
    zero_gated = sum((row.zero_gated or 0) for row in passed)
    active_mac = sum((row.active_mac or 0) for row in passed)
    avg_skip = (100.0 * zero_gated / total_mac) if total_mac else 0.0

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Gate Post-Sim Suite Summary\n\n")
        handle.write("- Stage: `{}`\n".format(stage))
        handle.write("- Vector dir: `{}`\n".format(vector_dir))
        handle.write("- Netlist: `{}`\n".format(os.environ.get("POSTSIM_NETLIST", "")))
        handle.write("- SDF: `{}`\n".format(os.environ.get("POSTSIM_SDF", "<none>") or "<none>"))
        handle.write("- Compile log: `{}`\n\n".format(compile_log))
        handle.write("| Total | Pass | Fail | Avg Cycles | Active MAC | Zero Gated | Avg Skip (%) |\n")
        handle.write("| ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        handle.write(
            "| {} | {} | {} | {:.2f} | {} | {} | {:.2f} |\n".format(
                total, len(passed), len(failed), avg_cycles, active_mac, zero_gated, avg_skip
            )
        )
        handle.write("\n")
        if failed:
            handle.write("## Failed Cases\n\n")
            for row in failed:
                handle.write("- `{}`: `{}`\n".format(row.case, row.run_log))


def print_failed_case_log_tail(rows):
    failed_rows = [row for row in rows if row.status != "PASS"]
    if not failed_rows:
        return

    first_failed = failed_rows[0]
    run_log = Path(first_failed.run_log)
    if not run_log.exists():
        return

    try:
        lines = run_log.read_text(errors="ignore").splitlines()
        tail = "\n".join(lines[-120:])
        if tail:
            sys.stderr.write("==== gate suite first failed case log (tail) ====\n")
            sys.stderr.write("case={}\n".format(first_failed.case))
            sys.stderr.write(tail + "\n")
            sys.stderr.write("==== end failed case log tail ====\n")
    except Exception:
        pass


def read_log_tail(path, max_lines):
    file_path = Path(path)
    if not file_path.exists():
        return "<missing>"
    try:
        lines = file_path.read_text(errors="ignore").splitlines()
        if not lines:
            return "<empty>"
        return "\n".join(lines[-max_lines:])
    except Exception as exc:
        return "<unreadable: {}>".format(exc)


def write_debug_snapshot(path, stage, vector_dir, output_dir, compile_info, rows, suite_status, extra_note):
    total = len(rows)
    passed = len([row for row in rows if row.status == "PASS"])
    failed_rows = [row for row in rows if row.status != "PASS"]
    first_failed = failed_rows[0] if failed_rows else None

    lines = []
    lines.append("# Gate Debug Snapshot")
    lines.append("")
    lines.append("stage={}".format(stage))
    lines.append("suite_status={}".format(suite_status))
    lines.append("vector_dir={}".format(vector_dir))
    lines.append("output_dir={}".format(output_dir))
    lines.append("netlist={}".format(os.environ.get("POSTSIM_NETLIST", "")))
    lines.append("prepared_netlist={}".format(compile_info.get("prepared_netlist", "")))
    lines.append("sdf={}".format(os.environ.get("POSTSIM_SDF", "<none>") or "<none>"))
    lines.append("tb_top={}".format(os.environ.get("POSTSIM_TB_TOP", "")))
    lines.append("tb_file={}".format(os.environ.get("POSTSIM_TB_FILE", "")))
    lines.append("sim_library_verilog={}".format(os.environ.get("SIM_LIBRARY_VERILOG", "")))
    lines.append("additional_sim_verilogs={}".format(os.environ.get("ADDITIONAL_SIM_VERILOGS", "")))
    lines.append("disable_timing_checks={}".format(os.environ.get("POSTSIM_DISABLE_TIMING_CHECKS", "0")))
    lines.append("compile_rc={}".format(compile_info.get("compile_rc", "")))
    lines.append("compile_log={}".format(compile_info.get("compile_log", "")))
    lines.append("compile_cmd={}".format(compile_info.get("compile_cmd", "")))
    lines.append("total_cases={}".format(total))
    lines.append("pass_cases={}".format(passed))
    lines.append("fail_cases={}".format(len(failed_rows)))
    if extra_note:
        lines.append("note={}".format(extra_note))

    if first_failed is not None:
        lines.append("first_failed_case={}".format(first_failed.case))
        lines.append("first_failed_input={}".format(first_failed.input_path))
        lines.append("first_failed_expected={}".format(first_failed.expected_path))
        lines.append("first_failed_run_log={}".format(first_failed.run_log))
        lines.append("first_failed_cycles={}".format(first_failed.cycles))
        lines.append("first_failed_skip_ratio_pct={}".format(first_failed.skip_ratio_pct))

    lines.append("")
    lines.append("## Compile Log Tail")
    lines.append("")
    lines.append(read_log_tail(compile_info.get("compile_log", ""), 120))
    lines.append("")

    if first_failed is not None:
        lines.append("## First Failed Run Log Tail")
        lines.append("")
        lines.append(read_log_tail(first_failed.run_log, 160))
        lines.append("")

    if failed_rows:
        lines.append("## First 20 Failed Cases")
        lines.append("")
        for row in failed_rows[:20]:
            lines.append(
                "- case={} status={} cycles={} run_log={}".format(
                    row.case, row.status, row.cycles, row.run_log
                )
            )
        lines.append("")

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Compile once and run a full gate-level txt vector suite.")
    parser.add_argument("--stage", required=True, help="Logical stage label such as none, dc, or innovus.")
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--dump-vcd", action="store_true")
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    if output_dir.exists():
        shutil.rmtree(str(output_dir))
    (output_dir / "logs").mkdir(parents=True, exist_ok=True)
    if args.dump_vcd:
        (output_dir / "vcd").mkdir(parents=True, exist_ok=True)

    cases = discover_cases(vector_dir)
    if not cases:
        die("No txt vector cases found in {}".format(vector_dir))

    debug_snapshot_path = output_dir / "debug_snapshot.txt"
    compile_info = compile_once(output_dir)
    compile_log = compile_info["compile_log"]
    if compile_info["compile_rc"] != 0:
        write_debug_snapshot(
            debug_snapshot_path,
            args.stage,
            vector_dir,
            output_dir,
            compile_info,
            [],
            "COMPILE_FAIL",
            "VCS compile failed before any case ran",
        )
        sys.stderr.write("GATE_DEBUG_SNAPSHOT path={}\n".format(debug_snapshot_path))
        if compile_log.exists():
            try:
                lines = compile_log.read_text(errors="ignore").splitlines()
                tail = "\n".join(lines[-120:])
                if tail:
                    sys.stderr.write("==== gate suite compile.log (tail) ====\n")
                    sys.stderr.write(tail + "\n")
                    sys.stderr.write("==== end compile.log tail ====\n")
            except Exception:
                pass
        raise SystemExit("VCS compile failed for gate suite. See {}".format(compile_log))

    simv = compile_info["simv"]
    pass_marker = env_or_die("POSTSIM_PASS_MARKER")
    results = []
    failures = 0

    for case_name, input_path, expected_path in cases:
        run_log = output_dir / "logs" / "{}.run.log".format(case_name)
        vcd_path = (output_dir / "vcd" / "{}.vcd".format(case_name)) if args.dump_vcd else None
        cmd = [str(simv), "-l", str(run_log), "+SOFT_FAIL", "+CASE={}".format(case_name), "+INPUT={}".format(input_path), "+EXPECTED={}".format(expected_path)]
        if os.environ.get("POSTSIM_DISABLE_TIMING_CHECKS", "0") == "1":
            cmd.extend(["+notimingcheck", "+no_notifier", "+nospecify"])
        if vcd_path is not None:
            cmd.append("+VCD={}".format(vcd_path))

        result = run(cmd, output_dir, env=vcs_env(), check=False)
        combined = (result.stdout or "") + (result.stderr or "")
        if run_log.exists():
            combined += run_log.read_text(errors="ignore")
        if combined and not run_log.exists():
            run_log.write_text(combined, encoding="utf-8")

        parsed = parse_case_output(args.stage, case_name, input_path, expected_path, run_log, vcd_path, combined)

        ok = parsed.status == "PASS" and (pass_marker in combined)
        if parsed.status == "UNKNOWN" and result.returncode == 0 and pass_marker in combined:
            ok = True
            parsed.status = "PASS"
        elif parsed.status == "UNKNOWN":
            ok = False
            parsed.status = "FAIL"

        results.append(parsed)
        failures += 0 if ok else 1
        print("GATE_CASE stage={} case={} status={}".format(args.stage, case_name, "PASS" if ok else "FAIL"))
        print("GATE_TXT_CASE stage={} case={} status={}".format(args.stage, case_name, color_status(ok)))

    write_csv(output_dir / "gate_case_metrics.csv", results)
    write_summary(output_dir / "summary.md", results, args.stage, vector_dir, compile_log)
    write_debug_snapshot(
        debug_snapshot_path,
        args.stage,
        vector_dir,
        output_dir,
        compile_info,
        results,
        "PASS" if failures == 0 else "FAIL",
        "",
    )
    print("GATE_DEBUG_SNAPSHOT path={}".format(debug_snapshot_path))
    if failures:
        print_failed_case_log_tail(results)

    print("")
    print(
        "GATE_SUITE stage={} status={} total={} pass={} fail={}".format(
            args.stage, "PASS" if failures == 0 else "FAIL", len(results), len(results) - failures, failures
        )
    )
    print("GATE_SUMMARY summary={}".format(output_dir / "summary.md"))
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
