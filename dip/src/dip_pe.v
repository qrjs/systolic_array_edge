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

    reg                           stage1_valid;
    reg signed [DATA_WIDTH-1:0]   stage1_data;
    reg signed [ACC_WIDTH-1:0]    stage1_psum;

    reg                           stage2_valid;
    reg signed [DATA_WIDTH-1:0]   stage2_data;
    reg signed [ACC_WIDTH-1:0]    stage2_psum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_weight <= {WEIGHT_WIDTH{1'b0}};
            stage1_valid  <= 1'b0;
            stage1_data   <= {DATA_WIDTH{1'b0}};
            stage1_psum   <= {ACC_WIDTH{1'b0}};
            stage2_valid  <= 1'b0;
            stage2_data   <= {DATA_WIDTH{1'b0}};
            stage2_psum   <= {ACC_WIDTH{1'b0}};
        end else if (flush) begin
            stage1_valid  <= 1'b0;
            stage1_data   <= {DATA_WIDTH{1'b0}};
            stage1_psum   <= {ACC_WIDTH{1'b0}};
            stage2_valid  <= 1'b0;
            stage2_data   <= {DATA_WIDTH{1'b0}};
            stage2_psum   <= {ACC_WIDTH{1'b0}};
        end else if (clk_enable) begin
            if (weight_load) begin
                stored_weight <= weight_in;
            end

            stage2_valid <= stage1_valid;
            stage2_data  <= stage1_data;
            // 低功耗优化：DiP 的每个 PE 在真正执行 MAC 前先判断操作数是否为 0。
            // 若该 token 对输出没有贡献，则直接透传部分和，避免无效切换。
            stage2_psum  <= stage1_psum;
            if (stage1_valid && (stage1_data != 0) && (stored_weight != 0)) begin
                stage2_psum <= stage1_psum + (stage1_data * stored_weight);
            end

            stage1_valid <= token_valid_in;
            stage1_data  <= data_in;
            stage1_psum  <= psum_in;
        end
    end

    assign token_valid_out = stage2_valid;
    assign data_out = stage2_data;
    assign psum_out = stage2_psum;

endmodule
