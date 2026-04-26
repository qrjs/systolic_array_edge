#!/usr/bin/env python3

import argparse
import csv
import random
import shutil
from pathlib import Path


MATRIX_SIZE = 4
SUITE_INPUT_NAME = "suite_input.txt"
SUITE_EXPECTED_NAME = "suite_expected.txt"


def matmul(a_matrix, b_matrix):
    return [
        [
            sum(a_matrix[row][k] * b_matrix[k][col] for k in range(MATRIX_SIZE))
            for col in range(MATRIX_SIZE)
        ]
        for row in range(MATRIX_SIZE)
    ]


def zero_matrix():
    return [[0 for _ in range(MATRIX_SIZE)] for _ in range(MATRIX_SIZE)]


def identity_matrix(scale=1):
    return [
        [scale if row == col else 0 for col in range(MATRIX_SIZE)]
        for row in range(MATRIX_SIZE)
    ]


def parse_csv_ints(raw):
    values = []
    for item in raw.replace(" ", "").split(","):
        if item:
            values.append(int(item))
    return values


def maybe_sparse_value(rng, value_min, value_max, sparse_prob):
    if rng.random() < sparse_prob:
        return 0
    return rng.randint(value_min, value_max)


def random_matrix(rng, value_min, value_max, sparse_prob):
    return [
        [maybe_sparse_value(rng, value_min, value_max, sparse_prob) for _ in range(MATRIX_SIZE)]
        for _ in range(MATRIX_SIZE)
    ]


def nonzero_count(matrix):
    return sum(1 for row in matrix for value in row if value != 0)


def write_suite_input(path, label, cases):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis vector suite\n")
        handle.write("# label={} count={}\n".format(label, len(cases)))
        for case_name, a_matrix, b_matrix, _meta in cases:
            handle.write("CASE {}\n".format(case_name))
            handle.write("A\n")
            for row in a_matrix:
                handle.write(" ".join(str(value) for value in row) + "\n")
            handle.write("B\n")
            for row in b_matrix:
                handle.write(" ".join(str(value) for value in row) + "\n")


def write_suite_expected(path, label, cases):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis expected output suite\n")
        handle.write("# label={} count={}\n".format(label, len(cases)))
        for case_name, a_matrix, b_matrix, _meta in cases:
            handle.write("CASE {}\n".format(case_name))
            handle.write("C\n")
            for row in matmul(a_matrix, b_matrix):
                handle.write(" ".join(str(value) for value in row) + "\n")


def write_case_metadata(path, cases):
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow([
            "case",
            "a_nonzero",
            "b_nonzero",
            "a_total",
            "b_total",
            "active_mac",
            "total_mac",
            "zero_gated",
            "skip_ratio_pct",
            "tag",
        ])
        total_entries = MATRIX_SIZE * MATRIX_SIZE
        total_mac = MATRIX_SIZE * MATRIX_SIZE * MATRIX_SIZE
        for case_name, a_matrix, b_matrix, meta in cases:
            a_nz = nonzero_count(a_matrix)
            b_nz = nonzero_count(b_matrix)
            active_mac = 0
            for row in range(MATRIX_SIZE):
                for col in range(MATRIX_SIZE):
                    for k_idx in range(MATRIX_SIZE):
                        if a_matrix[row][k_idx] != 0 and b_matrix[k_idx][col] != 0:
                            active_mac += 1
            zero_gated = total_mac - active_mac
            skip_ratio = 100.0 * zero_gated / float(total_mac)
            writer.writerow([
                case_name,
                a_nz,
                b_nz,
                total_entries,
                total_entries,
                active_mac,
                total_mac,
                zero_gated,
                "{:.2f}".format(skip_ratio),
                meta.get("tag", ""),
            ])


def write_suite(output_dir, label, cases):
    output_dir.mkdir(parents=True, exist_ok=True)
    write_suite_input(output_dir / SUITE_INPUT_NAME, label, cases)
    write_suite_expected(output_dir / SUITE_EXPECTED_NAME, label, cases)
    write_case_metadata(output_dir / "case_metadata.csv", cases)


