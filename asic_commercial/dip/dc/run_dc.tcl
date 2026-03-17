# Canonical Synopsys DC runset for the DIP commercial flow.

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
set project_root [env_or_die PROJECT_ROOT]
set filelist [env_or_die FILELIST]
set sdc_file [env_or_die SDC_FILE]
set report_dir [env_or_die REPORT_DIR]
set result_dir [env_or_die RESULT_DIR]
set dc_work_dir [env_or_die DC_WORK_DIR]
set target_library [env_or_die TARGET_LIBRARY]
set link_library [env_or_die LINK_LIBRARY]
set max_cores [expr {[info exists ::env(MAX_CORES)] ? $::env(MAX_CORES) : 8}]
set use_ultra [expr {[info exists ::env(DC_USE_ULTRA)] ? $::env(DC_USE_ULTRA) : 0}]
set svf_file [expr {[info exists ::env(SYNTH_SVF)] ? $::env(SYNTH_SVF) : ""}]

file mkdir $report_dir
file mkdir $result_dir
file mkdir $dc_work_dir

lassign [parse_filelist $filelist] rtl_files incdirs
if {[llength $rtl_files] == 0} {
    error "No RTL files were found in $filelist"
}

define_design_lib WORK -path $dc_work_dir

catch {set_host_options -max_cores $max_cores}
set_app_var search_path [concat [list $project_root] $incdirs]
set_app_var target_library $target_library
set_app_var link_library "* $link_library"
set_app_var hdlin_keep_unconnected_nets true

foreach rtl_file $rtl_files {
    analyze -format verilog $rtl_file
}

elaborate $design_name
current_design $design_name
uniquify
link

redirect -file "$report_dir/${design_name}_dc_check_design_pre.rpt" {
    check_design
}

if {$svf_file ne ""} {
    set_svf $svf_file
}

source $sdc_file
set_fix_multiple_port_nets -all -buffer_constants [get_designs $design_name]

if {$use_ultra eq "1"} {
    compile_ultra
} else {
    compile -map_effort medium
}

change_names -rules verilog -hierarchy

redirect -file "$report_dir/${design_name}_dc_qor.rpt" {
    report_qor
}
redirect -file "$report_dir/${design_name}_dc_area.rpt" {
    report_area -hierarchy
}
redirect -file "$report_dir/${design_name}_dc_timing_setup.rpt" {
    report_timing -delay max -max_paths 10
}
redirect -file "$report_dir/${design_name}_dc_timing_hold.rpt" {
    report_timing -delay min -max_paths 10
}
redirect -file "$report_dir/${design_name}_dc_check_design_post.rpt" {
    check_design
}

write_file -format ddc -hierarchy -output "$result_dir/${design_name}_dc.ddc"
write_file -format verilog -hierarchy -output "$result_dir/${design_name}_dc.v"
write_sdc "$result_dir/${design_name}_dc.sdc"
write_sdf "$result_dir/${design_name}_dc.sdf"

if {$svf_file ne ""} {
    set_svf -off
}

exit
