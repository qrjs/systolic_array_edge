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

set design_name [require_env DESIGN_NAME]
set repo_root [require_env REPO_ROOT]
set filelist_path [require_env FILELIST]
set rtl_files [resolve_filelist $repo_root $filelist_path]
set target_library_raw [require_env TARGET_LIBRARY]
set link_library_raw [require_env LINK_LIBRARY]

set target_library_list [split $target_library_raw]
set link_library_list [split $link_library_raw]
set_app_var search_path [dirnames_for_paths $target_library_list]
set_app_var target_library $target_library_list
set_app_var link_library $link_library_list
set synopsys_auto_setup true

if {[info exists ::env(DC_SVF)] && $::env(DC_SVF) ne "" && [file exists $::env(DC_SVF)]} {
    set_svf $::env(DC_SVF)
}

set_reference_design -top $design_name $rtl_files
set_implementation_design -top $design_name [require_env FM_IMPL_NETLIST]
match
verify
report_results > [require_env FM_SUMMARY_RPT]
quit
