proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

proc maybe_configure_icc_shell_exec {} {
    set icc_shell_exec ""
    if {[info exists ::env(ICC_SHELL_EXEC)] && $::env(ICC_SHELL_EXEC) ne ""} {
        set icc_shell_exec $::env(ICC_SHELL_EXEC)
    } else {
        catch {set icc_shell_exec [exec which icc_shell]}
    }

    if {$icc_shell_exec ne ""} {
        puts "  icc_shell_exec = $icc_shell_exec"
        catch {set_app_options -name lib.configuration.icc_shell_exec -value $icc_shell_exec}
    } else {
        puts "  icc_shell_exec = <not found>"
    }
}

proc create_design_lib {design_lib tech_file ref_libs} {
    set create_mode "tech_and_ref"
    if {[info exists ::env(ICC2_CREATE_LIB_MODE)] && $::env(ICC2_CREATE_LIB_MODE) ne ""} {
        set create_mode [string tolower $::env(ICC2_CREATE_LIB_MODE)]
    }

    switch -- $create_mode {
        ref_only {
            puts "  create_lib mode = ref_only"
            create_lib $design_lib -ref_libs $ref_libs
        }
        tech_and_ref {
            puts "  create_lib mode = tech_and_ref"
            create_lib $design_lib -technology $tech_file -ref_libs $ref_libs
        }
        auto {
            puts "  create_lib mode = auto"
            if {$tech_file ne "" && [file exists $tech_file]} {
                puts "  auto path = use technology file"
                create_lib $design_lib -technology $tech_file -ref_libs $ref_libs
            } else {
                puts "  auto path = use ref libs only"
                create_lib $design_lib -ref_libs $ref_libs
            }
        }
        default {
            error "Unsupported ICC2_CREATE_LIB_MODE '$create_mode' (expected tech_and_ref, ref_only, or auto)"
        }
    }
}

set step [string tolower [require_env ICC2_STEP]]
set design_name [require_env DESIGN_NAME]
set design_lib [require_env ICC2_DESIGN_LIB]
set tech_file ""
if {[info exists ::env(ICC2_TECH_FILE)] && $::env(ICC2_TECH_FILE) ne ""} {
    set tech_file $::env(ICC2_TECH_FILE)
}
set ref_libs [split [require_env ICC2_REFERENCE_LIBS]]
set input_netlist [require_env ICC2_INPUT_NETLIST]
set sdc_file [require_env SDC_FILE]

puts "ICC2 setup:"
puts "  design_lib = $design_lib"
puts "  tech_file  = $tech_file"
puts "  ref_libs   = $ref_libs"
maybe_configure_icc_shell_exec

if {($step eq "all" || $step eq "init") && (![file exists $design_lib] || [require_env ICC2_OVERWRITE_LIB] eq "1")} {
    file delete -force $design_lib
    create_design_lib $design_lib $tech_file $ref_libs
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
