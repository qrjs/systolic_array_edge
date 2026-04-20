# Backward-compatible wrapper.
# Old usage:
#   DATAFLOW_TYPE=dip RUN_MODE=base dc_shell -f syn.tcl
# New standardized flow:
#   dc_shell -f run.tcl

if {[info exists ::env(DATAFLOW_TYPE)] && ![info exists ::env(ARCH_LIST)]} {
    set ::env(ARCH_LIST) $::env(DATAFLOW_TYPE)
}

if {[info exists ::env(REPORT_TAG)] && ![info exists ::env(RUN_TAG)]} {
    set ::env(RUN_TAG) $::env(REPORT_TAG)
}

source [file join [file dirname [info script]] run.tcl]
