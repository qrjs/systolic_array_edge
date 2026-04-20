# Edit these paths on the machine that has Synopsys DC and the target library.

if {![info exists flow_root]} {
    set flow_root [file normalize [file join [file dirname [info script]] ..]]
}
if {![info exists project_root]} {
    set project_root [file normalize [file join $flow_root .. ..]]
}

define_design_lib WORK -path [file join $flow_root dc work]

# Add project_root so filelist entries like ftp/i2c_master_top.v resolve cleanly.
set_app_var search_path [list $project_root]

# Replace these placeholders with the real library database files.
set_app_var target_library [list "/path/to/stdcell_typ.db"]
set_app_var link_library "* /path/to/stdcell_typ.db /path/to/io.db /path/to/sram.db"
