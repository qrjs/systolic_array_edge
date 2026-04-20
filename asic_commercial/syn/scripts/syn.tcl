# ====================================================================
# 脉动阵列 (Systolic Array) 极限优化综合脚本
# 目标：1GHz 频率冲刺 + 时钟门控低功耗优化
# 适用工艺：TSMC 90nm (slow.db)
# ====================================================================

# 1. 核心参数设置
set DATAFLOW_TYPE "dip"
set TOP_MODULE    "standard_dip_array_4x4"

# 2. 目录路径与环境清理
set RTL_DIR     "../../${DATAFLOW_TYPE}/src"
set REPORT_DIR  "./reports"
set MAPPED_DIR  "./mapped"

# 清除缓存，确保从零开始
remove_design -all

# ====================================================================
# 3. 读入 RTL 代码
# ====================================================================
puts ">>> 阶段 1: 正在读取 Verilog 源码..."

set rtl_files [glob -nocomplain ${RTL_DIR}/*.v]
if {[llength $rtl_files] == 0} {
    puts "Error: 在 ${RTL_DIR} 找不到任何 .v 文件！"
    exit
}

analyze -format verilog $rtl_files
elaborate $TOP_MODULE
current_design $TOP_MODULE

# 链接库并进行基础设计检查
link
check_design > ${REPORT_DIR}/${DATAFLOW_TYPE}_check_design.rpt

# ====================================================================
# 4. 极致时序与环境约束
# ====================================================================
puts ">>> 阶段 2: 施加极限约束 (Targeting 1GHz)..."

# 设定 1.0ns (1GHz) 目标，对于 90nm 这是“压力测试”级别
set CLK_NAME   "clk"
set CLK_PERIOD 1.0

create_clock -name $CLK_NAME -period $CLK_PERIOD [get_ports $CLK_NAME]
set_ideal_network [get_ports $CLK_NAME]
set_dont_touch_network [get_ports $CLK_NAME]

# 设定 I/O 延迟为周期的 20%
set IN_DELAY  [expr $CLK_PERIOD * 0.2]
set OUT_DELAY [expr $CLK_PERIOD * 0.2]
set_input_delay  $IN_DELAY  -clock $CLK_NAME [remove_from_collection [all_inputs] [get_ports $CLK_NAME]]
set_output_delay $OUT_DELAY -clock $CLK_NAME [all_outputs]

# 负载约束
set_load 0.05 [all_outputs]

# ====================================================================
# 5. 执行逻辑综合 (核心优化开关)
# ====================================================================
puts ">>> 阶段 3: 开始极致综合优化..."

# --- [优化 A] 时钟门控 (Clock Gating) ---
# 自动在位宽 >= 4 的寄存器处插入门控单元，大幅降低翻转功耗
set_clock_gating_style -minimum_bitwidth 4 \
                       -positive_edge_logic {integrated} \
                       -control_point before
insert_clock_gating

# --- [优化 B] 寄存器重定向 (Retiming) ---
# 允许工具为了修时序而跨组合逻辑移动寄存器位置
set_optimize_registers true

# --- [优化 C] 面积清零 ---
# 告诉工具：只要能跑快，哪怕面积炸了也无所谓
set_max_area 0

# --- [执行] 启动高强度综合 ---
compile_ultra -gate_clock -retime -timing_high_effort_script

# ====================================================================
# 6. 生成报告与导出网表
# ====================================================================
puts ">>> 阶段 4: 正在导出报告..."

report_timing > ${REPORT_DIR}/${DATAFLOW_TYPE}_1ghz_timing.rpt
report_area   > ${REPORT_DIR}/${DATAFLOW_TYPE}_1ghz_area.rpt
report_power  > ${REPORT_DIR}/${DATAFLOW_TYPE}_1ghz_power.rpt
report_clock_gating > ${REPORT_DIR}/${DATAFLOW_TYPE}_gating_check.rpt
report_constraint -all_violators > ${REPORT_DIR}/${DATAFLOW_TYPE}_1ghz_violators.rpt

# 导出网表供后续使用
change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output ${MAPPED_DIR}/${DATAFLOW_TYPE}_1ghz_netlist.v
write_sdc ${MAPPED_DIR}/${DATAFLOW_TYPE}_1ghz_constraints.sdc

puts "===================================================================="
puts "  极限综合任务完成！请检查 ${REPORT_DIR} 确认 Slack 数值。"
puts "===================================================================="
exit
