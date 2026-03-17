source [file join $::env(ICC2_ROOT) common.tcl]

set netlist_out [env_or_die ICC2_FINAL_NETLIST]
set def_out [env_or_die ICC2_FINAL_DEF]
set sdf_out [env_or_die ICC2_FINAL_SDF]
set spef_out [env_or_die ICC2_FINAL_SPEF]
set gds_out [env_or_die ICC2_FINAL_GDS]
set gds_map [env_or_default GDS_STREAM_OUT_MAP ""]

flow_log "Exporting ICC2 implementation results"
write_verilog -include all $netlist_out
write_def $def_out
write_sdf $sdf_out
write_parasitics -format spef -output $spef_out

if {$gds_map ne ""} {
    write_gds -layer_map $gds_map $gds_out
} else {
    flow_log "Skipping GDS stream-out because GDS_STREAM_OUT_MAP is not set"
}

redirect [report_path export final_qor] {
    report_qor
}

save_stage_block export
