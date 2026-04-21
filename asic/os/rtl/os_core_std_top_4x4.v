`timescale 1ns/1ps

// Standard-API ASIC wrapper for OS.
module os_core_std_top_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                       clk,
    input  wire                                       rst_n,
    input  wire                                       flush,
    input  wire                                       clk_enable,
    input  wire [ARRAY_SIZE-1:0]                      a_valid,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           a_data,
    input  wire [ARRAY_SIZE-1:0]                      b_valid,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]         b_data,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    standard_os_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_os_std_array (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .a_valid(a_valid),
        .a_data(a_data),
        .b_valid(b_valid),
        .b_data(b_data),
        .result_valid(result_valid),
        .result_matrix(result_matrix),
        .busy(busy)
    );

endmodule
