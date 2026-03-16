# Cadence Innovus MMMC starting template for the DIP commercial flow.
# Update library and RC file paths before use.

if {![info exists ::env(DESIGN_NAME)]} {
    error "Please source scripts/prepare_env.sh before launching Innovus."
}

if {![info exists ::env(TLUPLUS_MAX)] || ![info exists ::env(TLUPLUS_MIN)]} {
    error "TLUPLUS files are not set. Fill config/libs.env first."
}

create_library_set -name LIB_TYP -timing [list $::env(TARGET_LIBRARY)]
create_rc_corner -name RC_TYP \
    -qx_tech_file $::env(QRC_TECH_FILE) \
    -preRoute_res 1.0 -postRoute_res 1.0 \
    -preRoute_cap 1.0 -postRoute_cap 1.0 \
    -preRoute_clkres 1.0 -preRoute_clkcap 1.0 \
    -T 25

create_delay_corner -name DC_TYP -library_set LIB_TYP -rc_corner RC_TYP
create_constraint_mode -name FUNC -sdc_files [list $::env(SDC_FILE)]
create_analysis_view -name VIEW_FUNC -constraint_mode FUNC -delay_corner DC_TYP
set_analysis_view -setup [list VIEW_FUNC] -hold [list VIEW_FUNC]
