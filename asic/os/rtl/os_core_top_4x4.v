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

    wire legacy_input_mode_ok;
    wire legacy_ctrl_active;
    wire result_valid;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix;
    wire busy_core;
    wire [ARRAY_SIZE-1:0] a_valid_mux;
    wire [ARRAY_SIZE-1:0] b_valid_mux;
    wire adapted_flush;

    assign legacy_input_mode_ok = (input_row_sel == 2'b00);
    assign legacy_ctrl_active = output_read;
    assign adapted_flush = flush | accumulator_clr;
    assign a_valid_mux = legacy_input_mode_ok ? input_valid : {ARRAY_SIZE{1'b0}};
    assign b_valid_mux = (clk_enable && !adapted_flush) ? {ARRAY_SIZE{weight_valid}} : {ARRAY_SIZE{1'b0}};

    assign input_ready = {ARRAY_SIZE{legacy_input_mode_ok && clk_enable && !adapted_flush}};
    assign weight_ready = clk_enable && !adapted_flush;
    assign output_data = result_matrix;
    assign output_valid = {ARRAY_SIZE*ARRAY_SIZE{result_valid && output_read}};
    assign busy = busy_core | legacy_ctrl_active;

    standard_os_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_os_array (
        .clk(clk),
        .rst_n(rst_n),
        .flush(adapted_flush),
        .clk_enable(clk_enable),
        .a_valid(a_valid_mux),
        .a_data(input_in),
        .b_valid(b_valid_mux),
        .b_data(weight_in),
        .result_valid(result_valid),
        .result_matrix(result_matrix),
        .busy(busy_core)
    );

endmodule
