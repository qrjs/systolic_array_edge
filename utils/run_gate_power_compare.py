#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SUITE_INPUT_NAME = "suite_input.txt"
SUITE_EXPECTED_NAME = "suite_expected.txt"

FLOW_MAP = {
    "ws": ROOT / "asic_commercial" / "ws" / "scripts" / "run_postsim.sh",
    "is": ROOT / "asic_commercial" / "is" / "scripts" / "run_postsim.sh",
    "dip": ROOT / "asic_commercial" / "dip" / "scripts" / "run_postsim.sh",
    "os": ROOT / "asic_commercial" / "os" / "scripts" / "run_postsim.sh",
}

CASE_RE = re.compile(r"\[[A-Z_]+\]\[CASE\].*input=(\S+)\s+expected=(\S+)")
POWER_RE = re.compile(
    r"\[[A-Z_]+\]\[POWER\].*A_nz=(\d+)/(\d+)\s+B_nz=(\d+)/(\d+)\s+active_mac=(\d+)/(\d+)\s+zero_gated=(\d+)\s+skip_ratio=([0-9.]+)%"
)
CASE_METRIC_RE = re.compile(r"\[[A-Z_]+\]\[CASE_METRIC\]\s+launch_cycle=(\d+)\s+done_cycle=(\d+)\s+cycles=(\d+)")
PASS_RE = re.compile(r"\[([A-Z_]+)\]\[PASS\]\s+(\S+)")
FAIL_RE = re.compile(r"\[([A-Z_]+)\]\[FAIL\]\s+(\S+)")


@dataclass
class GateCaseMetric:
    arch: str
    case: str
    input_path: str
    expected_path: str
    status: str = ""
    a_nz: int | None = None
    a_total: int | None = None
    b_nz: int | None = None
    b_total: int | None = None
    active_mac: int | None = None
    total_mac: int | None = None
    zero_gated: int | None = None
    skip_ratio_pct: float | None = None
    launch_cycle: int | None = None
    done_cycle: int | None = None
    cycles: int | None = None
    run_log: str = ""
    vcd_path: str = ""


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


def run_case(
    arch: str,
    case_name: str,
    input_path: Path,
    expected_path: Path,
    output_dir: Path,
    *,
    sdf_mode: str,
    dump_vcd: bool,
) -> str:
    script = FLOW_MAP[arch]
    env = os.environ.copy()
    env["POSTSIM_INPUT"] = str(input_path)
    env["POSTSIM_EXPECTED"] = str(expected_path)
    env["POSTSIM_CASE"] = case_name
    env["POSTSIM_SDF_MODE"] = sdf_mode
    if dump_vcd:
        vcd_dir = output_dir / "vcd"
        vcd_dir.mkdir(parents=True, exist_ok=True)
        env["POSTSIM_VCD_PATH"] = str(vcd_dir / f"{arch}_{case_name}.vcd")

    result = subprocess.run([str(script)], cwd=ROOT, text=True, capture_output=True, env=env)
    text = (result.stdout or "") + (result.stderr or "")
    sys.stdout.write(result.stdout or "")
    sys.stderr.write(result.stderr or "")
    if result.returncode != 0:
        raise SystemExit(result.returncode)
    return text


def parse_log(arch: str, case_name: str, input_path: Path, expected_path: Path, text: str, output_dir: Path) -> GateCaseMetric:
    metric = GateCaseMetric(
        arch=arch.upper(),
        case=case_name,
        input_path=str(input_path),
        expected_path=str(expected_path),
        run_log=str(output_dir / "logs" / f"{arch}_{case_name}.log"),
        vcd_path=str(output_dir / "vcd" / f"{arch}_{case_name}.vcd"),
    )

    power_match = POWER_RE.search(text)
    if power_match:
        metric.a_nz = int(power_match.group(1))
        metric.a_total = int(power_match.group(2))
        metric.b_nz = int(power_match.group(3))
        metric.b_total = int(power_match.group(4))
        metric.active_mac = int(power_match.group(5))
        metric.total_mac = int(power_match.group(6))
        metric.zero_gated = int(power_match.group(7))
        metric.skip_ratio_pct = float(power_match.group(8))

    time_match = CASE_METRIC_RE.search(text)
    if time_match:
        metric.launch_cycle = int(time_match.group(1))
        metric.done_cycle = int(time_match.group(2))
        metric.cycles = int(time_match.group(3))

    if PASS_RE.search(text):
        metric.status = "PASS"
    elif FAIL_RE.search(text):
        metric.status = "FAIL"
    else:
        metric.status = "UNKNOWN"

    return metric


