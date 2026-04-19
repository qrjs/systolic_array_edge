#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ARCHES = ["ws", "is", "os", "dip"]
SUITE_SUMMARY_RE = re.compile(
    r"SUITE_SUMMARY arch=(\w+) simulator=(\w+) total=(\d+) pass=(\d+) fail=(\d+) status=(PASS|FAIL)"
)
ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")


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
    return text + (" " * max(0, width - visible_len(text)))


def build_box(lines: list[str], ok: bool) -> str:
    color = C.GREEN if ok else C.RED
    width = max(visible_len(line) for line in lines)
    top = f"{color}╔{'═' * (width + 2)}╗{C.RESET}"
    body = [f"{color}║{C.RESET} {ljust_ansi(line, width)} {color}║{C.RESET}" for line in lines]
    bottom = f"{color}╚{'═' * (width + 2)}╝{C.RESET}"
    return "\n".join([top, *body, bottom])


def status_word(ok: bool) -> str:
    color = C.GREEN if ok else C.RED
    return f"{C.BOLD}{color}{'PASS' if ok else 'FAIL'}{C.RESET}"


def parse_suite_summary(text: str) -> tuple[int, int, int, bool]:
    matches = SUITE_SUMMARY_RE.findall(text)
    if not matches:
        return 0, 0, 0, False
    _, _, total, passed, failed, status = matches[-1]
    return int(total), int(passed), int(failed), status == "PASS"


def run_arch(arch: str, simulator: str, vector_dir: Path) -> tuple[int, Path]:
    log_dir = ROOT / "test_logs" / "multi_arch_txt"
    if not log_dir.exists():
        log_dir.mkdir(parents=True, exist_ok=True)
    log_path = log_dir / f"{arch}_{simulator}.log"
    cmd = [
        "make",
        "-C",
        str(ROOT / arch / "scripts"),
        "txt",
        f"SIM={simulator}",
        f"VECTOR_DIR={vector_dir}",
    ]
    env = os.environ.copy()
    env["DEFER_SUMMARY"] = "1"

    with log_path.open("w", encoding="utf-8") as handle:
        process = subprocess.Popen(
            cmd,
            cwd=ROOT,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            env=env,
        )
        assert process.stdout is not None
        for line in process.stdout:
            sys.stdout.write(line)
            handle.write(line)
        process.stdout.close()
        rc = process.wait()
    return rc, log_path


def tail_text(path: Path, lines: int = 40) -> str:
    text = path.read_text(errors="ignore").splitlines()
    return "\n".join(text[-lines:])


def main() -> int:
    parser = argparse.ArgumentParser(description="Run multi-arch txt regressions and print summaries at the end.")
    parser.add_argument("--simulator", required=True, choices=["iverilog", "vcs"])
    parser.add_argument("--vector-dir", required=True)
    parser.add_argument("--arches", nargs="*", default=ARCHES)
    parser.add_argument("--label", default="txt")
    args = parser.parse_args()

    vector_dir = Path(args.vector_dir).resolve()
    log_dir = ROOT / "test_logs" / "multi_arch_txt"
    if log_dir.exists():
        shutil.rmtree(log_dir)
    results: list[dict[str, object]] = []

    print(f"[multi-arch] label={args.label} simulator={args.simulator} vector_dir={vector_dir}")
    for index, arch in enumerate(args.arches, start=1):
        print(f"[multi-arch] ({index}/{len(args.arches)}) running {arch} ...")
        rc, log_path = run_arch(arch, args.simulator, vector_dir)
        text = log_path.read_text(errors="ignore")
        total, passed, failed, ok = parse_suite_summary(text)
        if rc != 0:
            ok = False
        results.append({
            "arch": arch.upper(),
            "rc": rc,
            "log": log_path,
            "total": total,
            "passed": passed,
            "failed": failed,
            "ok": ok,
        })
        print(f"[multi-arch] ({index}/{len(args.arches)}) {arch} done: {status_word(ok)}")
        if not ok:
            print(f"[multi-arch] recent log tail for {arch}:\n{tail_text(log_path)}")

    print()
    print(f"[multi-arch] final summaries for label={args.label} simulator={args.simulator}")
    print()

    overall_total = sum(int(item["total"]) for item in results)
    overall_pass = sum(int(item["passed"]) for item in results)
    overall_fail = sum(int(item["failed"]) for item in results)
    overall_ok = all(bool(item["ok"]) for item in results)

    for item in results:
        ok = bool(item["ok"])
        lines = [
            f"{C.CYAN}{item['arch']}{C.RESET} | mode=txt | tool={args.simulator} | status={status_word(ok)}",
            f"统计: total={item['total']} pass={C.GREEN}{item['passed']}{C.RESET} fail={C.RED}{item['failed']}{C.RESET}",
            f"日志: {item['log']}",
        ]
        print(build_box(lines, ok))
        print()

    overall_lines = [
        f"{C.CYAN}ALL_ARCH{C.RESET} | label={args.label} | tool={args.simulator} | status={status_word(overall_ok)}",
        f"统计: arches={len(results)} total={overall_total} pass={C.GREEN}{overall_pass}{C.RESET} fail={C.RED}{overall_fail}{C.RESET}",
        f"向量目录: {vector_dir}",
    ]
    print(build_box(overall_lines, overall_ok))
    print()
    return 0 if overall_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
