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
PASS_RE = re.compile(r"\[[A-Z_]+\]\[PASS\]\s+(\S+)")
FAIL_RE = re.compile(r"\[[A-Z_]+\]\[FAIL\]\s+(\S+)")


def die(message):
    raise SystemExit(message)


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


def env_flag(name):
    return os.environ.get(name, "0").strip().lower() in ("1", "true", "yes", "on")


def coverage_enabled():
    return env_flag("FRONTSIM_COVERAGE")


def coverage_metrics():
    return os.environ.get("FRONTSIM_COVERAGE_METRICS", "line+cond+tgl+branch+fsm").strip()


def coverage_db_dir(output_dir):
    raw = os.environ.get("FRONTSIM_COVERAGE_DIR", "").strip()
    if raw:
        path = Path(raw)
        return path if path.is_absolute() else (ROOT / path).resolve()
    return (output_dir / "coverage" / "simv.vdb").resolve()


def safe_cm_name(case_name):
    return re.sub(r"[^A-Za-z0-9_.-]", "_", case_name)


def read_filelist(path):
    files = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.split("#", 1)[0].strip()
        if line:
            files.append(resolve_path(line))
    return files


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


def required_min_cases():
    raw = os.environ.get("FRONTSIM_MIN_CASES", "").strip() or os.environ.get("MIN_FRONTSIM_CASES", "").strip()
    if not raw:
        return 0
    try:
        value = int(raw)
    except ValueError:
        die("FRONTSIM_MIN_CASES/MIN_FRONTSIM_CASES must be an integer, got '{}'".format(raw))
    return max(0, value)


def vcs_env():
    env = os.environ.copy()
    license_file = (
        env.get("VCS_LICENSE_FILE")
        or env.get("SNPSLMD_LICENSE_FILE")
        or env.get("SYNOPSYS_LICENSE_FILE")
        or env.get("LM_LICENSE_FILE")
    )
    if license_file:
        env["VCS_LICENSE_FILE"] = license_file
        env["SNPSLMD_LICENSE_FILE"] = license_file
        env["SYNOPSYS_LICENSE_FILE"] = license_file
        env["LM_LICENSE_FILE"] = license_file
    return env


def run(cmd, cwd, env, check=True):
    result = subprocess.run(cmd, cwd=str(cwd), universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env)
    if check and result.returncode != 0:
        raise subprocess.CalledProcessError(result.returncode, cmd, output=result.stdout, stderr=result.stderr)
    return result


def compile_once(output_dir):
    vcs_bin = os.environ.get("VCS_BIN", "vcs")
    tb_top = env_or_die("FRONTSIM_TB_TOP")
    tb_file = resolve_path(env_or_die("FRONTSIM_TB_FILE"))
    filelist = resolve_path(env_or_die("FILELIST"))
    rtl_files = read_filelist(filelist)
    compile_log = output_dir / "compile.log"
    build_dir = output_dir / "build"
    simv = build_dir / "{}.simv".format(tb_top)
    cm_enabled = coverage_enabled()
    cm_metrics = coverage_metrics()
    cm_dir = coverage_db_dir(output_dir)
    shutil.rmtree(build_dir, ignore_errors=True)
    if cm_enabled:
        shutil.rmtree(str(cm_dir), ignore_errors=True)
    build_dir.mkdir(parents=True, exist_ok=True)

    compile_cmd = [
        vcs_bin,
        "-full64",
        "-sverilog",
        "+define+TB_SKIP_SDF_ANNOTATE",
        "+incdir+{}".format(ROOT),
        "-timescale=1ns/1ps",
        "-debug_access+all",
        "-kdb",
        "-Mdir={}".format(build_dir / "csrc"),
        "-l",
        str(compile_log),
        "-top",
        tb_top,
    ]
    license_wait = os.environ.get("VCS_LICENSE_WAIT_MINUTES", "0").strip()
    if license_wait.isdigit() and int(license_wait) > 0:
        compile_cmd.extend(["-licwait", license_wait])
    if os.environ.get("FRONTSIM_GATE_SAFE_INPUT_LAUNCH", "0").strip() == "1":
        compile_cmd.append("+define+TB_GATE_SAFE_INPUT_LAUNCH")
    if cm_enabled:
        compile_cmd.extend(["-cm", cm_metrics, "-cm_dir", str(cm_dir)])

    compile_cmd.extend([str(path) for path in rtl_files])
    compile_cmd.extend([str(tb_file), "-o", str(simv)])

    result = run(compile_cmd, build_dir, env=vcs_env(), check=False)
    compile_text = (result.stdout or "") + (result.stderr or "")
    if compile_text:
        previous = compile_log.read_text(errors="ignore") if compile_log.exists() else ""
        compile_log.write_text(previous + compile_text, encoding="utf-8")
    if result.returncode == 0:
        simv.chmod(simv.stat().st_mode | 0o111)
    return {
        "simv": simv,
        "compile_log": compile_log,
        "compile_cmd": " ".join(shlex.quote(part) for part in compile_cmd),
        "compile_rc": result.returncode,
        "coverage_enabled": "1" if cm_enabled else "0",
        "coverage_metrics": cm_metrics if cm_enabled else "",
        "coverage_db": str(cm_dir) if cm_enabled else "",
    }


