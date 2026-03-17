source [file join $::env(ICC2_ROOT) common.tcl]

flow_log "Running ICC2 placement"
place_opt

redirect [report_path place qor] {
    report_qor
}
redirect [report_path place timing] {
    report_timing -max_paths 10
}

save_stage_block place
