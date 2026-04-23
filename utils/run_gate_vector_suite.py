#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
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


@dataclass
class GateCaseResult:
    stage: str
    case: str
    status: str
    input_path: str
    expected_path: str
    launch_cycle: int | None
    done_cycle: int | None
    cycles: int | None
    a_nz: int | None
    a_total: int | None
    b_nz: int | None
    b_total: int | None
    active_mac: int | None
    total_mac: int | None
    zero_gated: int | None
    skip_ratio_pct: float | None
    run_log: str
    vcd_path: str


def die(message: str) -> "NoReturn":
    raise SystemExit(message)


def use_color() -> bool:
    return sys.stdout.isatty() and os.environ.get("TERM", "") not in {"", "dumb"}


class Color:
    if use_color():
        BOLD = "\033[1m"
        GREEN = "\033[32m"
        RED = "\033[31m"
        RESET = "\033[0m"
    else:
        BOLD = GREEN = RED = RESET = ""


def color_status(ok: bool) -> str:
    if ok:
        return f"{Color.BOLD}{Color.GREEN}PASS{Color.RESET}"
    return f"{Color.BOLD}{Color.RED}FAIL{Color.RESET}"


def env_or_die(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        die(f"Missing required environment variable: {name}")
    return value


def resolve_path(raw: str) -> Path:
    path = Path(raw)
    return path if path.is_absolute() else (ROOT / path).resolve()


def split_path_list(raw: str) -> list[str]:
    return [item for item in raw.split() if item]


def parse_suite_case_names(path: Path) -> list[str]:
    case_names: list[str] = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("CASE "):
            _, case_name = line.split(None, 1)
            case_names.append(case_name.strip())
    return case_names


def discover_cases(vector_dir: Path) -> list[tuple[str, Path, Path]]:
    suite_input = vector_dir / SUITE_INPUT_NAME
    suite_expected = vector_dir / SUITE_EXPECTED_NAME
    if suite_input.exists() and suite_expected.exists():
        return [(case_name, suite_input.resolve(), suite_expected.resolve()) for case_name in parse_suite_case_names(suite_input)]

    cases: list[tuple[str, Path, Path]] = []
    for input_path in sorted(vector_dir.glob("*_input.txt")):
        case_name = input_path.stem[:-6]
        expected_path = vector_dir / f"{case_name}_expected.txt"
        cases.append((case_name, input_path.resolve(), expected_path.resolve()))
    return cases


def vcs_env() -> dict[str, str]:
    env = os.environ.copy()
    license_file = env.get("VCS_LICENSE_FILE")
    if license_file:
        env["SNPSLMD_LICENSE_FILE"] = license_file
        env["SYNOPSYS_LICENSE_FILE"] = license_file
        env["LM_LICENSE_FILE"] = license_file
    return env


def run(cmd: list[str], cwd: Path, *, env: dict[str, str], check: bool = True) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True, env=env)
    if check and result.returncode != 0:
        raise subprocess.CalledProcessError(result.returncode, cmd, output=result.stdout, stderr=result.stderr)
    return result


