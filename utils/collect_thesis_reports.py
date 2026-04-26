#!/usr/bin/env python3

import argparse
import csv
import hashlib
import os
import re
from pathlib import Path


ARCHES = ["ws", "os", "is", "dip"]
DESIGN = {
    "ws": "ws_core_std_top_4x4",
    "os": "os_core_std_top_4x4",
    "is": "is_core_std_top_4x4",
    "dip": "dip_core_std_top_4x4",
}


def read_text(path):
    try:
        return path.read_text(errors="ignore")
    except Exception:
        return ""


def ensure_dir(path):
    path.mkdir(parents=True, exist_ok=True)


def read_csv(path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def status_or_missing(path, ok_pattern, fail_pattern=None):
    text = read_text(path)
    if not text:
        return "MISSING"
    if re.search(ok_pattern, text, re.I | re.S):
        return "PASS"
    if fail_pattern and re.search(fail_pattern, text, re.I | re.S):
        return "FAIL"
    return "UNKNOWN"


def parse_suite_summary(path):
    text = read_text(path)
    result = {
        "status": "MISSING",
        "total": "",
        "pass": "",
        "fail": "",
        "avg_cycles": "",
        "active_mac": "",
        "zero_gated": "",
        "avg_skip_pct": "",
    }
    if not text:
        return result
    status_match = re.search(r"Suite status:\s*`?([^`\n]+)`?", text)
    if status_match:
        result["status"] = status_match.group(1).strip()
    for line in text.splitlines():
        parts = [part.strip() for part in line.strip().strip("|").split("|")]
        if len(parts) >= 3 and all(re.match(r"^-?\d+(?:\.\d+)?$", item) for item in parts[:3]):
            result["total"], result["pass"], result["fail"] = parts[:3]
            if len(parts) >= 7:
                result["avg_cycles"] = parts[3]
                result["active_mac"] = parts[4]
                result["zero_gated"] = parts[5]
                result["avg_skip_pct"] = parts[6]
            break
    return result


def parse_first_float(pattern, text):
    match = re.search(pattern, text, re.I | re.M)
    if not match:
        return ""
    return match.group(1)


def power_to_mw(value, unit):
    if value == "":
        return ""
    number = float(value)
    unit = (unit or "mW").lower()
    if unit == "w":
        number *= 1000.0
    elif unit == "uw":
        number *= 0.001
    elif unit == "nw":
        number *= 0.000001
    return "{:.6f}".format(number)


def parse_dc_power(path):
    text = read_text(path)
    result = {"dynamic_mw": "", "leakage_mw": ""}
    if not text:
        return result
    dyn = re.search(r"Total Dynamic Power\s*=\s*([0-9.]+)\s*([munp]?W)", text, re.I)
    leak = re.search(r"Cell Leakage Power\s*=\s*([0-9.]+)\s*([munp]?W)", text, re.I)
    if dyn:
        result["dynamic_mw"] = power_to_mw(dyn.group(1), dyn.group(2))
    if leak:
        result["leakage_mw"] = power_to_mw(leak.group(1), leak.group(2))
    return result


def parse_innovus_power(path):
    text = read_text(path)
    result = {
        "internal_mw": "",
        "switching_mw": "",
        "leakage_mw": "",
        "total_mw": "",
    }
    if not text:
        return result
    for key, label in [
        ("internal_mw", "Total Internal Power"),
        ("switching_mw", "Total Switching Power"),
        ("leakage_mw", "Total Leakage Power"),
        ("total_mw", "Total Power"),
    ]:
        match = re.search(r"{}:\s*([0-9.eE+-]+)".format(re.escape(label)), text)
        if match:
            result[key] = "{:.6f}".format(float(match.group(1)))
    return result


def parse_innovus_area(path):
    text = read_text(path)
    for line in text.splitlines():
        parts = line.split()
        if len(parts) >= 4 and parts[0] == "0":
            return {"instances": parts[2], "area_um2": parts[3]}
    return {"instances": "", "area_um2": ""}


def parse_dc_area(path):
    return parse_first_float(r"Total cell area:\s*([0-9.]+)", read_text(path))


def parse_fm(path):
    text = read_text(path)
    result = {"status": "MISSING", "passing": "", "failing": "", "aborted": "", "unverified": ""}
    if not text:
        return result
    status = re.search(r"Status:\s+(\S+)", text)
    if status:
        result["status"] = "PASS" if status.group(1) == "SUCCEEDED" else status.group(1)
    for key, label in [
        ("passing", "Passing Points"),
        ("failing", "Failing Points"),
        ("aborted", "Aborted Points"),
        ("unverified", "Unverified Points"),
    ]:
        match = re.search(r"{}:\s+([0-9]+)".format(label), text)
        if match:
            result[key] = match.group(1)
    return result


def parse_clock_gates(flow_root, design):
    candidates = [
        flow_root / "logs" / "{}_innovus_view.log".format(design),
        flow_root / "logs" / "{}_innovus.log".format(design),
    ]
    for path in candidates:
        text = read_text(path)
        if not text:
            continue
        matches = re.findall(r"clock_tree\s+clk\s+contains\s+\d+\s+sinks\s+and\s+(\d+)\s+clock gates", text)
        if matches:
            return matches[-1]
        matches = re.findall(r"Total clock gates\s+(\d+)", text)
        if matches:
            return matches[-1]
    return ""


def file_status(path):
    if not path.exists():
        return {"status": "MISSING", "path": str(path), "bytes": "", "mtime": ""}
    stat = path.stat()
    return {
        "status": "PRESENT",
        "path": str(path),
        "bytes": str(stat.st_size),
        "mtime": str(int(stat.st_mtime)),
    }


def sha256_file(path):
    if not path.exists():
        return ""
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def collect_arch(repo_root, arch):
    flow_root = repo_root / "asic_commercial" / arch
    design = DESIGN[arch]
    flavor = "gated" if arch == "dip" else "plain"
    reports = flow_root / "reports"
    innovus_reports = reports / "innovus"
    fm_reports = reports / "fm"
    results = flow_root / "results"
    innovus_results = results / "innovus"

    front = parse_suite_summary(flow_root / "frontsim" / "suites" / "summary.md")
    gate = parse_suite_summary(flow_root / "postsim" / "suites" / "innovus" / "summary.md")
    innovus_area = parse_innovus_area(innovus_reports / "{}_area.rpt".format(design))
    innovus_power = parse_innovus_power(innovus_reports / "{}_power.rpt".format(design))
    dc_area = parse_dc_area(reports / "{}_dc_{}_area.rpt".format(design, flavor))
    dc_power = parse_dc_power(reports / "{}_dc_{}_power.rpt".format(design, flavor))
    fm_dc = parse_fm(fm_reports / "{}_fm_dc_{}_summary.rpt".format(design, flavor))
    fm_innovus = parse_fm(fm_reports / "{}_fm_innovus_{}_summary.rpt".format(design, flavor))
    gds = file_status(innovus_results / "{}.gds".format(design))
    def_file = file_status(innovus_results / "{}.def".format(design))
    sdf = file_status(innovus_results / "{}_innovus.sdf".format(design))
    netlist = file_status(innovus_results / "{}_innovus.v".format(design))

    drc_status = status_or_missing(innovus_reports / "{}_drc.rpt".format(design), r"Verification Complete\s*:\s*0 Viols")
    conn_status = status_or_missing(
        innovus_reports / "{}_connectivity.rpt".format(design),
        r"Found no problems or warnings.*Verification Complete\s*:\s*0 Viols\.\s*0 Wrngs",
    )
    slack = parse_first_float(r"=\s*Slack Time\s+(-?[0-9.]+)", read_text(innovus_reports / "{}_timing.rpt".format(design)))
    clock_gates = parse_clock_gates(flow_root, design)

    return {
        "arch": arch.upper(),
        "flavor": flavor,
        "clock_gates": clock_gates,
        "front_status": front["status"],
        "front_total": front["total"],
        "front_pass": front["pass"],
        "front_fail": front["fail"],
        "gate_status": gate["status"],
        "gate_total": gate["total"],
        "gate_pass": gate["pass"],
        "gate_fail": gate["fail"],
        "gate_avg_cycles": gate["avg_cycles"],
        "gate_active_mac": gate["active_mac"],
        "gate_zero_gated": gate["zero_gated"],
        "gate_avg_skip_pct": gate["avg_skip_pct"],
        "dc_area_um2": dc_area,
        "dc_dynamic_mw": dc_power["dynamic_mw"],
        "dc_leakage_mw": dc_power["leakage_mw"],
        "innovus_instances": innovus_area["instances"],
        "innovus_area_um2": innovus_area["area_um2"],
        "innovus_internal_mw": innovus_power["internal_mw"],
        "innovus_switching_mw": innovus_power["switching_mw"],
        "innovus_leakage_mw": innovus_power["leakage_mw"],
        "innovus_total_mw": innovus_power["total_mw"],
        "postroute_slack_ns": slack,
        "innovus_drc": drc_status,
        "innovus_connectivity": conn_status,
        "fm_dc": fm_dc["status"],
        "fm_innovus": fm_innovus["status"],
        "gds_status": gds["status"],
        "gds_path": gds["path"],
        "gds_bytes": gds["bytes"],
        "def_status": def_file["status"],
        "sdf_status": sdf["status"],
        "netlist_status": netlist["status"],
    }


def write_csv(path, rows):
    ensure_dir(path.parent)
    fields = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def md_value(value):
    return value if value not in ("", None) else "NA"


def to_float(value, default=0.0):
    try:
        return float(value)
    except Exception:
        return default


def avg(rows, key):
    values = [to_float(row.get(key, "")) for row in rows if row.get(key, "") not in ("", None)]
    if not values:
        return ""
    return "{:.2f}".format(sum(values) / float(len(values)))


def total(rows, key):
    values = [to_float(row.get(key, "")) for row in rows if row.get(key, "") not in ("", None)]
    if not values:
        return ""
    if all(abs(value - int(value)) < 1e-9 for value in values):
        return str(int(sum(values)))
    return "{:.2f}".format(sum(values))


def write_dataflow_compare(path, rows):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Dataflow Compare\n\n")
        handle.write("主表用于统一工程平台下的 WS/OS/IS/DiP 对比；DiP 的 clock gating 作为工程优化点单独标注。\n\n")
        handle.write("| Arch | Flavor | DC Area | DC Dyn mW | Innovus Area | Innovus Total mW | Slack ns | Gate Sim | FM Innovus | DRC | Conn | Clock Gates |\n")
        handle.write("| --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- | --- | ---: |\n")
        for row in rows:
            handle.write(
                "| {arch} | {flavor} | {dc_area_um2} | {dc_dynamic_mw} | {innovus_area_um2} | {innovus_total_mw} | {postroute_slack_ns} | {gate_pass}/{gate_total} {gate_status} | {fm_innovus} | {innovus_drc} | {innovus_connectivity} | {clock_gates} |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def write_backend_status(path, rows):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Backend Status\n\n")
        handle.write("| Arch | GDS | DEF | Innovus SDF | Netlist | DRC | Connectivity | Slack ns | FM DC | FM Innovus |\n")
        handle.write("| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- |\n")
        for row in rows:
            handle.write(
                "| {arch} | {gds_status} | {def_status} | {sdf_status} | {netlist_status} | {innovus_drc} | {innovus_connectivity} | {postroute_slack_ns} | {fm_dc} | {fm_innovus} |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )
        handle.write("\n## Layout Files\n\n")
        for row in rows:
            handle.write("- {}: `{}` bytes={}\n".format(row["arch"], row["gds_path"], md_value(row["gds_bytes"])))


def collect_handoff(repo_root):
    rows = []
    for arch in ARCHES:
        design = DESIGN[arch]
        flow_root = repo_root / "asic_commercial" / arch
        result_root = flow_root / "results" / "innovus"
        script_root = flow_root / "scripts"
        artifacts = [
            ("gds", result_root / "{}.gds".format(design)),
            ("def", result_root / "{}.def".format(design)),
            ("sdf", result_root / "{}_innovus.sdf".format(design)),
            ("netlist", result_root / "{}_innovus.v".format(design)),
            ("lvs_netlist", result_root / "{}_innovus_lvs.v".format(design)),
        ]
        for kind, path in artifacts:
            info = file_status(path)
            rows.append({
                "arch": arch.upper(),
                "kind": kind,
                "status": info["status"],
                "bytes": info["bytes"],
                "mtime": info["mtime"],
                "sha256": sha256_file(path),
                "path": info["path"],
            })
        for kind, path in [
            ("view_layout_script", script_root / "view_layout.sh"),
            ("innovus_gui_script", script_root / "run_innovus_gui.sh"),
            ("virtuoso_layout_script", script_root / "run_virtuoso_layout.sh"),
        ]:
            info = file_status(path)
            rows.append({
                "arch": arch.upper(),
                "kind": kind,
                "status": info["status"],
                "bytes": info["bytes"],
                "mtime": info["mtime"],
                "sha256": sha256_file(path),
                "path": info["path"],
            })
    return rows


def write_handoff_manifest(path, csv_path, repo_root):
    rows = collect_handoff(repo_root)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Handoff Manifest\n\n")
        handle.write("该表固定四个数据流的后端交付物和版图查看脚本，包含文件大小与 SHA256，便于答辩/复现实验时确认使用的是同一批产物。\n\n")
        handle.write("| Arch | Kind | Status | Bytes | SHA256 | Path |\n")
        handle.write("| --- | --- | --- | ---: | --- | --- |\n")
        for row in rows:
            sha = row["sha256"][:16] if row["sha256"] else ""
            handle.write(
                "| {arch} | {kind} | {status} | {bytes} | {sha} | `{path}` |\n".format(
                    arch=row["arch"],
                    kind=row["kind"],
                    status=row["status"],
                    bytes=md_value(row["bytes"]),
                    sha=md_value(sha),
                    path=row["path"],
                )
            )
        handle.write("\n## Layout View Commands\n\n")
        for arch in ARCHES:
            script = repo_root / "asic_commercial" / arch / "scripts" / "view_layout.sh"
            if script.exists():
                handle.write("- {}: `{}`\n".format(arch.upper(), script))


def int_value(value, default=0):
    try:
        return int(float(value))
    except Exception:
        return default


def dim_pair(width, height):
    if width in ("", None) or height in ("", None):
        return ""
    return "{} x {}".format(width, height)


def collect_layout_completeness(repo_root):
    rows = []
    for arch in ARCHES:
        design = DESIGN[arch]
        flow_root = repo_root / "asic_commercial" / arch
        innovus_results = flow_root / "results" / "innovus"
        innovus_reports = flow_root / "reports" / "innovus"

        def_path = innovus_results / "{}.def".format(design)
        gds_path = innovus_results / "{}.gds".format(design)
        layout = parse_def_layout(def_path)
        pins = parse_pin_assignment(innovus_reports / "{}_pin_assignment.rpt".format(design), design)
        route = parse_route_status(innovus_reports / "{}_route.rpt".format(design))
        conn = parse_innovus_connectivity(innovus_reports / "{}_connectivity.rpt".format(design))
        drc = parse_innovus_drc(innovus_reports / "{}_drc.rpt".format(design))

        gds = file_status(gds_path)
        def_file = file_status(def_path)
        top_pins_legal = (
            int_value(pins.get("pins")) > 0
            and int_value(pins.get("pins")) == int_value(pins.get("legal"))
            and int_value(pins.get("illegal")) == 0
            and int_value(pins.get("unplaced")) == 0
        )
        pg_specialnets = (
            layout.get("has_vdd") == "YES"
            and layout.get("has_vss") == "YES"
            and layout.get("vdd_use_power") == "YES"
            and layout.get("vss_use_ground") == "YES"
            and int_value(layout.get("specialnets")) >= 2
        )
        innovus_clean = (
            route.get("properly_connected") == "YES"
            and int_value(conn.get("connectivity_viols")) == 0
            and int_value(conn.get("connectivity_warnings")) == 0
            and int_value(drc.get("innovus_drc_viols")) == 0
        )
        block_layout_ok = (
            gds["status"] == "PRESENT"
            and def_file["status"] == "PRESENT"
            and int_value(layout.get("components")) > 0
            and top_pins_legal
            and pg_specialnets
            and innovus_clean
        )
        pad_count = int_value(pins.get("pads"))
        io_pad_ring = "YES" if pad_count > 0 else "NO"
        tapeout_io_status = "FULL_CHIP_IO_PRESENT" if pad_count > 0 else "BLOCK_ONLY_NO_PAD_RING"
        notes = [
            "block-level hard macro",
            "no IO pad ring/ESD/seal ring" if pad_count == 0 else "IO pads present",
            "VDD/VSS DEF SPECIALNETS present" if pg_specialnets else "VDD/VSS PG specialnets need review",
            "strict Calibre DRC/LVS tracked separately",
        ]
        rows.append({
            "arch": arch.upper(),
            "design": design,
            "block_layout_status": "PASS" if block_layout_ok else "CHECK_REQUIRED",
            "io_pad_ring": io_pad_ring,
            "tapeout_io_status": tapeout_io_status,
            "gds_status": gds["status"],
            "gds_bytes": gds["bytes"],
            "def_status": def_file["status"],
            "components": layout.get("components", ""),
            "def_pins": layout.get("pins", ""),
            "report_pins": pins.get("pins", ""),
            "legal_pins": pins.get("legal", ""),
            "illegal_pins": pins.get("illegal", ""),
            "unplaced_pins": pins.get("unplaced", ""),
            "pads": pins.get("pads", ""),
            "top_pins_legal": "PASS" if top_pins_legal else "CHECK_REQUIRED",
            "specialnets": layout.get("specialnets", ""),
            "has_vdd": layout.get("has_vdd", ""),
            "has_vss": layout.get("has_vss", ""),
            "vdd_use_power": layout.get("vdd_use_power", ""),
            "vss_use_ground": layout.get("vss_use_ground", ""),
            "pg_specialnets": "PASS" if pg_specialnets else "CHECK_REQUIRED",
            "die_um": dim_pair(layout.get("die_w_um"), layout.get("die_h_um")),
            "core_um": dim_pair(layout.get("core_w_um"), layout.get("core_h_um")),
            "route_nets": route.get("route_nets", ""),
            "route_terms": route.get("route_terms", ""),
            "properly_connected": route.get("properly_connected", ""),
            "antenna_or_data_issues": route.get("antenna_or_data_issues", ""),
            "connectivity_viols": conn.get("connectivity_viols", ""),
            "connectivity_warnings": conn.get("connectivity_warnings", ""),
            "innovus_drc_viols": drc.get("innovus_drc_viols", ""),
            "innovus_clean": "PASS" if innovus_clean else "CHECK_REQUIRED",
            "gds_path": str(gds_path),
            "def_path": str(def_path),
            "notes": "; ".join(notes),
        })
    return rows


def write_layout_completeness(path, csv_path, repo_root):
    rows = collect_layout_completeness(repo_root)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Layout Completeness\n\n")
        handle.write("该表回答版图是否完整、是否有 IO、VDD/VSS 如何存在。当前四个数据流都是 block-level hard macro 交付：GDS/DEF 存在，顶层 signal pin 合法放置，VDD/VSS 在 DEF SPECIALNETS 中；但不是 full-chip pad-ring 版图。\n\n")
        handle.write("## Block-Level Completeness\n\n")
        handle.write("| Arch | Block Layout | IO Pad Ring | Top Pins | Pads | VDD/VSS | Specialnets | Components | Die um | Core um | Route | Innovus Conn/DRC | Antenna/Data Issues |\n")
        handle.write("| --- | --- | --- | --- | ---: | --- | ---: | ---: | ---: | ---: | --- | --- | ---: |\n")
        for row in rows:
            pg = "{} VDD={} VSS={}".format(row["pg_specialnets"], row["has_vdd"], row["has_vss"])
            pins = "{}/{} legal".format(row["legal_pins"], row["report_pins"])
            conn_drc = "{}v/{}w / {}drc".format(
                md_value(row["connectivity_viols"]),
                md_value(row["connectivity_warnings"]),
                md_value(row["innovus_drc_viols"]),
            )
            route = "{} nets / {} terms".format(md_value(row["route_nets"]), md_value(row["route_terms"]))
            handle.write(
                "| {arch} | {block_layout_status} | {io_pad_ring} | {pins} | {pads} | {pg} | {specialnets} | {components} | {die_um} | {core_um} | {route} | {conn_drc} | {antenna_or_data_issues} |\n".format(
                    arch=row["arch"],
                    block_layout_status=row["block_layout_status"],
                    io_pad_ring=row["io_pad_ring"],
                    pins=pins,
                    pads=md_value(row["pads"]),
                    pg=pg,
                    specialnets=md_value(row["specialnets"]),
                    components=md_value(row["components"]),
                    die_um=md_value(row["die_um"]),
                    core_um=md_value(row["core_um"]),
                    route=route,
                    conn_drc=conn_drc,
                    antenna_or_data_issues=md_value(row["antenna_or_data_issues"]),
                )
            )

        handle.write("\n## Tapeout IO Interpretation\n\n")
        handle.write("| Arch | Status | GDS | DEF | Notes |\n")
        handle.write("| --- | --- | --- | --- | --- |\n")
        for row in rows:
            handle.write(
                "| {arch} | {tapeout_io_status} | {gds_status} bytes={gds_bytes} | {def_status} | {notes} |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )

        handle.write("\n结论：这些版图已经达到论文中四个数据流在同一后端约束下做 block-level PPA/版图对比的要求；但因为 `IO Pad Ring=NO`，它们还不是可直接封装流片的 full-chip 版图。严格流片前还需要补 IO pad/ESD/power pad/可能的 seal ring，并继续收敛 Calibre DRC/LVS。\n")


def parse_calibre_drc(path):
    text = read_text(path)
    if not text:
        return {"status": "NOT_RUN", "results": "", "path": str(path)}
    match = re.search(r"TOTAL DRC Results Generated:\s*([0-9]+)", text, re.I)
    results = match.group(1) if match else ""
    if results == "0":
        status = "PASS"
    elif results:
        status = "CHECK_REQUIRED"
    else:
        status = "UNKNOWN"
    return {"status": status, "results": results, "path": str(path)}


def parse_calibre_lvs(path):
    text = read_text(path)
    if not text:
        return {"status": "NOT_RUN", "result": "", "path": str(path)}
    if re.search(r"\bCORRECT\b", text) and not re.search(r"\bINCORRECT\b", text):
        return {"status": "PASS", "result": "CORRECT", "path": str(path)}
    if re.search(r"\bINCORRECT\b", text):
        return {"status": "CHECK_REQUIRED", "result": "INCORRECT", "path": str(path)}
    if re.search(r"\bNOT COMPARED\b", text):
        return {"status": "CHECK_REQUIRED", "result": "NOT_COMPARED", "path": str(path)}
    return {"status": "UNKNOWN", "result": "", "path": str(path)}


def parse_def_layout(path):
    text = read_text(path)
    result = {
        "design": "",
        "units": "",
        "die_w_um": "",
        "die_h_um": "",
        "core_w_um": "",
        "core_h_um": "",
        "components": "",
        "pins": "",
        "specialnets": "",
        "has_vdd": "NO",
        "has_vss": "NO",
        "vdd_use_power": "NO",
        "vss_use_ground": "NO",
    }
    if not text:
        return result
    design = re.search(r"^DESIGN\s+(\S+)\s*;", text, re.M)
    units = re.search(r"^UNITS\s+DISTANCE\s+MICRONS\s+(\d+)\s*;", text, re.M)
    die = re.search(r"^DIEAREA\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s*;", text, re.M)
    comp = re.search(r"^COMPONENTS\s+(\d+)\s*;", text, re.M)
    pins = re.search(r"^PINS\s+(\d+)\s*;", text, re.M)
    special = re.search(r"^SPECIALNETS\s+(\d+)\s*;", text, re.M)
    result["design"] = design.group(1) if design else ""
    result["units"] = units.group(1) if units else ""
    if units and die:
        dbu = float(units.group(1))
        x1, y1, x2, y2 = [float(value) for value in die.groups()]
        result["die_w_um"] = "{:.3f}".format((x2 - x1) / dbu)
        result["die_h_um"] = "{:.3f}".format((y2 - y1) / dbu)
    core_values = {}
    for name, value in re.findall(r"DESIGN\s+(FE_CORE_BOX_[A-Z_]+)\s+REAL\s+([-+0-9.]+)\s*;", text):
        core_values[name] = to_float(value)
    if {"FE_CORE_BOX_LL_X", "FE_CORE_BOX_UR_X"}.issubset(core_values):
        result["core_w_um"] = "{:.3f}".format(core_values["FE_CORE_BOX_UR_X"] - core_values["FE_CORE_BOX_LL_X"])
    if {"FE_CORE_BOX_LL_Y", "FE_CORE_BOX_UR_Y"}.issubset(core_values):
        result["core_h_um"] = "{:.3f}".format(core_values["FE_CORE_BOX_UR_Y"] - core_values["FE_CORE_BOX_LL_Y"])
    result["components"] = comp.group(1) if comp else ""
    result["pins"] = pins.group(1) if pins else ""
    result["specialnets"] = special.group(1) if special else ""
    result["has_vdd"] = "YES" if re.search(r"(?m)^-\s+VDD\s+\(\s+\*\s+VDD\s+\)", text) else "NO"
    result["has_vss"] = "YES" if re.search(r"(?m)^-\s+VSS\s+\(\s+\*\s+VSS\s+\)", text) else "NO"
    vdd_block = re.search(r"(?ms)^-\s+VDD\s+\(\s+\*\s+VDD\s+\).*?(?=^-\s+|\nEND SPECIALNETS)", text)
    vss_block = re.search(r"(?ms)^-\s+VSS\s+\(\s+\*\s+VSS\s+\).*?(?=^-\s+|\nEND SPECIALNETS)", text)
    result["vdd_use_power"] = "YES" if vdd_block and re.search(r"\+\s+USE\s+POWER", vdd_block.group(0)) else "NO"
    result["vss_use_ground"] = "YES" if vss_block and re.search(r"\+\s+USE\s+GROUND", vss_block.group(0)) else "NO"
    return result


def parse_pin_assignment(path, design):
    text = read_text(path)
    result = {"pads": "", "pins": "", "legal": "", "illegal": "", "unplaced": ""}
    if not text:
        return result
    for line in text.splitlines():
        if design not in line or "|" not in line:
            continue
        parts = [part.strip() for part in line.strip().strip("|").split("|")]
        if len(parts) >= 10 and parts[0] == design:
            result.update({
                "pads": parts[1],
                "pins": parts[2],
                "legal": parts[3],
                "illegal": parts[4],
                "unplaced": parts[9],
            })
            break
    return result


def parse_route_status(path):
    text = read_text(path)
    result = {"route_nets": "", "route_terms": "", "antenna_or_data_issues": "0", "properly_connected": "NO"}
    if not text:
        return result
    connected = re.search(r"All\s+(\d+)\s+nets\s+(\d+)\s+terms\s+of\s+cell\s+\S+\s+are\s+properly\s+connected", text)
    if connected:
        result["route_nets"] = connected.group(1)
        result["route_terms"] = connected.group(2)
        result["properly_connected"] = "YES"
    issues = re.search(r"Several\s+\((\d+)\)\s+nets\s+have\s+antennas\s+or\s+data\s+inconsistencies", text)
    if issues:
        result["antenna_or_data_issues"] = issues.group(1)
    return result


def parse_innovus_connectivity(path):
    text = read_text(path)
    result = {"connectivity_viols": "", "connectivity_warnings": ""}
    match = re.search(r"Verification Complete\s*:\s*(\d+)\s+Viols\.\s*(\d+)\s+Wrngs\.", text)
    if match:
        result["connectivity_viols"] = match.group(1)
        result["connectivity_warnings"] = match.group(2)
    return result


def parse_innovus_drc(path):
    text = read_text(path)
    result = {"innovus_drc_viols": ""}
    matches = re.findall(r"Verification Complete\s*:\s*(\d+)\s+Viols\.", text)
    if matches:
        result["innovus_drc_viols"] = matches[-1]
    return result


def latest_existing(paths):
    existing = [path for path in paths if path.exists()]
    if not existing:
        return paths[0] if paths else Path("")
    return max(existing, key=lambda path: path.stat().st_mtime)


def calibre_drc_report_path(repo_root, arch):
    design = DESIGN[arch]
    calibre_reports = repo_root / "asic_commercial" / arch / "reports" / "calibre"
    return latest_existing([
        calibre_reports / "{}_drc.rep".format(design),
        calibre_reports / "{}_drc_backend.rep".format(design),
        calibre_reports / "{}_drc_backend_datatype_preserve_patch.rep".format(design),
    ])


def calibre_lvs_report_path(repo_root, arch):
    design = DESIGN[arch]
    calibre_reports = repo_root / "asic_commercial" / arch / "reports" / "calibre"
    return latest_existing([
        calibre_reports / "{}_lvs.rep".format(design),
        calibre_reports / "{}_lvs_datatype_preserve_patch.rep".format(design),
        calibre_reports / "{}_lvs_ports_only_fixed.rep".format(design),
    ])


def calibre_lvs_report_paths(repo_root, arch):
    design = DESIGN[arch]
    calibre_reports = repo_root / "asic_commercial" / arch / "reports" / "calibre"
    if not calibre_reports.exists():
        return []
    return sorted(calibre_reports.glob("{}_lvs*.rep".format(design)))


def parse_calibre_drc_rules(path):
    text = read_text(path)
    rules = []
    if not text:
        return rules
    pattern = re.compile(
        r"^RULECHECK\s+(.+?)\s+TOTAL Result Count =\s*([0-9]+)\s*\(([0-9]+)\)",
        re.M,
    )
    for match in pattern.finditer(text):
        count = int(match.group(2))
        expanded_count = int(match.group(3))
        if count == 0 and expanded_count == 0:
            continue
        name = re.sub(r"\s*\.+$", "", match.group(1).strip())
        rules.append({
            "rule": name,
            "count": count,
            "expanded_count": expanded_count,
            "category": rule_category(name),
        })
    return rules


def rule_category(name):
    upper = name.upper()
    if "WARNING" in upper:
        return "warning"
    if upper.startswith("USER_GUIDE."):
        return "user_guide"
    if re.match(r"^M[0-9]+[.:]", upper):
        return "metal"
    if re.match(r"^(VIA|VIA[0-9]+)[.:]", upper):
        return "via"
    if upper.startswith("CO."):
        return "contact"
    if upper.startswith("G."):
        return "geometry"
    return "other"


def collect_calibre_drc_summary(repo_root):
    rows = []
    for arch in ARCHES:
        path = calibre_drc_report_path(repo_root, arch)
        rules = parse_calibre_drc_rules(path)
        for rule in rules:
            rows.append({
                "arch": arch.upper(),
                "category": rule["category"],
                "rule": rule["rule"],
                "count": str(rule["count"]),
                "expanded_count": str(rule["expanded_count"]),
                "path": str(path),
            })
    return rows


def write_calibre_drc_summary(path, csv_path, repo_root):
    rows = collect_calibre_drc_summary(repo_root)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Calibre DRC Summary\n\n")
        handle.write("该表解析 Calibre DRC `.rep` 中所有非零 RULECHECK，便于定位严格 foundry DRC 收敛的主要问题。`Count` 是规则主结果数，`Expanded` 是括号内展开结果数。\n\n")
        if not rows:
            handle.write("未找到非零 Calibre DRC 结果。\n")
            return

        handle.write("## Per Arch\n\n")
        handle.write("| Arch | Nonzero Rules | Count Sum | Expanded Sum | Report |\n")
        handle.write("| --- | ---: | ---: | ---: | --- |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            count_sum = sum(int(row["count"]) for row in arch_rows)
            expanded_sum = sum(int(row["expanded_count"]) for row in arch_rows)
            report_path = calibre_drc_report_path(repo_root, arch)
            handle.write("| {} | {} | {} | {} | `{}` |\n".format(
                arch.upper(),
                len(arch_rows),
                count_sum,
                expanded_sum,
                report_path,
            ))

        handle.write("\n## Category Totals\n\n")
        handle.write("| Arch | Category | Count Sum | Expanded Sum |\n")
        handle.write("| --- | --- | ---: | ---: |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            categories = sorted({row["category"] for row in arch_rows})
            for category in categories:
                cat_rows = [row for row in arch_rows if row["category"] == category]
                handle.write("| {} | {} | {} | {} |\n".format(
                    arch.upper(),
                    category,
                    sum(int(row["count"]) for row in cat_rows),
                    sum(int(row["expanded_count"]) for row in cat_rows),
                ))

        handle.write("\n## Top Rules\n\n")
        handle.write("| Arch | Rank | Category | Rule | Count | Expanded |\n")
        handle.write("| --- | ---: | --- | --- | ---: | ---: |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            ranked = sorted(arch_rows, key=lambda row: (int(row["count"]), int(row["expanded_count"])), reverse=True)
            for rank, row in enumerate(ranked[:12], start=1):
                handle.write("| {arch} | {rank} | {category} | {rule} | {count} | {expanded_count} |\n".format(
                    arch=row["arch"],
                    rank=rank,
                    category=row["category"],
                    rule=row["rule"],
                    count=row["count"],
                    expanded_count=row["expanded_count"],
                ))


def count_lvs_numbered_section(text, heading):
    marker = re.search(r"\n\s*{}\s*\n".format(re.escape(heading)), text, re.I)
    if not marker:
        return 0
    section = text[marker.end():]
    next_heading = re.search(r"\n\s*[A-Z][A-Z ]{8,}\s*\n", section)
    if next_heading:
        section = section[:next_heading.start()]
    return len(re.findall(r"^\s+[0-9]+\s+", section, re.M))


def parse_lvs_cell_summary(text):
    marker = re.search(r"\n\*+\s*\n\s*CELL\s+SUMMARY\s*\n\*+\s*\n", text, re.I)
    if not marker:
        return []
    section = text[marker.end():]
    next_marker = re.search(r"\n\*+\s*\n\s*[A-Z][A-Z ]+\s*\n\*+\s*\n", section)
    if next_marker:
        section = section[:next_marker.start()]
    rows = []
    for line in section.splitlines():
        match = re.match(r"\s*(CORRECT|INCORRECT|NOT COMPARED)\s+(\S+)\s+(\S+)", line, re.I)
        if match:
            rows.append({
                "result": match.group(1).upper(),
                "layout": match.group(2),
                "source": match.group(3),
            })
    return rows


def summarize_lvs_messages(messages, limit=4):
    if not messages:
        return ""
    subckt_cells = sorted(set(
        match.group(1)
        for msg in messages
        for match in [re.search(r'No matching "\.SUBCKT" statement for "([^"]+)"', msg)]
        if match
    ))
    compact = []
    if subckt_cells:
        shown = ", ".join(subckt_cells[:8])
        suffix = "" if len(subckt_cells) <= 8 else ", ..."
        compact.append("No matching .SUBCKT statements for {} unique cells ({})".format(len(subckt_cells), shown + suffix))

    for msg in messages:
        if re.search(r'No matching "\.SUBCKT" statement for "([^"]+)"', msg):
            continue
        compact.append(msg)

    if len(compact) > limit:
        compact = compact[:limit] + ["{} more message types".format(len(compact) - limit)]
    return "; ".join(compact)


def parse_calibre_lvs_detail(path, top_cell=""):
    text = read_text(path)
    if not text:
        return {
            "status": "NOT_RUN",
            "result": "",
            "top_result": "",
            "incorrect_cells": "",
            "errors": "",
            "warnings": "",
            "incorrect_nets": "",
            "incorrect_instances": "",
            "incorrect_ports": "",
            "path": str(path),
        }

    base = parse_calibre_lvs(path)
    header = text
    cell_summary = re.search(r"\n\*+\s*\n\s*CELL\s+SUMMARY", text, re.I)
    if cell_summary:
        header = text[:cell_summary.start()]
    errors = sorted(set(item.strip() for item in re.findall(r"^\s*Error:\s*(.+)$", header, re.M)))
    warnings = sorted(set(item.strip() for item in re.findall(r"^\s*Warning:\s*(.+)$", header, re.M)))
    cells = parse_lvs_cell_summary(text)
    top_result = ""
    if top_cell:
        for cell in cells:
            if cell["layout"] == top_cell or cell["source"] == top_cell:
                top_result = cell["result"]
                break
        if not top_result and cells:
            top_result = "NOT_LISTED"
    incorrect_cells = sum(1 for cell in cells if cell["result"] != "CORRECT")

    return {
        "status": base["status"],
        "result": base["result"],
        "top_result": top_result,
        "incorrect_cells": str(incorrect_cells),
        "errors": summarize_lvs_messages(errors),
        "warnings": summarize_lvs_messages(warnings),
        "incorrect_nets": str(count_lvs_numbered_section(text, "INCORRECT NETS")),
        "incorrect_instances": str(count_lvs_numbered_section(text, "INCORRECT INSTANCES")),
        "incorrect_ports": str(count_lvs_numbered_section(text, "INCORRECT PORTS")),
        "path": str(path),
    }


def write_calibre_lvs_summary(path, csv_path, repo_root):
    rows = []
    for arch in ARCHES:
        lvs_path = calibre_lvs_report_path(repo_root, arch)
        detail = parse_calibre_lvs_detail(lvs_path, DESIGN[arch])
        rows.append({
            "arch": arch.upper(),
            "status": detail["status"],
            "result": detail["result"],
            "top_result": detail["top_result"],
            "incorrect_cells": detail["incorrect_cells"],
            "incorrect_nets": detail["incorrect_nets"],
            "incorrect_instances": detail["incorrect_instances"],
            "incorrect_ports": detail["incorrect_ports"],
            "errors": detail["errors"],
            "warnings": detail["warnings"],
            "path": detail["path"],
        })
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Calibre LVS Summary\n\n")
        handle.write("该表汇总严格 foundry LVS 的当前状态。`CHECK_REQUIRED` 表示 Calibre 已完成比较但结果还未 clean。\n\n")
        handle.write("| Arch | Status | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Errors | Warnings | Report |\n")
        handle.write("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | --- | --- | --- |\n")
        for row in rows:
            handle.write(
                "| {arch} | {status} | {result} | {top_result} | {incorrect_cells} | {incorrect_nets} | {incorrect_instances} | {incorrect_ports} | {errors} | {warnings} | `{path}` |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def lvs_attempt_name(path, design):
    stem = path.stem
    prefix = "{}_".format(design)
    if stem.startswith(prefix):
        return stem[len(prefix):]
    return stem


def lvs_int(row, key, default=999999):
    return int(to_float(row.get(key, ""), default))


def lvs_result_rank(row):
    result = row.get("result", "")
    top_result = row.get("top_result", "")
    if result == "CORRECT" and top_result in ("CORRECT", "NA", ""):
        return 0
    if result == "INCORRECT" and top_result == "INCORRECT":
        return 1
    if result == "INCORRECT":
        return 2
    if result in ("NOT_COMPARED", "MISSING"):
        return 4
    return 3


def lvs_mismatch_score(row):
    if row.get("result") == "NOT_COMPARED":
        return 900000000
    if row.get("status") == "MISSING":
        return 999000000
    return (
        lvs_int(row, "incorrect_ports") * 1000000
        + lvs_int(row, "incorrect_instances") * 1000
        + lvs_int(row, "incorrect_nets")
        + lvs_int(row, "incorrect_cells") * 10
    )


def collect_calibre_lvs_attempts(repo_root):
    rows = []
    for arch in ARCHES:
        design = DESIGN[arch]
        for path in calibre_lvs_report_paths(repo_root, arch):
            detail = parse_calibre_lvs_detail(path, design)
            stat = path.stat()
            rows.append({
                "arch": arch.upper(),
                "attempt": lvs_attempt_name(path, design),
                "status": detail["status"],
                "result": detail["result"],
                "top_result": detail["top_result"],
                "incorrect_cells": detail["incorrect_cells"],
                "incorrect_nets": detail["incorrect_nets"],
                "incorrect_instances": detail["incorrect_instances"],
                "incorrect_ports": detail["incorrect_ports"],
                "mismatch_score": str(lvs_mismatch_score(detail)),
                "errors": detail["errors"],
                "warnings": detail["warnings"],
                "mtime": str(int(stat.st_mtime)),
                "path": str(path),
            })
    return rows


def write_calibre_lvs_attempts(path, csv_path, repo_root):
    rows = collect_calibre_lvs_attempts(repo_root)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Calibre LVS Attempts\n\n")
        handle.write("该表扫描每个数据流已有的 Calibre LVS 尝试，用于区分严格 signoff 尝试和调试型参数 sweep。`Top Result=NOT_LISTED` 通常表示错误集中在 leaf/stdcell 比较，不能视为 top clean。\n\n")
        if not rows:
            handle.write("未找到 Calibre LVS report。\n")
            return

        handle.write("## Current Attempts\n\n")
        handle.write("| Arch | Attempt | Status | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Mismatch Score | Errors | Report |\n")
        handle.write("| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            for row in sorted(arch_rows, key=lambda item: item["attempt"]):
                handle.write(
                    "| {arch} | {attempt} | {status} | {result} | {top_result} | {incorrect_cells} | {incorrect_nets} | {incorrect_instances} | {incorrect_ports} | {mismatch_score} | {errors} | `{path}` |\n".format(
                        **{key: md_value(value) for key, value in row.items()}
                    )
                )

        handle.write("\n## Lowest Overall-Mismatch Attempts\n\n")
        handle.write("排序优先级为：比较完成状态、综合 mismatch score。score 对 port/instance mismatch 加重权重，因此比单看 incorrect nets 更适合判断哪个 LVS 配置更接近 clean。\n\n")
        handle.write("| Arch | Attempt | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Mismatch Score | Errors |\n")
        handle.write("| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            ranked = sorted(
                arch_rows,
                key=lambda row: (
                    lvs_result_rank(row),
                    lvs_int(row, "mismatch_score"),
                    row["attempt"],
                ),
            )
            for row in ranked[:5]:
                handle.write(
                    "| {arch} | {attempt} | {result} | {top_result} | {incorrect_cells} | {incorrect_nets} | {incorrect_instances} | {incorrect_ports} | {mismatch_score} | {errors} |\n".format(
                        **{key: md_value(value) for key, value in row.items()}
                    )
                )

        handle.write("\n## Lowest Incorrect-Net Attempts\n\n")
        handle.write("该表只用于诊断 net 数量收敛，不代表综合 LVS 最优；若同时引入 port/instance mismatch，应以后面的 overall mismatch 表为准。\n\n")
        handle.write("| Arch | Attempt | Result | Top Result | Incorrect Cells | Incorrect Nets | Errors |\n")
        handle.write("| --- | --- | --- | --- | ---: | ---: | --- |\n")
        for arch in ARCHES:
            arch_rows = [row for row in rows if row["arch"] == arch.upper()]
            ranked = sorted(
                arch_rows,
                key=lambda row: (
                    lvs_result_rank(row),
                    to_float(row["incorrect_nets"], 999999.0),
                    to_float(row["incorrect_ports"], 999999.0),
                    to_float(row["incorrect_instances"], 999999.0),
                    to_float(row["incorrect_cells"], 999999.0),
                    row["attempt"],
                ),
            )
            for row in ranked[:5]:
                handle.write(
                    "| {arch} | {attempt} | {result} | {top_result} | {incorrect_cells} | {incorrect_nets} | {errors} |\n".format(
                        **{key: md_value(value) for key, value in row.items()}
                    )
                )


def collect_tapeout_gap(repo_root, arch_rows):
    rows = []
    by_arch = {row["arch"].lower(): row for row in arch_rows}
    for arch in ARCHES:
        design = DESIGN[arch]
        flow_root = repo_root / "asic_commercial" / arch
        calibre_reports = flow_root / "reports" / "calibre"
        summary = by_arch.get(arch, {})

        required_items = [
            ("rtl_frontsim_268", summary.get("front_status") == "PASS", "{} {}/{}".format(summary.get("front_status", ""), summary.get("front_pass", ""), summary.get("front_total", ""))),
            ("innovus_gate_sim_268", summary.get("gate_status") == "PASS", "{} {}/{}".format(summary.get("gate_status", ""), summary.get("gate_pass", ""), summary.get("gate_total", ""))),
            ("fm_dc", summary.get("fm_dc") == "PASS", summary.get("fm_dc", "")),
            ("fm_innovus", summary.get("fm_innovus") == "PASS", summary.get("fm_innovus", "")),
            ("innovus_drc", summary.get("innovus_drc") == "PASS", summary.get("innovus_drc", "")),
            ("innovus_connectivity", summary.get("innovus_connectivity") == "PASS", summary.get("innovus_connectivity", "")),
            ("postroute_setup_slack", to_float(summary.get("postroute_slack_ns", "-1"), -1.0) >= 0.0, "{} ns".format(summary.get("postroute_slack_ns", ""))),
            ("gds_def_sdf_netlist", all(summary.get(key) == "PRESENT" for key in ["gds_status", "def_status", "sdf_status", "netlist_status"]), "gds={} def={} sdf={} netlist={}".format(summary.get("gds_status", ""), summary.get("def_status", ""), summary.get("sdf_status", ""), summary.get("netlist_status", ""))),
        ]
        for item, ok, detail in required_items:
            rows.append({
                "arch": arch.upper(),
                "domain": "implemented_flow",
                "item": item,
                "status": "PASS" if ok else "CHECK_REQUIRED",
                "detail": detail,
                "path": "",
            })

        drc_path = calibre_drc_report_path(repo_root, arch)
        drc = parse_calibre_drc(drc_path)
        rows.append({
            "arch": arch.upper(),
            "domain": "tapeout_gap",
            "item": "calibre_foundry_drc",
            "status": drc["status"],
            "detail": "results={}".format(md_value(drc["results"])),
            "path": drc["path"],
        })

        lvs_path = calibre_lvs_report_path(repo_root, arch)
        lvs = parse_calibre_lvs(lvs_path)
        rows.append({
            "arch": arch.upper(),
            "domain": "tapeout_gap",
            "item": "calibre_lvs",
            "status": lvs["status"],
            "detail": "result={}".format(md_value(lvs["result"])),
            "path": lvs["path"],
        })
    return rows


def write_tapeout_gap(path, csv_path, repo_root, arch_rows):
    rows = collect_tapeout_gap(repo_root, arch_rows)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Tapeout Gap Report\n\n")
        handle.write("该表把当前论文工程已收敛的 Innovus 主线与严格流片还需要补齐的 Calibre/foundry signoff 分开。`implemented_flow` 为当前证据链；`tapeout_gap` 是流片前仍需专门收敛或确认的项目。\n\n")
        handle.write("| Arch | Domain | Item | Status | Detail | Path |\n")
        handle.write("| --- | --- | --- | --- | --- | --- |\n")
        for row in rows:
            handle.write(
                "| {arch} | {domain} | {item} | {status} | {detail} | `{path}` |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def write_validation_summary(path, repo_root, output_dir):
    validation_csv = output_dir / "runs" / "validation_summary.csv"
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Validation Summary\n\n")
        if validation_csv.exists():
            rows = list(csv.DictReader(validation_csv.open(encoding="utf-8", newline="")))
            handle.write("来源：`{}`\n\n".format(validation_csv))
            handle.write("| Domain | Arch | Group | Stage | Status | Total | Pass | Fail |\n")
            handle.write("| --- | --- | --- | --- | --- | ---: | ---: | ---: |\n")
            for row in rows:
                handle.write(
                    "| {} | {} | {} | {} | {} | {} | {} | {} |\n".format(
                        row["domain"],
                        row["arch"].upper(),
                        row["group"],
                        row["stage"],
                        row["status"],
                        row["total"],
                        row["pass"],
                        row["fail"],
                    )
                )
        else:
            handle.write("尚未运行 thesis 扩展验证；下面列出现有 baseline 268 结果。\n\n")
            handle.write("| Arch | Frontsim | Gate Innovus |\n")
            handle.write("| --- | --- | --- |\n")
            for arch in ARCHES:
                flow = repo_root / "asic_commercial" / arch
                front = parse_suite_summary(flow / "frontsim" / "suites" / "summary.md")
                gate = parse_suite_summary(flow / "postsim" / "suites" / "innovus" / "summary.md")
                handle.write(
                    "| {} | {}/{} {} | {}/{} {} |\n".format(
                        arch.upper(),
                        front["pass"],
                        front["total"],
                        front["status"],
                        gate["pass"],
                        gate["total"],
                        gate["status"],
                    )
                )


def read_vector_manifest(repo_root):
    rows = [{
        "group": "baseline_268",
        "kind": "baseline",
        "vector_dir": str((repo_root / "test_vectors" / "txt").resolve()),
        "cases": "268",
        "seed": "",
        "sparse_prob": "",
    }]
    rows.extend(read_csv(repo_root / "test_vectors" / "thesis" / "manifest.csv"))
    return rows


def validation_cell(row):
    if not row:
        return "NOT_RUN"
    status = row.get("status", "UNKNOWN")
    total = row.get("total", "")
    passed = row.get("pass", "")
    failed = row.get("fail", "")
    if total:
        return "{} {}/{} fail={}".format(status, passed, total, failed)
    return status


def write_vector_manifest(path, repo_root):
    rows = read_vector_manifest(repo_root)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Vector Manifest\n\n")
        handle.write("Baseline 268 来自 `test_vectors/txt`；其余 suite 由 `utils/generate_thesis_vectors.py` 固定 seed 生成。\n\n")
        handle.write("| Group | Kind | Cases | Seed | Sparse Prob | Vector Dir |\n")
        handle.write("| --- | --- | ---: | ---: | ---: | --- |\n")
        total_cases = 0
        for row in rows:
            cases = int(row.get("cases") or 0)
            total_cases += cases
            handle.write(
                "| {} | {} | {} | {} | {} | `{}` |\n".format(
                    row.get("group", ""),
                    row.get("kind", ""),
                    row.get("cases", ""),
                    row.get("seed", ""),
                    row.get("sparse_prob", ""),
                    row.get("vector_dir", ""),
                )
            )
        handle.write("\nTotal distinct vector cases listed: `{}`\n".format(total_cases))


def collect_vector_activity(repo_root):
    rows = []
    for vector in read_vector_manifest(repo_root):
        group = vector.get("group", "")
        if group == "baseline_268":
            continue
        metadata = read_csv(Path(vector.get("vector_dir", "")) / "case_metadata.csv")
        if not metadata:
            continue
        rows.append({
            "group": group,
            "kind": vector.get("kind", ""),
            "cases": str(len(metadata)),
            "sparse_prob": vector.get("sparse_prob", ""),
            "avg_a_nonzero": avg(metadata, "a_nonzero"),
            "avg_b_nonzero": avg(metadata, "b_nonzero"),
            "avg_active_mac": avg(metadata, "active_mac"),
            "avg_zero_gated": avg(metadata, "zero_gated"),
            "avg_skip_ratio_pct": avg(metadata, "skip_ratio_pct"),
            "total_active_mac": total(metadata, "active_mac"),
            "total_zero_gated": total(metadata, "zero_gated"),
        })
    return rows


def write_vector_activity_summary(path, csv_path, repo_root):
    rows = collect_vector_activity(repo_root)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Vector Activity Summary\n\n")
        handle.write("该表由 `case_metadata.csv` 聚合，量化不同 directed/random/sparse suite 对 MAC 活动量和理论零值跳过比例的压力。\n\n")
        if not rows:
            handle.write("尚未找到 thesis vector metadata。\n")
            return
        handle.write("| Group | Kind | Cases | Sparse Prob | Avg A NZ | Avg B NZ | Avg Active MAC | Avg Zero Gated | Avg Skip % |\n")
        handle.write("| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        for row in rows:
            handle.write(
                "| {group} | {kind} | {cases} | {sparse_prob} | {avg_a_nonzero} | {avg_b_nonzero} | {avg_active_mac} | {avg_zero_gated} | {avg_skip_ratio_pct} |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def collect_gate_activity(output_dir):
    rows = []
    runs_dir = output_dir / "runs"
    for arch in ARCHES:
        gate_root = runs_dir / arch / "gate"
        if not gate_root.exists():
            continue
        for metrics_path in sorted(gate_root.glob("*/innovus/gate_case_metrics.csv")):
            group = metrics_path.parent.parent.name
            metrics = read_csv(metrics_path)
            passed = [row for row in metrics if row.get("status") == "PASS"]
            if not passed:
                continue
            rows.append({
                "arch": arch.upper(),
                "group": group,
                "stage": "innovus",
                "cases": str(len(metrics)),
                "pass": str(len(passed)),
                "avg_cycles": avg(passed, "cycles"),
                "avg_active_mac": avg(passed, "active_mac"),
                "avg_zero_gated": avg(passed, "zero_gated"),
                "avg_skip_ratio_pct": avg(passed, "skip_ratio_pct"),
                "total_active_mac": total(passed, "active_mac"),
                "total_zero_gated": total(passed, "zero_gated"),
            })
    return rows


def write_gate_activity_summary(path, csv_path, output_dir):
    rows = collect_gate_activity(output_dir)
    write_csv(csv_path, rows)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Gate Activity Summary\n\n")
        handle.write("该表来自 Innovus SDF 门仿 `gate_case_metrics.csv`，用于把功能 PASS 和稀疏活动统计关联起来。\n\n")
        if not rows:
            handle.write("尚未找到扩展门仿 activity metrics。\n")
            return
        handle.write("| Arch | Group | Stage | Cases | Pass | Avg Cycles | Avg Active MAC | Avg Zero Gated | Avg Skip % |\n")
        handle.write("| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |\n")
        for row in rows:
            handle.write(
                "| {arch} | {group} | {stage} | {cases} | {pass} | {avg_cycles} | {avg_active_mac} | {avg_zero_gated} | {avg_skip_ratio_pct} |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def write_validation_matrix(path, repo_root, output_dir, arch_rows):
    manifest_rows = read_vector_manifest(repo_root)
    validation_rows = read_csv(output_dir / "runs" / "validation_summary.csv")
    by_key = {}
    for row in validation_rows:
        by_key[(row.get("domain", ""), row.get("arch", "").lower(), row.get("group", ""), row.get("stage", ""))] = row

    baseline_by_arch = {row["arch"].lower(): row for row in arch_rows}
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Validation Matrix\n\n")
        handle.write("矩阵用于区分 baseline 已完成项、扩展验证已完成项和仍未运行项，避免论文里只写“跑过”但没有可追溯证据。\n\n")
        handle.write("| Group | Kind | Cases | Front WS | Front OS | Front IS | Front DIP | Gate WS | Gate OS | Gate IS | Gate DIP |\n")
        handle.write("| --- | --- | ---: | --- | --- | --- | --- | --- | --- | --- | --- |\n")
        for vector in manifest_rows:
            group = vector.get("group", "")
            front_cells = []
            gate_cells = []
            for arch in ARCHES:
                if group == "baseline_268":
                    row = baseline_by_arch.get(arch, {})
                    front_cells.append("{} {}/{} fail={}".format(
                        row.get("front_status", "MISSING"),
                        row.get("front_pass", ""),
                        row.get("front_total", ""),
                        row.get("front_fail", ""),
                    ))
                    gate_cells.append("{} {}/{} fail={}".format(
                        row.get("gate_status", "MISSING"),
                        row.get("gate_pass", ""),
                        row.get("gate_total", ""),
                        row.get("gate_fail", ""),
                    ))
                else:
                    front_cells.append(validation_cell(by_key.get(("frontsim", arch, group, "rtl"))))
                    gate_cells.append(validation_cell(by_key.get(("gatesim", arch, group, "innovus"))))
            handle.write(
                "| {} | {} | {} | {} | {} | {} | {} | {} | {} | {} | {} |\n".format(
                    group,
                    vector.get("kind", ""),
                    vector.get("cases", ""),
                    front_cells[0],
                    front_cells[1],
                    front_cells[2],
                    front_cells[3],
                    gate_cells[0],
                    gate_cells[1],
                    gate_cells[2],
                    gate_cells[3],
                )
            )


def parse_coverage_dashboard(path):
    text = read_text(path)
    result = {
        "score": "",
        "line": "",
        "cond": "",
        "toggle": "",
        "fsm": "",
        "branch": "",
        "tests": "",
    }
    if not text:
        return result
    tests = re.search(r"Number of tests:\s*([0-9]+)", text)
    if tests:
        result["tests"] = tests.group(1)
    section = re.search(r"Total Coverage Summary.*?</tr><tr>(.*?)</tr>", text, re.I | re.S)
    if not section:
        return result
    values = [item.strip() for item in re.findall(r'<td class="[^"]*">\s*([^<]*)</td>', section.group(1), re.I)]
    fields = ["score", "line", "cond", "toggle", "fsm", "branch"]
    for field, value in zip(fields, values):
        result[field] = value
    return result


def write_coverage_summary(path, output_dir):
    rows = []
    for arch in ARCHES:
        front_root = output_dir / "runs" / arch / "front"
        if not front_root.exists():
            continue
        for summary_path in sorted(front_root.glob("*/summary.md")):
            text = read_text(summary_path)
            status_match = re.search(r"Coverage status:\s*`([^`]+)`", text)
            if not status_match:
                continue
            report_match = re.search(r"Coverage report:\s*`([^`]+)`", text)
            group = summary_path.parent.name
            report_dir = Path(report_match.group(1)) if report_match else summary_path.parent / "coverage" / "urg_report"
            coverage = parse_coverage_dashboard(report_dir / "dashboard.html")
            rows.append({
                "arch": arch.upper(),
                "group": group,
                "status": status_match.group(1),
                "tests": coverage["tests"],
                "score": coverage["score"],
                "line": coverage["line"],
                "cond": coverage["cond"],
                "toggle": coverage["toggle"],
                "fsm": coverage["fsm"],
                "branch": coverage["branch"],
                "report": str(report_dir),
            })

    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Coverage Summary\n\n")
        if not rows:
            handle.write("尚未生成 thesis VCS/URG coverage 报告。\n")
            return
        handle.write("| Arch | Group | Status | Tests | Score | Line | Cond | Toggle | FSM | Branch | Report |\n")
        handle.write("| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |\n")
        for row in rows:
            handle.write(
                "| {arch} | {group} | {status} | {tests} | {score} | {line} | {cond} | {toggle} | {fsm} | {branch} | `{report}` |\n".format(
                    **{key: md_value(value) for key, value in row.items()}
                )
            )


def write_dip_ablation(path, repo_root, dip_row):
    flow = repo_root / "asic_commercial" / "dip"
    design = DESIGN["dip"]
    reports = flow / "reports"
    plain_area = parse_dc_area(reports / "{}_dc_plain_area.rpt".format(design))
    plain_power = parse_dc_power(reports / "{}_dc_plain_power.rpt".format(design))
    gated_area = parse_dc_area(reports / "{}_dc_gated_area.rpt".format(design))
    gated_power = parse_dc_power(reports / "{}_dc_gated_power.rpt".format(design))
    selected_env = read_text(flow / "gated_opt" / "selected.env")
    selected_profile = parse_first_float(r'DIP_SELECTED_GATED_PROFILE="([^"]+)"', selected_env)
    selected_power = parse_first_float(r'DIP_SELECTED_GATED_POWER_MW="([^"]+)"', selected_env)
    selected_area = parse_first_float(r'DIP_SELECTED_GATED_AREA="([^"]+)"', selected_env)
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# DiP Plain vs Gated Ablation\n\n")
        handle.write("| Variant | DC Area | DC Dyn mW | DC Leak mW | Notes |\n")
        handle.write("| --- | ---: | ---: | ---: | --- |\n")
        handle.write("| plain | {} | {} | {} | no clock gating |\n".format(md_value(plain_area), md_value(plain_power["dynamic_mw"]), md_value(plain_power["leakage_mw"])))
        handle.write("| gated | {} | {} | {} | selected profile `{}` |\n".format(md_value(gated_area), md_value(gated_power["dynamic_mw"]), md_value(gated_power["leakage_mw"]), md_value(selected_profile)))
        handle.write("\n")
        handle.write("- Selected gated profile: `{}`\n".format(md_value(selected_profile)))
        handle.write("- Selected profile power/area: `{}` mW / `{}` um^2\n".format(md_value(selected_power), md_value(selected_area)))
        handle.write("- Innovus clock gates: `{}`\n".format(md_value(dip_row.get("clock_gates"))))
        handle.write("- Innovus post-route gate sim: `{}/{}` `{}`\n".format(dip_row["gate_pass"], dip_row["gate_total"], dip_row["gate_status"]))
        handle.write("- Innovus slack: `{}` ns\n".format(md_value(dip_row["postroute_slack_ns"])))


def write_summary_md(path, rows):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Evidence Summary\n\n")
        handle.write("该目录汇总论文实验证据链：功能回归、门级回归、FM、后端 DRC/connectivity、PPA 和版图产物。\n\n")
        handle.write("- `summary.csv`: 机器可读总表\n")
        handle.write("- `dataflow_compare.md`: 四数据流 PPA/验证横比\n")
        handle.write("- `dip_ablation.md`: DiP plain/gated 消融\n")
        handle.write("- `backend_status.md`: 后端产物和检查状态\n")
        handle.write("- `layout_completeness.md`: 版图完整性、IO pad ring、VDD/VSS special nets 检查\n")
        handle.write("- `handoff_manifest.md`: GDS/DEF/SDF/netlist/view 脚本 SHA256 清单\n")
        handle.write("- `tapeout_gap.md`: Innovus 主线与 Calibre/foundry signoff 缺口\n")
        handle.write("- `calibre_drc_summary.md`: Calibre DRC 非零规则聚合\n")
        handle.write("- `calibre_lvs_summary.md`: Calibre LVS 错误/警告摘要\n")
        handle.write("- `calibre_lvs_attempts.md`: Calibre LVS 多配置尝试对比\n")
        handle.write("- `foundry_signoff_check.md`: 严格 Calibre DRC/LVS 签核检查，需运行 `make thesis-foundry-signoff` 生成\n")
        handle.write("- `vector_manifest.md`: baseline + directed/random/sparse 向量清单\n")
        handle.write("- `vector_activity_summary.md`: 向量稀疏度和理论 MAC 活动统计\n")
        handle.write("- `gate_activity_summary.md`: Innovus SDF 门仿活动统计\n")
        handle.write("- `validation_matrix.md`: 扩展验证完成矩阵\n")
        handle.write("- `coverage_summary.md`: VCS/URG 覆盖率摘要\n")
        handle.write("- `validation_summary.md`: baseline 或 thesis 扩展回归状态\n\n")
        all_ok = all(
            row["front_status"] == "PASS"
            and row["gate_status"] == "PASS"
            and row["fm_innovus"] == "PASS"
            and row["innovus_drc"] == "PASS"
            and row["innovus_connectivity"] == "PASS"
            and row["gds_status"] == "PRESENT"
            for row in rows
        )
        handle.write("Overall implementation evidence: `{}`\n".format("PASS" if all_ok else "CHECK_REQUIRED"))


def main():
    parser = argparse.ArgumentParser(description="Collect thesis validation and backend reports.")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--output-dir", default="reports/thesis")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    output_dir = (repo_root / args.output_dir).resolve() if not Path(args.output_dir).is_absolute() else Path(args.output_dir)
    ensure_dir(output_dir)

    rows = [collect_arch(repo_root, arch) for arch in ARCHES]
    write_csv(output_dir / "summary.csv", rows)
    write_dataflow_compare(output_dir / "dataflow_compare.md", rows)
    write_backend_status(output_dir / "backend_status.md", rows)
    write_layout_completeness(output_dir / "layout_completeness.md", output_dir / "layout_completeness.csv", repo_root)
    write_handoff_manifest(output_dir / "handoff_manifest.md", output_dir / "handoff_manifest.csv", repo_root)
    write_tapeout_gap(output_dir / "tapeout_gap.md", output_dir / "tapeout_gap.csv", repo_root, rows)
    write_calibre_drc_summary(output_dir / "calibre_drc_summary.md", output_dir / "calibre_drc_summary.csv", repo_root)
    write_calibre_lvs_summary(output_dir / "calibre_lvs_summary.md", output_dir / "calibre_lvs_summary.csv", repo_root)
    write_calibre_lvs_attempts(output_dir / "calibre_lvs_attempts.md", output_dir / "calibre_lvs_attempts.csv", repo_root)
    write_vector_manifest(output_dir / "vector_manifest.md", repo_root)
    write_vector_activity_summary(output_dir / "vector_activity_summary.md", output_dir / "vector_activity_summary.csv", repo_root)
    write_gate_activity_summary(output_dir / "gate_activity_summary.md", output_dir / "gate_activity_summary.csv", output_dir)
    write_validation_summary(output_dir / "validation_summary.md", repo_root, output_dir)
    write_validation_matrix(output_dir / "validation_matrix.md", repo_root, output_dir, rows)
    write_coverage_summary(output_dir / "coverage_summary.md", output_dir)
    dip_row = [row for row in rows if row["arch"] == "DIP"][0]
    write_dip_ablation(output_dir / "dip_ablation.md", repo_root, dip_row)
    write_summary_md(output_dir / "summary.md", rows)
    print("THESIS_REPORT_SUMMARY path={}".format(output_dir / "summary.md"))
    print("THESIS_REPORT_CSV path={}".format(output_dir / "summary.csv"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
