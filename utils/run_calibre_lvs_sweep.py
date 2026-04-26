#!/usr/bin/env python3

import argparse
import csv
import os
import re
import subprocess
import sys
from pathlib import Path


ARCHES = ["ws", "os", "is", "dip"]
DESIGN = {
    "ws": "ws_core_std_top_4x4",
    "os": "os_core_std_top_4x4",
    "is": "is_core_std_top_4x4",
    "dip": "dip_core_std_top_4x4",
}

PROFILES = {
    "default": {},
    "ports_only_stdlib": {
        "CALIBRE_LVS_TEXT_MODE": "ports_only",
        "CALIBRE_LVS_STD_LIB": "1",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
    },
    "ports_only_nostdlib": {
        "CALIBRE_LVS_TEXT_MODE": "ports_only",
        "CALIBRE_LVS_STD_LIB": "0",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
    },
    "unpatched_ports_only_nostdlib": {
        "CALIBRE_LVS_TEXT_MODE": "ports_only",
        "CALIBRE_LVS_STD_LIB": "0",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
        "CALIBRE_LVS_USE_UNPATCHED_GDS": "1",
    },
    "patched_ports_only_nostdlib": {
        "CALIBRE_LVS_TEXT_MODE": "ports_only",
        "CALIBRE_LVS_STD_LIB": "0",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
        "CALIBRE_LVS_USE_UNPATCHED_GDS": "0",
    },
    "gds_text_stdlib": {
        "CALIBRE_LVS_TEXT_MODE": "gds",
        "CALIBRE_LVS_STD_LIB": "1",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
    },
    "no_text_stdlib": {
        "CALIBRE_LVS_TEXT_MODE": "none",
        "CALIBRE_LVS_STD_LIB": "1",
        "CALIBRE_LVS_UNIQUE_CASE_NETS": "1",
        "CALIBRE_LVS_DROP_TOP_POWER_PORTS": "1",
        "CALIBRE_LVS_GLOBALS_ARE_PORTS": "NO",
    },
}


def ensure_dir(path):
    path.mkdir(parents=True, exist_ok=True)


def split_csv(raw):
    return [item.strip() for item in raw.split(",") if item.strip()]


def read_text(path):
    try:
        return path.read_text(errors="ignore")
    except Exception:
        return ""


def parse_lvs_result(path):
    text = read_text(path)
    if not text:
        return "MISSING"
    if re.search(r"\bCORRECT\b", text) and not re.search(r"\bINCORRECT\b", text):
        return "CORRECT"
    if re.search(r"\bINCORRECT\b", text):
        return "INCORRECT"
    if re.search(r"\bNOT COMPARED\b", text):
        return "NOT_COMPARED"
    return "UNKNOWN"


def run_command(cmd, env, cwd, log_path):
    ensure_dir(log_path.parent)
    with log_path.open("w", encoding="utf-8") as handle:
        handle.write("$ {}\n\n".format(" ".join(cmd)))
        handle.flush()
        process = subprocess.Popen(
            cmd,
            cwd=str(cwd),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
            env=env,
        )
        assert process.stdout is not None
        for line in process.stdout:
            handle.write(line)
            if (
                line.startswith("[dip-flow]")
                or "LVS completed" in line
                or line.startswith("--- CALIBRE::LVS")
                or line.startswith("Error:")
            ):
                sys.stdout.write(line)
                sys.stdout.flush()
        process.stdout.close()
        return process.wait()


def write_summary(path, rows):
    ensure_dir(path.parent)
    fields = [
        "arch",
        "profile",
        "return_code",
        "result",
        "report",
        "log",
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def main():
    parser = argparse.ArgumentParser(description="Run Calibre LVS profile sweeps for thesis backend signoff debugging.")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--arches", default="ws,os,is,dip")
    parser.add_argument("--profiles", default="ports_only_nostdlib")
    parser.add_argument("--summary", default="reports/thesis/runs/calibre_lvs_sweep_summary.csv")
    parser.add_argument("--stop-on-fail", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    arches = split_csv(args.arches)
    profiles = split_csv(args.profiles)
    for arch in arches:
        if arch not in ARCHES:
            raise SystemExit("Unsupported arch '{}'".format(arch))
    for profile in profiles:
        if profile not in PROFILES:
            raise SystemExit("Unsupported profile '{}'. Available: {}".format(profile, ",".join(sorted(PROFILES))))

    rows = []
    failures = 0
    for arch in arches:
        design = DESIGN[arch]
        flow_root = repo_root / "asic_commercial" / arch
        script = flow_root / "scripts" / "run_calibre_lvs.sh"
        if not script.exists():
            script = repo_root / "asic_commercial" / "dip" / "scripts" / "run_calibre_lvs.sh"
        for profile in profiles:
            suffix = "lvs" if profile == "default" else "lvs_{}".format(profile)
            report = flow_root / "reports" / "calibre" / "{}_{}.rep".format(design, suffix)
            results = flow_root / "reports" / "calibre" / "{}_{}.results".format(design, suffix)
            deck = flow_root / "calibre" / "work" / "{}_{}.rule".format(design, suffix)
            source_cdl = flow_root / "calibre" / "work" / "{}_{}_source.cdl".format(design, suffix)
            normalized_v = flow_root / "calibre" / "work" / "{}_{}_case_normalized.v".format(design, suffix)
            case_report = flow_root / "calibre" / "work" / "{}_{}_case_normalized.rpt".format(design, suffix)
            port_text = flow_root / "calibre" / "work" / "{}_{}_ports.svrf".format(design, suffix)
            log = flow_root / "logs" / "{}_calibre_{}.log".format(design, suffix)

            env = os.environ.copy()
            env.update(PROFILES[profile])
            env.update({
                "FLOW_ROOT": str(flow_root),
                "RUNSET_ROOT": str(repo_root / "asic_commercial" / "dip"),
                "CALIBRE_LVS_RPT": str(report),
                "CALIBRE_LVS_RESULTS_DB": str(results),
                "CALIBRE_LVS_DECK": str(deck),
                "CALIBRE_LVS_SOURCE_CDL": str(source_cdl),
                "CALIBRE_LVS_NORMALIZED_VERILOG": str(normalized_v),
                "CALIBRE_LVS_CASE_REPORT": str(case_report),
                "CALIBRE_LVS_PORT_TEXT": str(port_text),
            })
            cmd = ["bash", str(script)]
            print("[lvs-sweep] start arch={} profile={} log={}".format(arch, profile, log), flush=True)
            if args.dry_run:
                rc = 0
            else:
                rc = run_command(cmd, env, flow_root, log)
            result = parse_lvs_result(report)
            print("[lvs-sweep] done arch={} profile={} rc={} result={} report={}".format(arch, profile, rc, result, report), flush=True)
            rows.append({
                "arch": arch,
                "profile": profile,
                "return_code": str(rc),
                "result": result,
                "report": str(report),
                "log": str(log),
            })
            if rc != 0:
                failures += 1
                if args.stop_on_fail:
                    write_summary((repo_root / args.summary).resolve(), rows)
                    return rc

    write_summary((repo_root / args.summary).resolve(), rows)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
