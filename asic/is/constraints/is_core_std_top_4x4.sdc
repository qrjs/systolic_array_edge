create_clock -name clk -period 10.000 [get_ports clk]
set_clock_uncertainty 0.100 [get_clocks clk]

set_input_delay -clock clk -max 2.000 [get_ports input_load_row_data*]
set_input_delay -clock clk -min 0.500 [get_ports input_load_row_data*]
set_input_delay -clock clk -max 2.000 [get_ports weight_data_vec*]
set_input_delay -clock clk -min 0.500 [get_ports weight_data_vec*]
set_input_delay -clock clk -max 2.000 [get_ports input_load_row_idx*]
set_input_delay -clock clk -min 0.500 [get_ports input_load_row_idx*]
set_input_delay -clock clk -max 2.000 [get_ports {input_load_valid weight_valid_vec* flush clk_enable}]
set_input_delay -clock clk -min 0.500 [get_ports {input_load_valid weight_valid_vec* flush clk_enable}]

set_output_delay -clock clk -max 2.000 [get_ports result_matrix*]
set_output_delay -clock clk -min 0.500 [get_ports result_matrix*]
set_output_delay -clock clk -max 2.000 [get_ports {result_valid busy}]
set_output_delay -clock clk -min 0.500 [get_ports {result_valid busy}]

set_false_path -from [get_ports rst_n]
