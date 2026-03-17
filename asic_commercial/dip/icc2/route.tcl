source [file join $::env(ICC2_ROOT) common.tcl]

flow_log "Running ICC2 routing"
route_auto
route_opt

redirect [report_path route qor] {
    report_qor
}
redirect [report_path route timing] {
    report_timing -max_paths 10
}

save_stage_block route
