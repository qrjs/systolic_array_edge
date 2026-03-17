source [file join $::env(ICC2_ROOT) common.tcl]

flow_log "Running ICC2 CTS"
clock_opt

redirect [report_path cts qor] {
    report_qor
}
redirect [report_path cts timing] {
    report_timing -max_paths 10
}

save_stage_block cts
