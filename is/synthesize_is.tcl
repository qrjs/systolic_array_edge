#==============================================================================
# IS (Input Stationary) 架构 Vivado 综合脚本
#==============================================================================

# 设置项目参数
set project_name "systolic_array_is"
set top_module "systolic_array_is_4x4"
set device_part "xc7a35tcpg236-1"

# 创建输出目录
file mkdir reports

# 创建新项目
create_project $project_name ./vivado/$project_name -part $device_part -force

# 添加源文件（使用绝对路径）
set src_dir [file dirname [info script]]
add_files -norecurse [file join $src_dir src is_pe.v]
add_files -norecurse [file join $src_dir src systolic_array_is_4x4.v]
add_files -norecurse [file join $src_dir src matrix_multiplier_top.v]

# 设置顶层模块
set_property top $top_module [current_fileset]

# 更新编译顺序
update_compile_order -fileset sources_1

# 综合设计
synth_design -top $top_module -part $device_part

# 生成报告
set report_dir [file join $src_dir reports]
report_timing_summary -file [file join $report_dir timing_report.txt] -max_paths 10
report_utilization -file [file join $report_dir utilization_report.txt]
report_power -file [file join $report_dir power_report.txt]

# 保存综合网表
set vivado_dir [file join $src_dir vivado]
write_checkpoint -force [file join $vivado_dir ${project_name}_syn.dcp]

# 写出综合网表（Verilog）
write_verilog -force [file join $vivado_dir ${project_name}_syn.v]

# 写出EDIF网表
write_edif -force [file join $vivado_dir ${project_name}_syn.edf]

# 保存项目
close_project

# 打印完成信息
puts "=================================================="
puts "IS 架构综合完成！"
puts "=================================================="
puts "报告文件："
puts "  - 时序报告: ../reports/timing_report.txt"
puts "  - 资源报告: ../reports/utilization_report.txt"
puts "  - 功耗报告: ../reports/power_report.txt"
puts "综合网表："
puts "  - Verilog:  ../vivado/${project_name}_syn.v"
puts "  - Checkpoint: ../vivado/${project_name}_syn.dcp"
puts "=================================================="
