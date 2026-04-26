# Calibre LVS Summary

该表汇总严格 foundry LVS 的当前状态。`CHECK_REQUIRED` 表示 Calibre 已完成比较但结果还未 clean。

| Arch | Status | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Errors | Warnings | Report |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | --- | --- | --- |
| WS | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | Connectivity errors.; Different numbers of nets.; Property errors. | Ambiguity points were found and resolved arbitrarily.; Unbalanced smashed mosfets were matched. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs.rep` |
| OS | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 324 | 0 | 0 | Connectivity errors.; Different numbers of nets. | Ambiguity points were found and resolved arbitrarily. | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_lvs.rep` |
| IS | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 503 | 0 | 0 | Connectivity errors.; Different numbers of nets.; Property errors. | Ambiguity points were found and resolved arbitrarily.; Unbalanced smashed mosfets were matched. | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_lvs.rep` |
| DIP | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | Connectivity errors.; Different numbers of nets.; Property errors. | Ambiguity points were found and resolved arbitrarily. | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs.rep` |
