#==============================================================================
# Vivado TCL Script: Compare All Three Dataflow Architectures
# 功能：综合并对比 WS, IS, OS 三种数据流设计
#==============================================================================

# 设置项目路径
set project_dir ".."
set src_dir "$project_dir/src"
const constr_dir "$project_dir/constraints"
set reports_dir "$project_dir/reports"

# 创建报告目录
file mkdir $reports_dir

#==============================================================================
# WS (Weights Stationary) 综合
#==============================================================================
puts "\n========================================"
puts "Synthesizing WS (Weights Stationary)"
puts "========================================"

# 读取设计文件
read_verilog [list \
    "$src_dir/pe.v" \
    "$src_dir/systolic_array_4x4.v" \
]

# 读取约束文件
read_xdc "$constr_dir/systolic_array.xdc"

# 综合
synth_design -top systolic_array_4x4 -part xc7a35tcpg236-1

# 优化
opt_design

# 布局布线
place_design
route_design

# 生成报告
report_timing_summary -file $reports_dir/timing_ws_summary.rpt
report_utilization -file $reports_dir/utilization_ws.rpt
report_power -file $reports_dir/power_ws.rpt

# 提取关键指标
set ws_wns [get_property STATS.WNS [get_runs impl_1]]
set ws_tns [get_property STATS.TNS [get_runs impl_1]]
set ws_whs [get_property STATS.WHS [get_runs impl_1]]
set_ws_ths [get_property STATS.THS [get_runs impl_1]]

puts "WS Timing: WNS=$ws_wns, TNS=$ws_tns"

# 保存检查点
write_checkpoint -force $reports_dir/ws_checkpoint.dcp

# 关闭当前设计
close_project

#==============================================================================
# IS (Input Stationary) 综合
#==============================================================================
puts "\n========================================"
puts "Synthesizing IS (Input Stationary)"
puts "========================================"

# 读取设计文件
read_verilog [list \
    "$src_dir/is_pe.v" \
    "$src_dir/systolic_array_is_4x4.v" \
]

# 读取约束文件
read_xdc "$constr_dir/systolic_array.xdc"

# 综合
synth_design -top systolic_array_is_4x4 -part xc7a35tcpg236-1

# 优化
opt_design

# 布局布线
place_design
route_design

# 生成报告
report_timing_summary -file $reports_dir/timing_is_summary.rpt
report_utilization -file $reports_dir/utilization_is.rpt
report_power -file $reports_dir/power_is.rpt

# 提取关键指标
set is_wns [get_property STATS.WNS [get_runs impl_1]]
set is_tns [get_property STATS.TNS [get_runs impl_1]]
set is_whs [get_property STATS.WHS [get_runs impl_1]]
set is_ths [get_property STATS.THS [get_runs impl_1]]

puts "IS Timing: WNS=$is_wns, TNS=$is_tns"

# 保存检查点
write_checkpoint -force $reports_dir/is_checkpoint.dcp

# 关闭当前设计
close_project

#==============================================================================
# OS (Output Stationary) 综合
#==============================================================================
puts "\n========================================"
puts "Synthesizing OS (Output Stationary)"
puts "========================================"

# 读取设计文件
read_verilog [list \
    "$src_dir/os_pe.v" \
    "$src_dir/systolic_array_os_4x4.v" \
]

# 读取约束文件
read_xdc "$constr_dir/systolic_array.xdc"

# 综合
synth_design -top systolic_array_os_4x4 -part xc7a35tcpg236-1

# 优化
opt_design

# 布局布线
place_design
route_design

# 生成报告
report_timing_summary -file $reports_dir/timing_os_summary.rpt
report_utilization -file $reports_dir/utilization_os.rpt
report_power -file $reports_dir/power_os.rpt

# 提取关键指标
set os_wns [get_property STATS.WNS [get_runs impl_1]]
set os_tns [get_property STATS.TNS [get_runs impl_1]]
set os_whs [get_property STATS.WHS [get_runs impl_1]]
set os_ths [get_property STATS.THS [get_runs impl_1]]

puts "OS Timing: WNS=$os_wns, TNS=$os_tns"

# 保存检查点
write_checkpoint -force $reports_dir/os_checkpoint.dcp

# 关闭当前设计
close_project

#==============================================================================
# 生成对比报告
#==============================================================================
puts "\n========================================"
puts "Dataflow Comparison Summary"
puts "========================================"

puts "\nTiming Summary:"
puts "=========================================="
puts [format "%-10s %-10s %-10s %-10s" "Design" "WNS (ns)" "TNS (ns)" "Status"]
puts [format "%-10s %-10s %-10s %-10s" "WS" "$ws_wns" "$ws_tns" [expr {$ws_wns >= 0 ? "PASS" : "FAIL"}]]
puts [format "%-10s %-10s %-10s %-10s" "IS" "$is_wns" "$is_tns" [expr {$is_wns >= 0 ? "PASS" : "FAIL"}]]
puts [format "%-10s %-10s %-10s %-10s" "OS" "$os_wns" "$os_tns" [expr {$os_wns >= 0 ? "PASS" : "FAIL"}]]

puts "\nReports generated in: $reports_dir"
puts "========================================"

#==============================================================================
# 完成提示
#==============================================================================
puts "\n✅ All three dataflow architectures synthesized!"
puts "📊 Reports saved to: $reports_dir"
puts "🐍 Run 'python script/performance_comparison.py' to parse and visualize results"
puts "========================================\n"
