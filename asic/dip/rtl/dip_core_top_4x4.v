`timescale 1ns/1ps

// ASIC handoff wrapper for the DiP array.
// Kept as a thin wrapper so backend can use a dedicated top name and SDC
// without affecting the validated project structure.
module dip_core_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire flush,
    input  wire clk_enable,
    input  wire weight_row_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0] weight_row_idx,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0] weight_row_data,
    input  wire input_row_valid,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0] input_row_data,
    output wire output_row_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_row_data,
    output wire busy
);

    systolic_array_dip_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_dip_array (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .weight_row_valid(weight_row_valid),
        .weight_row_idx(weight_row_idx),
        .weight_row_data(weight_row_data),
        .input_row_valid(input_row_valid),
        .input_row_data(input_row_data),
        .output_row_valid(output_row_valid),
        .output_row_data(output_row_data),
        .busy(busy)
    );

endmodule
