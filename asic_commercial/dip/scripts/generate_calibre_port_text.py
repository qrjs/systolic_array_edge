#!/usr/bin/env python3
"""Generate Calibre LAYOUT TEXT statements for top-level DEF pins."""

import argparse
import re
from pathlib import Path


DEF_LAYER_TO_CALIBRE_TEXT = {
    "AP": 625,
    "M1": 626,
    "M10": 627,
    "M2": 628,
    "M3": 629,
    "M4": 630,
    "M5": 631,
    "M6": 632,
    "M7": 633,
    "M8": 634,
    "M9": 635,
}


def svrf_quote(value):
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def parse_def_pins(def_path):
    units = 1000
    pins = []
    in_pins = False
    current = None
    unit_re = re.compile(r"UNITS\s+DISTANCE\s+MICRONS\s+(\d+)")
    start_re = re.compile(r"^\s*-\s+(\S+)\s+\+\s+NET\s+(\S+)")
    layer_re = re.compile(
        r"\+\s+LAYER\s+(\S+)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)"
    )
    place_re = re.compile(r"\+\s+(?:FIXED|PLACED)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+(\S+)")

    for raw in def_path.read_text(errors="ignore").splitlines():
        line = raw.strip()
        unit_match = unit_re.search(line)
        if unit_match:
            units = int(unit_match.group(1))

        if line.startswith("PINS "):
            in_pins = True
            continue
        if in_pins and line == "END PINS":
            if current:
                pins.append(current)
            break
        if not in_pins:
            continue

        start_match = start_re.match(line)
        if start_match:
            if current:
                pins.append(current)
            current = {
                "pin": start_match.group(1),
                "net": start_match.group(2),
                "layer": None,
                "rect": None,
                "place": None,
                "orient": "N",
            }
            continue
        if not current:
            continue

        layer_match = layer_re.search(line)
        if layer_match and current["layer"] is None:
            current["layer"] = layer_match.group(1)
            current["rect"] = tuple(int(layer_match.group(i)) for i in range(2, 6))

        place_match = place_re.search(line)
        if place_match:
            current["place"] = (int(place_match.group(1)), int(place_match.group(2)))
            current["orient"] = place_match.group(3)

        if line.endswith(";"):
            pins.append(current)
            current = None

    return units, pins


def transform_point(x, y, orient):
    orient = orient.upper()
    if orient == "N":
        return x, y
    if orient == "S":
        return -x, -y
    if orient == "E":
        return y, -x
    if orient == "W":
        return -y, x
    if orient == "FN":
        return -x, y
    if orient == "FS":
        return x, -y
    if orient == "FE":
        return y, x
    if orient == "FW":
        return -y, -x
    return x, y


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--def", dest="def_file", required=True)
    parser.add_argument("--top", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    units, pins = parse_def_pins(Path(args.def_file).resolve())
    out_path = Path(args.output).resolve()
    out_path.parent.mkdir(parents=True, exist_ok=True)

    written = 0
    with out_path.open("w") as fh:
        fh.write("// Generated top-level port labels for Calibre LVS.\n")
        for pin in pins:
            layer = pin["layer"]
            rect = pin["rect"]
            place = pin["place"]
            if layer not in DEF_LAYER_TO_CALIBRE_TEXT or rect is None or place is None:
                continue
            x1, y1, x2, y2 = rect
            local_x = (x1 + x2) / 2.0
            local_y = (y1 + y2) / 2.0
            label_x, label_y = transform_point(local_x, local_y, pin["orient"])
            x = (place[0] + label_x) / units
            y = (place[1] + label_y) / units
            text_layer = DEF_LAYER_TO_CALIBRE_TEXT[layer]
            fh.write(
                "LAYOUT TEXT {name} {x:.6f} {y:.6f} {layer} {top}\n".format(
                    name=svrf_quote(pin["pin"]),
                    x=x,
                    y=y,
                    layer=text_layer,
                    top=args.top,
                )
            )
            written += 1

    print("[dip-flow][INFO] generated {0} Calibre port labels: {1}".format(written, out_path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
