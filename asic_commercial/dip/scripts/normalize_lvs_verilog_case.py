#!/usr/bin/env python3
"""Make Verilog net names unique for LVS tools with case-insensitive lookups."""

import argparse
import re
from collections import defaultdict
from pathlib import Path


DECL_RE = re.compile(
    r"(?ms)^\s*(?:input|output|inout|wire|tri|supply0|supply1)\b[^;]*;"
)
IDENT_RE = re.compile(r"(?<![A-Za-z0-9_$])([A-Za-z_][A-Za-z0-9_$]*)(?![A-Za-z0-9_$])")
MODULE_RE = re.compile(r"(?ms)\bmodule\b.*?\bendmodule\b")

KEYWORDS = {
    "assign",
    "buf",
    "endmodule",
    "inout",
    "input",
    "module",
    "output",
    "supply0",
    "supply1",
    "tri",
    "wire",
}


def declared_identifiers(module_text):
    names = []
    for decl in DECL_RE.finditer(module_text):
        # Drop ranges before tokenizing. This avoids collecting constants from [N:M].
        text = re.sub(r"\[[^\]]+\]", " ", decl.group(0))
        for name in IDENT_RE.findall(text):
            if name.lower() not in KEYWORDS:
                names.append(name)
    return names


def build_case_mapping(names):
    by_folded = defaultdict(set)
    for name in names:
        by_folded[name.lower()].add(name)

    mapping = {}
    used = set(names)
    for folded, variants in sorted(by_folded.items()):
        if len(variants) < 2:
            continue
        # Keep the variant containing uppercase characters. DC/Innovus commonly
        # use N### for DW macro nets and n### for random internal nets.
        keep = sorted(variants, key=lambda n: (not any(c.isupper() for c in n), n))[0]
        for name in sorted(variants):
            if name == keep:
                continue
            candidate = f"{name}__lvs_case"
            suffix = 0
            while candidate in used:
                suffix += 1
                candidate = f"{name}__lvs_case{suffix}"
            mapping[name] = candidate
            used.add(candidate)
    return mapping


def rewrite_module(module_text):
    mapping = build_case_mapping(declared_identifiers(module_text))
    if not mapping:
        return module_text, mapping

    def replace(match):
        token = match.group(1)
        return mapping.get(token, token)

    return IDENT_RE.sub(replace, module_text), mapping


def rewrite_verilog(text):
    out = []
    report = []
    pos = 0
    for match in MODULE_RE.finditer(text):
        out.append(text[pos : match.start()])
        module_text = match.group(0)
        rewritten, mapping = rewrite_module(module_text)
        if mapping:
            module_name_match = re.search(r"\bmodule\s+([A-Za-z_][A-Za-z0-9_$]*)", module_text)
            module_name = module_name_match.group(1) if module_name_match else "<unknown>"
            report.append((module_name, mapping))
        out.append(rewritten)
        pos = match.end()
    out.append(text[pos:])
    return "".join(out), report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--report", default="")
    args = parser.parse_args()

    input_path = Path(args.input).resolve()
    output_path = Path(args.output).resolve()
    text = input_path.read_text(errors="ignore")
    rewritten, report = rewrite_verilog(text)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        "// Generated for Calibre LVS: case-collision net names normalized.\n" + rewritten
    )

    if args.report:
        report_path = Path(args.report).resolve()
        report_path.parent.mkdir(parents=True, exist_ok=True)
        with report_path.open("w") as fh:
            total = sum(len(mapping) for _, mapping in report)
            fh.write(f"renamed_nets {total}\n")
            for module_name, mapping in report:
                fh.write(f"\nmodule {module_name}\n")
                for src, dst in sorted(mapping.items()):
                    fh.write(f"  {src} -> {dst}\n")

    total = sum(len(mapping) for _, mapping in report)
    print(f"[dip-flow][INFO] LVS Verilog case normalization renamed {total} nets")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
