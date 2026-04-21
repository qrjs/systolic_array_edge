proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

set step [string tolower [require_env ICC2_STEP]]
set design_name [require_env DESIGN_NAME]
set design_lib [require_env ICC2_DESIGN_LIB]
set tech_file [require_env ICC2_TECH_FILE]
set ref_libs [split [require_env ICC2_REFERENCE_LIBS]]
set input_netlist [require_env ICC2_INPUT_NETLIST]
set sdc_file [require_env SDC_FILE]

if {($step eq "all" || $step eq "init") && (![file exists $design_lib] || [require_env ICC2_OVERWRITE_LIB] eq "1")} {
    file delete -force $design_lib
    create_lib $design_lib -technology $tech_file -ref_libs $ref_libs
}

open_lib $design_lib

if {$step eq "all" || $step eq "init"} {
    if {[llength [get_blocks -quiet $design_name]] == 0} {
        create_block $design_name
    } else {
        current_block $design_name
    }
    current_block $design_name
    read_verilog $input_netlist
    link_block
    if {[info exists ::env(TLUPLUS_MAX)] && $::env(TLUPLUS_MAX) ne "" &&
        [info exists ::env(TLUPLUS_MIN)] && $::env(TLUPLUS_MIN) ne "" &&
        [info exists ::env(TLUPLUS_MAP)] && $::env(TLUPLUS_MAP) ne ""} {
        set_tlu_plus_files \
            -max_tluplus $::env(TLUPLUS_MAX) \
            -min_tluplus $::env(TLUPLUS_MIN) \
            -tech2itf_map $::env(TLUPLUS_MAP)
    }
    read_sdc $sdc_file
    initialize_floorplan \
        -core_utilization [require_env CORE_UTILIZATION] \
        -core_offset [list [require_env CORE_MARGIN_LEFT] [require_env CORE_MARGIN_BOTTOM] [require_env CORE_MARGIN_RIGHT] [require_env CORE_MARGIN_TOP]] \
        -shape R
    save_block
}

if {$step eq "all" || $step eq "place"} {
    place_opt
    save_block
}

if {$step eq "all" || $step eq "cts"} {
    clock_opt
    save_block
}

if {$step eq "all" || $step eq "route"} {
    route_auto
    route_opt
    save_block
}

if {$step eq "all" || $step eq "export"} {
    write_verilog -include all [require_env ICC2_NETLIST]
    write_sdf [require_env ICC2_SDF]
    write_def [require_env ICC2_DEF]
    if {[info exists ::env(GDS_STREAM_OUT_MAP)] && $::env(GDS_STREAM_OUT_MAP) ne ""} {
        write_gds -layer_map $::env(GDS_STREAM_OUT_MAP) [require_env ICC2_GDS]
    } else {
        write_gds [require_env ICC2_GDS]
    }
}

quit

