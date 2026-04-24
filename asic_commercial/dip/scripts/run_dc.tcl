proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

proc env_or_default {name default_value} {
    if {[info exists ::env($name)] && $::env($name) ne ""} {
        return $::env($name)
    }
    return $default_value
}

proc resolve_filelist {repo_root filelist_path} {
    set rtl_files {}
    set fh [open $filelist_path r]
    while {[gets $fh line] >= 0} {
        set line [string trim $line]
        if {$line eq "" || [string match "#*" $line]} {
            continue
        }
        if {[file pathtype $line] eq "absolute"} {
            lappend rtl_files $line
        } else {
            lappend rtl_files [file normalize [file join $repo_root $line]]
        }
    }
    close $fh
    return $rtl_files
}

set design_name   [require_env DESIGN_NAME]
set repo_root     [require_env REPO_ROOT]
set filelist_path [require_env FILELIST]
set sdc_path      [require_env SDC_FILE]
set work_dir      [require_env DC_WORK_DIR]

define_design_lib WORK -path $work_dir

set target_library_raw [require_env TARGET_LIBRARY]
set link_library_raw   [require_env LINK_LIBRARY]
set max_cores_raw      [expr {[info exists ::env(MAX_CORES)] ? $::env(MAX_CORES) : "8"}]
set use_ultra_raw      [expr {[info exists ::env(DC_USE_ULTRA)] ? $::env(DC_USE_ULTRA) : "0"}]
set dip_compile_profile [string tolower [env_or_default DIP_COMPILE_PROFILE "plain"]]

set_app_var target_library [split $target_library_raw]
set_app_var link_library [split $link_library_raw]

catch {set_host_options -max_cores $max_cores_raw}
set_svf [require_env DC_SVF]

set rtl_files [resolve_filelist $repo_root $filelist_path]
analyze -format sverilog $rtl_files
elaborate $design_name
current_design $design_name
link
check_design > [require_env DC_CHECK_RPT]
source $sdc_path

if {$use_ultra_raw eq "1"} {
    set default_compile_profile "ultra"
} else {
    set default_compile_profile "plain"
}

if {$dip_compile_profile eq "plain" || $dip_compile_profile eq "default"} {
    set dip_compile_profile $default_compile_profile
}

switch -- $dip_compile_profile {
    plain {
        compile
    }
    ultra {
        compile_ultra
    }
    gated_default {
        set_clock_gating_style -minimum_bitwidth 4 \
                               -positive_edge_logic {integrated} \
                               -control_point before
        insert_clock_gating
        compile
        redirect -file [require_env DC_GATING_RPT] {report_clock_gating}
    }
    gated_area {
        set_clock_gating_style -minimum_bitwidth 64 \
                               -positive_edge_logic {integrated} \
                               -control_point before
        insert_clock_gating
        set_max_area 0
        compile -map_effort high
        redirect -file [require_env DC_GATING_RPT] {report_clock_gating}
    }
    gated_ultra_area {
        set_clock_gating_style -minimum_bitwidth 64 \
                               -positive_edge_logic {integrated} \
                               -control_point before
        insert_clock_gating
        set_max_area 0
        compile_ultra -gate_clock
        redirect -file [require_env DC_GATING_RPT] {report_clock_gating}
    }
    default {
        error "Unsupported DIP_COMPILE_PROFILE '$dip_compile_profile' (expected plain, ultra, gated_default, gated_area, or gated_ultra_area)"
    }
}

redirect -file [require_env DC_QOR_RPT] {report_qor}
redirect -file [require_env DC_TIMING_RPT] {report_timing}
redirect -file [require_env DC_AREA_RPT] {report_area}
redirect -file [require_env DC_POWER_RPT] {report_power}
redirect -file [require_env DC_VIOLATORS_RPT] {report_constraint -all_violators}

set_fix_multiple_port_nets -all -buffer_constants [current_design]
set_app_var verilogout_no_tri true
change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output [require_env DC_NETLIST]
write_sdf [require_env DC_SDF]
write_file -format ddc -hierarchy -output [require_env DC_DDC]
write_sdc [require_env DC_EXPORTED_SDC]
quit