def read_log_tail(path, max_lines):
    file_path = Path(path)
    if not file_path.exists():
        return "<missing>"
    lines = file_path.read_text(errors="ignore").splitlines()
    if not lines:
        return "<empty>"
    return "\n".join(lines[-max_lines:])


def write_csv(path, rows):
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["case", "status", "input_path", "expected_path", "run_log"])
        for row in rows:
            writer.writerow([row["case"], row["status"], row["input_path"], row["expected_path"], row["run_log"]])


def write_summary(path, rows, vector_dir, compile_log, suite_status, note, coverage_info):
    passed = [row for row in rows if row["status"] == "PASS"]
    failed = [row for row in rows if row["status"] != "PASS"]
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# RTL Front-Sim Suite Summary\n\n")
        handle.write("- Vector dir: `{}`\n".format(vector_dir))
        handle.write("- Suite status: `{}`\n".format(suite_status))
        handle.write("- Compile log: `{}`\n".format(compile_log))
        if note:
            handle.write("- Note: `{}`\n".format(note))
        if coverage_info:
            handle.write("- Coverage status: `{}`\n".format(coverage_info.get("status", "")))
            if coverage_info.get("db"):
                handle.write("- Coverage DB: `{}`\n".format(coverage_info.get("db", "")))
            if coverage_info.get("report"):
                handle.write("- Coverage report: `{}`\n".format(coverage_info.get("report", "")))
            if coverage_info.get("log"):
                handle.write("- Coverage log: `{}`\n".format(coverage_info.get("log", "")))
        handle.write("\n")
        handle.write("| Total | Pass | Fail |\n")
        handle.write("| ---: | ---: | ---: |\n")
        handle.write("| {} | {} | {} |\n".format(len(rows), len(passed), len(failed)))
        if failed:
            handle.write("\n## Failed Cases\n\n")
            for row in failed:
                handle.write("- `{}`: `{}`\n".format(row["case"], row["run_log"]))


def write_debug_snapshot(path, vector_dir, output_dir, compile_info, rows, suite_status, note, coverage_info):
    failed = [row for row in rows if row["status"] != "PASS"]
    lines = [
        "# RTL Front-Sim Debug Snapshot",
        "",
        "suite_status={}".format(suite_status),
        "vector_dir={}".format(vector_dir),
        "output_dir={}".format(output_dir),
        "tb_top={}".format(os.environ.get("FRONTSIM_TB_TOP", "")),
        "tb_file={}".format(os.environ.get("FRONTSIM_TB_FILE", "")),
        "filelist={}".format(os.environ.get("FILELIST", "")),
        "compile_rc={}".format(compile_info.get("compile_rc", "")),
        "compile_log={}".format(compile_info.get("compile_log", "")),
        "compile_cmd={}".format(compile_info.get("compile_cmd", "")),
        "coverage_enabled={}".format(compile_info.get("coverage_enabled", "0")),
        "coverage_metrics={}".format(compile_info.get("coverage_metrics", "")),
        "coverage_db={}".format(compile_info.get("coverage_db", "")),
        "coverage_status={}".format(coverage_info.get("status", "") if coverage_info else ""),
        "coverage_report={}".format(coverage_info.get("report", "") if coverage_info else ""),
        "coverage_log={}".format(coverage_info.get("log", "") if coverage_info else ""),
        "total_cases={}".format(len(rows)),
        "pass_cases={}".format(len(rows) - len(failed)),
        "fail_cases={}".format(len(failed)),
    ]
    if note:
        lines.append("note={}".format(note))
    if failed:
        lines.append("first_failed_case={}".format(failed[0]["case"]))
        lines.append("first_failed_run_log={}".format(failed[0]["run_log"]))
    lines.extend(["", "## Compile Log Tail", "", read_log_tail(compile_info.get("compile_log", ""), 120), ""])
    if failed:
        lines.extend(["## First Failed Run Log Tail", "", read_log_tail(failed[0]["run_log"], 160), ""])
    if coverage_info and coverage_info.get("log"):
        lines.extend(["## Coverage Log Tail", "", read_log_tail(coverage_info.get("log"), 120), ""])
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def run_coverage_report(output_dir, compile_info):
    if compile_info.get("coverage_enabled") != "1":
        return {}
    cm_dir = Path(compile_info.get("coverage_db", ""))
    report_dir = (output_dir / "coverage" / "urg_report").resolve()
    log_path = output_dir / "coverage" / "urg.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    if not cm_dir.exists():
        log_path.write_text("Coverage database is missing: {}\n".format(cm_dir), encoding="utf-8")
        return {"status": "MISSING_DB", "db": str(cm_dir), "report": str(report_dir), "log": str(log_path)}
    urg_bin = os.environ.get("URG_BIN", "urg")
    urg_path = shutil.which(urg_bin)
    if urg_path is None:
        log_path.write_text("URG not found: {}\n".format(urg_bin), encoding="utf-8")
        return {"status": "URG_MISSING", "db": str(cm_dir), "report": str(report_dir), "log": str(log_path)}
    shutil.rmtree(str(report_dir), ignore_errors=True)
    cmd = [urg_path, "-full64", "-dir", str(cm_dir), "-report", str(report_dir)]
    result = run(cmd, output_dir, env=vcs_env(), check=False)
    log_path.write_text((result.stdout or "") + (result.stderr or ""), encoding="utf-8")
    status = "PASS" if result.returncode == 0 else "URG_FAIL"
    return {"status": status, "db": str(cm_dir), "report": str(report_dir), "log": str(log_path)}


