source [file join $::env(ICC2_ROOT) common.tcl]

set power_net [env_or_die POWER_NET]
set ground_net [env_or_die GROUND_NET]
set ring_layer_h [env_or_default RING_LAYER_H metal8]
set ring_layer_v [env_or_default RING_LAYER_V metal9]
set ring_width [env_or_default RING_WIDTH 2.0]
set ring_spacing [env_or_default RING_SPACING 1.0]
set ring_offset [env_or_default RING_OFFSET 1.0]

flow_log "Running ICC2 power planning"
connect_pg_net -automatic

create_pg_ring_pattern core_ring_pat \
    -horizontal_layer $ring_layer_h \
    -vertical_layer $ring_layer_v \
    -horizontal_width $ring_width \
    -vertical_width $ring_width \
    -horizontal_spacing $ring_spacing \
    -vertical_spacing $ring_spacing

set_pg_strategy core_ring_strat \
    -core \
    -pattern [list [list name core_ring_pat] [list nets [list $power_net $ground_net]] [list offset $ring_offset]]

compile_pg -strategies core_ring_strat

save_stage_block power
