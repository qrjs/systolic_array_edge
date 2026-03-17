# Compatibility wrapper.
# The canonical DC runset now lives in `dc/run_dc.tcl`.

if {![info exists ::env(DIP_ROOT)]} {
    error "Please source scripts/prepare_env.sh before launching DC."
}

source [file join $::env(DIP_ROOT) dc run_dc.tcl]