def main():
    parser = argparse.ArgumentParser(description="Compile once and run a full RTL file-vector suite.")
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    if output_dir.exists():
        shutil.rmtree(str(output_dir))
    (output_dir / "logs").mkdir(parents=True, exist_ok=True)

    cases = discover_cases(vector_dir)
    if not cases:
        die("No txt vector cases found in {}".format(vector_dir))
    min_cases = required_min_cases()
    if min_cases and len(cases) < min_cases:
        die("RTL frontsim suite found {} cases in {}, below required minimum {}".format(len(cases), vector_dir, min_cases))

    debug_snapshot = output_dir / "debug_snapshot.txt"
    compile_info = compile_once(output_dir)
    compile_log = compile_info["compile_log"]
    if compile_info["compile_rc"] != 0:
        rows = []
        write_csv(output_dir / "front_case_metrics.csv", rows)
        write_summary(output_dir / "summary.md", rows, vector_dir, compile_log, "COMPILE_FAIL", "VCS compile failed", {})
        write_debug_snapshot(debug_snapshot, vector_dir, output_dir, compile_info, rows, "COMPILE_FAIL", "VCS compile failed", {})
        raise SystemExit("VCS compile failed for RTL frontsim suite. See {}".format(compile_log))

    simv = compile_info["simv"]
    pass_marker = env_or_die("FRONTSIM_PASS_MARKER")
    rows = []
    failures = 0
    for case_name, input_path, expected_path in cases:
        run_log = output_dir / "logs" / "{}.run.log".format(case_name)
        cmd = [
            str(simv),
            "-l",
            str(run_log),
            "+SOFT_FAIL",
            "+CASE={}".format(case_name),
            "+INPUT={}".format(input_path),
            "+EXPECTED={}".format(expected_path),
        ]
        if compile_info.get("coverage_enabled") == "1":
            cmd.extend([
                "-cm",
                compile_info.get("coverage_metrics", coverage_metrics()),
                "-cm_dir",
                compile_info.get("coverage_db", str(coverage_db_dir(output_dir))),
                "-cm_name",
                safe_cm_name(case_name),
            ])
        result = run(cmd, output_dir, env=vcs_env(), check=False)
        combined = (result.stdout or "") + (result.stderr or "")
        if run_log.exists():
            combined += run_log.read_text(errors="ignore")
        if combined and not run_log.exists():
            run_log.write_text(combined, encoding="utf-8")

        status = "PASS" if pass_marker in combined or PASS_RE.search(combined) else "FAIL"
        if FAIL_RE.search(combined):
            status = "FAIL"
        failures += 0 if status == "PASS" else 1
        rows.append(
            {
                "case": case_name,
                "status": status,
                "input_path": str(input_path),
                "expected_path": str(expected_path),
                "run_log": str(run_log),
            }
        )
        print("FRONT_CASE case={} status={}".format(case_name, status))

    suite_status = "PASS" if failures == 0 else "FUNCTIONAL_FAIL"
    coverage_info = run_coverage_report(output_dir, compile_info)
    write_csv(output_dir / "front_case_metrics.csv", rows)
    write_summary(output_dir / "summary.md", rows, vector_dir, compile_log, suite_status, "", coverage_info)
    write_debug_snapshot(debug_snapshot, vector_dir, output_dir, compile_info, rows, suite_status, "", coverage_info)
    print("")
    print("FRONT_SUITE status={} total={} pass={} fail={}".format(suite_status, len(rows), len(rows) - failures, failures))
    if coverage_info:
        print("FRONT_COVERAGE status={} report={}".format(coverage_info.get("status", ""), coverage_info.get("report", "")))
    print("FRONT_SUMMARY summary={}".format(output_dir / "summary.md"))
    if env_flag("FRONTSIM_COVERAGE_STRICT") and coverage_info and coverage_info.get("status") != "PASS":
        return 1
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
