`timescale 1ns/1ps

// ASIC handoff wrapper for the WS array.
// This wrapper intentionally keeps the current validated interface unchanged,
// while giving backend a stable top name and a dedicated ASIC handoff path.
module ws_core_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [WEIGHT_WIDTH-1:0] weight_in,
    input  wire weight_valid,
    input  wire weight_load,
    input  wire [3:0] weight_addr,
    output wire weight_ready,
    input  wire [DATA_WIDTH-1:0] input_data,
    input  wire input_valid,
    input  wire [1:0] input_row_sel,
    output wire input_ready,
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_data,
    output wire [ARRAY_SIZE-1:0] output_valid,
    input  wire [ARRAY_SIZE-1:0] output_ready,
    input  wire flush,
    input  wire clk_enable,
    output wire busy
);

    systolic_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_ws_array (
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_load(weight_load),
        .weight_addr(weight_addr),
        .weight_ready(weight_ready),
        .input_data(input_data),
        .input_valid(input_valid),
        .input_row_sel(input_row_sel),
        .input_ready(input_ready),
        .output_data(output_data),
        .output_valid(output_valid),
        .output_ready(output_ready),
        .flush(flush),
        .clk_enable(clk_enable),
        .busy(busy)
    );

endmodule
