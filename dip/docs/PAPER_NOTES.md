# DiP Paper Notes

Reference paper:

- arXiv abstract: https://arxiv.org/abs/2412.09709
- arXiv HTML/PDF entry: https://ar5iv.labs.arxiv.org/html/2412.09709

## Paper Facts Used In This Implementation

The following DiP ideas were directly carried into this standalone subproject:

1. Diagonal input movement across PE rows
2. Left-boundary to next-row right-boundary connection
3. Vertically accumulated partial sums
4. Offline weight permutation in software
5. 2-stage pipelined MAC per PE
6. Parallel overlap between loading the first active weight row and loading the first input row

The paper describes the architecture as follows:

- Inputs move diagonally across PE rows.
- The leftmost PE in one row feeds the rightmost PE in the next row.
- Weights stay stationary after being loaded.
- Partial sums accumulate vertically.

The paper's 3x3 example explains the weight permutation and timing:

- Weight rows are loaded before and during the first input cycle.
- Cycle 0 loads the first permuted weight row and the first input row in parallel.
- Later cycles stream the remaining input rows while previously injected rows propagate diagonally.

## Weight Permutation Used Here

The implementation uses the same column-wise rotation rule described in the paper:

```text
W_rot[i][j] = W[(i + j) mod N][j]
```

This means:

- Column `0` is unchanged
- Column `1` is rotated by one row
- Column `2` is rotated by two rows
- ...

For a `4x4` matrix, the hardware receives `W_rot`, while the golden reference remains `A x W`.

## Timing Model Used Here

The testbench applies the same scheduling style as the paper:

1. Preload cycles before computation
   - load `W_rot[N-1]` down to `W_rot[1]`
2. Cycle `0`
   - load `W_rot[0]`
   - input `A[0]`
3. Cycle `1..N-1`
   - input `A[1]` to `A[N-1]`
4. Drain until all output rows are observed

## Explicit Deviations

This standalone reproduction intentionally differs from the paper in a few places:

- Default datapath widths are `16/16/32`, not the paper's 8-bit evaluation baseline.
- The design is implemented as a clean standalone subproject and is not integrated into the root regression flow.
- Row-addressed weight loading is exposed as a practical RTL interface for testing.
- This work reproduces the dataflow behavior and functional matrix multiplication only; it does not reproduce the paper's measured silicon results.
