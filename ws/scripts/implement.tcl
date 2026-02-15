#!/usr/bin/tclsh
#
# Vivado Implementation Script for Systolic Array
# 功能：运行布局布线，优化时序
#

# 设置项目路径
set project_dir [file dirname [file dirname [info script]]]
set src_dir "$project_dir/src"
set constraints_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports"

# 创建报告目录
file mkdir $reports_dir

puts "=============================================================================="
puts "Systolic Array - Implementation"
puts "=============================================================================="

# 创建新项目
puts "\nCreating Vivado project..."
create_project -force systolic_array_impl "$project_dir/vivado_project_impl" -part xc7a35tcpg236-1

# 添加源文件
puts "\nAdding source files..."
add_files [glob "$src_dir/*.v"]

# 添加约束文件
puts "\nAdding constraint files..."
add_files -fileset constrs_1 -force [glob "$constraints_dir/*.xdc"]

# 设置顶层模块
set_property top systolic_array_4x4 [current_fileset]
update_compile_order -fileset sources_1

#==============================================================================
# 综合阶段
#==============================================================================
puts "\n=============================================================================="
puts "Running Synthesis..."
puts "=============================================================================="

# 设置综合策略
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]

# 执行综合
synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1 \
    -fanout_limit 400 \
    -fsm_extraction one_hot \
    -resource_sharing auto \
    -max_bram -1 \
    -max_dsp -1 \
    -keep_equivalent_registers \
    -no_lc

puts "\nSynthesis complete!"

#==============================================================================
# 综合后优化
#==============================================================================
puts "\n=============================================================================="
puts "Running Post-Synthesis Optimization..."
puts "=============================================================================="

# 运行逻辑优化
opt_design -remap -resynth_area

puts "Post-synthesis optimization complete!"

#==============================================================================
# 布局阶段
#==============================================================================
puts "\n=============================================================================="
puts "Running Placement..."
puts "=============================================================================="

# 设置布局策略
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

# 运行布局
place_design -directive Explore

# 生成预布局时序报告
puts "\nGenerating post-placement timing report..."
report_timing_summary -file "$reports_dir/timing_post_place.txt" -max_paths 10

puts "Placement complete!"

#==============================================================================
# 布局后优化
#==============================================================================
puts "\n=============================================================================="
puts "Running Post-Placement PhysOpt..."
puts "=============================================================================="

# 物理优化 - 修复时序
phys_opt_design -directive ExploreWithHoldFix
phys_opt_design -directive AggressiveExplore

# 再次运行优化
phys_opt_design -directive AlternateRetimeing

puts "Post-placement optimization complete!"

#==============================================================================
# 布线阶段
#==============================================================================
puts "\n=============================================================================="
puts "Running Routing..."
puts "=============================================================================="

# 运行布线
route_design -directive Explore

# 生成预布线时序报告
puts "\nGenerating post-route timing report..."
report_timing_summary -file "$reports_dir/timing_post_route.txt" -max_paths 10

puts "Routing complete!"

#==============================================================================
# 布线后优化
#==============================================================================
puts "\n=============================================================================="
puts "Running Post-Route PhysOpt..."
puts "=============================================================================="

# 如果时序未满足，再次优化
set wns [get_property STATS.WNS [get_runs impl_1]]
if {$wns < 0} {
    puts "WNS is $wns, running post-route optimization..."

    # 布线后物理优化
    phys_opt_design -directive ExploreWithHoldFix

    # 重新布线关键路径
    route_design -unroute -nets [get_nets -hier -filter {SLACK_MET < 0}]
    route_design -directive AggressiveExplore

    puts "Post-route optimization complete!"
}

#==============================================================================
# 最终报告生成
#==============================================================================
puts "\n=============================================================================="
puts "Generating Final Reports..."
puts "=============================================================================="

# 时序报告
puts "\n1. Final Timing Report..."
report_timing_summary -file "$reports_dir/timing_final.txt" -max_paths 20 -report_unconstrained

# 时序细节报告
puts "\n2. Timing Details Report..."
report_timing -sort_by slack -max_paths 20 -input_pins -file "$reports_dir/timing_details.txt"

# 资源报告
puts "\n3. Utilization Report..."
report_utilization -file "$reports_dir/utilization_final.txt" -hierarchical

# 功耗报告
puts "\n4. Power Report..."
report_power -file "$reports_dir/power_final.txt"

# DRC 报告
puts "\n5. DRC Report..."
report_drc -file "$reports_dir/drc_final.txt"

# 时钟交互报告
puts "\n6. Clock Interaction Report..."
report_clock_interaction -file "$reports_dir/clock_interaction_final.txt"

# 保存检查点
puts "\nSaving checkpoint..."
write_checkpoint -force "$project_dir/vivado_project_impl/systolic_array_routed.dcp"

# 生成比特流（可选）
puts "\nGenerating bitstream..."
write_bitstream -force "$project_dir/vivado_project_impl/systolic_array.bit"

# 关闭项目
puts "\nClosing project..."
close_project

#==============================================================================
# 显示结果
#==============================================================================
puts "\n=============================================================================="
puts "Implementation Complete!"
puts "=============================================================================="

# 读取最终时序数据
set fp [open "$reports_dir/timing_final.txt" r]
set content [read $fp]
close $fp

# 提取 WNS
if {[regexp {WNS.*?\s+(-?\d+\.\d+)} $content match wns]} {
    puts "\nFinal WNS: $wns ns"
    if {$wns >= 0} {
        puts "✅ TIMING CONSTRAINTS MET!"
    } else {
        puts "⚠️  Timing constraints not met. WNS = $wns ns"
    }
}

puts "\nReports generated in: $reports_dir"
puts "  - timing_final.txt"
puts "  - timing_details.txt"
puts "  - utilization_final.txt"
puts "  - power_final.txt"
puts "  - drc_final.txt"
puts "  - clock_interaction_final.txt"
puts {}

return 0
