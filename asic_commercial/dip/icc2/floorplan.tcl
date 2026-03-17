source [file join $::env(ICC2_ROOT) common.tcl]

set aspect_ratio [env_or_default FLOORPLAN_ASPECT_RATIO 1.0]
set core_util [env_or_default CORE_UTILIZATION 0.55]
set margin_left [env_or_default CORE_MARGIN_LEFT 8]
set margin_bottom [env_or_default CORE_MARGIN_BOTTOM 8]
set margin_right [env_or_default CORE_MARGIN_RIGHT 8]
set margin_top [env_or_default CORE_MARGIN_TOP 8]
set place_site [env_or_die PLACE_SITE]

flow_log "Running ICC2 floorplan"
initialize_floorplan \
    -shape R \
    -core_utilization $core_util \
    -side_ratio [list $aspect_ratio 1.0] \
    -core_offset [list $margin_left $margin_bottom $margin_right $margin_top] \
    -site_row_pattern $place_site

redirect [report_path floorplan floorplan] {
    report_utilization
}

save_stage_block floorplan
