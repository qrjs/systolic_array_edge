#==============================================================================
# DIP Systolic Array Timing Constraints
# Target part: XC7A35T-1
# Target frequency: 100MHz
#==============================================================================

create_clock -period 10.000 -name clk [get_ports clk]

# Input delays
set_input_delay -clock clk -max 2.000 [get_ports input_row_data*]
set_input_delay -clock clk -min 0.500 [get_ports input_row_data*]

set_input_delay -clock clk -max 2.000 [get_ports weight_row_data*]
# OOC core-only 后端中，权重广播口直接驱动首级寄存器，给出稍微更保守的最小外部到达时间，
# 避免把板级/上游发射寄存器延迟全部理想化为 0ns，导致不必要的输入 hold 违例。
set_input_delay -clock clk -min 0.600 [get_ports weight_row_data*]

set_input_delay -clock clk -max 2.000 [get_ports {input_row_valid weight_row_valid clk_enable flush rst_n}]
set_input_delay -clock clk -min 0.500 [get_ports {input_row_valid weight_row_valid clk_enable flush rst_n}]

set_input_delay -clock clk -max 2.000 [get_ports weight_row_idx*]
set_input_delay -clock clk -min 0.500 [get_ports weight_row_idx*]

# Output delays
set_output_delay -clock clk -max 2.000 [get_ports output_row_data*]
set_output_delay -clock clk -min 0.500 [get_ports output_row_data*]

set_output_delay -clock clk -max 2.000 [get_ports {output_row_valid busy}]
set_output_delay -clock clk -min 0.500 [get_ports {output_row_valid busy}]
