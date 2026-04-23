create_clock -name clk -period 5.000 [get_ports clk]
set_clock_uncertainty 0.050 [get_clocks clk]

set_input_delay -clock clk -max 1.000 [get_ports input_row_data*]
set_input_delay -clock clk -min 0.250 [get_ports input_row_data*]
set_input_delay -clock clk -max 1.000 [get_ports weight_row_data*]
set_input_delay -clock clk -min 0.250 [get_ports weight_row_data*]
set_input_delay -clock clk -max 1.000 [get_ports weight_row_idx*]
set_input_delay -clock clk -min 0.250 [get_ports weight_row_idx*]
set_input_delay -clock clk -max 1.000 [get_ports {input_row_valid weight_row_valid flush clk_enable}]
set_input_delay -clock clk -min 0.250 [get_ports {input_row_valid weight_row_valid flush clk_enable}]

set_output_delay -clock clk -max 1.000 [get_ports result_matrix*]
set_output_delay -clock clk -min 0.250 [get_ports result_matrix*]
set_output_delay -clock clk -max 1.000 [get_ports {result_valid busy}]
set_output_delay -clock clk -min 0.250 [get_ports {result_valid busy}]

set_false_path -from [get_ports rst_n]
