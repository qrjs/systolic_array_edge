# Calibre DRC Summary

该表解析 Calibre DRC `.rep` 中所有非零 RULECHECK，便于定位严格 foundry DRC 收敛的主要问题。`Count` 是规则主结果数，`Expanded` 是括号内展开结果数。

## Per Arch

| Arch | Nonzero Rules | Count Sum | Expanded Sum | Report |
| --- | ---: | ---: | ---: | --- |
| WS | 25 | 8720 | 38040 | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_drc_backend_datatype_preserve_patch.rep` |
| OS | 24 | 8758 | 36503 | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_drc_backend.rep` |
| IS | 25 | 8964 | 38021 | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_drc_backend.rep` |
| DIP | 33 | 8773 | 28609 | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_drc_backend.rep` |

## Category Totals

| Arch | Category | Count Sum | Expanded Sum |
| --- | --- | ---: | ---: |
| WS | contact | 73 | 29044 |
| WS | geometry | 2730 | 2730 |
| WS | metal | 2174 | 2503 |
| WS | user_guide | 3740 | 3760 |
| WS | warning | 3 | 3 |
| OS | contact | 56 | 27480 |
| OS | geometry | 2772 | 2772 |
| OS | metal | 2278 | 2599 |
| OS | user_guide | 3648 | 3648 |
| OS | via | 1 | 1 |
| OS | warning | 3 | 3 |
| IS | contact | 75 | 28803 |
| IS | geometry | 2873 | 2873 |
| IS | metal | 2293 | 2622 |
| IS | user_guide | 3720 | 3720 |
| IS | warning | 3 | 3 |
| DIP | contact | 66 | 19597 |
| DIP | geometry | 2654 | 2654 |
| DIP | metal | 2668 | 2965 |
| DIP | user_guide | 3381 | 3389 |
| DIP | via | 1 | 1 |
| DIP | warning | 3 | 3 |

## Top Rules

| Arch | Rank | Category | Rule | Count | Expanded |
| --- | ---: | --- | --- | ---: | ---: |
| WS | 1 | geometry | G.4:M1i | 2381 | 2381 |
| WS | 2 | user_guide | USER_GUIDE.VIA6 | 1326 | 1346 |
| WS | 3 | user_guide | USER_GUIDE.VIA7 | 1320 | 1320 |
| WS | 4 | user_guide | USER_GUIDE.VIA9 | 696 | 696 |
| WS | 5 | metal | M1.S.1 | 595 | 595 |
| WS | 6 | metal | M2.S.1 | 511 | 511 |
| WS | 7 | geometry | G.4:M2i | 347 | 347 |
| WS | 8 | user_guide | USER_GUIDE.VIA8 | 344 | 344 |
| WS | 9 | metal | M3.S.1 | 342 | 342 |
| WS | 10 | metal | M4.S.1 | 331 | 331 |
| WS | 11 | metal | M5.S.1 | 330 | 330 |
| WS | 12 | contact | CO.EN.6 | 73 | 29044 |
| OS | 1 | geometry | G.4:M1i | 2325 | 2325 |
| OS | 2 | user_guide | USER_GUIDE.VIA6 | 1288 | 1288 |
| OS | 3 | user_guide | USER_GUIDE.VIA7 | 1288 | 1288 |
| OS | 4 | user_guide | USER_GUIDE.VIA9 | 688 | 688 |
| OS | 5 | metal | M1.S.1 | 674 | 674 |
| OS | 6 | metal | M2.S.1 | 543 | 543 |
| OS | 7 | geometry | G.4:M2i | 447 | 447 |
| OS | 8 | user_guide | USER_GUIDE.VIA8 | 340 | 340 |
| OS | 9 | metal | M3.S.1 | 333 | 333 |
| OS | 10 | metal | M4.S.1 | 322 | 322 |
| OS | 11 | metal | M5.S.1 | 322 | 322 |
| OS | 12 | contact | CO.EN.6 | 56 | 27480 |
| IS | 1 | geometry | G.4:M1i | 2411 | 2411 |
| IS | 2 | user_guide | USER_GUIDE.VIA6 | 1320 | 1320 |
| IS | 3 | user_guide | USER_GUIDE.VIA7 | 1320 | 1320 |
| IS | 4 | user_guide | USER_GUIDE.VIA9 | 696 | 696 |
| IS | 5 | metal | M1.S.1 | 644 | 644 |
| IS | 6 | metal | M2.S.1 | 561 | 561 |
| IS | 7 | geometry | G.4:M2i | 460 | 460 |
| IS | 8 | user_guide | USER_GUIDE.VIA8 | 344 | 344 |
| IS | 9 | metal | M3.S.1 | 342 | 342 |
| IS | 10 | metal | M4.S.1 | 331 | 331 |
| IS | 11 | metal | M5.S.1 | 330 | 330 |
| IS | 12 | contact | CO.EN.6 | 75 | 28803 |
| DIP | 1 | geometry | G.4:M1i | 2271 | 2271 |
| DIP | 2 | user_guide | USER_GUIDE.VIA6 | 1198 | 1206 |
| DIP | 3 | user_guide | USER_GUIDE.VIA7 | 1192 | 1192 |
| DIP | 4 | metal | M1.S.1 | 759 | 759 |
| DIP | 5 | metal | M2.S.1 | 754 | 754 |
| DIP | 6 | user_guide | USER_GUIDE.VIA9 | 632 | 632 |
| DIP | 7 | geometry | G.4:M2i | 381 | 381 |
| DIP | 8 | metal | M3.S.1 | 364 | 364 |
| DIP | 9 | user_guide | USER_GUIDE.VIA8 | 312 | 312 |
| DIP | 10 | metal | M4.S.1 | 304 | 304 |
| DIP | 11 | metal | M5.S.1 | 298 | 298 |
| DIP | 12 | contact | CO.EN.6 | 66 | 19597 |
