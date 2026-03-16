create_clock -name clk -period 10.000 [get_ports clk]
set_clock_uncertainty 0.100 [get_clocks clk]

set_input_delay -clock clk -max 2.000 [get_ports input_row_data*]
set_input_delay -clock clk -min 0.500 [get_ports input_row_data*]
set_input_delay -clock clk -max 2.000 [get_ports weight_row_data*]
set_input_delay -clock clk -min 0.600 [get_ports weight_row_data*]
set_input_delay -clock clk -max 2.000 [get_ports weight_row_idx*]
set_input_delay -clock clk -min 0.500 [get_ports weight_row_idx*]
set_input_delay -clock clk -max 2.000 [get_ports {input_row_valid weight_row_valid flush clk_enable}]
set_input_delay -clock clk -min 0.500 [get_ports {input_row_valid weight_row_valid flush clk_enable}]

set_output_delay -clock clk -max 2.000 [get_ports output_row_data*]
set_output_delay -clock clk -min 0.500 [get_ports output_row_data*]
set_output_delay -clock clk -max 2.000 [get_ports {output_row_valid busy}]
set_output_delay -clock clk -min 0.500 [get_ports {output_row_valid busy}]

set_false_path -from [get_ports rst_n]
