proc require_env {name} {
    if {![info exists ::env($name)] || $::env($name) eq ""} {
        error "Missing environment variable '$name'"
    }
    return $::env($name)
}

proc env_or_default {name default_value} {
    if {[info exists ::env($name)] && $::env($name) ne ""} {
        return $::env($name)
    }
    return $default_value
}

proc try_gui_cmd {args} {
    if {[catch {uplevel #0 $args} err]} {
        puts "WARN: GUI command '$args' failed: $err"
    }
}

set design_name [require_env DESIGN_NAME]
set checkpoint [env_or_default INNOVUS_VIEW_CHECKPOINT "${::env(INNOVUS_CHECKPOINT_PREFIX)}_route.enc.dat"]

if {![file exists $checkpoint]} {
    error "Innovus checkpoint not found: $checkpoint"
}

puts "Restoring Innovus layout:"
puts "  design     = $design_name"
puts "  checkpoint = $checkpoint"

restoreDesign $checkpoint $design_name

try_gui_cmd win on
try_gui_cmd gui_open_cell_view
try_gui_cmd setDrawView place
try_gui_cmd fit
try_gui_cmd redraw

puts "Layout is loaded. Use the GUI layer panel to toggle M1/M2/.../VDD/VSS visibility."
