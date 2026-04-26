#!/usr/bin/env python3

import argparse
import csv
import os
import re
import subprocess
import sys
from pathlib import Path


ARCHES = ["ws", "is", "os", "dip"]
SUMMARY_ROW_RE = re.compile(r"^\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*(?:\||$)")
STATUS_RE = re.compile(r"Suite status:\s*`?([^`\n]+)`?")


def read_csv(path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def ensure_dir(path):
    path.mkdir(parents=True, exist_ok=True)


def parse_group_filter(raw):
    return [item.strip() for item in raw.split(",") if item.strip()]


def group_selected(row, filters):
    if not filters:
        return False
    for item in filters:
        if item == "all":
            return True
        if item == row["group"] or item == row["kind"]:
            return True
    return False


def discover_vectors(repo_root, vector_root):
    rows = [{
        "group": "baseline_268",
        "kind": "baseline",
        "vector_dir": str((repo_root / "test_vectors" / "txt").resolve()),
        "cases": "268",
        "seed": "",
        "sparse_prob": "",
    }]
    manifest = vector_root / "manifest.csv"
    rows.extend(read_csv(manifest))
    return rows


def parse_suite_summary(path):
    result = {
        "status": "MISSING",
        "total": "",
        "pass": "",
        "fail": "",
    }
    if not path.exists():
        return result
    text = path.read_text(errors="ignore")
    status_match = STATUS_RE.search(text)
    if status_match:
        result["status"] = status_match.group(1).strip()
    for line in text.splitlines():
        match = SUMMARY_ROW_RE.match(line.strip())
        if match:
            result["total"] = match.group(1)
            result["pass"] = match.group(2)
            result["fail"] = match.group(3)
            break
    return result


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
            sys.stdout.write(line)
            handle.write(line)
        process.stdout.close()
        return process.wait()


def flavor_for_arch(arch):
    return "gated" if arch == "dip" else "plain"


def suite_script(repo_root, arch, script_name):
    arch_script = repo_root / "asic_commercial" / arch / "scripts" / script_name
    if arch_script.exists():
        return arch_script
    return repo_root / "asic_commercial" / "dip" / "scripts" / script_name


def frontsim_cmd(repo_root, arch):
    return ["bash", str(suite_script(repo_root, arch, "run_frontsim_suite.sh"))]


def gatesim_cmd(repo_root, arch, stage):
    return ["bash", str(suite_script(repo_root, arch, "run_postsim_suite.sh")), stage]


def apply_flow_env(env, repo_root, arch):
    env["FLOW_ROOT"] = str(repo_root / "asic_commercial" / arch)
    env["RUNSET_ROOT"] = str(repo_root / "asic_commercial" / "dip")


def write_rows(path, rows):
    ensure_dir(path.parent)
    fields = [
        "domain",
        "arch",
        "group",
        "kind",
        "vector_dir",
        "cases_requested",
        "stage",
        "status",
        "total",
        "pass",
        "fail",
        "return_code",
        "summary_path",
        "log_path",
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def write_md(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Validation Run Summary\n\n")
        handle.write("| Domain | Arch | Group | Stage | Status | Total | Pass | Fail | Log |\n")
        handle.write("| --- | --- | --- | --- | --- | ---: | ---: | ---: | --- |\n")
        for row in rows:
            handle.write(
                "| {} | {} | {} | {} | {} | {} | {} | {} | `{}` |\n".format(
                    row["domain"],
                    row["arch"].upper(),
                    row["group"],
                    row["stage"],
                    row["status"],
                    row["total"],
                    row["pass"],
                    row["fail"],
                    row["log_path"],
                )
            )


def merge_existing_rows(summary_path, new_rows):
    merged = {}
    if summary_path.exists():
        for row in read_csv(summary_path):
            key = (row.get("domain", ""), row.get("arch", ""), row.get("group", ""), row.get("stage", ""))
            merged[key] = row
    for row in new_rows:
        key = (row.get("domain", ""), row.get("arch", ""), row.get("group", ""), row.get("stage", ""))
        merged[key] = row
    return [merged[key] for key in sorted(merged.keys())]


def main():
    parser = argparse.ArgumentParser(description="Run thesis front/gate validation suites.")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--vector-root", default="test_vectors/thesis")
    parser.add_argument("--output-root", default="reports/thesis/runs")
    parser.add_argument("--arches", default="ws,os,is,dip")
    parser.add_argument("--front-groups", default="baseline_268,directed,random,sparse")
    parser.add_argument("--gate-groups", default="baseline_268,directed,sparse")
    parser.add_argument("--gate-stage", default="innovus")
    parser.add_argument("--frontsim-coverage", action="store_true", help="Enable VCS coverage for RTL frontsim suites.")
    parser.add_argument("--frontsim-coverage-strict", action="store_true", help="Fail when URG coverage report generation fails.")
    parser.add_argument("--skip-frontsim", action="store_true")
    parser.add_argument("--skip-gatesim", action="store_true")
    parser.add_argument("--stop-on-fail", action="store_true")
    parser.add_argument("--replace", action="store_true", help="Replace the validation summary instead of updating it incrementally.")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    vector_root = (repo_root / args.vector_root).resolve() if not Path(args.vector_root).is_absolute() else Path(args.vector_root)
    output_root = (repo_root / args.output_root).resolve() if not Path(args.output_root).is_absolute() else Path(args.output_root)
    ensure_dir(output_root)

    arches = [item.strip() for item in args.arches.split(",") if item.strip()]
    for arch in arches:
        if arch not in ARCHES:
            raise SystemExit("Unsupported arch '{}'".format(arch))

    vector_rows = discover_vectors(repo_root, vector_root)
    front_filters = parse_group_filter(args.front_groups)
    gate_filters = parse_group_filter(args.gate_groups)
    result_rows = []
    failures = 0

    for arch in arches:
        for vector in vector_rows:
            if not args.skip_frontsim and group_selected(vector, front_filters):
                suite_dir = output_root / arch / "front" / vector["group"]
                log_path = output_root / "logs" / "{}_front_{}.log".format(arch, vector["group"])
                summary_path = suite_dir / "summary.md"
                env = os.environ.copy()
                apply_flow_env(env, repo_root, arch)
                env["FRONTSIM_VECTOR_DIR"] = vector["vector_dir"]
                env["FRONTSIM_SUITE_DIR"] = str(suite_dir)
                env["MIN_VECTOR_CASES"] = str(vector.get("cases") or "0")
                if args.frontsim_coverage:
                    env["FRONTSIM_COVERAGE"] = "1"
                if args.frontsim_coverage_strict:
                    env["FRONTSIM_COVERAGE_STRICT"] = "1"
                cmd = frontsim_cmd(repo_root, arch)
                if args.dry_run:
                    rc = 0
                    print("DRY_RUN {}".format(" ".join(cmd)))
                else:
                    rc = run_command(cmd, env, repo_root, log_path)
                parsed = parse_suite_summary(summary_path)
                if rc != 0:
                    failures += 1
                result_rows.append({
                    "domain": "frontsim",
                    "arch": arch,
                    "group": vector["group"],
                    "kind": vector["kind"],
                    "vector_dir": vector["vector_dir"],
                    "cases_requested": vector.get("cases", ""),
                    "stage": "rtl",
                    "status": parsed["status"],
                    "total": parsed["total"],
                    "pass": parsed["pass"],
                    "fail": parsed["fail"],
                    "return_code": str(rc),
                    "summary_path": str(summary_path),
                    "log_path": str(log_path),
                })
                if rc != 0 and args.stop_on_fail:
                    summary_csv = output_root / "validation_summary.csv"
                    rows_to_write = result_rows if args.replace else merge_existing_rows(summary_csv, result_rows)
                    write_rows(summary_csv, rows_to_write)
                    return rc

            if not args.skip_gatesim and group_selected(vector, gate_filters):
                suite_dir = output_root / arch / "gate" / vector["group"]
                log_path = output_root / "logs" / "{}_gate_{}_{}.log".format(arch, args.gate_stage, vector["group"])
                summary_path = suite_dir / args.gate_stage / "summary.md"
                env = os.environ.copy()
                apply_flow_env(env, repo_root, arch)
                env["POSTSIM_VECTOR_DIR"] = vector["vector_dir"]
                env["POSTSIM_SUITE_DIR"] = str(suite_dir)
                env["MIN_GATE_CASES"] = str(vector.get("cases") or "0")
                env["POSTSIM_FLAVOR"] = flavor_for_arch(arch)
                env["POSTSIM_INNOVUS_FLAVOR"] = flavor_for_arch(arch)
                cmd = gatesim_cmd(repo_root, arch, args.gate_stage)
                if args.dry_run:
                    rc = 0
                    print("DRY_RUN {}".format(" ".join(cmd)))
                else:
                    rc = run_command(cmd, env, repo_root, log_path)
                parsed = parse_suite_summary(summary_path)
                if rc != 0:
                    failures += 1
                result_rows.append({
                    "domain": "gatesim",
                    "arch": arch,
                    "group": vector["group"],
                    "kind": vector["kind"],
                    "vector_dir": vector["vector_dir"],
                    "cases_requested": vector.get("cases", ""),
                    "stage": args.gate_stage,
                    "status": parsed["status"],
                    "total": parsed["total"],
                    "pass": parsed["pass"],
                    "fail": parsed["fail"],
                    "return_code": str(rc),
                    "summary_path": str(summary_path),
                    "log_path": str(log_path),
                })
                if rc != 0 and args.stop_on_fail:
                    summary_csv = output_root / "validation_summary.csv"
                    rows_to_write = result_rows if args.replace else merge_existing_rows(summary_csv, result_rows)
                    write_rows(summary_csv, rows_to_write)
                    return rc

    if args.dry_run:
        print("THESIS_VALIDATION_DRY_RUN commands={}".format(len(result_rows)))
        return 0

    summary_csv = output_root / "validation_summary.csv"
    rows_to_write = result_rows if args.replace else merge_existing_rows(summary_csv, result_rows)
    write_rows(summary_csv, rows_to_write)
    write_md(output_root / "validation_summary.md", rows_to_write)
    print("THESIS_VALIDATION_SUMMARY path={}".format(output_root / "validation_summary.csv"))
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