def compile_once(output_dir: Path) -> tuple[Path, Path]:
    vcs_bin = os.environ.get("VCS_BIN", "vcs")
    tb_top = env_or_die("POSTSIM_TB_TOP")
    tb_file = resolve_path(env_or_die("POSTSIM_TB_FILE"))
    netlist = resolve_path(env_or_die("POSTSIM_NETLIST"))
    compile_log = output_dir / "compile.log"
    simv = output_dir / "build" / f"{tb_top}.simv"
    simv.parent.mkdir(parents=True, exist_ok=True)

    compile_cmd = [
        vcs_bin,
        "-full64",
        "-sverilog",
        "+define+TB_SKIP_SDF_ANNOTATE",
        f"+incdir+{ROOT}",
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

    compile_cmd.extend([str(netlist), str(tb_file), "-o", str(simv)])

    sdf_path = os.environ.get("POSTSIM_SDF", "").strip()
    if sdf_path:
        compile_cmd.extend(["-sdf", f"max:{tb_top}.dut:{resolve_path(sdf_path)}"])

    result = run(compile_cmd, ROOT, env=vcs_env(), check=False)
    compile_text = (result.stdout or "") + (result.stderr or "")
    if compile_text:
        compile_log.write_text((compile_log.read_text(errors="ignore") if compile_log.exists() else "") + compile_text, encoding="utf-8")
    if result.returncode != 0:
        raise SystemExit(f"VCS compile failed for gate suite. See {compile_log}")

    simv.chmod(simv.stat().st_mode | 0o111)
    return simv, compile_log


def parse_case_output(
    *,
    stage: str,
    case_name: str,
    input_path: Path,
    expected_path: Path,
    run_log: Path,
    vcd_path: Path | None,
    text: str,
) -> GateCaseResult:
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


def write_csv(path: Path, rows: list[GateCaseResult]) -> None:
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


def write_summary(path: Path, rows: list[GateCaseResult], *, stage: str, vector_dir: Path, compile_log: Path) -> None:
    total = len(rows)
    passed = [row for row in rows if row.status == "PASS"]
    failed = [row for row in rows if row.status != "PASS"]
    avg_cycles = sum(row.cycles or 0 for row in passed) / len(passed) if passed else 0.0
    total_mac = sum(row.total_mac or 0 for row in passed)
    zero_gated = sum(row.zero_gated or 0 for row in passed)
    active_mac = sum(row.active_mac or 0 for row in passed)
    avg_skip = (100.0 * zero_gated / total_mac) if total_mac else 0.0

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Gate Post-Sim Suite Summary\n\n")
        handle.write(f"- Stage: `{stage}`\n")
        handle.write(f"- Vector dir: `{vector_dir}`\n")
        handle.write(f"- Netlist: `{os.environ.get('POSTSIM_NETLIST', '')}`\n")
        handle.write(f"- SDF: `{os.environ.get('POSTSIM_SDF', '<none>') or '<none>'}`\n")
        handle.write(f"- Compile log: `{compile_log}`\n\n")
        handle.write("| Total | Pass | Fail | Avg Cycles | Active MAC | Zero Gated | Avg Skip (%) |\n")
        handle.write("| ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        handle.write(
            f"| {total} | {len(passed)} | {len(failed)} | {avg_cycles:.2f} | {active_mac} | {zero_gated} | {avg_skip:.2f} |\n"
        )
        handle.write("\n")
        if failed:
            handle.write("## Failed Cases\n\n")
            for row in failed:
                handle.write(f"- `{row.case}`: `{row.run_log}`\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Compile once and run a full gate-level txt vector suite.")
    parser.add_argument("--stage", required=True, help="Logical stage label such as none, dc, or innovus.")
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--dump-vcd", action="store_true")
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    if output_dir.exists():
        shutil.rmtree(output_dir)
    (output_dir / "logs").mkdir(parents=True, exist_ok=True)
    if args.dump_vcd:
        (output_dir / "vcd").mkdir(parents=True, exist_ok=True)

    cases = discover_cases(vector_dir)
    if not cases:
        die(f"No txt vector cases found in {vector_dir}")

    simv, compile_log = compile_once(output_dir)
    pass_marker = env_or_die("POSTSIM_PASS_MARKER")
    results: list[GateCaseResult] = []
    failures = 0

    for case_name, input_path, expected_path in cases:
        run_log = output_dir / "logs" / f"{case_name}.run.log"
        vcd_path = (output_dir / "vcd" / f"{case_name}.vcd") if args.dump_vcd else None
        cmd = [str(simv), "-l", str(run_log), "+SOFT_FAIL", f"+CASE={case_name}", f"+INPUT={input_path}", f"+EXPECTED={expected_path}"]
        if vcd_path is not None:
            cmd.append(f"+VCD={vcd_path}")

        result = run(cmd, output_dir, env=vcs_env(), check=False)
        combined = (result.stdout or "") + (result.stderr or "")
        if run_log.exists():
            combined += run_log.read_text(errors="ignore")
        if combined and not run_log.exists():
            run_log.write_text(combined, encoding="utf-8")

        parsed = parse_case_output(
            stage=args.stage,
            case_name=case_name,
            input_path=input_path,
            expected_path=expected_path,
            run_log=run_log,
            vcd_path=vcd_path,
            text=combined,
        )

        ok = parsed.status == "PASS" and (pass_marker in combined)
        if parsed.status == "UNKNOWN" and result.returncode == 0 and pass_marker in combined:
            ok = True
            parsed.status = "PASS"
        elif parsed.status == "UNKNOWN":
            ok = False
            parsed.status = "FAIL"

        results.append(parsed)
        failures += 0 if ok else 1
        print(f"GATE_CASE stage={args.stage} case={case_name} status={'PASS' if ok else 'FAIL'}")
        print(f"GATE_TXT_CASE stage={args.stage} case={case_name} status={color_status(ok)}")

    write_csv(output_dir / "gate_case_metrics.csv", results)
    write_summary(output_dir / "summary.md", results, stage=args.stage, vector_dir=vector_dir, compile_log=compile_log)

    print()
    print(
        f"GATE_SUITE stage={args.stage} status={'PASS' if failures == 0 else 'FAIL'} "
        f"total={len(results)} pass={len(results) - failures} fail={failures}"
    )
    print(f"GATE_SUMMARY summary={output_dir / 'summary.md'}")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
