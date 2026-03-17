#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VCS_LICENSE_FILE = os.environ.get("VCS_LICENSE_FILE", "5999@curry-GTR-Pro")


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


def build_once(arch: str, sim: str, build_dir: Path) -> Path:
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
    run([
        "vcs", "-full64", "-sverilog", "+incdir+" + str(ROOT), "-timescale=1ns/1ps", "-debug_access+all", "-kdb",
        "-licwait", "10",
        "-LDFLAGS", "-Wl,--no-as-needed", "-l", str(build_dir / "compile.log"),
        "-top", cfg["top"], "-o", str(exe), *(str(p) for p in cfg["rtl"]), str(cfg["tb"])
    ], build_dir, env=vcs_env())
    return exe


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--arch", required=True, choices=sorted(ARCH_CONFIG))
    parser.add_argument("--simulator", required=True, choices=["iverilog", "vcs"])
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    build_dir = (output_dir / "build").resolve()
    exe = build_once(args.arch, args.simulator, build_dir)

    results: list[tuple[str, bool]] = []
    failures = 0
    power_samples: list[tuple[int, int, int]] = []
    power_pattern = re.compile(r"\[[A-Z_]+\]\[POWER\].*?active_mac=(\d+)/(\d+).*?zero_gated=(\d+)")

    for input_path in sorted(vector_dir.glob("*_input.txt")):
        input_path = input_path.resolve()
        case_name = input_path.stem[:-6]
        expected_path = (vector_dir / f"{case_name}_expected.txt").resolve()
        pass_marker = f"[{args.arch.upper()}_FILE][PASS]"
        fail_marker = f"[{args.arch.upper()}_FILE][FAIL]"
        if args.simulator == "iverilog":
            cmd = ["vvp", str(exe), "+SOFT_FAIL", f"+INPUT={input_path}", f"+EXPECTED={expected_path}"]
            rc, output = run(cmd, output_dir, check=False)
        else:
            run_log = output_dir / f"{case_name}.run.log"
            cmd = [str(exe), "-l", str(run_log), "+SOFT_FAIL", f"+INPUT={input_path}", f"+EXPECTED={expected_path}"]
            rc, output = run(cmd, output_dir, env=vcs_env(), check=False)
            if run_log.exists():
                output += run_log.read_text(errors="ignore")
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

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
