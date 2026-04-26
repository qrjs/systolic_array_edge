# Foundry Signoff Check

该检查只覆盖严格 foundry Calibre DRC/LVS，不代表论文实现主线。只有 DRC 非零规则为 0 且 LVS `CORRECT` 时才为 PASS。

| Arch | Item | Status | Detail | Path |
| --- | --- | --- | --- | --- |
| WS | calibre_foundry_drc | FAIL | count_sum=8720 expanded_sum=38040 | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_drc_backend_datatype_preserve_patch.rep` |
| OS | calibre_foundry_drc | FAIL | count_sum=8758 expanded_sum=36503 | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_drc_backend.rep` |
| IS | calibre_foundry_drc | FAIL | count_sum=8964 expanded_sum=38021 | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_drc_backend.rep` |
| DIP | calibre_foundry_drc | FAIL | count_sum=8773 expanded_sum=28609 | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_drc_backend.rep` |
| WS | calibre_lvs | FAIL | result=INCORRECT top_result=INCORRECT cells=1 nets=384 instances=0 ports=0 | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs.rep` |
| OS | calibre_lvs | FAIL | result=INCORRECT top_result=INCORRECT cells=1 nets=324 instances=0 ports=0 | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_lvs.rep` |
| IS | calibre_lvs | FAIL | result=INCORRECT top_result=INCORRECT cells=1 nets=503 instances=0 ports=0 | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_lvs.rep` |
| DIP | calibre_lvs | FAIL | result=INCORRECT top_result=INCORRECT cells=1 nets=1003 instances=0 ports=0 | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs.rep` |

Overall foundry signoff check: `FAIL`
