`timescale 1ns/1ps

// Standard-API ASIC wrapper for WS.
// This top exposes the validated file-vector interface used by RTL and gate-level
// VCS regressions without changing the main comparison handoff top.
module ws_core_std_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                       clk,
    input  wire                                       rst_n,
    input  wire                                       flush,
    input  wire                                       clk_enable,
    input  wire                                       weight_row_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0]              weight_row_idx,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]         weight_row_data,
    input  wire [ARRAY_SIZE-1:0]                      input_valid_vec,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           input_data_vec,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    standard_ws_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_ws_std_array (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .weight_row_valid(weight_row_valid),
        .weight_row_idx(weight_row_idx),
        .weight_row_data(weight_row_data),
        .input_valid_vec(input_valid_vec),
        .input_data_vec(input_data_vec),
        .result_valid(result_valid),
        .result_matrix(result_matrix),
        .busy(busy)
    );

endmodule