def write_csv(path: Path, rows: list[GateCaseMetric]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh)
        writer.writerow(
            [
                "arch",
                "case",
                "status",
                "input_path",
                "expected_path",
                "a_nz",
                "a_total",
                "b_nz",
                "b_total",
                "active_mac",
                "total_mac",
                "zero_gated",
                "skip_ratio_pct",
                "launch_cycle",
                "done_cycle",
                "cycles",
                "run_log",
                "vcd_path",
            ]
        )
        for r in rows:
            writer.writerow(
                [
                    r.arch,
                    r.case,
                    r.status,
                    r.input_path,
                    r.expected_path,
                    r.a_nz,
                    r.a_total,
                    r.b_nz,
                    r.b_total,
                    r.active_mac,
                    r.total_mac,
                    r.zero_gated,
                    r.skip_ratio_pct,
                    r.launch_cycle,
                    r.done_cycle,
                    r.cycles,
                    r.run_log,
                    r.vcd_path,
                ]
            )


def write_summary(path: Path, rows: list[GateCaseMetric]) -> None:
    valid = [r for r in rows if r.status == "PASS"]
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        fh.write("# Gate Workload Summary\n\n")
        if not valid:
            fh.write("No passing cases.\n")
            return
        active = sum(r.active_mac or 0 for r in valid)
        total = sum(r.total_mac or 0 for r in valid)
        zero = sum(r.zero_gated or 0 for r in valid)
        cycles = sum(r.cycles or 0 for r in valid)
        fh.write("| Arch | Cases | Active MAC | Total MAC | Zero Gated | Avg Skip (%) | Avg Cycles |\n")
        fh.write("| --- | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        fh.write(
            f"| {valid[0].arch} | {len(valid)} | {active} | {total} | {zero} | "
            f"{(100.0 * zero / total) if total else 0.0:.2f} | {(cycles / len(valid)) if valid else 0.0:.2f} |\n"
        )


def main() -> int:
    parser = argparse.ArgumentParser(description="Run gate-level file-vector workloads and collect activity-side metrics.")
    parser.add_argument("--arch", required=True, choices=sorted(FLOW_MAP))
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--sdf-mode", default="dc", choices=["none", "dc", "icc2", "custom"])
    parser.add_argument("--dump-vcd", action="store_true")
    parser.add_argument("--case-limit", type=int, default=0)
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    log_dir = output_dir / "logs"
    log_dir.mkdir(parents=True, exist_ok=True)

    cases = discover_cases(vector_dir)
    if args.case_limit > 0:
        cases = cases[: args.case_limit]

    rows: list[GateCaseMetric] = []
    for case_name, input_path, expected_path in cases:
        text = run_case(args.arch, case_name, input_path, expected_path, output_dir, sdf_mode=args.sdf_mode, dump_vcd=args.dump_vcd)
        (log_dir / f"{args.arch}_{case_name}.log").write_text(text, encoding="utf-8")
        rows.append(parse_log(args.arch, case_name, input_path, expected_path, text, output_dir))

    write_csv(output_dir / "gate_case_metrics.csv", rows)
    write_summary(output_dir / "summary.md", rows)
    print(f"GATE_WORKLOAD_SUMMARY output={output_dir / 'summary.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
