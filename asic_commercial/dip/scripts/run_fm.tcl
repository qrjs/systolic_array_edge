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

set design_name [require_env DESIGN_NAME]
set repo_root [require_env REPO_ROOT]
set filelist_path [require_env FILELIST]
set rtl_files [resolve_filelist $repo_root $filelist_path]

set_reference_design -top $design_name $rtl_files
set_implementation_design -top $design_name [require_env FM_IMPL_NETLIST]
match
verify
report_results > [require_env FM_SUMMARY_RPT]
quit

