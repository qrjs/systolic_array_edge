# Vector Activity Summary

该表由 `case_metadata.csv` 聚合，量化不同 directed/random/sparse suite 对 MAC 活动量和理论零值跳过比例的压力。

| Group | Kind | Cases | Sparse Prob | Avg A NZ | Avg B NZ | Avg Active MAC | Avg Zero Gated | Avg Skip % |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| directed | directed | 20 | NA | 10.85 | 10.05 | 28.35 | 35.65 | 55.70 |
| random_seed_2026042601 | random | 128 | 0.3 | 11.09 | 11.22 | 31.15 | 32.85 | 51.33 |
| random_seed_2026042602 | random | 128 | 0.3 | 10.98 | 10.95 | 29.91 | 34.09 | 53.27 |
| random_seed_2026042603 | random | 128 | 0.3 | 11.08 | 11.06 | 30.51 | 33.49 | 52.33 |
| random_seed_2026042604 | random | 128 | 0.3 | 11.06 | 10.87 | 30.00 | 34.00 | 53.12 |
| random_seed_2026042605 | random | 128 | 0.3 | 11.11 | 11.30 | 31.52 | 32.48 | 50.74 |
| sparse_00 | sparse | 64 | 0.0 | 15.86 | 15.92 | 63.14 | 0.86 | 1.34 |
| sparse_25 | sparse | 64 | 0.25 | 12.11 | 11.97 | 36.48 | 27.52 | 42.99 |
| sparse_50 | sparse | 64 | 0.5 | 7.78 | 8.41 | 16.27 | 47.73 | 74.59 |
| sparse_75 | sparse | 64 | 0.75 | 3.58 | 4.12 | 3.56 | 60.44 | 94.43 |
| sparse_90 | sparse | 64 | 0.9 | 1.58 | 1.75 | 0.52 | 63.48 | 99.20 |
