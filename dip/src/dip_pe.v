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
    input  wire                           weight_load,
    input  wire signed [WEIGHT_WIDTH-1:0] weight_in,
    input  wire                           token_valid_in,
    input  wire signed [DATA_WIDTH-1:0]   data_in,
    input  wire signed [ACC_WIDTH-1:0]    psum_in,
    output wire                           token_valid_out,
    output wire signed [DATA_WIDTH-1:0]   data_out,
    output wire signed [ACC_WIDTH-1:0]    psum_out
);

    reg signed [WEIGHT_WIDTH-1:0] stored_weight;
    reg                           stored_weight_nonzero;
    reg                           token_valid_reg;
    reg signed [DATA_WIDTH-1:0]   data_out_reg;
    reg signed [ACC_WIDTH-1:0]    psum_out_reg;

    wire signed [WEIGHT_WIDTH-1:0] active_weight;
    wire                           active_weight_nonzero;
    wire                           data_nonzero;
    wire                           mac_enable;
    wire signed [ACC_WIDTH-1:0]    mac_result;

    assign active_weight = weight_load ? weight_in : stored_weight;
    assign active_weight_nonzero = weight_load ? (weight_in != 0) : stored_weight_nonzero;
    assign data_nonzero = (data_in != 0);
    assign mac_enable = token_valid_in && data_nonzero && active_weight_nonzero;
    assign mac_result = mac_enable ? (psum_in + (data_in * active_weight)) : psum_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_weight <= {WEIGHT_WIDTH{1'b0}};
            stored_weight_nonzero <= 1'b0;
            token_valid_reg <= 1'b0;
            data_out_reg <= {DATA_WIDTH{1'b0}};
            psum_out_reg <= {ACC_WIDTH{1'b0}};
        end else if (flush) begin
            token_valid_reg <= 1'b0;
            data_out_reg <= {DATA_WIDTH{1'b0}};
            psum_out_reg <= {ACC_WIDTH{1'b0}};
        end else if (clk_enable) begin
            if (weight_load) begin
                stored_weight <= weight_in;
                stored_weight_nonzero <= (weight_in != 0);
            end

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
        cover property (@(posedge clk) weight_load);
        cover property (@(posedge clk) token_valid_in);
        cover property (@(posedge clk) token_valid_in && mac_enable);
        cover property (@(posedge clk) token_valid_in && !mac_enable);
        cover property (@(posedge clk) weight_load && token_valid_in);
        cover property (@(posedge clk) token_valid_reg);
        cover property (@(posedge clk) flush);
    `endif

endmodule
