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

proc dirnames_for_paths {paths} {
    set out {}
    foreach path $paths {
        if {$path eq "*"} {
            continue
        }
        set dir [file dirname $path]
        if {[lsearch -exact $out $dir] < 0} {
            lappend out $dir
        }
    }
    return $out
}

proc existing_files_only {paths} {
    set out {}
    foreach path $paths {
        if {$path eq "*" || $path eq ""} {
            continue
        }
        if {[file exists $path] && [lsearch -exact $out $path] < 0} {
            lappend out $path
        }
    }
    return $out
}

proc read_verilog_files {container files args} {
    foreach file $files {
        if {![file exists $file]} {
            error "Verilog file not found: $file"
        }
    }
    if {![read_verilog -container $container -libname WORK {*}$args $files]} {
        error "read_verilog failed for container '$container'"
    }
}

set design_name [require_env DESIGN_NAME]
set repo_root [require_env REPO_ROOT]
set filelist_path [require_env FILELIST]
set rtl_files [resolve_filelist $repo_root $filelist_path]
set target_library_raw [require_env TARGET_LIBRARY]
set link_library_raw [require_env LINK_LIBRARY]
set impl_netlist [require_env FM_IMPL_NETLIST]

set target_library_list [split $target_library_raw]
set link_library_list [split $link_library_raw]
set library_files [existing_files_only [concat $target_library_list $link_library_list]]
set search_paths [dirnames_for_paths [concat $library_files $rtl_files [list $impl_netlist]]]
set_app_var search_path $search_paths
set synopsys_auto_setup true

puts "Formality setup:"
puts "  design_name   = $design_name"
puts "  rtl_files     = $rtl_files"
puts "  impl_netlist  = $impl_netlist"
puts "  library_files = $library_files"
if {[info exists ::env(FM_SVF)] && $::env(FM_SVF) ne "" && [file exists $::env(FM_SVF)]} {
    puts "  svf           = $::env(FM_SVF)"
    set_svf $::env(FM_SVF)
} else {
    puts "  svf           = <none>"
}

if {[llength $library_files] > 0} {
    if {![read_db {*}$library_files]} {
        error "read_db failed"
    }
}

read_verilog_files r $rtl_files
if {![set_top r:/WORK/$design_name]} {
    error "set_top failed for reference design '$design_name'"
}
set_reference_design r:/WORK/$design_name

read_verilog_files i [list $impl_netlist] -netlist
if {![set_top i:/WORK/$design_name]} {
    error "set_top failed for implementation design '$design_name'"
}
set_implementation_design i:/WORK/$design_name

if {![match]} {
    report_unmatched_points
    redirect -file [require_env FM_SUMMARY_RPT] {report_status -short}
    error "Formality match failed"
}
set verify_status [verify]
redirect -file [require_env FM_SUMMARY_RPT] {report_status -short}
if {!$verify_status} {
    report_failing_points
    report_aborted_points
    error "Formality verify failed"
}
quit
