#==============================================================================
# Systolic Array Timing Constraints
# 面向边缘计算的 4x4 Systolic 阵列时序约束
# 目标器件: XC7A35TCPG236-1 (Artix-7)
# 目标频率: 100 MHz
#==============================================================================

#==============================================================================
# 时钟定义
#==============================================================================

# 主时钟 - 100 MHz (10ns 周期)
# 说明: 这是设计的主时钟，驱动所有寄存器
create_clock -period 10.000 -name clk [get_ports clk]

# 设置时钟转换时间 (可选，使用默认值)
# set_clock_transition -rise 0.1 [get_clocks clk]
# set_clock_transition -fall 0.1 [get_clocks clk]

# 设置时钟不确定性 (可选，Vivado 会自动计算)
# set_clock_uncertainty 0.5 [get_clocks clk]

#==============================================================================
# 输入延迟约束
#==============================================================================

# 输入数据接口 (16位)
# 假设外部器件在时钟上升沿后 2ns 内输出数据
set_input_delay -clock clk -max 2.000 [get_ports input_in]
set_input_delay -clock clk -min 0.500 [get_ports input_in]

# 输入地址接口
set_input_delay -clock clk -max 2.000 [get_ports input_addr[*]]
set_input_delay -clock clk -min 0.500 [get_ports input_addr[*]]

# 权重输入接口 (16位)
set_input_delay -clock clk -max 2.000 [get_ports weight_in]
set_input_delay -clock clk -min 0.500 [get_ports weight_in]

# 输入有效/控制信号
set_input_delay -clock clk -max 2.000 [get_ports {input_valid weight_valid input_load clk_enable}]
set_input_delay -clock clk -min 0.500 [get_ports {input_valid weight_valid input_load clk_enable}]

# 输出就绪信号
set_input_delay -clock clk -max 2.000 [get_ports {output_ready[*]}]
set_input_delay -clock clk -min 0.500 [get_ports {output_ready[*]}]

# 控制信号
set_input_delay -clock clk -max 2.000 [get_ports {rst_n flush}]
set_input_delay -clock clk -min 0.500 [get_ports {rst_n flush}]

#==============================================================================
# 输出延迟约束
#==============================================================================

# 输出数据接口 (4×32 = 128位，作为 4 个 32 位端口)
# 假设外部器件需要在时钟上升沿前 2ns 接收到数据
set_output_delay -clock clk -max 2.000 [get_ports output_data*]
set_output_delay -clock clk -min 0.500 [get_ports output_data*]

# 输出有效信号
set_output_delay -clock clk -max 2.000 [get_ports {output_valid[*]}]
set_output_delay -clock clk -min 0.500 [get_ports {output_valid[*]}]

# 输入就绪信号
set_output_delay -clock clk -max 2.000 [get_ports {input_ready weight_ready}]
set_output_delay -clock clk -min 0.500 [get_ports {input_ready weight_ready}]

# 忙标志信号
set_output_delay -clock clk -max 2.000 [get_ports busy]
set_output_delay -clock clk -min 0.500 [get_ports busy]

#==============================================================================
# 多周期路径约束 (如果需要)
#==============================================================================

# 如果某些路径需要多个周期完成，可以在这里添加
# 例如:复位信号的传播可能需要多个周期
# set_multicycle_path -setup 2 -from [get_ports rst_n]
# set_multicycle_path -hold 1 -from [get_ports rst_n]

#==============================================================================
# 伪路径约束 (如果需要)
#==============================================================================

# 如果某些路径不需要时序检查，可以标记为伪路径
# 例如:异步复位信号
# set_false_path -from [get_ports rst_n]

#==============================================================================
# IO 标准约束 (可选，用于布局布线)
#==============================================================================

# 设置 IO 标准 (根据实际板卡调整)
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# 设置驱动强度
# set_property DRIVE 12 [get_ports {output_data*}]

# 设置引脚位置 (可选，根据实际板卡定义)
# set_property PACKAGE_PIN W5 [get_ports clk]
# set_property PACKAGE_PIN U18 [get_ports rst_n]

#==============================================================================
# 物理约束 (可选)
#==============================================================================

# 位置约束 - 将 PE 阵列放在特定区域 (可选)
# create_pblock pblock_systolic_array
# resize_pblock pblock_systolic_array -add {SLICE_X0Y0:SLICE_X49Y99}
# add_cells_to_pblock pblock_systolic_array [get_cells -quiet [list systolic_array_4x4]]

# DSP48E1 位置约束 (可选，用于优化性能)
# set_property LOC DSP48E1_X0Y0 [get_cells -hierarchical -filter {PRIMITIVE_TYPE =~ DSP48E1}]

#==============================================================================
# 综合/实现策略
#==============================================================================

# 这些不是 XDC 约束，而是在 TCL 脚本中设置的
# 这里只是记录

# 综合策略: Flow_PerfOptimized_high
# 实现策略: Performance_NetDelay_high

#==============================================================================
# 注释
#==============================================================================
# 1. 时钟周期: 10ns = 100 MHz
# 2. 输入延迟: max 2ns, min 0.5ns (假设外部器件特性)
# 3. 输出延迟: max 2ns, min 0.5ns (假设下游器件要求)
# 4. 建立时间裕量 (setup slack): 应该 > 0
# 5. 保持时间裕量 (hold slack): 应该 > 0
#
# 根据实际板卡和应用场景调整这些值！
#==============================================================================
