#!/usr/bin/tclsh
#
# Vivado implementation script (non-project flow) for IS array.
#

set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports/impl"
set part_name "xc7a35tcpg236-1"
set top_name "systolic_array_is_4x4"

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
# 采用 out-of-context 模式执行 core-only 后端，实现阶段不再受验证顶层 I/O 数量限制，
# 便于获得阵列核心本身的 post-route 时序。
synth_design -mode out_of_context -top $top_name -part $part_name -flatten_hierarchy rebuilt -fsm_extraction one_hot -resource_sharing auto -retiming
opt_design -directive Explore

puts "\n=============================================================================="
puts "Running Placement..."
puts "=============================================================================="
place_design -directive Explore
phys_opt_design -directive ExploreWithHoldFix
report_timing_summary -file "$reports_dir/timing_post_place.txt" -max_paths 20 -report_unconstrained

puts "\n=============================================================================="
puts "Running Routing..."
puts "=============================================================================="
route_design -directive Explore
phys_opt_design -directive ExploreWithHoldFix
report_timing_summary -file "$reports_dir/timing_post_route.txt" -max_paths 20 -report_unconstrained
report_timing -sort_by slack -max_paths 20 -input_pins -file "$reports_dir/timing_details_post_route.txt"

puts "\n=============================================================================="
puts "Generating Reports..."
puts "=============================================================================="
report_utilization -file "$reports_dir/utilization_report.txt"
report_clock_interaction -file "$reports_dir/clock_interaction.txt"
report_power -file "$reports_dir/power_report.txt"
report_drc -file "$reports_dir/drc.txt"

write_checkpoint -force "$reports_dir/is_impl.dcp"
write_verilog -force "$reports_dir/is_impl.v"

puts "\n=============================================================================="
puts "Implementation Complete!"
puts "=============================================================================="
puts "\nReports generated in: $reports_dir"

return 0
