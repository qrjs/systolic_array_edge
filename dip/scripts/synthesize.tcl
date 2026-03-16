#!/usr/bin/tclsh
#
# Vivado synthesis script for the standalone DiP systolic array.
#

set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports/synth"
set vivado_project_dir "$project_dir/vivado_project"
set part_name "xc7a35tcpg236-1"

file mkdir $reports_dir

puts "Creating Vivado project..."
create_project -force dip_systolic_array $vivado_project_dir -part $part_name

puts "\nAdding source files..."
add_files [glob "$src_dir/*.v"]

set xdc_files [glob -nocomplain "$constraints_dir/*.xdc"]
if {[llength $xdc_files] > 0} {
    puts "\nAdding constraint files..."
    add_files -fileset constrs_1 -force $xdc_files
} else {
    puts "\nNo XDC constraints found, synthesizing without timing constraints..."
}

set_property top systolic_array_dip_4x4 [current_fileset]
update_compile_order -fileset sources_1

puts "\n=============================================================================="
puts "Running Synthesis..."
puts "=============================================================================="

set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
synth_design -top systolic_array_dip_4x4 -part $part_name -fanout_limit 400 -resource_sharing auto

puts "\n=============================================================================="
puts "Generating Reports..."
puts "=============================================================================="

report_utilization -file "$reports_dir/utilization_report.txt"
report_timing_summary -file "$reports_dir/timing_report.txt" -max_paths 10 -report_unconstrained
report_clock_interaction -file "$reports_dir/clock_interaction.txt"
report_power -file "$reports_dir/power_report.txt"
report_drc -file "$reports_dir/drc.txt"

write_checkpoint -force "$vivado_project_dir/dip_synth.dcp"
write_verilog -force "$vivado_project_dir/dip_syn.v"

close_project

puts "\n=============================================================================="
puts "Synthesis Complete!"
puts "=============================================================================="
puts "\nReports generated in: $reports_dir"

return 0
