#!/usr/bin/tclsh
#
# Vivado Synthesis Optimization Script
# 功能：综合优化，改善时序
#

set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports"

file mkdir $reports_dir

puts "=============================================================================="
puts "Systolic Array - Synthesis Optimization"
puts "=============================================================================="

# 创建项目
puts "\nCreating project..."
create_project -force systolic_array_opt "$project_dir/vivado_project_opt" -part xc7a35tcpg236-1

# 添加文件
add_files [glob "$src_dir/*.v"]
add_files -fileset constrs_1 -force [glob "$constraints_dir/*.xdc"]
set_property top systolic_array_4x4 [current_fileset]
update_compile_order -fileset sources_1

#==============================================================================
# 综合优化阶段 1: 基本综合
#==============================================================================
puts "\n=============================================================================="
puts "Phase 1: Initial Synthesis"
puts "=============================================================================="

synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1 \
    -fanout_limit 400 \
    -fsm_extraction one_hot \
    -resource_sharing auto \
    -max_bram 0 \
    -max_dsp 16 \
    -keep_equivalent_registers \
    -no_lc \
    -shreg_min_size 5

# 报告初始时序
puts "\nInitial Timing Report:"
report_timing_summary -max_paths 5 -file "$reports_dir/timing_initial.txt"

set wns_initial [get_property STATS.WNS [get_runs synth_1]]
set tns_initial [get_property STATS.TNS [get_runs synth_1]]
puts "Initial WNS: $wns_initial ns"
puts "Initial TNS: $tns_initial ns"

#==============================================================================
# 综合优化阶段 2: 逻辑优化
#==============================================================================
puts "\n=============================================================================="
puts "Phase 2: Logic Optimization"
puts "=============================================================================="

# 运行多次优化尝试
# 尝试 1: 重映射
puts "\nOptimization Attempt 1: Remap"
opt_design -remap -resynth_area

report_timing_summary -max_paths 5 -file "$reports_dir/timing_opt1.txt"
set wns_opt1 [get_property STATS.WNS [get_runs synth_1]]
puts "After remap - WNS: $wns_opt1 ns"

# 尝试 2: 方向性优化
puts "\nOptimization Attempt 2: Directed Optimization"
if {$wns_opt1 < 0} {
    opt_design -sweep \
               -remap \
               -resynth_seq_area \
               -resynth_area

    report_timing_summary -max_paths 5 -file "$reports_dir/timing_opt2.txt"
    set wns_opt2 [get_property STATS.WNS [get_runs synth_1]]
    puts "After directed opt - WNS: $wns_opt2 ns"
}

# 尝试 3: 激进优化
puts "\nOptimization Attempt 3: Aggressive Optimization"
opt_design -directive ExploreWithAreaPostRoute

report_timing_summary -max_paths 5 -file "$reports_dir/timing_opt3.txt"
set wns_opt3 [get_property STATS.WNS [get_runs synth_1]]
puts "After aggressive opt - WNS: $wns_opt3 ns"

#==============================================================================
# 生成最终报告
#==============================================================================
puts "\n=============================================================================="
puts "Generating Final Reports"
puts "=============================================================================="

report_utilization -file "$reports_dir/utilization_optimized.txt"
report_timing_summary -max_paths 20 -file "$reports_dir/timing_final.txt" -report_unconstrained
report_timing -sort_by slack -max_paths 20 -file "$reports_dir/timing_paths.txt"
report_power -file "$reports_dir/power_optimized.txt"
report_drc -file "$reports_dir/drc_optimized.txt"

# 保存检查点
write_checkpoint -force "$project_dir/vivado_project_opt/systolic_array_optimized.dcp"

# 关闭项目
close_project

#==============================================================================
# 显示结果
#==============================================================================
puts "\n=============================================================================="
puts "Optimization Complete!"
puts "=============================================================================="

puts "\nTiming Summary:"
puts "  Initial WNS: $wns_initial ns"
puts "  After remap: $wns_opt1 ns"
puts "  After directed opt: $wns_opt2 ns"
puts "  After aggressive opt: $wns_opt3 ns"

if {$wns_opt3 >= 0} {
    puts "\n✅ TIMING CONSTRAINTS MET!"
    puts "Design meets 100 MHz timing requirement."
} else {
    puts "\n⚠️  Timing constraints not fully met."
    puts "Final WNS: $wns_opt3 ns"
    puts "Estimated max frequency: [expr 1000.0 / (10.0 - $wns_opt3)] MHz"
}

puts "\nReports:"
puts "  - timing_initial.txt"
puts "  - timing_opt1.txt"
puts "  - timing_opt2.txt"
puts "  - timing_opt3.txt"
puts "  - timing_final.txt"
puts "  - timing_paths.txt"
puts "  - utilization_optimized.txt"
puts "  - power_optimized.txt"
puts "  - drc_optimized.txt"
puts {}

return 0
