source [file join $::env(ICC2_ROOT) common.tcl]

proc run_stage {stage script_name} {
    flow_log "Starting ICC2 stage: $stage"
    source [file join [env_or_die ICC2_ROOT] $script_name]
    flow_log "Finished ICC2 stage: $stage"
}

set flow_step [env_or_default FLOW_STEP all]

switch -- $flow_step {
    init {
        run_stage init init.tcl
    }
    floorplan {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
    }
    power {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
    }
    place {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
        run_stage place place.tcl
    }
    cts {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
        run_stage place place.tcl
        run_stage cts cts.tcl
    }
    route {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
        run_stage place place.tcl
        run_stage cts cts.tcl
        run_stage route route.tcl
    }
    export {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
        run_stage place place.tcl
        run_stage cts cts.tcl
        run_stage route route.tcl
        run_stage export export.tcl
    }
    all {
        run_stage init init.tcl
        run_stage floorplan floorplan.tcl
        run_stage power power_plan.tcl
        run_stage place place.tcl
        run_stage cts cts.tcl
        run_stage route route.tcl
        run_stage export export.tcl
    }
    default {
        error "Unsupported FLOW_STEP: $flow_step"
    }
}

exit
