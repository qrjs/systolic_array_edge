# Calibre LVS Attempts

该表扫描每个数据流已有的 Calibre LVS 尝试，用于区分严格 signoff 尝试和调试型参数 sweep。`Top Result=NOT_LISTED` 通常表示错误集中在 leaf/stdcell 比较，不能视为 top clean。

## Current Attempts

| Arch | Attempt | Status | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Mismatch Score | Errors | Report |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| WS | lvs | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs.rep` |
| WS | lvs_box | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 368 | 0 | 0 | 378 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_box.rep` |
| WS | lvs_box_sourcebox | CHECK_REQUIRED | NOT_COMPARED | NA | 0 | 0 | 0 | 0 | 900000000 | No matching .SUBCKT statements for 8 unique cells (BUFFD12BWP12T40P140, BUFFD16BWP12T40P140, BUFFD1BWP12T40P140, BUFFD2BWP12T40P140, CKBD8BWP12T40P140, INVD1BWP12T40P140, INVD2BWP12T40P140, INVD3BWP12T40P140) | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_box_sourcebox.rep` |
| WS | lvs_box_sourcebox_stubs | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 368 | 0 | 1 | 1000378 | Connectivity errors.; Different numbers of nets.; Different numbers of ports. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_box_sourcebox_stubs.rep` |
| WS | lvs_datatype_preserve_patch | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1000 | 1000 | 1 | 2001010 | Connectivity errors.; Different numbers of instances.; Different numbers of nets.; Different numbers of ports. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_datatype_preserve_patch.rep` |
| WS | lvs_default_unpatched | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 413 | 0 | 0 | 423 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_default_unpatched.rep` |
| WS | lvs_gds_labeled | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 413 | 0 | 0 | 423 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_gds_labeled.rep` |
| WS | lvs_innovus_logic | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_innovus_logic.rep` |
| WS | lvs_ports_only | CHECK_REQUIRED | INCORRECT | INCORRECT | 45 | 2 | 0 | 0 | 452 | Cells with non-floating extra pins.; Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only.rep` |
| WS | lvs_ports_only_fixed | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only_fixed.rep` |
| WS | lvs_ports_only_flat | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 483 | 0 | 0 | 493 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only_flat.rep` |
| WS | lvs_ports_only_nocase | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only_nocase.rep` |
| WS | lvs_ports_only_nostdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only_nostdlib.rep` |
| WS | lvs_ports_only_stdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_only_stdlib.rep` |
| WS | lvs_ports_power_globals_yes | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 1 | 1000394 | Connectivity errors.; Different numbers of nets.; Different numbers of ports.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_power_globals_yes.rep` |
| WS | lvs_ports_power_ports | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 1 | 1000394 | Connectivity errors.; Different numbers of nets.; Different numbers of ports.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_ports_power_ports.rep` |
| WS | lvs_property_nettext2 | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_property_nettext2.rep` |
| WS | lvs_unique_case | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 413 | 0 | 0 | 423 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_unique_case.rep` |
| WS | lvs_unpatched_gds | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 413 | 0 | 0 | 423 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs_unpatched_gds.rep` |
| OS | lvs | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 324 | 0 | 0 | 334 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_lvs.rep` |
| OS | lvs_ports_only_nostdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 324 | 0 | 0 | 334 | Connectivity errors.; Different numbers of nets. | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_lvs_ports_only_nostdlib.rep` |
| IS | lvs | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 503 | 0 | 0 | 513 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_lvs.rep` |
| IS | lvs_ports_only_nostdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 503 | 0 | 0 | 513 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_lvs_ports_only_nostdlib.rep` |
| DIP | lvs | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs.rep` |
| DIP | lvs_patched_ports_only_nostdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1000 | 1000 | 1 | 2001010 | Connectivity errors.; Different numbers of instances.; Different numbers of nets.; Different numbers of ports. | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs_patched_ports_only_nostdlib.rep` |
| DIP | lvs_patchedgds_ports_only | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs_patchedgds_ports_only.rep` |
| DIP | lvs_ports_only_nostdlib | CHECK_REQUIRED | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs_ports_only_nostdlib.rep` |

## Lowest Overall-Mismatch Attempts

排序优先级为：比较完成状态、综合 mismatch score。score 对 port/instance mismatch 加重权重，因此比单看 incorrect nets 更适合判断哪个 LVS 配置更接近 clean。

| Arch | Attempt | Result | Top Result | Incorrect Cells | Incorrect Nets | Incorrect Instances | Incorrect Ports | Mismatch Score | Errors |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| WS | lvs_box | INCORRECT | INCORRECT | 1 | 368 | 0 | 0 | 378 | Connectivity errors.; Different numbers of nets. |
| WS | lvs | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. |
| WS | lvs_innovus_logic | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. |
| WS | lvs_ports_only_fixed | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. |
| WS | lvs_ports_only_nocase | INCORRECT | INCORRECT | 1 | 384 | 0 | 0 | 394 | Connectivity errors.; Different numbers of nets.; Property errors. |
| OS | lvs | INCORRECT | INCORRECT | 1 | 324 | 0 | 0 | 334 | Connectivity errors.; Different numbers of nets. |
| OS | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 324 | 0 | 0 | 334 | Connectivity errors.; Different numbers of nets. |
| IS | lvs | INCORRECT | INCORRECT | 1 | 503 | 0 | 0 | 513 | Connectivity errors.; Different numbers of nets.; Property errors. |
| IS | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 503 | 0 | 0 | 513 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_patchedgds_ports_only | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 1003 | 0 | 0 | 1013 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_patched_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 1000 | 1000 | 1 | 2001010 | Connectivity errors.; Different numbers of instances.; Different numbers of nets.; Different numbers of ports. |

## Lowest Incorrect-Net Attempts

该表只用于诊断 net 数量收敛，不代表综合 LVS 最优；若同时引入 port/instance mismatch，应以后面的 overall mismatch 表为准。

| Arch | Attempt | Result | Top Result | Incorrect Cells | Incorrect Nets | Errors |
| --- | --- | --- | --- | ---: | ---: | --- |
| WS | lvs_ports_only | INCORRECT | INCORRECT | 45 | 2 | Cells with non-floating extra pins.; Connectivity errors.; Different numbers of nets. |
| WS | lvs_box | INCORRECT | INCORRECT | 1 | 368 | Connectivity errors.; Different numbers of nets. |
| WS | lvs_box_sourcebox_stubs | INCORRECT | INCORRECT | 1 | 368 | Connectivity errors.; Different numbers of nets.; Different numbers of ports. |
| WS | lvs | INCORRECT | INCORRECT | 1 | 384 | Connectivity errors.; Different numbers of nets.; Property errors. |
| WS | lvs_innovus_logic | INCORRECT | INCORRECT | 1 | 384 | Connectivity errors.; Different numbers of nets.; Property errors. |
| OS | lvs | INCORRECT | INCORRECT | 1 | 324 | Connectivity errors.; Different numbers of nets. |
| OS | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 324 | Connectivity errors.; Different numbers of nets. |
| IS | lvs | INCORRECT | INCORRECT | 1 | 503 | Connectivity errors.; Different numbers of nets.; Property errors. |
| IS | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 503 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_patched_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 1000 | Connectivity errors.; Different numbers of instances.; Different numbers of nets.; Different numbers of ports. |
| DIP | lvs | INCORRECT | INCORRECT | 1 | 1003 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_patchedgds_ports_only | INCORRECT | INCORRECT | 1 | 1003 | Connectivity errors.; Different numbers of nets.; Property errors. |
| DIP | lvs_ports_only_nostdlib | INCORRECT | INCORRECT | 1 | 1003 | Connectivity errors.; Different numbers of nets.; Property errors. |
