#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VCS_LICENSE_FILE = os.environ.get("VCS_LICENSE_FILE", "5999@curry-GTR-Pro")
DEFAULT_COVERAGE_METRICS = "line+tgl+cond+branch+assert"
SUITE_INPUT_NAME = "suite_input.txt"
SUITE_EXPECTED_NAME = "suite_expected.txt"


ARCH_CONFIG = {
    "ws": {
        "rtl": [ROOT / "ws" / "src" / "standard_ws_array_4x4.v"],
        "tb": ROOT / "ws" / "tb" / "standard_ws_file_tb.sv",
        "top": "standard_ws_file_tb",
    },
    "is": {
        "rtl": [ROOT / "is" / "src" / "standard_is_array_4x4.v"],
        "tb": ROOT / "is" / "tb" / "standard_is_file_tb.sv",
        "top": "standard_is_file_tb",
    },
    "os": {
        "rtl": [ROOT / "os" / "src" / "standard_os_array_4x4.v"],
        "tb": ROOT / "os" / "tb" / "standard_os_file_tb.sv",
        "top": "standard_os_file_tb",
    },
    "dip": {
        "rtl": [
            ROOT / "dip" / "src" / "dip_pe.v",
            ROOT / "dip" / "src" / "systolic_array_dip_4x4.v",
            ROOT / "dip" / "src" / "standard_dip_array_4x4.v",
        ],
        "tb": ROOT / "dip" / "tb" / "standard_dip_file_tb.sv",
        "top": "standard_dip_file_tb",
    },
}


def use_color() -> bool:
    return sys.stdout.isatty() and os.environ.get("TERM", "") not in {"", "dumb"}


class C:
    if use_color():
        RESET = "\033[0m"
        BOLD = "\033[1m"
        GREEN = "\033[32m"
        RED = "\033[31m"
        CYAN = "\033[36m"
    else:
        RESET = BOLD = GREEN = RED = CYAN = ""


def color_status(ok: bool) -> str:
    color = C.GREEN if ok else C.RED
    word = "PASS" if ok else "FAIL"
    return f"{C.BOLD}{color}{word}{C.RESET}"


def run(
    cmd: list[str],
    cwd: Path,
    env: dict[str, str] | None = None,
    *,
    check: bool = True,
) -> tuple[int, str]:
    result = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True, env=env)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    if check and result.returncode != 0:
        raise SystemExit(result.returncode)
    return result.returncode, result.stdout + result.stderr


def vcs_env() -> dict[str, str]:
    env = os.environ.copy()
    env["SNPSLMD_LICENSE_FILE"] = VCS_LICENSE_FILE
    env["SYNOPSYS_LICENSE_FILE"] = VCS_LICENSE_FILE
    env["LM_LICENSE_FILE"] = VCS_LICENSE_FILE
    return env


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
        input_path = input_path.resolve()
        case_name = input_path.stem[:-6]
        expected_path = (vector_dir / f"{case_name}_expected.txt").resolve()
        cases.append((case_name, input_path, expected_path))
    return cases


