#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RUN_SUITE = ROOT / "utils" / "run_file_vector_suite.py"


@dataclass
class CaseMetric:
    arch: str
    case: str
    input_path: str
    expected_path: str
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
    status: str | None = None


CASE_RE = re.compile(r"\[[A-Z_]+\]\[CASE\].*input=(\S+)\s+expected=(\S+)")
POWER_RE = re.compile(
    r"\[[A-Z_]+\]\[POWER\].*A_nz=(\d+)/(\d+)\s+B_nz=(\d+)/(\d+)\s+active_mac=(\d+)/(\d+)\s+zero_gated=(\d+)\s+skip_ratio=([0-9.]+)%"
)
CASE_METRIC_RE = re.compile(r"\[[A-Z_]+\]\[CASE_METRIC\]\s+launch_cycle=(\d+)\s+done_cycle=(\d+)\s+cycles=(\d+)")
PASS_RE = re.compile(r"FILE_VECTOR\s+arch=([A-Z]+)\s+simulator=\w+\s+case=([^\s]+)\s+status=(PASS|FAIL)")


def run_suite(arch: str, simulator: str, vector_dir: Path, output_dir: Path) -> str:
    output_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        sys.executable,
        str(RUN_SUITE),
        "--arch",
        arch,
        "--simulator",
        simulator,
        "--vector-dir",
        str(vector_dir),
        "--output-dir",
        str(output_dir),
    ]
    result = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
    text = (result.stdout or "") + (result.stderr or "")
    sys.stdout.write(result.stdout or "")
    sys.stderr.write(result.stderr or "")
    if result.returncode != 0:
        raise SystemExit(result.returncode)
    return text


def parse_case_name(input_path: str) -> str:
    name = Path(input_path).name
    if name.endswith("_input.txt"):
        return name[:-10]
    return Path(input_path).stem


def parse_output(arch: str, text: str) -> list[CaseMetric]:
    by_case: dict[str, CaseMetric] = {}
    current_case: str | None = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        case_match = CASE_RE.search(line)
        if case_match:
            input_path, expected_path = case_match.groups()
            case_name = parse_case_name(input_path)
            current_case = case_name
            by_case.setdefault(case_name, CaseMetric(arch=arch, case=case_name, input_path=input_path, expected_path=expected_path))
            continue

        power_match = POWER_RE.search(line)
        if power_match and current_case is not None:
            metric = by_case[current_case]
            metric.a_nz = int(power_match.group(1))
            metric.a_total = int(power_match.group(2))
            metric.b_nz = int(power_match.group(3))
            metric.b_total = int(power_match.group(4))
            metric.active_mac = int(power_match.group(5))
            metric.total_mac = int(power_match.group(6))
            metric.zero_gated = int(power_match.group(7))
            metric.skip_ratio_pct = float(power_match.group(8))
            continue

        timing_match = CASE_METRIC_RE.search(line)
        if timing_match and current_case is not None:
            metric = by_case[current_case]
            metric.launch_cycle = int(timing_match.group(1))
            metric.done_cycle = int(timing_match.group(2))
            metric.cycles = int(timing_match.group(3))
            continue

        pass_match = PASS_RE.search(line)
        if pass_match:
            _, case_name, status = pass_match.groups()
            by_case.setdefault(case_name, CaseMetric(arch=arch, case=case_name, input_path="", expected_path=""))
            by_case[case_name].status = status

    return [by_case[name] for name in sorted(by_case)]


def write_case_csv(path: Path, metrics: list[CaseMetric]) -> None:
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
                "active_mac_per_cycle",
            ]
        )
        for m in metrics:
            active_per_cycle = ""
            if m.active_mac is not None and m.cycles not in (None, 0):
                active_per_cycle = f"{m.active_mac / m.cycles:.6f}"
            writer.writerow(
                [
                    m.arch,
                    m.case,
                    m.status or "",
                    m.input_path,
                    m.expected_path,
                    m.a_nz,
                    m.a_total,
                    m.b_nz,
                    m.b_total,
                    m.active_mac,
                    m.total_mac,
                    m.zero_gated,
                    m.skip_ratio_pct,
                    m.launch_cycle,
                    m.done_cycle,
                    m.cycles,
                    active_per_cycle,
                ]
            )


def summarize(metrics: list[CaseMetric]) -> dict[str, float | int]:
    valid = [m for m in metrics if m.status == "PASS"]
    if not valid:
        return {"cases": 0}
    sum_active = sum(m.active_mac or 0 for m in valid)
    sum_total = sum(m.total_mac or 0 for m in valid)
    sum_zero = sum(m.zero_gated or 0 for m in valid)
    sum_cycles = sum(m.cycles or 0 for m in valid)
    return {
        "cases": len(valid),
        "active_mac": sum_active,
        "total_mac": sum_total,
        "zero_gated": sum_zero,
        "avg_skip_pct": (100.0 * sum_zero / sum_total) if sum_total else 0.0,
        "avg_cycles": (sum_cycles / len(valid)) if valid else 0.0,
        "active_mac_per_cycle": (sum_active / sum_cycles) if sum_cycles else 0.0,
    }


def write_summary_md(path: Path, arch_to_summary: dict[str, dict[str, float | int]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        fh.write("# Workload Activity Summary\n\n")
        fh.write("| Arch | Cases | Active MAC | Total MAC | Zero Gated | Avg Skip (%) | Avg Cycles | Active MAC / Cycle |\n")
        fh.write("| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        for arch, s in arch_to_summary.items():
            fh.write(
                f"| {arch} | {s.get('cases', 0)} | {s.get('active_mac', 0)} | {s.get('total_mac', 0)} | "
                f"{s.get('zero_gated', 0)} | {s.get('avg_skip_pct', 0.0):.2f} | "
                f"{s.get('avg_cycles', 0.0):.2f} | {s.get('active_mac_per_cycle', 0.0):.4f} |\n"
            )


def main() -> int:
    parser = argparse.ArgumentParser(description="Run the same txt workload on multiple architectures and summarize activity metrics.")
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--simulator", default="iverilog", choices=["iverilog", "vcs"])
    parser.add_argument("--arches", nargs="+", default=["ws", "is", "os", "dip"], choices=["dip", "os", "ws", "is"])
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    all_metrics: list[CaseMetric] = []
    arch_to_summary: dict[str, dict[str, float | int]] = {}

    for arch in args.arches:
        arch_out = output_dir / arch
        text = run_suite(arch, args.simulator, vector_dir, arch_out)
        metrics = parse_output(arch.upper(), text)
        write_case_csv(arch_out / "case_metrics.csv", metrics)
        arch_to_summary[arch.upper()] = summarize(metrics)
        all_metrics.extend(metrics)

    write_case_csv(output_dir / "all_case_metrics.csv", all_metrics)
    write_summary_md(output_dir / "summary.md", arch_to_summary)
    print(f"WORKLOAD_COMPARE_SUMMARY output={output_dir / 'summary.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
