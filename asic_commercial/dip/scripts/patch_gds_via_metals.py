#!/usr/bin/env python3
"""Patch Innovus streamOut via cells with metal landing rectangles.

Some older Innovus/TSMC28 combinations stream via definitions as cut-only
GDS cells. The foundry Calibre decks then see VIAx without the adjacent
Mx/Mx+1 landing metal, causing massive enclosure errors. This utility restores
the via metal rectangles from the Cadence TLEF and applies a conservative
fallback for generated cut-only via cells.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple


Rect = Tuple[float, float, float, float]
ViaShapes = Dict[str, List[Rect]]
ViaDefs = Dict[str, ViaShapes]
LayerMap = Dict[str, str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gds", required=True, help="Input GDS to patch")
    parser.add_argument("--tlef", required=True, help="Technology LEF with VIA definitions")
    parser.add_argument("--stream-map", required=True, help="Innovus streamOut map")
    parser.add_argument("--output", help="Patched output GDS; defaults to in-place")
    parser.add_argument("--backup", help="Backup path for in-place patching")
    parser.add_argument(
        "--backup-manifest",
        help="Optional shell env file recording the actual unpatched backup path",
    )
    parser.add_argument("--calibredrv", default=os.environ.get("CALIBREDRV_BIN", "calibredrv"))
    parser.add_argument("--dbu-per-micron", type=int, default=1000)
    parser.add_argument("--generic-enclosure-dbu", type=int, default=30)
    parser.add_argument(
        "--no-generic",
        action="store_true",
        help="Only patch explicit TLEF VIA cells; do not infer metals for generated cut-only VIA cells",
    )
    parser.add_argument(
        "--no-remap-datatypes",
        action="store_true",
        help="Do not remap high-metal/high-via datatype 0 polygons to the streamOut map datatypes",
    )
    parser.add_argument("--work-dir", help="Directory for generated Tcl/log files")
    return parser.parse_args()


def fail(message: str) -> None:
    print(f"[dip-flow][ERROR] {message}", file=sys.stderr)
    raise SystemExit(1)


def require_file(path: Path, label: str) -> None:
    if not path.is_file():
        fail(f"{label} not found: {path}")


def shell_quote(value: Path) -> str:
    return "'" + str(value).replace("'", "'\"'\"'") + "'"


def choose_backup_path(path: Path) -> Path:
    if not path.exists():
        return path
    stem = path.with_suffix("")
    suffix = path.suffix
    for idx in range(1, 1000):
        candidate = Path(f"{stem}.{idx}{suffix}")
        if not candidate.exists():
            return candidate
    fail(f"could not find free backup path for {path}")


def gds_layer(layer: int, datatype: int) -> str:
    return f"{layer}.{datatype}"


def parse_stream_map(path: Path) -> Tuple[LayerMap, LayerMap]:
    metal_map: LayerMap = {}
    cut_map: LayerMap = {}
    metal_priority = {"NET": 0, "SPNET": 1, "PIN": 2, "LEFPIN": 3}
    cut_priority = {"VIA": 0, "PIN": 1, "LEFPIN": 2, "VIAFILL": 3}
    metal_seen: Dict[str, int] = {}
    cut_seen: Dict[str, int] = {}

    for raw in path.read_text(errors="ignore").splitlines():
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        fields = line.split()
        if len(fields) < 4:
            continue
        name, purpose, layer_s, datatype_s = fields[:4]
        if not re.fullmatch(r"-?\d+", layer_s) or not re.fullmatch(r"-?\d+", datatype_s):
            continue
        mapped = gds_layer(int(layer_s), int(datatype_s))
        if re.fullmatch(r"M\d+|AP", name):
            pri = metal_priority.get(purpose, 99)
            if pri < metal_seen.get(name, 100):
                metal_map[name] = mapped
                metal_seen[name] = pri
        elif re.fullmatch(r"VIA\d+", name):
            pri = cut_priority.get(purpose, 99)
            if pri < cut_seen.get(name, 100):
                cut_map[name] = mapped
                cut_seen[name] = pri

    for idx in range(1, 11):
        metal_map.setdefault(f"M{idx}", gds_layer(30 + idx, 0))
    for idx in range(1, 10):
        cut_map.setdefault(f"VIA{idx}", gds_layer(50 + idx, 0))
    return metal_map, cut_map


def parse_tlef_vias(path: Path) -> ViaDefs:
    via_defs: ViaDefs = {}
    current_name: Optional[str] = None
    current_layer: Optional[str] = None
    current_shapes: ViaShapes = {}

    for raw in path.read_text(errors="ignore").splitlines():
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue

        via_match = re.match(r"^VIA\s+(\S+)", line)
        if via_match and current_name is None:
            current_name = via_match.group(1)
            current_layer = None
            current_shapes = {}
            continue

        if current_name is None:
            continue

        end_match = re.match(r"^END\s+(\S+)", line)
        if end_match:
            via_defs[current_name] = current_shapes
            current_name = None
            current_layer = None
            current_shapes = {}
            continue

        layer_match = re.match(r"^LAYER\s+(\S+)\s*;", line)
        if layer_match:
            current_layer = layer_match.group(1)
            current_shapes.setdefault(current_layer, [])
            continue

        rect_match = re.match(
            r"^RECT\s+([-+0-9.eE]+)\s+([-+0-9.eE]+)\s+([-+0-9.eE]+)\s+([-+0-9.eE]+)\s*;",
            line,
        )
        if rect_match and current_layer:
            current_shapes.setdefault(current_layer, []).append(tuple(float(x) for x in rect_match.groups()))

    return via_defs


def to_dbu(value: float, dbu_per_micron: int) -> int:
    return int(round(value * dbu_per_micron))


def tcl_quote(value: str) -> str:
    return "{" + value.replace("\\", "\\\\").replace("}", "\\}") + "}"


def iter_known_metal_rects(
    via_defs: ViaDefs,
    metal_map: LayerMap,
    dbu_per_micron: int,
) -> Iterable[Tuple[str, str, Rect]]:
    for via_name in sorted(via_defs):
        for layer_name, rects in via_defs[via_name].items():
            if not re.fullmatch(r"M\d+|AP", layer_name):
                continue
            mapped_layer = metal_map.get(layer_name)
            if mapped_layer is None:
                continue
            for rect in rects:
                yield (
                    via_name,
                    mapped_layer,
                    tuple(to_dbu(v, dbu_per_micron) for v in rect),  # type: ignore[arg-type]
                )


def build_datatype_remaps(metal_map: LayerMap, cut_map: LayerMap) -> List[Tuple[str, str]]:
    remaps: List[Tuple[str, str]] = []
    for layer_name, mapped_layer in sorted(metal_map.items()):
        if not re.fullmatch(r"M\d+|AP", layer_name):
            continue
        layer, datatype = mapped_layer.split(".", 1)
        if datatype != "0":
            remaps.append((f"{layer}.0", mapped_layer))
    for layer_name, mapped_layer in sorted(cut_map.items()):
        if not re.fullmatch(r"VIA\d+", layer_name):
            continue
        layer, datatype = mapped_layer.split(".", 1)
        if datatype != "0":
            remaps.append((f"{layer}.0", mapped_layer))
    return remaps


def build_gdsout_maps(metal_map: LayerMap, cut_map: LayerMap) -> List[Tuple[str, int, int]]:
    maps: List[Tuple[str, int, int]] = []
    seen = set()
    for mapped_layer in list(metal_map.values()) + list(cut_map.values()):
        layer_s, datatype_s = mapped_layer.split(".", 1)
        layer = int(layer_s)
        datatype = int(datatype_s)
        key = (mapped_layer, layer, datatype)
        if datatype == 0 or key in seen:
            continue
        maps.append(key)
        seen.add(key)
    return sorted(maps)


def build_tcl(
    input_gds: Path,
    output_gds: Path,
    via_defs: ViaDefs,
    metal_map: LayerMap,
    cut_map: LayerMap,
    dbu_per_micron: int,
    generic_enclosure_dbu: int,
    patch_generic: bool,
    remap_datatypes: bool,
) -> str:
    known_present = sorted(
        name
        for name, shapes in via_defs.items()
        if any(re.fullmatch(r"M\d+|AP", layer) for layer in shapes)
    )

    lines: List[str] = [
        "proc safe_count_poly {L cell layer} {",
        "    if {[catch {$L iterator count poly $cell $layer} count]} {",
        "        return 0",
        "    }",
        "    return $count",
        "}",
        "",
        "proc patch_rects_if_missing {L cell layer rects} {",
        "    set added 0",
        "    if {[safe_count_poly $L $cell $layer] > 0} {",
        "        return 0",
        "    }",
        "    if {![$L exists layer $layer]} {",
        "        $L create layer $layer",
        "    }",
        "    foreach rect $rects {",
        "        foreach {x1 y1 x2 y2} $rect { break }",
        "        $L create polygon $cell $layer $x1 $y1 $x2 $y2",
        "        incr added",
        "    }",
        "    return $added",
        "}",
        "",
        "proc polygon_bbox {poly} {",
        "    set minx [lindex $poly 0]",
        "    set miny [lindex $poly 1]",
        "    set maxx $minx",
        "    set maxy $miny",
        "    set n [llength $poly]",
        "    for {set i 0} {$i < $n} {incr i 2} {",
        "        set x [lindex $poly $i]",
        "        set y [lindex $poly [expr {$i + 1}]]",
        "        if {$x < $minx} { set minx $x }",
        "        if {$x > $maxx} { set maxx $x }",
        "        if {$y < $miny} { set miny $y }",
        "        if {$y > $maxy} { set maxy $y }",
        "    }",
        "    return [list $minx $miny $maxx $maxy]",
        "}",
        "",
        "proc patch_generic_cut_only_via {L cell cut_layer metal_layers enclosure} {",
        "    set cut_count [safe_count_poly $L $cell $cut_layer]",
        "    if {$cut_count == 0} {",
        "        return 0",
        "    }",
        "    set needs {}",
        "    foreach metal_layer $metal_layers {",
        "        if {[safe_count_poly $L $cell $metal_layer] == 0} {",
        "            lappend needs $metal_layer",
        "        }",
        "    }",
        "    if {[llength $needs] == 0} {",
        "        return 0",
        "    }",
        "    set added 0",
        "    foreach poly [$L iterator poly $cell $cut_layer range 0 end] {",
        "        foreach {minx miny maxx maxy} [polygon_bbox $poly] { break }",
        "        set x1 [expr {$minx - $enclosure}]",
        "        set y1 [expr {$miny - $enclosure}]",
        "        set x2 [expr {$maxx + $enclosure}]",
        "        set y2 [expr {$maxy + $enclosure}]",
        "        foreach metal_layer $needs {",
        "            if {![$L exists layer $metal_layer]} {",
        "                $L create layer $metal_layer",
        "            }",
        "            $L create polygon $cell $metal_layer $x1 $y1 $x2 $y2",
        "            incr added",
        "        }",
        "    }",
        "    return $added",
        "}",
        "",
        "proc remap_polygon_layer {L from_layer to_layer} {",
        "    if {$from_layer eq $to_layer} {",
        "        return 0",
        "    }",
        "    if {![$L exists layer $from_layer]} {",
        "        return 0",
        "    }",
        "    set added 0",
        "    if {![$L exists layer $to_layer]} {",
        "        $L create layer $to_layer",
        "    }",
        "    foreach cell [$L cells] {",
        "        set count 0",
        "        catch {set count [$L iterator count poly $cell $from_layer]}",
        "        if {$count == 0} {",
        "            continue",
        "        }",
        "        foreach poly [$L iterator poly $cell $from_layer range 0 end] {",
        "            $L create polygon $cell $to_layer {*}$poly",
        "            incr added",
        "        }",
        "    }",
        "    if {$added > 0} {",
        "        $L delete layer $from_layer",
        "    }",
        "    return $added",
        "}",
        "",
        "proc gdsout_map_for_layer {layer} {",
        "    if {[regexp {^([0-9]+)\\.([0-9]+)$} $layer _ gds_layer gds_datatype]} {",
        "        return [list $gds_layer $gds_datatype]",
        "    }",
        "    if {[regexp {^([0-9]+)$} $layer _ gds_layer]} {",
        "        return [list $gds_layer 0]",
        "    }",
        "    return [list $layer 0]",
        "}",
        "",
        f"set input_gds {tcl_quote(str(input_gds))}",
        f"set output_gds {tcl_quote(str(output_gds))}",
        "set L [layout create $input_gds]",
        "set known_added 0",
        "set generic_added 0",
        "set remap_added 0",
        "array set known_vias {}",
    ]

    if remap_datatypes:
        for from_layer, to_layer in build_datatype_remaps(metal_map, cut_map):
            lines.append(f"incr remap_added [remap_polygon_layer $L {tcl_quote(from_layer)} {tcl_quote(to_layer)}]")
    else:
        lines.append("puts \"\\[dip-flow\\]\\[INFO\\] high-layer datatype remap disabled\"")

    grouped: Dict[Tuple[str, str], List[Rect]] = {}
    for via_name, layer, rect in iter_known_metal_rects(via_defs, metal_map, dbu_per_micron):
        grouped.setdefault((via_name, layer), []).append(rect)

    for via_name in known_present:
        lines.append(f"set known_vias({tcl_quote(via_name)}) 1")

    for (via_name, layer), rects in sorted(grouped.items()):
        rect_list = " ".join(
            "{" + " ".join(str(int(coord)) for coord in rect) + "}" for rect in rects
        )
        lines.extend(
            [
                f"if {{[$L exists cell {tcl_quote(via_name)}]}} {{",
                f"    incr known_added [patch_rects_if_missing $L {tcl_quote(via_name)} {tcl_quote(layer)} {{{rect_list}}}]",
                "}",
            ]
        )

    if patch_generic:
        lines.extend(
            [
                "array set cut_to_metals {}",
            ]
        )
        for idx in range(1, 10):
            cut_layer = cut_map.get(f"VIA{idx}")
            bottom = metal_map.get(f"M{idx}")
            top = metal_map.get(f"M{idx + 1}")
            if cut_layer and bottom and top:
                lines.append(f"set cut_to_metals({tcl_quote(cut_layer)}) [list {tcl_quote(bottom)} {tcl_quote(top)}]")

        lines.extend(
            [
                f"set generic_enclosure {generic_enclosure_dbu}",
                "foreach cell [$L cells] {",
                "    if {[info exists known_vias($cell)]} {",
                "        continue",
                "    }",
                "    if {![string match {*VIA*} $cell]} {",
                "        continue",
                "    }",
                "    foreach cut_layer [array names cut_to_metals] {",
                "        incr generic_added [patch_generic_cut_only_via $L $cell $cut_layer $cut_to_metals($cut_layer) $generic_enclosure]",
                "    }",
                "}",
            ]
        )
    else:
        lines.append("puts \"\\[dip-flow\\]\\[INFO\\] generic cut-only via patching disabled\"")

    lines.extend(
        [
            "puts \"\\[dip-flow\\]\\[INFO\\] patched known via metal rectangles: $known_added\"",
            "puts \"\\[dip-flow\\]\\[INFO\\] patched generic via metal rectangles: $generic_added\"",
            "puts \"\\[dip-flow\\]\\[INFO\\] remapped high-layer datatype polygons: $remap_added\"",
            "set gdsout_args [list $output_gds -noReport]",
            "array set nonzero_gdsout_layers {}",
        ]
    )
    gdsout_maps = build_gdsout_maps(metal_map, cut_map) if remap_datatypes else []
    for _, gds_layer_num, _ in gdsout_maps:
        lines.append(f"set nonzero_gdsout_layers({gds_layer_num}) 1")
    lines.extend(
        [
            "foreach layer [$L layers] {",
            "    if {[info exists nonzero_gdsout_layers($layer)]} {",
            "        continue",
            "    }",
            "    lassign [gdsout_map_for_layer $layer] gds_layer gds_datatype",
            "    lappend gdsout_args -map $layer $gds_layer $gds_datatype",
            "}",
        ]
    )
    for internal_layer, gds_layer_num, gds_datatype in gdsout_maps:
        lines.append(
            f"lappend gdsout_args -map {tcl_quote(internal_layer)} {gds_layer_num} {gds_datatype}"
        )
    lines.extend(
        [
            "eval [linsert $gdsout_args 0 $L gdsout]",
            "puts \"\\[dip-flow\\]\\[INFO\\] patched GDS written: $output_gds\"",
            "exit",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    gds = Path(args.gds).resolve()
    tlef = Path(args.tlef).resolve()
    stream_map = Path(args.stream_map).resolve()
    output = Path(args.output).resolve() if args.output else gds
    require_file(gds, "GDS")
    require_file(tlef, "TLEF")
    require_file(stream_map, "streamOut map")

    via_defs = parse_tlef_vias(tlef)
    if not via_defs:
        fail(f"no VIA definitions parsed from {tlef}")
    metal_map, cut_map = parse_stream_map(stream_map)

    work_dir = Path(args.work_dir).resolve() if args.work_dir else Path(tempfile.mkdtemp(prefix="via_patch_"))
    work_dir.mkdir(parents=True, exist_ok=True)
    in_place = output == gds
    input_gds = gds
    final_output = output
    temp_output = output
    if in_place:
        requested_backup = Path(args.backup).resolve() if args.backup else gds.with_name(f"{gds.stem}.pre_via_metal_patch{gds.suffix}")
        backup = choose_backup_path(requested_backup)
        shutil.copy2(gds, backup)
        if args.backup_manifest:
            manifest = Path(args.backup_manifest).resolve()
            manifest.parent.mkdir(parents=True, exist_ok=True)
            manifest.write_text(
                f"INNOVUS_LAST_UNPATCHED_GDS={shell_quote(backup)}\n"
            )
        input_gds = backup
        temp_output = work_dir / f"{gds.stem}.patched{gds.suffix}"
        print(f"[dip-flow][INFO] backup unpatched GDS: {backup}")

    tcl_path = work_dir / f"{gds.stem}_patch_via_metals.tcl"
    tcl_path.write_text(
        build_tcl(
            input_gds,
            temp_output,
            via_defs,
            metal_map,
            cut_map,
            args.dbu_per_micron,
            args.generic_enclosure_dbu,
            not args.no_generic,
            not args.no_remap_datatypes,
        )
    )
    print(f"[dip-flow][INFO] via metal patch Tcl: {tcl_path}")

    subprocess.run([args.calibredrv, str(tcl_path)], check=True)

    if in_place:
        shutil.move(str(temp_output), str(final_output))
        print(f"[dip-flow][INFO] replaced GDS with via-metal patched file: {final_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
