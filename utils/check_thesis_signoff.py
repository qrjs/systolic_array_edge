#!/usr/bin/env python3

import argparse
import csv
from pathlib import Path


ARCHES = ["WS", "OS", "IS", "DIP"]


def read_csv(path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def ensure_dir(path):
    path.mkdir(parents=True, exist_ok=True)


def as_int(value, default=-1):
    try:
        return int(float(value))
    except Exception:
        return default


def as_float(value, default=-1.0):
    try:
        return float(value)
    except Exception:
        return default


def add_check(rows, arch, item, status, detail):
    rows.append({
        "arch": arch,
        "item": item,
        "status": "PASS" if status else "FAIL",
        "detail": detail,
    })


def write_md(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Signoff Check\n\n")
        handle.write("该检查覆盖论文工程主线的前端功能、门级回归、FM、后端 Innovus 检查、时序余量、版图交付物、VDD/VSS special nets 和 block-level IO 边界。\n\n")
        handle.write("| Arch | Item | Status | Detail |\n")
        handle.write("| --- | --- | --- | --- |\n")
        for row in rows:
            handle.write("| {arch} | {item} | {status} | {detail} |\n".format(**row))
        overall = "PASS" if all(row["status"] == "PASS" for row in rows) else "FAIL"
        handle.write("\nOverall signoff check: `{}`\n".format(overall))


def write_csv(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["arch", "item", "status", "detail"], lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def check_arch(row, min_cases):
    arch = row.get("arch", "")
    checks = []

    front_total = as_int(row.get("front_total"))
    front_pass = as_int(row.get("front_pass"))
    front_fail = as_int(row.get("front_fail"))
    add_check(
        checks,
        arch,
        "rtl_frontsim_baseline",
        row.get("front_status") == "PASS" and front_total >= min_cases and front_pass == front_total and front_fail == 0,
        "{}/{} fail={} status={}".format(front_pass, front_total, front_fail, row.get("front_status", "")),
    )

    gate_total = as_int(row.get("gate_total"))
    gate_pass = as_int(row.get("gate_pass"))
    gate_fail = as_int(row.get("gate_fail"))
    add_check(
        checks,
        arch,
        "innovus_gate_sim_baseline",
        row.get("gate_status") == "PASS" and gate_total >= min_cases and gate_pass == gate_total and gate_fail == 0,
        "{}/{} fail={} status={}".format(gate_pass, gate_total, gate_fail, row.get("gate_status", "")),
    )

    for key in ["fm_dc", "fm_innovus", "innovus_drc", "innovus_connectivity"]:
        add_check(checks, arch, key, row.get(key) == "PASS", row.get(key, ""))

    slack = as_float(row.get("postroute_slack_ns"))
    add_check(checks, arch, "postroute_setup_slack", slack >= 0.0, "{} ns".format(row.get("postroute_slack_ns", "")))

    for key in ["gds_status", "def_status", "sdf_status", "netlist_status"]:
        add_check(checks, arch, key, row.get(key) == "PRESENT", row.get(key, ""))

    dc_area = as_float(row.get("dc_area_um2"))
    dc_dyn = as_float(row.get("dc_dynamic_mw"))
    innovus_area = as_float(row.get("innovus_area_um2"))
    innovus_power = as_float(row.get("innovus_total_mw"))
    add_check(checks, arch, "ppa_numbers_present", dc_area > 0 and dc_dyn > 0 and innovus_area > 0 and innovus_power > 0, "dc_area={} dc_dyn={} innovus_area={} innovus_total={}".format(row.get("dc_area_um2", ""), row.get("dc_dynamic_mw", ""), row.get("innovus_area_um2", ""), row.get("innovus_total_mw", "")))

    gates = as_int(row.get("clock_gates"), default=0)
    if arch == "DIP":
        add_check(checks, arch, "dip_clock_gating_enabled", gates > 0 and row.get("flavor") == "gated", "flavor={} clock_gates={}".format(row.get("flavor", ""), row.get("clock_gates", "")))
    else:
        add_check(checks, arch, "non_dip_clock_gating_disabled", gates == 0 and row.get("flavor") == "plain", "flavor={} clock_gates={}".format(row.get("flavor", ""), row.get("clock_gates", "")))

    return checks


def check_extended_validation(path):
    rows = read_csv(path)
    checks = []
    if not rows:
        add_check(checks, "ALL", "extended_validation_rows", False, "missing {}".format(path))
        return checks
    failed = []
    total_cases = 0
    for row in rows:
        row_total = as_int(row.get("total"), default=0)
        row_pass = as_int(row.get("pass"), default=-1)
        row_fail = as_int(row.get("fail"), default=-1)
        total_cases += max(0, row_total)
        if row.get("status") != "PASS" or row_total <= 0 or row_pass != row_total or row_fail != 0 or as_int(row.get("return_code"), default=1) != 0:
            failed.append("{}:{}:{}:{}".format(row.get("domain", ""), row.get("arch", ""), row.get("group", ""), row.get("status", "")))
    add_check(
        checks,
        "ALL",
        "extended_validation_clean",
        not failed,
        "rows={} cases={} failed={}".format(len(rows), total_cases, ",".join(failed[:6]) if failed else "none"),
    )
    return checks


def check_layout_completeness(path):
    rows = read_csv(path)
    checks = []
    if not rows:
        add_check(checks, "ALL", "layout_completeness_rows", False, "missing {}".format(path))
        return checks

    by_arch = {row.get("arch", ""): row for row in rows}
    for arch in ARCHES:
        row = by_arch.get(arch)
        if row is None:
            add_check(checks, arch, "layout_row_present", False, "missing from {}".format(path))
            continue
        add_check(checks, arch, "layout_row_present", True, "present")
        add_check(
            checks,
            arch,
            "block_layout_complete",
            row.get("block_layout_status") == "PASS" and row.get("gds_status") == "PRESENT" and row.get("def_status") == "PRESENT",
            "status={} gds={} def={} components={}".format(row.get("block_layout_status", ""), row.get("gds_status", ""), row.get("def_status", ""), row.get("components", "")),
        )
        add_check(
            checks,
            arch,
            "top_pins_legal",
            row.get("top_pins_legal") == "PASS" and as_int(row.get("illegal_pins"), 1) == 0 and as_int(row.get("unplaced_pins"), 1) == 0,
            "legal={}/{} illegal={} unplaced={}".format(row.get("legal_pins", ""), row.get("report_pins", ""), row.get("illegal_pins", ""), row.get("unplaced_pins", "")),
        )
        add_check(
            checks,
            arch,
            "pg_vdd_vss_specialnets",
            row.get("pg_specialnets") == "PASS"
            and row.get("has_vdd") == "YES"
            and row.get("has_vss") == "YES"
            and row.get("vdd_use_power") == "YES"
            and row.get("vss_use_ground") == "YES",
            "specialnets={} VDD={} use_power={} VSS={} use_ground={}".format(row.get("specialnets", ""), row.get("has_vdd", ""), row.get("vdd_use_power", ""), row.get("has_vss", ""), row.get("vss_use_ground", "")),
        )
        add_check(
            checks,
            arch,
            "innovus_layout_clean",
            row.get("innovus_clean") == "PASS"
            and as_int(row.get("connectivity_viols"), 1) == 0
            and as_int(row.get("connectivity_warnings"), 1) == 0
            and as_int(row.get("innovus_drc_viols"), 1) == 0,
            "conn={}v/{}w drc={} route={}/{}".format(row.get("connectivity_viols", ""), row.get("connectivity_warnings", ""), row.get("innovus_drc_viols", ""), row.get("route_nets", ""), row.get("route_terms", "")),
        )
        add_check(
            checks,
            arch,
            "block_level_io_scope_declared",
            row.get("io_pad_ring") == "NO" and row.get("tapeout_io_status") == "BLOCK_ONLY_NO_PAD_RING",
            "io_pad_ring={} pads={} status={}".format(row.get("io_pad_ring", ""), row.get("pads", ""), row.get("tapeout_io_status", "")),
        )
    return checks


def main():
    parser = argparse.ArgumentParser(description="Check thesis front-to-back evidence status.")
    parser.add_argument("--report-dir", default="reports/thesis")
    parser.add_argument("--min-cases", type=int, default=268)
    parser.add_argument("--require-extended", action="store_true")
    args = parser.parse_args()

    report_dir = Path(args.report_dir).resolve()
    summary_csv = report_dir / "summary.csv"
    rows = read_csv(summary_csv)
    by_arch = {row.get("arch", ""): row for row in rows}

    checks = []
    for arch in ARCHES:
        row = by_arch.get(arch)
        if row is None:
            add_check(checks, arch, "summary_row_present", False, "missing from {}".format(summary_csv))
            continue
        add_check(checks, arch, "summary_row_present", True, "present")
        checks.extend(check_arch(row, args.min_cases))

    validation_csv = report_dir / "runs" / "validation_summary.csv"
    if args.require_extended or validation_csv.exists():
        checks.extend(check_extended_validation(validation_csv))

    checks.extend(check_layout_completeness(report_dir / "layout_completeness.csv"))

    write_csv(report_dir / "signoff_check.csv", checks)
    write_md(report_dir / "signoff_check.md", checks)
    failed = [row for row in checks if row["status"] != "PASS"]
    print("THESIS_SIGNOFF_CHECK status={} report={}".format("FAIL" if failed else "PASS", report_dir / "signoff_check.md"))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
