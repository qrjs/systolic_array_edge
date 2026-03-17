# Canonical Formality runset for the DIP commercial flow.

proc env_or_die {name} {
    if {![info exists ::env($name)] || [string trim $::env($name)] eq ""} {
        error "Missing required environment variable: $name"
    }
    return $::env($name)
}

proc parse_filelist {filelist_path} {
    set base_dir [file dirname $filelist_path]
    set project_root [env_or_die PROJECT_ROOT]
    set rtl_files [list]
    set incdirs [list]

    set fh [open $filelist_path r]
    while {[gets $fh line] >= 0} {
        set line [string trim $line]
        if {$line eq ""} {
            continue
        }
        if {[string match "#*" $line] || [string match "//*" $line]} {
            continue
        }
        if {[string match "+incdir+*" $line]} {
            set incdir [string range $line 8 end]
            if {[file pathtype $incdir] ne "absolute"} {
                set project_candidate [file normalize [file join $project_root $incdir]]
                set filelist_candidate [file normalize [file join $base_dir $incdir]]
                if {[file exists $project_candidate]} {
                    set incdir $project_candidate
                } else {
                    set incdir $filelist_candidate
                }
            }
            lappend incdirs $incdir
            continue
        }
        if {[string match "-f *" $line]} {
            set nested [string trim [string range $line 2 end]]
            if {[file pathtype $nested] ne "absolute"} {
                set project_candidate [file normalize [file join $project_root $nested]]
                set filelist_candidate [file normalize [file join $base_dir $nested]]
                if {[file exists $project_candidate]} {
                    set nested $project_candidate
                } else {
                    set nested $filelist_candidate
                }
            }
            lassign [parse_filelist $nested] nested_files nested_incdirs
            set rtl_files [concat $rtl_files $nested_files]
            set incdirs [concat $incdirs $nested_incdirs]
            continue
        }
        if {[string match "-v *" $line]} {
            set line [string trim [string range $line 2 end]]
        }
        if {[file pathtype $line] ne "absolute"} {
            set project_candidate [file normalize [file join $project_root $line]]
            set filelist_candidate [file normalize [file join $base_dir $line]]
            if {[file exists $project_candidate]} {
                set line $project_candidate
            } else {
                set line $filelist_candidate
            }
        }
        lappend rtl_files $line
    }
    close $fh
    return [list $rtl_files $incdirs]
}

set design_name [env_or_die DESIGN_NAME]
set filelist [env_or_die FILELIST]
set target_library [env_or_die TARGET_LIBRARY]
set link_library [env_or_die LINK_LIBRARY]
set svf_file [env_or_die SYNTH_SVF]
set impl_netlist [env_or_die FM_IMPLEMENTATION_NETLIST]
set report_dir [env_or_die FM_REPORT_DIR]
set project_root [env_or_die PROJECT_ROOT]

file mkdir $report_dir

lassign [parse_filelist $filelist] rtl_files incdirs

set_app_var synopsys_auto_setup true
set_app_var search_path [concat [list $project_root] $incdirs]
set_app_var target_library $target_library
set_app_var link_library "* $link_library"

set_svf $svf_file

foreach rtl_file $rtl_files {
    read_verilog -container r $rtl_file
}
set_top r:/WORK/$design_name

read_verilog -container i $impl_netlist
set_top i:/WORK/$design_name

match
verify

redirect -file "$report_dir/${design_name}_fm_verification.rpt" {
    report_verification
}
redirect -file "$report_dir/${design_name}_fm_unmatched.rpt" {
    report_unmatched_points
}
redirect -file "$report_dir/${design_name}_fm_failing.rpt" {
    report_failing_points
}

exit
