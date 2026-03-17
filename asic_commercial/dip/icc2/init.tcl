source [file join $::env(ICC2_ROOT) common.tcl]

set design_lib [env_or_die ICC2_DESIGN_LIB]
set design_name [env_or_die DESIGN_NAME]
set tech_file [env_or_die ICC2_TECH_FILE]
set ref_libs [split [env_or_die ICC2_REFERENCE_LIBS]]
set max_tlu [env_or_die TLUPLUS_MAX]
set min_tlu [env_or_die TLUPLUS_MIN]
set tlu_map [env_or_die TLUPLUS_MAP]
set sdc_file [env_or_die SDC_FILE]
set netlist_file [env_or_die ICC2_NETLIST]
set max_cores [env_or_default MAX_CORES 8]
set overwrite_lib [env_or_default ICC2_OVERWRITE_LIB 1]

if {[file exists $design_lib]} {
    if {$overwrite_lib eq "1"} {
        file delete -force $design_lib
    } else {
        error "ICC2 design library already exists: $design_lib. Remove it or set ICC2_OVERWRITE_LIB=1 before rerunning init."
    }
}

file mkdir [env_or_die ICC2_WORK_DIR]
file mkdir [env_or_die ICC2_REPORT_DIR]
file mkdir [env_or_die ICC2_RESULT_DIR]

catch {set_host_options -max_cores $max_cores}

flow_log "Creating ICC2 design library"
create_lib $design_lib -technology $tech_file -ref_libs $ref_libs
open_lib $design_lib

read_parasitic_tech -tlup $max_tlu -layermap $tlu_map -name maxTLU
read_parasitic_tech -tlup $min_tlu -layermap $tlu_map -name minTLU

read_verilog -top $design_name $netlist_file
current_block $design_name
link_block
read_sdc $sdc_file
set_parasitic_parameters -early_spec minTLU -late_spec maxTLU

redirect [report_path init qor] {
    report_qor
}
redirect [report_path init timing] {
    report_timing -max_paths 10
}

save_stage_block init
