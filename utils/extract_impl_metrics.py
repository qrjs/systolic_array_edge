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
    pattern = rf"{kind}\s*:\s*\d+\s+Failing Endpoint[s]?\s*,?\s+Worst Slack\s+([-\d\.]+)ns"
    matches = list(re.finditer(pattern, timing_text))
    if not matches:
        return "NA"
    return matches[0].group(1)


def _calc_fmax_mhz(wns_ns: str, period_ns: float) -> str:
    if wns_ns == "NA":
        return "NA"
    try:
        crit = period_ns - float(wns_ns)
    except ValueError:
        return "NA"
    if crit <= 0:
        return "NA"
    return f"{1000.0 / crit:.3f}"


def parse_arch(repo_root: pathlib.Path, arch: str, period_ns: float) -> Dict[str, str]:
    report_dir = repo_root / arch / "reports" / "impl"
    util_path = report_dir / "utilization_report.txt"
    timing_path = report_dir / "timing_post_route.txt"
    power_path = report_dir / "power_report.txt"

    if not (util_path.exists() and timing_path.exists() and power_path.exists()):
        return {
            "arch": arch.upper(),
            "status": "MISSING",
            "lut": "NA",
            "ff": "NA",
            "dsp": "NA",
            "wns_ns": "NA",
            "whs_ns": "NA",
            "fmax_mhz": "NA",
            "total_power_w": "NA",
            "dynamic_power_w": "NA",
        }

    util = _read(util_path)
    timing = _read(timing_path)
    power = _read(power_path)
    wns = _extract_first_timing_slack("Setup", timing)
    whs = _extract_first_timing_slack("Hold", timing)

    return {
        "arch": arch.upper(),
        "status": "READY",
        "lut": _extract_int(r"Slice LUTs\*?\s*\|\s*([0-9]+)\s*\|", util),
        "ff": _extract_int(r"Slice Registers\s*\|\s*([0-9]+)\s*\|", util),
        "dsp": _extract_int(r"DSPs\s*\|\s*([0-9]+)\s*\|", util),
        "wns_ns": wns,
        "whs_ns": whs,
        "fmax_mhz": _calc_fmax_mhz(wns, period_ns),
        "total_power_w": _extract_float(r"Total On-Chip Power \(W\)\s*\|\s*([-\d\.]+)", power),
        "dynamic_power_w": _extract_float(r"Dynamic \(W\)\s*\|\s*([-\d\.]+)", power),
    }


def to_markdown(rows: List[Dict[str, str]]) -> str:
    headers = [
        "ARCH",
        "STATUS",
        "LUT",
        "FF",
        "DSP",
        "PostRouteWNS(ns)",
        "PostRouteWHS(ns)",
        "PostRouteFmax(MHz)",
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
                    r["status"],
                    r["lut"],
                    r["ff"],
                    r["dsp"],
                    r["wns_ns"],
                    r["whs_ns"],
                    r["fmax_mhz"],
                    r["total_power_w"],
                    r["dynamic_power_w"],
                ]
            )
            + " |"
        )
    return "\n".join(out) + "\n"


def main() -> int:
    p = argparse.ArgumentParser(description="Extract Vivado post-route implementation metrics.")
    p.add_argument("--repo-root", default=".", help="Repository root path")
    p.add_argument("--arches", nargs="+", default=["ws", "is", "os", "dip"], help="Architectures to summarize")
    p.add_argument("--output-dir", default="test_logs/impl_summary", help="Directory to write summary csv/md")
    p.add_argument("--target-period-ns", type=float, default=10.0, help="Clock period used for Fmax estimation")
    args = p.parse_args()

    repo_root = pathlib.Path(args.repo_root).resolve()
    output_dir = pathlib.Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    rows = [parse_arch(repo_root, a, args.target_period_ns) for a in args.arches]

    csv_path = output_dir / "impl_metrics.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "arch",
                "status",
                "lut",
                "ff",
                "dsp",
                "wns_ns",
                "whs_ns",
                "fmax_mhz",
                "total_power_w",
                "dynamic_power_w",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)

    md_path = output_dir / "impl_metrics.md"
    md_path.write_text(to_markdown(rows), encoding="utf-8")

    print(f"wrote: {csv_path}")
    print(f"wrote: {md_path}")
    print("")
    print(to_markdown(rows), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
