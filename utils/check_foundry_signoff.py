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


def as_int(value, default=0):
    try:
        return int(float(value))
    except Exception:
        return default


def add_row(rows, arch, item, status, detail, path=""):
    rows.append({
        "arch": arch,
        "item": item,
        "status": status,
        "detail": detail,
        "path": path,
    })


def collect_drc_checks(report_dir):
    rows = read_csv(report_dir / "calibre_drc_summary.csv")
    checks = []
    for arch in ARCHES:
        arch_rows = [row for row in rows if row.get("arch") == arch]
        count_sum = sum(as_int(row.get("count")) for row in arch_rows)
        expanded_sum = sum(as_int(row.get("expanded_count")) for row in arch_rows)
        paths = sorted({row.get("path", "") for row in arch_rows if row.get("path")})
        if not arch_rows:
            add_row(checks, arch, "calibre_foundry_drc", "FAIL", "missing drc summary rows")
        elif count_sum == 0 and expanded_sum == 0:
            add_row(checks, arch, "calibre_foundry_drc", "PASS", "count_sum=0 expanded_sum=0", paths[0] if paths else "")
        else:
            add_row(checks, arch, "calibre_foundry_drc", "FAIL", "count_sum={} expanded_sum={}".format(count_sum, expanded_sum), paths[0] if paths else "")
    return checks


def collect_lvs_checks(report_dir):
    rows = read_csv(report_dir / "calibre_lvs_summary.csv")
    by_arch = {row.get("arch"): row for row in rows}
    checks = []
    for arch in ARCHES:
        row = by_arch.get(arch)
        if row is None:
            add_row(checks, arch, "calibre_lvs", "FAIL", "missing lvs summary row")
            continue
        clean = row.get("result") == "CORRECT" and row.get("top_result") in ("CORRECT", "NA", "")
        status = "PASS" if clean else "FAIL"
        detail = "result={} top_result={} cells={} nets={} instances={} ports={}".format(
            row.get("result", ""),
            row.get("top_result", ""),
            row.get("incorrect_cells", ""),
            row.get("incorrect_nets", ""),
            row.get("incorrect_instances", ""),
            row.get("incorrect_ports", ""),
        )
        add_row(checks, arch, "calibre_lvs", status, detail, row.get("path", ""))
    return checks


def write_csv(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["arch", "item", "status", "detail", "path"], lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def md_value(value):
    return value if value not in ("", None) else "NA"


def write_md(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Foundry Signoff Check\n\n")
        handle.write("该检查只覆盖严格 foundry Calibre DRC/LVS，不代表论文实现主线。只有 DRC 非零规则为 0 且 LVS `CORRECT` 时才为 PASS。\n\n")
        handle.write("| Arch | Item | Status | Detail | Path |\n")
        handle.write("| --- | --- | --- | --- | --- |\n")
        for row in rows:
            handle.write("| {arch} | {item} | {status} | {detail} | `{path}` |\n".format(
                **{key: md_value(value) for key, value in row.items()}
            ))
        overall = "PASS" if all(row["status"] == "PASS" for row in rows) else "FAIL"
        handle.write("\nOverall foundry signoff check: `{}`\n".format(overall))


def main():
    parser = argparse.ArgumentParser(description="Check strict foundry Calibre DRC/LVS status.")
    parser.add_argument("--report-dir", default="reports/thesis")
    args = parser.parse_args()

    report_dir = Path(args.report_dir).resolve()
    rows = []
    rows.extend(collect_drc_checks(report_dir))
    rows.extend(collect_lvs_checks(report_dir))

    write_csv(report_dir / "foundry_signoff_check.csv", rows)
    write_md(report_dir / "foundry_signoff_check.md", rows)
    failed = [row for row in rows if row["status"] != "PASS"]
    print("FOUNDRY_SIGNOFF_CHECK status={} report={}".format("FAIL" if failed else "PASS", report_dir / "foundry_signoff_check.md"))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
