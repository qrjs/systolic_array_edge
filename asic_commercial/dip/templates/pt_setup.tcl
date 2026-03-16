# Synopsys PrimeTime starting template for the DIP commercial flow.
# Update netlist, parasitics, and library references before use.

if {![info exists ::env(DESIGN_NAME)]} {
    error "Please source scripts/prepare_env.sh before launching PrimeTime."
}

if {![info exists ::env(TARGET_LIBRARY)]} {
    error "TARGET_LIBRARY is not set. Fill config/libs.env first."
}

set design_name $::env(DESIGN_NAME)
set netlist_file "$::env(RESULT_DIR)/${design_name}_dc.v"
set sdc_file $::env(SDC_FILE)

set search_path [list $::env(PROJECT_ROOT)]
set target_library $::env(TARGET_LIBRARY)
set link_path "* $::env(LINK_LIBRARY)"

read_verilog $netlist_file
current_design $design_name
link_design $design_name
read_sdc $sdc_file

# Add read_parasitics once routed SPEF is ready.
report_timing -max_paths 10
report_constraint -all_violators
