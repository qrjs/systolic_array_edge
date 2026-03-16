#!/usr/bin/tclsh
#
# Vivado Synthesis Script for Systolic Array
# 功能：综合Systolic阵列设计，生成资源使用报告
#

# 设置项目路径
set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports/synth"

# 创建报告目录
file mkdir $reports_dir

# 创建新项目
puts "Creating Vivado project..."
create_project -force systolic_array "$project_dir/vivado_project" -part xc7a35tcpg236-1

# 添加源文件
puts "\nAdding source files..."
add_files [glob "$src_dir/*.v"]

# 添加约束文件
puts "\nAdding constraint files..."
add_files -fileset constrs_1 -force [glob "$constraints_dir/*.xdc"]

# 设置顶层模块
set_property top systolic_array_4x4 [current_fileset]

# 更新编译顺序
update_compile_order -fileset sources_1
puts "Source files added successfully"

# 运行综合
puts "\n=============================================================================="
puts "Running Synthesis..."
puts "=============================================================================="

# 设置综合策略：性能优化
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]

# 执行综合
synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1 -fanout_limit 400 -fsm_extraction one_hot -resource_sharing auto -max_bram -1 -max_dsp -1

# 生成综合报告
puts "\n=============================================================================="
puts "Generating Reports..."
puts "=============================================================================="

# 资源使用报告
puts "\n1. Resource Utilization Report..."
report_utilization -file "$reports_dir/utilization_report.txt"

# 时序报告
puts "\n2. Timing Report..."
report_timing_summary -file "$reports_dir/timing_report.txt" -max_paths 10 -report_unconstrained

# 时钟交互报告
puts "\n3. Clock Interaction Report..."
report_clock_interaction -file "$reports_dir/clock_interaction.txt"

# 功耗报告
puts "\n4. Power Report..."
report_power -file "$reports_dir/power_report.txt"

# DRC 报告
puts "\n5. DRC Report..."
report_drc -file "$reports_dir/drc.txt"

# 保存设计检查点
puts "\nSaving checkpoint..."
write_checkpoint -force "$project_dir/vivado_project/systolic_array_synth.dcp"

# 生成综合后的网表
puts "Writing netlist..."
write_verilog -force "$project_dir/vivado_project/systolic_array_syn.v"

# 关闭项目
puts "\nClosing project..."
close_project

puts "\n=============================================================================="
puts "Synthesis Complete!"
puts "=============================================================================="
puts "\nReports generated in: $reports_dir"
puts "  - utilization_report.txt"
puts "  - timing_report.txt"
puts "  - power_report.txt"
puts {}

return 0
