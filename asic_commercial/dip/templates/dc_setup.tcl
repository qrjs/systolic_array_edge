# Synopsys DC starting template for the DIP commercial flow.
# Fill in real library paths through config/libs.env and adapt as needed.

if {![info exists ::env(DESIGN_NAME)]} {
    error "Please source scripts/prepare_env.sh before launching DC."
}

set design_name $::env(DESIGN_NAME)
set filelist    $::env(FILELIST)
set sdc_file    $::env(SDC_FILE)
set report_dir  $::env(REPORT_DIR)
set result_dir  $::env(RESULT_DIR)

file mkdir $report_dir
file mkdir $result_dir

if {![info exists ::env(TARGET_LIBRARY)]} {
    error "TARGET_LIBRARY is not set. Fill config/libs.env first."
}

set_app_var search_path [list $::env(PROJECT_ROOT)]
set_app_var target_library $::env(TARGET_LIBRARY)
set_app_var link_library "* $::env(LINK_LIBRARY)"

# Replace with the preferred RTL reader style in your environment if needed.
analyze -format verilog -f $filelist
elaborate $design_name
link
source $sdc_file

# Replace compile settings based on your PPA target.
compile_ultra

write -format verilog -hierarchy -output "$result_dir/${design_name}_dc.v"
write_sdc "$result_dir/${design_name}_dc.sdc"
report_area > "$report_dir/${design_name}_dc_area.rpt"
report_timing -max_paths 10 > "$report_dir/${design_name}_dc_timing.rpt"
