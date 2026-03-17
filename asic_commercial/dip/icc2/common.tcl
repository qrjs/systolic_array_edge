proc env_or_die {name} {
    if {![info exists ::env($name)] || [string trim $::env($name)] eq ""} {
        error "Missing required environment variable: $name"
    }
    return $::env($name)
}

proc env_or_default {name default_value} {
    if {![info exists ::env($name)] || [string trim $::env($name)] eq ""} {
        return $default_value
    }
    return $::env($name)
}

proc flow_log {message} {
    puts "[clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}] $message"
}

proc report_path {stage suffix} {
    file mkdir [env_or_die ICC2_REPORT_DIR]
    return [file join [env_or_die ICC2_REPORT_DIR] "${stage}_${suffix}.rpt"]
}

proc stage_block_name {stage} {
    return "[env_or_die DESIGN_NAME]/$stage"
}

proc save_stage_block {stage} {
    save_block -as [stage_block_name $stage]
    flow_log "Saved block [stage_block_name $stage]"
}