def directed_cases():
    dense_a = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
    ]
    dense_b = [
        [2, 0, -1, 3],
        [1, -2, 4, 0],
        [0, 5, -3, 2],
        [7, 1, 0, -4],
    ]
    signed_a = [
        [-3, 0, 5, -7],
        [8, -1, 0, 2],
        [0, 6, -4, 3],
        [1, -5, 7, 0],
    ]
    signed_b = [
        [4, -2, 0, 1],
        [0, 3, -5, 6],
        [-7, 1, 2, 0],
        [5, 0, -3, 4],
    ]
    permutation = [
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
        [1, 0, 0, 0],
    ]
    triangular_a = [
        [1, 2, 3, 4],
        [0, -2, 5, 6],
        [0, 0, 7, -8],
        [0, 0, 0, 9],
    ]
    triangular_b = [
        [9, 0, 0, 0],
        [8, -7, 0, 0],
        [6, 5, 4, 0],
        [-3, 2, 1, -1],
    ]
    checker_a = [
        [1, 0, -1, 0],
        [0, 2, 0, -2],
        [3, 0, -3, 0],
        [0, 4, 0, -4],
    ]
    checker_b = [
        [0, 5, 0, -5],
        [6, 0, -6, 0],
        [0, 7, 0, -7],
        [8, 0, -8, 0],
    ]
    row_sparse = [
        [0, 0, 0, 0],
        [1, 0, 2, 0],
        [0, 0, 0, 0],
        [-3, 0, 4, 0],
    ]
    col_sparse = [
        [0, 5, 0, 0],
        [0, -6, 0, 0],
        [0, 7, 0, 0],
        [0, -8, 0, 0],
    ]
    wide_a = [
        [255, -128, 64, -32],
        [-16, 8, -4, 2],
        [1, -2, 4, -8],
        [32, -64, 128, -255],
    ]
    wide_b = [
        [-1, 2, -4, 8],
        [16, -32, 64, -128],
        [255, 128, -64, -32],
        [4, -8, 16, -32],
    ]
    cases = [
        ("zero", zero_matrix(), zero_matrix(), {"tag": "directed_zero"}),
        ("identity_left", identity_matrix(), dense_b, {"tag": "identity"}),
        ("identity_right", dense_a, identity_matrix(), {"tag": "identity"}),
        ("neg_identity", identity_matrix(-1), dense_b, {"tag": "negative_identity"}),
        ("dense_small", dense_a, dense_b, {"tag": "dense"}),
        ("signed_mix", signed_a, signed_b, {"tag": "signed"}),
        ("sparse_signed", checker_a, checker_b, {"tag": "sparse_signed"}),
        ("permutation", permutation, dense_b, {"tag": "permutation"}),
        ("rank1_outer", [[1], [2], [-3], [4]], [[5, -6, 7, -8]], {"tag": "rank1"}),
        ("triangular_mix", triangular_a, triangular_b, {"tag": "triangular"}),
        ("row_sparse", row_sparse, dense_b, {"tag": "row_sparse"}),
        ("col_sparse", dense_a, col_sparse, {"tag": "col_sparse"}),
        ("wide_range", wide_a, wide_b, {"tag": "wide_range"}),
        ("boundary_mix", [[64, -64, 63, -63]] * 4, [[-64, 63, -62, 61]] * 4, {"tag": "boundary"}),
        ("cancellation", [[1, -1, 1, -1]] * 4, [[1, 1, 1, 1], [-1, -1, -1, -1], [1, 1, 1, 1], [-1, -1, -1, -1]], {"tag": "cancellation"}),
        ("single_a_nonzero", [[9, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], dense_b, {"tag": "single_nonzero"}),
        ("single_b_nonzero", dense_a, [[0, 0, 0, 0], [0, -7, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], {"tag": "single_nonzero"}),
        ("diagonal_weight", dense_a, [[2, 0, 0, 0], [0, -3, 0, 0], [0, 0, 4, 0], [0, 0, 0, -5]], {"tag": "diagonal"}),
        ("alternating_signs", [[(-1) ** (r + c) * (r + c + 1) for c in range(4)] for r in range(4)], signed_b, {"tag": "alternating"}),
        ("lower_upper", triangular_b, triangular_a, {"tag": "lower_upper"}),
    ]

    normalized = []
    for case_name, a_matrix, b_matrix, meta in cases:
        if len(a_matrix) == MATRIX_SIZE and len(a_matrix[0]) == 1:
            a_matrix = [[a_matrix[row][0] for _ in range(MATRIX_SIZE)] for row in range(MATRIX_SIZE)]
        if len(b_matrix) == 1 and len(b_matrix[0]) == MATRIX_SIZE:
            b_matrix = [list(b_matrix[0]) for _ in range(MATRIX_SIZE)]
        normalized.append((case_name, a_matrix, b_matrix, meta))
    return normalized


def random_cases(seed, count, value_min, value_max, sparse_prob, prefix):
    rng = random.Random(seed)
    cases = []
    for index in range(count):
        case_name = "{}_{:03d}".format(prefix, index)
        a_matrix = random_matrix(rng, value_min, value_max, sparse_prob)
        b_matrix = random_matrix(rng, value_min, value_max, sparse_prob)
        cases.append((case_name, a_matrix, b_matrix, {"tag": "random"}))
    return cases


def write_manifest(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["group", "kind", "vector_dir", "cases", "seed", "sparse_prob", "value_min", "value_max"])
        for row in rows:
            writer.writerow([
                row["group"],
                row["kind"],
                row["vector_dir"],
                row["cases"],
                row.get("seed", ""),
                row.get("sparse_prob", ""),
                row.get("value_min", ""),
                row.get("value_max", ""),
            ])


def write_manifest_md(path, rows):
    with path.open("w", encoding="utf-8") as handle:
        handle.write("# Thesis Vector Manifest\n\n")
        handle.write("| Group | Kind | Cases | Seed | Sparse Prob | Vector Dir |\n")
        handle.write("| --- | --- | ---: | ---: | ---: | --- |\n")
        for row in rows:
            handle.write(
                "| {} | {} | {} | {} | {} | `{}` |\n".format(
                    row["group"],
                    row["kind"],
                    row["cases"],
                    row.get("seed", ""),
                    row.get("sparse_prob", ""),
                    row["vector_dir"],
                )
            )


def main():
    parser = argparse.ArgumentParser(description="Generate reproducible thesis vector suites.")
    parser.add_argument("--output-root", default="test_vectors/thesis")
    parser.add_argument("--random-seeds", default="2026042601,2026042602,2026042603,2026042604,2026042605")
    parser.add_argument("--random-count", type=int, default=128)
    parser.add_argument("--random-sparse-prob", type=float, default=0.30)
    parser.add_argument("--sparse-levels", default="0,25,50,75,90")
    parser.add_argument("--sparse-count", type=int, default=64)
    parser.add_argument("--value-min", type=int, default=-64)
    parser.add_argument("--value-max", type=int, default=64)
    parser.add_argument("--clean", action="store_true")
    args = parser.parse_args()

    if args.random_count <= 0:
        raise SystemExit("--random-count must be > 0")
    if args.sparse_count <= 0:
        raise SystemExit("--sparse-count must be > 0")
    if args.value_min > args.value_max:
        raise SystemExit("--value-min must be <= --value-max")
    if not (0.0 <= args.random_sparse_prob <= 1.0):
        raise SystemExit("--random-sparse-prob must be in [0, 1]")

    output_root = Path(args.output_root).resolve()
    if args.clean and output_root.exists():
        shutil.rmtree(str(output_root))
    output_root.mkdir(parents=True, exist_ok=True)

    rows = []

    directed_dir = output_root / "directed"
    directed = directed_cases()
    write_suite(directed_dir, "directed", directed)
    rows.append({
        "group": "directed",
        "kind": "directed",
        "vector_dir": str(directed_dir),
        "cases": len(directed),
    })

    for seed in parse_csv_ints(args.random_seeds):
        group = "random_seed_{}".format(seed)
        vector_dir = output_root / group
        cases = random_cases(seed, args.random_count, args.value_min, args.value_max, args.random_sparse_prob, "rand")
        write_suite(vector_dir, group, cases)
        rows.append({
            "group": group,
            "kind": "random",
            "vector_dir": str(vector_dir),
            "cases": len(cases),
            "seed": seed,
            "sparse_prob": args.random_sparse_prob,
            "value_min": args.value_min,
            "value_max": args.value_max,
        })

    for sparse_pct in parse_csv_ints(args.sparse_levels):
        if sparse_pct < 0 or sparse_pct > 100:
            raise SystemExit("--sparse-levels entries must be in [0, 100]")
        sparse_prob = sparse_pct / 100.0
        seed = 2026042600 + sparse_pct
        group = "sparse_{:02d}".format(sparse_pct)
        vector_dir = output_root / group
        cases = random_cases(seed, args.sparse_count, args.value_min, args.value_max, sparse_prob, "sp{:02d}".format(sparse_pct))
        write_suite(vector_dir, group, cases)
        rows.append({
            "group": group,
            "kind": "sparse",
            "vector_dir": str(vector_dir),
            "cases": len(cases),
            "seed": seed,
            "sparse_prob": sparse_prob,
            "value_min": args.value_min,
            "value_max": args.value_max,
        })

    write_manifest(output_root / "manifest.csv", rows)
    write_manifest_md(output_root / "manifest.md", rows)
    print("THESIS_VECTOR_MANIFEST path={}".format(output_root / "manifest.csv"))
    print("THESIS_VECTOR_SUMMARY suites={} cases={}".format(len(rows), sum(int(row["cases"]) for row in rows)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
