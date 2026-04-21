`timescale 1ns/1ps

// Standard-API ASIC wrapper for IS.
module is_core_std_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                       clk,
    input  wire                                       rst_n,
    input  wire                                       flush,
    input  wire                                       clk_enable,
    input  wire                                       input_load_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0]              input_load_row_idx,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           input_load_row_data,
    input  wire [ARRAY_SIZE-1:0]                      weight_valid_vec,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]         weight_data_vec,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    standard_is_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_is_std_array (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .input_load_valid(input_load_valid),
        .input_load_row_idx(input_load_row_idx),
        .input_load_row_data(input_load_row_data),
        .weight_valid_vec(weight_valid_vec),
        .weight_data_vec(weight_data_vec),
        .result_valid(result_valid),
        .result_matrix(result_matrix),
        .busy(busy)
    );

endmodule
