# Tapeout Gap Report

该表把当前论文工程已收敛的 Innovus 主线与严格流片还需要补齐的 Calibre/foundry signoff 分开。`implemented_flow` 为当前证据链；`tapeout_gap` 是流片前仍需专门收敛或确认的项目。

| Arch | Domain | Item | Status | Detail | Path |
| --- | --- | --- | --- | --- | --- |
| WS | implemented_flow | rtl_frontsim_268 | PASS | PASS 268/268 | `NA` |
| WS | implemented_flow | innovus_gate_sim_268 | PASS | PASS 268/268 | `NA` |
| WS | implemented_flow | fm_dc | PASS | PASS | `NA` |
| WS | implemented_flow | fm_innovus | PASS | PASS | `NA` |
| WS | implemented_flow | innovus_drc | PASS | PASS | `NA` |
| WS | implemented_flow | innovus_connectivity | PASS | PASS | `NA` |
| WS | implemented_flow | postroute_setup_slack | PASS | 2.192 ns | `NA` |
| WS | implemented_flow | gds_def_sdf_netlist | PASS | gds=PRESENT def=PRESENT sdf=PRESENT netlist=PRESENT | `NA` |
| WS | tapeout_gap | calibre_foundry_drc | CHECK_REQUIRED | results=8720 | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_drc_backend_datatype_preserve_patch.rep` |
| WS | tapeout_gap | calibre_lvs | CHECK_REQUIRED | result=INCORRECT | `/home/host_1/systolic_array_edge/asic_commercial/ws/reports/calibre/ws_core_std_top_4x4_lvs.rep` |
| OS | implemented_flow | rtl_frontsim_268 | PASS | PASS 268/268 | `NA` |
| OS | implemented_flow | innovus_gate_sim_268 | PASS | PASS 268/268 | `NA` |
| OS | implemented_flow | fm_dc | PASS | PASS | `NA` |
| OS | implemented_flow | fm_innovus | PASS | PASS | `NA` |
| OS | implemented_flow | innovus_drc | PASS | PASS | `NA` |
| OS | implemented_flow | innovus_connectivity | PASS | PASS | `NA` |
| OS | implemented_flow | postroute_setup_slack | PASS | 2.196 ns | `NA` |
| OS | implemented_flow | gds_def_sdf_netlist | PASS | gds=PRESENT def=PRESENT sdf=PRESENT netlist=PRESENT | `NA` |
| OS | tapeout_gap | calibre_foundry_drc | CHECK_REQUIRED | results=8758 | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_drc_backend.rep` |
| OS | tapeout_gap | calibre_lvs | CHECK_REQUIRED | result=INCORRECT | `/home/host_1/systolic_array_edge/asic_commercial/os/reports/calibre/os_core_std_top_4x4_lvs.rep` |
| IS | implemented_flow | rtl_frontsim_268 | PASS | PASS 268/268 | `NA` |
| IS | implemented_flow | innovus_gate_sim_268 | PASS | PASS 268/268 | `NA` |
| IS | implemented_flow | fm_dc | PASS | PASS | `NA` |
| IS | implemented_flow | fm_innovus | PASS | PASS | `NA` |
| IS | implemented_flow | innovus_drc | PASS | PASS | `NA` |
| IS | implemented_flow | innovus_connectivity | PASS | PASS | `NA` |
| IS | implemented_flow | postroute_setup_slack | PASS | 2.141 ns | `NA` |
| IS | implemented_flow | gds_def_sdf_netlist | PASS | gds=PRESENT def=PRESENT sdf=PRESENT netlist=PRESENT | `NA` |
| IS | tapeout_gap | calibre_foundry_drc | CHECK_REQUIRED | results=8964 | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_drc_backend.rep` |
| IS | tapeout_gap | calibre_lvs | CHECK_REQUIRED | result=INCORRECT | `/home/host_1/systolic_array_edge/asic_commercial/is/reports/calibre/is_core_std_top_4x4_lvs.rep` |
| DIP | implemented_flow | rtl_frontsim_268 | PASS | PASS 268/268 | `NA` |
| DIP | implemented_flow | innovus_gate_sim_268 | PASS | PASS 268/268 | `NA` |
| DIP | implemented_flow | fm_dc | PASS | PASS | `NA` |
| DIP | implemented_flow | fm_innovus | PASS | PASS | `NA` |
| DIP | implemented_flow | innovus_drc | PASS | PASS | `NA` |
| DIP | implemented_flow | innovus_connectivity | PASS | PASS | `NA` |
| DIP | implemented_flow | postroute_setup_slack | PASS | 2.038 ns | `NA` |
| DIP | implemented_flow | gds_def_sdf_netlist | PASS | gds=PRESENT def=PRESENT sdf=PRESENT netlist=PRESENT | `NA` |
| DIP | tapeout_gap | calibre_foundry_drc | CHECK_REQUIRED | results=8773 | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_drc_backend.rep` |
| DIP | tapeout_gap | calibre_lvs | CHECK_REQUIRED | result=INCORRECT | `/home/host_1/systolic_array_edge/asic_commercial/dip/reports/calibre/dip_core_std_top_4x4_lvs.rep` |
