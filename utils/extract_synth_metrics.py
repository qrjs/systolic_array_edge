#!/usr/bin/env python3
import argparse
import csv
import pathlib
import re
from typing import Dict, List


def _read(path: pathlib.Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def _extract_float(pattern: str, text: str) -> str:
    m = re.search(pattern, text, re.MULTILINE)
    return m.group(1) if m else "NA"


def _extract_int(pattern: str, text: str) -> str:
    m = re.search(pattern, text, re.MULTILINE)
    return m.group(1) if m else "NA"


def _extract_first_timing_slack(kind: str, timing_text: str) -> str:
    # Match both "Failing Endpoint ," and "Failing Endpoints," styles.
    pattern = rf"{kind}\s*:\s*\d+\s+Failing Endpoint[s]?\s*,?\s+Worst Slack\s+([-\d\.]+)ns"
    matches = list(re.finditer(pattern, timing_text))
    if not matches:
        return "NA"
    return matches[0].group(1)


def parse_arch(repo_root: pathlib.Path, arch: str) -> Dict[str, str]:
    report_dir = repo_root / arch / "reports" / "synth"
    # 统一依赖三个核心报告：
    # 1) utilization_report.txt 资源
    # 2) timing_report.txt      setup/hold
    # 3) power_report.txt       总功耗/动态功耗
    # 文件缺失会抛异常，调用方据此判断该架构是否已完成综合。
    util = _read(report_dir / "utilization_report.txt")
    timing = _read(report_dir / "timing_report.txt")
    power = _read(report_dir / "power_report.txt")

    return {
        "arch": arch.upper(),
        "lut": _extract_int(r"Slice LUTs\*?\s*\|\s*([0-9]+)\s*\|", util),
        "ff": _extract_int(r"Slice Registers\s*\|\s*([0-9]+)\s*\|", util),
        "dsp": _extract_int(r"DSPs\s*\|\s*([0-9]+)\s*\|", util),
        "wns_ns": _extract_first_timing_slack("Setup", timing),
        "whs_ns": _extract_first_timing_slack("Hold", timing),
        "total_power_w": _extract_float(r"Total On-Chip Power \(W\)\s*\|\s*([-\d\.]+)", power),
        "dynamic_power_w": _extract_float(r"Dynamic \(W\)\s*\|\s*([-\d\.]+)", power),
    }


def to_markdown(rows: List[Dict[str, str]]) -> str:
    headers = [
        "ARCH",
        "LUT",
        "FF",
        "DSP",
        "WNS(ns)",
        "WHS(ns)",
        "TotalPower(W)",
        "Dynamic(W)",
    ]
    out = ["| " + " | ".join(headers) + " |", "|" + "|".join(["---"] * len(headers)) + "|"]
    for r in rows:
        out.append(
            "| "
            + " | ".join(
                [
                    r["arch"],
                    r["lut"],
                    r["ff"],
                    r["dsp"],
                    r["wns_ns"],
                    r["whs_ns"],
                    r["total_power_w"],
                    r["dynamic_power_w"],
                ]
            )
            + " |"
        )
    return "\n".join(out) + "\n"


def main() -> int:
    p = argparse.ArgumentParser(description="Extract Vivado synth metrics for multiple architectures.")
    p.add_argument("--repo-root", default=".", help="Repository root path")
    p.add_argument("--arches", nargs="+", default=["ws", "is", "os", "dip"], help="Architectures to summarize")
    p.add_argument(
        "--output-dir",
        default="test_logs/synth_summary",
        help="Directory to write summary csv/md",
    )
    args = p.parse_args()

    repo_root = pathlib.Path(args.repo_root).resolve()
    output_dir = pathlib.Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    rows = [parse_arch(repo_root, a) for a in args.arches]

    csv_path = output_dir / "synth_metrics.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "arch",
                "lut",
                "ff",
                "dsp",
                "wns_ns",
                "whs_ns",
                "total_power_w",
                "dynamic_power_w",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)

    md_path = output_dir / "synth_metrics.md"
    md_path.write_text(to_markdown(rows), encoding="utf-8")

    print(f"wrote: {csv_path}")
    print(f"wrote: {md_path}")
    print("")
    print(to_markdown(rows), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
