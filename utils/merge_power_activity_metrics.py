#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
from pathlib import Path


def load_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as fh:
        return list(csv.DictReader(fh))


def as_float(value: str | None) -> float | None:
    if value is None or value == "":
        return None
    return float(value)


def as_int(value: str | None) -> int | None:
    if value is None or value == "":
        return None
    return int(value)


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def summarize(rows: list[dict[str, str]], arch: str, clk_period_ns: float) -> dict[str, str]:
    active_cases = [r for r in rows if r.get("status", "PASS") == "PASS"]
    if not active_cases:
        return {
            "arch": arch,
            "cases": "0",
            "avg_dynamic_mw": "NA",
            "avg_leakage_mw": "NA",
            "avg_total_mw": "NA",
            "avg_cycles": "NA",
            "total_active_mac": "NA",
            "total_zero_gated": "NA",
            "avg_skip_pct": "NA",
            "avg_energy_nj": "NA",
            "energy_per_active_mac_pj": "NA",
        }

    dyn = [as_float(r.get("dynamic_mw")) or 0.0 for r in active_cases]
    leak = [as_float(r.get("leakage_mw")) or 0.0 for r in active_cases]
    total = [as_float(r.get("total_mw")) or 0.0 for r in active_cases]
    cycles = [as_int(r.get("cycles")) or 0 for r in active_cases]
    active_mac = [as_int(r.get("active_mac")) or 0 for r in active_cases]
    zero_gated = [as_int(r.get("zero_gated")) or 0 for r in active_cases]
    total_mac = [as_int(r.get("total_mac")) or 0 for r in active_cases]

    total_energy_nj = 0.0
    total_active_mac = 0
    for row in active_cases:
        total_mw = as_float(row.get("total_mw")) or 0.0
        case_cycles = as_int(row.get("cycles")) or 0
        case_active = as_int(row.get("active_mac")) or 0
        case_time_ns = case_cycles * clk_period_ns
        case_energy_nj = total_mw * case_time_ns * 1.0e-3
        total_energy_nj += case_energy_nj
        total_active_mac += case_active

    energy_per_active_mac_pj = "NA"
    if total_active_mac > 0:
        energy_per_active_mac_pj = f"{(total_energy_nj * 1000.0) / total_active_mac:.6f}"

    skip_ratio = 0.0
    if sum(total_mac) > 0:
        skip_ratio = 100.0 * sum(zero_gated) / sum(total_mac)

    return {
        "arch": arch,
        "cases": str(len(active_cases)),
        "avg_dynamic_mw": f"{sum(dyn) / len(dyn):.6f}",
        "avg_leakage_mw": f"{sum(leak) / len(leak):.6f}",
        "avg_total_mw": f"{sum(total) / len(total):.6f}",
        "avg_cycles": f"{sum(cycles) / len(cycles):.6f}",
        "total_active_mac": str(sum(active_mac)),
        "total_zero_gated": str(sum(zero_gated)),
        "avg_skip_pct": f"{skip_ratio:.6f}",
        "avg_energy_nj": f"{total_energy_nj / len(active_cases):.6f}",
        "energy_per_active_mac_pj": energy_per_active_mac_pj,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Merge case-level activity metrics with case-level power data.")
    parser.add_argument("--activity-csv", required=True, help="CSV from run_workload_compare.py or run_gate_power_compare.py")
    parser.add_argument("--power-csv", required=True, help="CSV with columns: case,dynamic_mw,leakage_mw,total_mw")
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--arch", required=True)
    parser.add_argument("--clk-period-ns", type=float, required=True)
    args = parser.parse_args()

    activity_rows = load_csv(Path(args.activity_csv).resolve())
    power_rows = load_csv(Path(args.power_csv).resolve())
    power_by_case = {row["case"]: row for row in power_rows}

    merged: list[dict[str, str]] = []
    for row in activity_rows:
        case_name = row["case"]
        power = power_by_case.get(case_name, {})
        merged_row = dict(row)
        merged_row["dynamic_mw"] = power.get("dynamic_mw", "")
        merged_row["leakage_mw"] = power.get("leakage_mw", "")
        merged_row["total_mw"] = power.get("total_mw", "")

        total_mw = as_float(merged_row["total_mw"])
        cycles = as_int(merged_row.get("cycles"))
        active_mac = as_int(merged_row.get("active_mac"))
        if total_mw is not None and cycles is not None:
            case_time_ns = cycles * args.clk_period_ns
            energy_nj = total_mw * case_time_ns * 1.0e-3
            merged_row["energy_nj"] = f"{energy_nj:.6f}"
            if active_mac not in (None, 0):
                merged_row["energy_per_active_mac_pj"] = f"{(energy_nj * 1000.0) / active_mac:.6f}"
            else:
                merged_row["energy_per_active_mac_pj"] = ""
        else:
            merged_row["energy_nj"] = ""
            merged_row["energy_per_active_mac_pj"] = ""
        merged.append(merged_row)

    output_dir = Path(args.output_dir).resolve()
    if merged:
        fieldnames = list(merged[0].keys())
    else:
        fieldnames = []
    write_csv(output_dir / "merged_case_metrics.csv", merged, fieldnames)

    summary = summarize(merged, args.arch.upper(), args.clk_period_ns)
    write_csv(output_dir / "summary.csv", [summary], list(summary.keys()))

    md_path = output_dir / "summary.md"
    with md_path.open("w", encoding="utf-8") as fh:
        fh.write("# Power + Activity Summary\n\n")
        fh.write("| Arch | Cases | Avg Dyn (mW) | Avg Leak (mW) | Avg Total (mW) | Avg Cycles | Total Active MAC | Total Zero Gated | Avg Skip (%) | Avg Energy (nJ) | Energy / Active MAC (pJ) |\n")
        fh.write("| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        fh.write(
            f"| {summary['arch']} | {summary['cases']} | {summary['avg_dynamic_mw']} | {summary['avg_leakage_mw']} | "
            f"{summary['avg_total_mw']} | {summary['avg_cycles']} | {summary['total_active_mac']} | "
            f"{summary['total_zero_gated']} | {summary['avg_skip_pct']} | {summary['avg_energy_nj']} | "
            f"{summary['energy_per_active_mac_pj']} |\n"
        )

    print(f"MERGE_POWER_ACTIVITY_SUMMARY output={md_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

