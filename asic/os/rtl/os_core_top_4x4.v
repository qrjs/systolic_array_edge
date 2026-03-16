`timescale 1ns/1ps

// ASIC handoff wrapper for the OS array.
// This keeps the current top-level protocol intact while separating ASIC
// deliverables from the existing FPGA validation tree.
module os_core_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0] input_in,
    input  wire [ARRAY_SIZE-1:0] input_valid,
    input  wire [1:0] input_row_sel,
    output wire [ARRAY_SIZE-1:0] input_ready,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0] weight_in,
    input  wire weight_valid,
    output wire weight_ready,
    input  wire output_read,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] output_data,
    output wire [ARRAY_SIZE*ARRAY_SIZE-1:0] output_valid,
    input  wire accumulator_clr,
    input  wire flush,
    input  wire clk_enable,
    output wire busy
);

    systolic_array_os_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_os_array (
        .clk(clk),
        .rst_n(rst_n),
        .input_in(input_in),
        .input_valid(input_valid),
        .input_row_sel(input_row_sel),
        .input_ready(input_ready),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_ready(weight_ready),
        .output_read(output_read),
        .output_data(output_data),
        .output_valid(output_valid),
        .accumulator_clr(accumulator_clr),
        .flush(flush),
        .clk_enable(clk_enable),
        .busy(busy)
    );

endmodule
