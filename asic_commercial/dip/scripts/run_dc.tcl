proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
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
    compile_ultra
} else {
    compile
}

redirect -file [require_env DC_QOR_RPT] {report_qor}
redirect -file [require_env DC_TIMING_RPT] {report_timing}
redirect -file [require_env DC_AREA_RPT] {report_area}
redirect -file [require_env DC_POWER_RPT] {report_power}
redirect -file [require_env DC_VIOLATORS_RPT] {report_constraint -all_violators}

change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output [require_env DC_NETLIST]
write_sdf [require_env DC_SDF]
write_file -format ddc -hierarchy -output [require_env DC_DDC]
write_sdc [require_env DC_EXPORTED_SDC]
quit

