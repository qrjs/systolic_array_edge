# Simple DC runset for the teacher-provided I2C synthesis script.

proc parse_filelist {filelist_path project_root} {
    set base_dir [file dirname $filelist_path]
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
            lassign [parse_filelist $nested $project_root] nested_files nested_incdirs
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

set script_dir [file normalize [file dirname [info script]]]
set flow_root [file normalize [file join $script_dir ..]]
set project_root [file normalize [file join $flow_root .. ..]]

set tracked_setup [file join $flow_root config dc_setup.tcl]
if {![file exists $tracked_setup]} {
    error "Missing tracked DC setup file: $tracked_setup"
}
source $tracked_setup

set local_setup [file join $script_dir ".synopsys_dc.setup"]
if {[file exists $local_setup]} {
    puts "Info: sourcing local override $local_setup"
    source $local_setup
}

set design_name [expr {[info exists ::env(I2C_DC_TOP)] ? $::env(I2C_DC_TOP) : "i2c_master_top"}]
set filelist [expr {[info exists ::env(I2C_DC_FILELIST)] ? [file normalize $::env(I2C_DC_FILELIST)] : [file join $flow_root config i2c_master.f]}]
set sdc_file [expr {[info exists ::env(I2C_DC_SDC)] ? [file normalize $::env(I2C_DC_SDC)] : [file join $flow_root constraints mydesign.sdc]}]
set report_dir [file join $flow_root reports]
set result_dir [file join $flow_root results]
set work_dir [file join $flow_root dc work]

file mkdir $report_dir
file mkdir $result_dir
file mkdir $work_dir

if {![file exists $filelist]} {
    error "Missing filelist: $filelist"
}
if {![file exists $sdc_file]} {
    error "Missing SDC file: $sdc_file"
}

lassign [parse_filelist $filelist $project_root] rtl_files incdirs
if {[llength $rtl_files] == 0} {
    error "No RTL files were found in $filelist"
}

set current_search_path [get_app_var search_path]
set_app_var search_path [concat $current_search_path $incdirs]

read_verilog $rtl_files
current_design $design_name
link

if {[llength [info commands read_sdc]] > 0} {
    read_sdc $sdc_file
} else {
    source $sdc_file
}

check_design
compile

redirect -file [file join $report_dir "al_vios.rpt"] {
    report_constraint -all_violators
}

write -format ddc -hierarchy -output [file join $result_dir "mydesign.mapped.ddc"]
write -format verilog -hierarchy -output [file join $result_dir "mydesign.mapped.v"]

quit
