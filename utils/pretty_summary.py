#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import sys
import unicodedata
from pathlib import Path


ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
FILE_VECTOR_RE = re.compile(r"FILE_VECTOR arch=(\w+) simulator=(\w+) case=([^\s]+) status=(PASS|FAIL)")
SUITE_SUMMARY_RE = re.compile(
    r"SUITE_SUMMARY arch=(\w+) simulator=(\w+) total=(\d+) pass=(\d+) fail=(\d+) status=(PASS|FAIL)"
)
PASSED_RE = re.compile(r"Passed:\s*(\d+)")
FAILED_RE = re.compile(r"Failed:\s*(\d+)")
BRACKET_PASS_RE = re.compile(r"^\[[^\n]+?\]\[PASS\]", re.MULTILINE)
BRACKET_FAIL_RE = re.compile(r"^\[[^\n]+?\]\[FAIL\]", re.MULTILINE)
WARNING_RE = re.compile(r"\b(?:WARNING|Warning|CRITICAL WARNING)\b")
ERROR_RE = re.compile(r"\b(?:ERROR|Error|Fatal)\b")


def use_color() -> bool:
    return sys.stdout.isatty() and os.environ.get("TERM", "") not in {"", "dumb"}


class C:
    if use_color():
        RESET = "\033[0m"
        BOLD = "\033[1m"
        GREEN = "\033[32m"
        RED = "\033[31m"
        YELLOW = "\033[33m"
        CYAN = "\033[36m"
    else:
        RESET = BOLD = GREEN = RED = YELLOW = CYAN = ""


def strip_ansi(text: str) -> str:
    return ANSI_RE.sub("", text)


def visible_len(text: str) -> int:
    plain = strip_ansi(text)
    width = 0
    for char in plain:
        if unicodedata.combining(char):
            continue
        width += 2 if unicodedata.east_asian_width(char) in {"F", "W"} else 1
    return width


def ljust_ansi(text: str, width: int) -> str:
    padding = max(0, width - visible_len(text))
    return text + (" " * padding)


def color_status(ok: bool) -> str:
    color = C.GREEN if ok else C.RED
    word = "PASS" if ok else "FAIL"
    return f"{C.BOLD}{color}{word}{C.RESET}"


def color_number(value: int | None, ok_color: bool) -> str:
    if value is None:
        return "n/a"
    color = C.GREEN if ok_color else C.RED
    return f"{color}{value}{C.RESET}"


def parse_counts(text: str) -> tuple[int | None, int | None, int | None, str | None]:
    suite_matches = SUITE_SUMMARY_RE.findall(text)
    if suite_matches:
        _, _, total, passed, failed, _ = suite_matches[-1]
        return int(passed), int(failed), int(total), "suite_summary"

    file_vectors = FILE_VECTOR_RE.findall(text)
    if file_vectors:
        passed = sum(1 for *_, status in file_vectors if status == "PASS")
        failed = sum(1 for *_, status in file_vectors if status == "FAIL")
        return passed, failed, len(file_vectors), "file_vector"

    passed_matches = PASSED_RE.findall(text)
    failed_matches = FAILED_RE.findall(text)
    if passed_matches and failed_matches:
        passed = int(passed_matches[-1])
        failed = int(failed_matches[-1])
        return passed, failed, passed + failed, "final_report"

    bracket_pass = len(BRACKET_PASS_RE.findall(text))
    bracket_fail = len(BRACKET_FAIL_RE.findall(text))
    if bracket_pass or bracket_fail:
        return bracket_pass, bracket_fail, bracket_pass + bracket_fail, "bracket_markers"

    return None, None, None, None


def build_box(lines: list[str], ok: bool) -> str:
    color = C.GREEN if ok else C.RED
    width = max(visible_len(line) for line in lines)
    top = f"{color}╔{'═' * (width + 2)}╗{C.RESET}"
    body = [f"{color}║{C.RESET} {ljust_ansi(line, width)} {color}║{C.RESET}" for line in lines]
    bottom = f"{color}╚{'═' * (width + 2)}╝{C.RESET}"
    return "\n".join([top, *body, bottom])


def main() -> int:
    parser = argparse.ArgumentParser(description="Pretty CLI summary for Makefile flows.")
    parser.add_argument("--arch", required=True)
    parser.add_argument("--mode", required=True)
    parser.add_argument("--simulator", required=True)
    parser.add_argument("--log", required=True)
    parser.add_argument("--status", required=True, type=int)
    parser.add_argument("--artifact")
    args = parser.parse_args()

    log_path = Path(args.log)
    text = log_path.read_text(errors="ignore") if log_path.exists() else ""

    passed, failed, total, source = parse_counts(text)
    warning_count = len(WARNING_RE.findall(text))
    error_count = len(ERROR_RE.findall(text))

    ok = args.status == 0 and (failed in (None, 0))
    status_text = color_status(ok)

    lines = [
        f"{C.CYAN}{args.arch}{C.RESET} | mode={args.mode} | tool={args.simulator} | status={status_text}",
    ]

    if total is not None:
        lines.append(
            "统计: total="
            f"{total} pass={color_number(passed, True)} fail={color_number(failed, False)}"
        )
    else:
        lines.append("统计: 未从日志中提取到结构化计数，按命令返回码判定")

    if args.mode == "synth":
        lines.append(
            "日志分析: warnings="
            f"{C.YELLOW}{warning_count}{C.RESET} errors≈{color_number(error_count, error_count == 0)}"
        )

    if args.artifact:
        lines.append(f"产物: {args.artifact}")
    lines.append(f"日志: {log_path}")
    if source:
        lines.append(f"来源: {source}")

    print()
    print(build_box(lines, ok))
    print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
