#!/usr/bin/env python3

import argparse
import csv
import os
import shutil
from pathlib import Path


ARCHES = ["ws", "os", "is", "dip"]
DESIGN = {
    "ws": "ws_core_std_top_4x4",
    "os": "os_core_std_top_4x4",
    "is": "is_core_std_top_4x4",
    "dip": "dip_core_std_top_4x4",
}


DOCS = [
    "docs/论文材料索引与版图状态_CN.md",
    "docs/PROJECT_LAYOUT_CN.md",
    "docs/论文大纲_面向边缘计算脉动阵列_CN.md",
    "docs/论文综合实验口径说明_CN.md",
    "docs/边缘优化实践与实现说明_CN.md",
]


LAYOUT_KINDS = [
    ("gds", "{}.gds"),
    ("def", "{}.def"),
    ("netlist", "{}_innovus.v"),
    ("lvs_netlist", "{}_innovus_lvs.v"),
    ("sdf", "{}_innovus.sdf"),
]


def ensure_dir(path):
    path.mkdir(parents=True, exist_ok=True)


def read_csv(path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def copy_file(src, dst):
    if not src.exists():
        return False
    ensure_dir(dst.parent)
    shutil.copy2(src, dst)
    return True


def link_or_copy(src, dst, copy_artifacts=False):
    if not src.exists():
        return "MISSING"
    ensure_dir(dst.parent)
    if dst.exists() or dst.is_symlink():
        dst.unlink()
    if copy_artifacts:
        shutil.copy2(src, dst)
        return "COPIED"
    rel_src = os.path.relpath(src, start=dst.parent)
    os.symlink(rel_src, dst)
    return "LINKED"


def report_status(report_dir):
    signoff = report_dir / "signoff_check.md"
    foundry = report_dir / "foundry_signoff_check.md"
    return {
        "signoff": "PRESENT" if signoff.exists() else "MISSING",
        "foundry": "PRESENT" if foundry.exists() else "MISSING",
    }


def collect_layout_rows(repo_root, out_dir, copy_artifacts):
    rows = []
    for arch in ARCHES:
        design = DESIGN[arch]
        src_root = repo_root / "asic_commercial" / arch / "results" / "innovus"
        dst_root = out_dir / "layouts" / arch
        view_script = repo_root / "asic_commercial" / arch / "scripts" / "view_layout.sh"
        view_dst = dst_root / "view_layout.sh"
        view_status = link_or_copy(view_script, view_dst, copy_artifacts=False)
        for kind, pattern in LAYOUT_KINDS:
            src = src_root / pattern.format(design)
            dst = dst_root / src.name
            status = link_or_copy(src, dst, copy_artifacts=copy_artifacts)
            rows.append({
                "arch": arch.upper(),
                "kind": kind,
                "status": status,
                "workspace_path": str(dst),
                "source_path": str(src),
            })
        rows.append({
            "arch": arch.upper(),
            "kind": "view_layout_script",
            "status": view_status,
            "workspace_path": str(view_dst),
            "source_path": str(view_script),
        })
    return rows


def write_layout_index(path, rows):
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["arch", "kind", "status", "workspace_path", "source_path"], lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def write_readme(path, repo_root, report_dir, layout_rows):
    ensure_dir(path.parent)
    status = report_status(report_dir)
    layout_csv = read_csv(report_dir / "layout_completeness.csv")
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Materials Workspace\n\n")
        handle.write("这个目录是论文写作工作区，由 `make thesis-workspace` 生成。`reports/` 和 `docs/` 是拷贝件；`layouts/` 默认是指向正式后端交付物的符号链接，避免重复存一份 GDS。\n\n")
        handle.write("## Current Status\n\n")
        handle.write("- Thesis implementation signoff report: `{}`\n".format(status["signoff"]))
        handle.write("- Foundry Calibre gap report: `{}`\n".format(status["foundry"]))
        handle.write("- Layout scope: block-level hard macro, not full-chip pad-ring layout\n")
        handle.write("- IO pad ring: no, pads=0 for all four dataflows\n")
        handle.write("- Power/ground: VDD/VSS DEF SPECIALNETS present for all four dataflows\n\n")

        if layout_csv:
            handle.write("## Layout Completeness Snapshot\n\n")
            handle.write("| Arch | Block Layout | IO Pad Ring | Pads | VDD/VSS | Components | Die um | Core um |\n")
            handle.write("| --- | --- | --- | ---: | --- | ---: | --- | --- |\n")
            for row in layout_csv:
                handle.write("| {arch} | {block} | {io} | {pads} | {pg} | {components} | {die} | {core} |\n".format(
                    arch=row.get("arch", ""),
                    block=row.get("block_layout_status", ""),
                    io=row.get("io_pad_ring", ""),
                    pads=row.get("pads", ""),
                    pg="{} VDD={} VSS={}".format(row.get("pg_specialnets", ""), row.get("has_vdd", ""), row.get("has_vss", "")),
                    components=row.get("components", ""),
                    die=row.get("die_um", ""),
                    core=row.get("core_um", ""),
                ))
            handle.write("\n")

        handle.write("## Report Entry Points\n\n")
        for name in [
            "summary.md",
            "dataflow_compare.md",
            "dip_ablation.md",
            "layout_completeness.md",
            "validation_matrix.md",
            "handoff_manifest.md",
            "signoff_check.md",
            "foundry_signoff_check.md",
            "tapeout_gap.md",
        ]:
            handle.write("- `reports/{}`\n".format(name))

        handle.write("\n## Layout Entry Points\n\n")
        for arch in ARCHES:
            design = DESIGN[arch]
            handle.write("- {}: `layouts/{}/{}.gds`, `layouts/{}/{}.def`, `layouts/{}/view_layout.sh`\n".format(
                arch.upper(),
                arch,
                design,
                arch,
                design,
                arch,
            ))

        handle.write("\n## Regenerate\n\n")
        handle.write("```bash\n")
        handle.write("make thesis-workspace\n")
        handle.write("```\n\n")
        handle.write("源仓库：`{}`\n".format(repo_root))


def main():
    parser = argparse.ArgumentParser(description="Package thesis reports and layout links into a writing workspace.")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--report-dir", default="reports/thesis")
    parser.add_argument("--output-dir", default="work/thesis_materials/latest")
    parser.add_argument("--copy-layout-artifacts", action="store_true", help="Copy GDS/DEF/SDF/netlists instead of creating symlinks.")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    report_dir = (repo_root / args.report_dir).resolve() if not Path(args.report_dir).is_absolute() else Path(args.report_dir)
    out_dir = (repo_root / args.output_dir).resolve() if not Path(args.output_dir).is_absolute() else Path(args.output_dir)

    ensure_dir(out_dir)
    ensure_dir(out_dir / "reports")
    ensure_dir(out_dir / "docs")

    copied_reports = 0
    for src in sorted(report_dir.glob("*")):
        if src.is_file() and src.suffix in [".md", ".csv"]:
            if copy_file(src, out_dir / "reports" / src.name):
                copied_reports += 1

    copied_docs = 0
    for rel in DOCS:
        src = repo_root / rel
        if copy_file(src, out_dir / "docs" / src.name):
            copied_docs += 1

    layout_rows = collect_layout_rows(repo_root, out_dir, args.copy_layout_artifacts)
    write_layout_index(out_dir / "layout_artifacts.csv", layout_rows)
    write_readme(out_dir / "README.md", repo_root, report_dir, layout_rows)

    print("THESIS_WORKSPACE path={}".format(out_dir))
    print("THESIS_WORKSPACE reports={} docs={} layout_entries={}".format(copied_reports, copied_docs, len(layout_rows)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
