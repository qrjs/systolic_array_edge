#!/usr/bin/tclsh
#
# Quick Timing Check Script
#

set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports"

file mkdir $reports_dir

puts "=============================================================================="
puts "Quick Timing Check"
puts "=============================================================================="

create_project -force timing_check "$project_dir/vivado_timing" -part xc7a35tcpg236-1
add_files [glob "$src_dir/*.v"]
add_files -fileset constrs_1 -force [glob "$constraints_dir/*.xdc"]
set_property top systolic_array_4x4 [current_fileset]
update_compile_order -fileset sources_1

puts "\nRunning synthesis..."
synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1

puts "\nRunning optimization..."
opt_design

puts "\nGenerating reports..."
report_timing_summary -max_paths 10 -file "$reports_dir/timing_final_check.txt"
report_utilization -file "$reports_dir/utilization_final_check.txt"
report_power -file "$reports_dir/power_final_check.txt"

set wns [get_property STATS.WNS [get_runs synth_1]]
set tns [get_property STATS.TNS [get_runs synth_1]]
set whs [get_property STATS.WHS [get_runs synth_1]]
set ths [get_property STATS.THS [get_runs synth_1]]

puts "\n=============================================================================="
puts "Timing Results"
puts "=============================================================================="
puts "WNS: $wns ns"
puts "TNS: $tns ns"
puts "WHS: $whs ns"
puts "THS: $ths ns"

if {$wns >= 0 && ![string equal $wns "NA"]} {
    puts "\n✅ TIMING CONSTRAINTS MET!"
    puts "Target frequency: 100 MHz"
} elseif {[string equal $wns "NA"]} {
    puts "\n⚠️  No timing constraints applied or unconstrained design"
} else {
    puts "\n⚠️  Timing constraints not met"
    puts "Estimated max frequency: [expr 1000.0 / (10.0 - $wns)] MHz"
}

write_checkpoint -force "$project_dir/vivado_timing/timing_check.dcp"
close_project

puts "\nReports saved to:"
puts "  - $reports_dir/timing_final_check.txt"
puts "  - $reports_dir/utilization_final_check.txt"
puts "  - $reports_dir/power_final_check.txt"
puts {}

return 0
