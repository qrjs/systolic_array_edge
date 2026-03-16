`timescale 1ns/1ps

// ASIC handoff wrapper for the IS array.
// The goal is to give synthesis/PnR a dedicated handoff top without touching
// the validated simulation and FPGA entry points.
module is_core_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] input_in,
    input  wire input_valid,
    input  wire input_load,
    input  wire [3:0] input_addr,
    output wire input_ready,
    input  wire [WEIGHT_WIDTH-1:0] weight_in,
    input  wire weight_valid,
    output wire weight_ready,
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_data,
    output wire [ARRAY_SIZE-1:0] output_valid,
    input  wire [ARRAY_SIZE-1:0] output_ready,
    input  wire flush,
    input  wire clk_enable,
    output wire busy
);

    systolic_array_is_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_is_array (
        .clk(clk),
        .rst_n(rst_n),
        .input_in(input_in),
        .input_valid(input_valid),
        .input_load(input_load),
        .input_addr(input_addr),
        .input_ready(input_ready),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_ready(weight_ready),
        .output_data(output_data),
        .output_valid(output_valid),
        .output_ready(output_ready),
        .flush(flush),
        .clk_enable(clk_enable),
        .busy(busy)
    );

endmodule
