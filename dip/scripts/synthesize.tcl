#!/usr/bin/tclsh
#
# Vivado synthesis script (non-project flow) for DIP array.
#

set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports/synth"
set part_name "xc7a35tcpg236-1"
set top_name "systolic_array_dip_4x4"

file mkdir $reports_dir
file delete -force "$reports_dir/.Xil"

puts "Reading RTL sources..."
set rtl_files [glob -nocomplain "$src_dir/*.v" "$src_dir/*.sv"]
if {[llength $rtl_files] == 0} {
    error "No RTL sources found under $src_dir"
}
read_verilog -sv $rtl_files

set xdc_files [glob -nocomplain "$constraints_dir/*.xdc"]
if {[llength $xdc_files] > 0} {
    puts "Reading XDC constraints..."
    read_xdc $xdc_files
} else {
    puts "No XDC constraints found under $constraints_dir"
}

puts "\n=============================================================================="
puts "Running Synthesis..."
puts "=============================================================================="
synth_design -top $top_name -part $part_name -flatten_hierarchy rebuilt -fsm_extraction one_hot -resource_sharing auto -retiming
opt_design -directive Explore

puts "\n=============================================================================="
puts "Generating Reports..."
puts "=============================================================================="
report_utilization -file "$reports_dir/utilization_report.txt"
report_timing_summary -file "$reports_dir/timing_report.txt" -max_paths 20 -report_unconstrained
report_clock_interaction -file "$reports_dir/clock_interaction.txt"
report_power -file "$reports_dir/power_report.txt"
report_drc -file "$reports_dir/drc.txt"

write_checkpoint -force "$reports_dir/dip_synth.dcp"
write_verilog -force "$reports_dir/dip_syn.v"

puts "\n=============================================================================="
puts "Synthesis Complete!"
puts "=============================================================================="
puts "\nReports generated in: $reports_dir"

return 0
