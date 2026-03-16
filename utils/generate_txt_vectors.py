#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random
from pathlib import Path

MATRIX_SIZE = 4


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[row][k] * b[k][col] for k in range(MATRIX_SIZE)) for col in range(MATRIX_SIZE)]
        for row in range(MATRIX_SIZE)
    ]


def maybe_sparse_value(rng: random.Random, value_min: int, value_max: int, sparse_prob: float) -> int:
    if rng.random() < sparse_prob:
        return 0
    return rng.randint(value_min, value_max)


def random_matrix(rng: random.Random, value_min: int, value_max: int, sparse_prob: float) -> list[list[int]]:
    return [
        [maybe_sparse_value(rng, value_min, value_max, sparse_prob) for _ in range(MATRIX_SIZE)]
        for _ in range(MATRIX_SIZE)
    ]


def write_input(path: Path, case_name: str, seed: int, a: list[list[int]], b: list[list[int]]) -> None:
    with path.open("w", encoding="utf-8") as handle:
        handle.write(f"# Random generated input vector\n")
        handle.write(f"# case={case_name} seed={seed}\n")
        handle.write("A\n")
        for row in a:
            handle.write(" ".join(map(str, row)) + "\n")
        handle.write("B\n")
        for row in b:
            handle.write(" ".join(map(str, row)) + "\n")


def write_expected(path: Path, case_name: str, seed: int, c: list[list[int]]) -> None:
    with path.open("w", encoding="utf-8") as handle:
        handle.write(f"# Random generated expected output\n")
        handle.write(f"# case={case_name} seed={seed}\n")
        handle.write("C\n")
        for row in c:
            handle.write(" ".join(map(str, row)) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate reproducible txt matrix-vector suites.")
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--count", type=int, default=8)
    parser.add_argument("--seed", type=int, default=20260316)
    parser.add_argument("--prefix", default="rand")
    parser.add_argument("--value-min", type=int, default=-16)
    parser.add_argument("--value-max", type=int, default=16)
    parser.add_argument("--sparse-prob", type=float, default=0.20)
    parser.add_argument("--clean", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    if args.count <= 0:
        raise SystemExit("--count must be > 0")
    if args.value_min > args.value_max:
        raise SystemExit("--value-min must be <= --value-max")
    if not (0.0 <= args.sparse_prob <= 1.0):
        raise SystemExit("--sparse-prob must be in [0, 1]")

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    if args.clean:
        for path in output_dir.glob("*_input.txt"):
            path.unlink()
        for path in output_dir.glob("*_expected.txt"):
            path.unlink()

    rng = random.Random(args.seed)

    for case_idx in range(args.count):
        case_name = f"{args.prefix}_{case_idx:03d}"
        a_matrix = random_matrix(rng, args.value_min, args.value_max, args.sparse_prob)
        b_matrix = random_matrix(rng, args.value_min, args.value_max, args.sparse_prob)
        c_matrix = matmul(a_matrix, b_matrix)

        write_input(output_dir / f"{case_name}_input.txt", case_name, args.seed, a_matrix, b_matrix)
        write_expected(output_dir / f"{case_name}_expected.txt", case_name, args.seed, c_matrix)
        if not args.quiet:
            print(f"GENERATED case={case_name} seed={args.seed}")

    print(
        f"GENERATED_SUMMARY dir={output_dir} count={args.count} seed={args.seed} "
        f"range=[{args.value_min},{args.value_max}] sparse_prob={args.sparse_prob}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