def build_once(
    arch: str,
    sim: str,
    build_dir: Path,
    *,
    enable_coverage: bool = False,
    coverage_metrics: str = DEFAULT_COVERAGE_METRICS,
) -> Path:
    cfg = ARCH_CONFIG[arch]
    build_dir.mkdir(parents=True, exist_ok=True)
    if sim == "iverilog":
        exe = build_dir / f"{cfg['top']}.vvp"
        run(
            ["iverilog", "-g2012", "-Wall", "-I", str(ROOT), "-o", str(exe), *(str(p) for p in cfg["rtl"]), str(cfg["tb"])],
            build_dir,
        )
        return exe
    exe = build_dir / f"{cfg['top']}.simv"
    cmd = [
        "vcs",
        "-full64",
        "-sverilog",
        "+incdir+" + str(ROOT),
        "-timescale=1ns/1ps",
        "-debug_access+all",
        "-kdb",
        "-licwait",
        "10",
        "-LDFLAGS",
        "-Wl,--no-as-needed",
        "-l",
        str(build_dir / "compile.log"),
    ]
    if enable_coverage:
        cmd.extend(["+define+FORMAL", "-cm", coverage_metrics])
    cmd.extend(["-top", cfg["top"], "-o", str(exe), *(str(p) for p in cfg["rtl"]), str(cfg["tb"])])
    run(cmd, build_dir, env=vcs_env())
    exe.chmod(exe.stat().st_mode | 0o111)
    return exe


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--arch", required=True, choices=sorted(ARCH_CONFIG))
    parser.add_argument("--simulator", required=True, choices=["iverilog", "vcs"])
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--enable-coverage", action="store_true")
    parser.add_argument("--coverage-metrics", default=DEFAULT_COVERAGE_METRICS)
    args = parser.parse_args()
    if args.enable_coverage and args.simulator != "vcs":
        parser.error("--enable-coverage currently requires --simulator vcs")

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    case_vdb_dir = output_dir / "case_vdb"
    merged_vdb = output_dir / "merged.vdb"
    report_dir = output_dir / "report"
    if args.enable_coverage:
        for stale_path in [case_vdb_dir, merged_vdb, report_dir]:
            if stale_path.exists():
                shutil.rmtree(stale_path)
        case_vdb_dir.mkdir(parents=True, exist_ok=True)
    build_dir = (output_dir / "build").resolve()
    exe = build_once(
        args.arch,
        args.simulator,
        build_dir,
        enable_coverage=args.enable_coverage,
        coverage_metrics=args.coverage_metrics,
    )

    results: list[tuple[str, bool]] = []
    failures = 0
    power_samples: list[tuple[int, int, int]] = []
    coverage_case_vdbs: list[Path] = []
    coverage_failed = False
    power_pattern = re.compile(r"\[[A-Z_]+\]\[POWER\].*?active_mac=(\d+)/(\d+).*?zero_gated=(\d+)")

    for case_name, input_path, expected_path in discover_cases(vector_dir):
        pass_marker = f"[{args.arch.upper()}_FILE][PASS]"
        fail_marker = f"[{args.arch.upper()}_FILE][FAIL]"
        case_plusarg = f"+CASE={case_name}"
        if args.simulator == "iverilog":
            cmd = ["vvp", str(exe), "+SOFT_FAIL", case_plusarg, f"+INPUT={input_path}", f"+EXPECTED={expected_path}"]
            rc, output = run(cmd, output_dir, check=False)
        else:
            run_log = output_dir / f"{case_name}.run.log"
            exe.chmod(exe.stat().st_mode | 0o111)
            cmd = [str(exe), "-l", str(run_log)]
            case_vdb = case_vdb_dir / f"{case_name}.vdb"
            if args.enable_coverage:
                if case_vdb.exists():
                    shutil.rmtree(case_vdb)
                cmd.extend(["-cm", args.coverage_metrics, "-cm_name", case_name, "-cm_dir", str(case_vdb)])
            cmd.extend(["+SOFT_FAIL", case_plusarg, f"+INPUT={input_path}", f"+EXPECTED={expected_path}"])
            rc, output = run(cmd, output_dir, env=vcs_env(), check=False)
            if run_log.exists():
                output += run_log.read_text(errors="ignore")
            if args.enable_coverage and case_vdb.exists():
                coverage_case_vdbs.append(case_vdb)
        ok = pass_marker in output
        if fail_marker in output:
            ok = False
        elif (pass_marker not in output) and (rc != 0):
            ok = False
        power_match = power_pattern.search(output)
        if power_match:
            active_mac = int(power_match.group(1))
            total_mac = int(power_match.group(2))
            zero_gated = int(power_match.group(3))
            power_samples.append((active_mac, total_mac, zero_gated))
        results.append((case_name, ok))
        status = "PASS" if ok else "FAIL"
        print(f"FILE_VECTOR arch={args.arch.upper()} simulator={args.simulator} case={case_name} status={status}")
        print(f"TXT_CASE arch={args.arch.upper()} case={case_name} status={color_status(ok)}")
        if not ok:
            failures += 1

    total = len(results)
    passed = total - failures
    suite_ok = failures == 0
    failed_cases = [case_name for case_name, ok in results if not ok]

    print()
    print(
        f"TXT_SUITE arch={args.arch.upper()} simulator={args.simulator} "
        f"status={color_status(suite_ok)} total={total} pass={passed} fail={failures}"
    )
    if failed_cases:
        print(f"TXT_SUITE_FAILED cases={','.join(failed_cases)}")
    print(
        f"SUITE_SUMMARY arch={args.arch.upper()} simulator={args.simulator} "
        f"total={total} pass={passed} fail={failures} status={'PASS' if suite_ok else 'FAIL'}"
    )
    if power_samples:
        sum_active = sum(sample[0] for sample in power_samples)
        sum_total = sum(sample[1] for sample in power_samples)
        sum_zero = sum(sample[2] for sample in power_samples)
        avg_skip_pct = (100.0 * sum_zero / sum_total) if sum_total else 0.0
        print(
            f"TXT_POWER arch={args.arch.upper()} simulator={args.simulator} "
                f"cases={len(power_samples)} active_mac={sum_active} total_mac={sum_total} "
                f"zero_gated={sum_zero} avg_skip_pct={avg_skip_pct:.2f}%"
            )

    if args.enable_coverage:
        urg_bin = shutil.which("urg")
        if urg_bin is None:
            coverage_failed = True
            print(
                f"COVERAGE_REPORT arch={args.arch.upper()} simulator={args.simulator} "
                f"status=FAIL reason=missing_urg report={report_dir}"
            )
        elif not coverage_case_vdbs:
            coverage_failed = True
            print(
                f"COVERAGE_REPORT arch={args.arch.upper()} simulator={args.simulator} "
                f"status=FAIL reason=no_case_vdb report={report_dir}"
            )
        else:
            design_vdb = build_dir / f"{ARCH_CONFIG[args.arch]['top']}.simv.vdb"
            urg_cmd = [urg_bin, "-full64", "-dbname", str(merged_vdb), "-report", str(report_dir)]
            if design_vdb.exists():
                urg_cmd.extend(["-dir", str(design_vdb)])
            for case_vdb in coverage_case_vdbs:
                urg_cmd.extend(["-dir", str(case_vdb)])
            urg_rc, _ = run(urg_cmd, output_dir, env=vcs_env(), check=False)
            coverage_ok = (urg_rc == 0) and report_dir.exists()
            coverage_failed = not coverage_ok
            status = "PASS" if coverage_ok else "FAIL"
            print(
                f"COVERAGE_REPORT arch={args.arch.upper()} simulator={args.simulator} "
                f"status={status} cases={len(coverage_case_vdbs)} merged={merged_vdb} report={report_dir}"
            )

    return 1 if (failures or coverage_failed) else 0


if __name__ == "__main__":
    sys.exit(main())
