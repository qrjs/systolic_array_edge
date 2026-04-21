`timescale 1ns/1ps

module dip_pe #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32
)(
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           flush,
    input  wire                           clk_enable,
    input  wire signed [WEIGHT_WIDTH-1:0] committed_weight,
    input  wire                           committed_weight_nonzero,
    input  wire                           token_valid_in,
    input  wire signed [DATA_WIDTH-1:0]   data_in,
    input  wire signed [ACC_WIDTH-1:0]    psum_in,
    output wire                           token_valid_out,
    output wire signed [DATA_WIDTH-1:0]   data_out,
    output wire signed [ACC_WIDTH-1:0]    psum_out
);

    reg                           token_valid_reg;
    reg signed [DATA_WIDTH-1:0]   data_out_reg;
    reg signed [ACC_WIDTH-1:0]    psum_out_reg;

    wire                           data_nonzero;
    wire                           mac_enable;
    wire signed [ACC_WIDTH-1:0]    mac_result;

    assign data_nonzero = (data_in != 0);
    assign mac_enable = token_valid_in && data_nonzero && committed_weight_nonzero;
    assign mac_result = mac_enable ? (psum_in + (data_in * committed_weight)) : psum_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            token_valid_reg <= 1'b0;
            data_out_reg <= {DATA_WIDTH{1'b0}};
            psum_out_reg <= {ACC_WIDTH{1'b0}};
        end else if (flush) begin
            token_valid_reg <= 1'b0;
            data_out_reg <= {DATA_WIDTH{1'b0}};
            psum_out_reg <= {ACC_WIDTH{1'b0}};
        end else if (clk_enable) begin
            if (token_valid_in) begin
                data_out_reg <= data_in;
                psum_out_reg <= mac_result;
            end
            token_valid_reg <= token_valid_in;
        end
    end

    assign token_valid_out = token_valid_reg;
    assign data_out = data_out_reg;
    assign psum_out = psum_out_reg;

    `ifdef FORMAL
        cover property (@(posedge clk) token_valid_in);
        cover property (@(posedge clk) token_valid_in && mac_enable);
        cover property (@(posedge clk) token_valid_in && !mac_enable);
        cover property (@(posedge clk) token_valid_reg);
        cover property (@(posedge clk) flush);
    `endif

endmodule
