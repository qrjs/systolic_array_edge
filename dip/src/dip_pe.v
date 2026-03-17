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
    reg                           stage1_mac_en;

    reg                           stage2_valid;
    reg signed [DATA_WIDTH-1:0]   stage2_data;
    reg signed [ACC_WIDTH-1:0]    stage2_psum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_weight <= {WEIGHT_WIDTH{1'b0}};
            stage1_valid  <= 1'b0;
            stage1_data   <= {DATA_WIDTH{1'b0}};
            stage1_psum   <= {ACC_WIDTH{1'b0}};
            stage1_mac_en <= 1'b0;
            stage2_valid  <= 1'b0;
            stage2_data   <= {DATA_WIDTH{1'b0}};
            stage2_psum   <= {ACC_WIDTH{1'b0}};
        end else if (flush) begin
            stage1_valid  <= 1'b0;
            stage1_data   <= {DATA_WIDTH{1'b0}};
            stage1_psum   <= {ACC_WIDTH{1'b0}};
            stage1_mac_en <= 1'b0;
            stage2_valid  <= 1'b0;
            stage2_data   <= {DATA_WIDTH{1'b0}};
            stage2_psum   <= {ACC_WIDTH{1'b0}};
        end else if (clk_enable) begin
            if (weight_load) begin
                stored_weight <= weight_in;
            end

            stage2_valid <= stage1_valid;
            if (stage1_valid) begin
                stage2_data <= stage1_data;
                // 边缘场景更关心无效翻转和控制开销，因此把 “是否真的需要 MAC”
                // 的判定前移到 stage1 并寄存成 stage1_mac_en。
                // 这样 stage2 只在 token 有效且确实有贡献时才切换 DSP / adder，
                // 无效周期则仅清 valid，数据寄存器保持稳定，减少翻转。
                stage2_psum <= stage1_psum;
                if (stage1_mac_en) begin
                    stage2_psum <= stage1_psum + (stage1_data * stored_weight);
                end
            end

            stage1_valid <= token_valid_in;
            if (token_valid_in) begin
                stage1_data <= data_in;
                stage1_psum <= psum_in;
                // 若 weight_load 与 token_valid_in 同拍出现，则这个 token 在下一拍
                // 应该使用新装入的权重，因此这里优先用 weight_in 参与零值判定。
                stage1_mac_en <= (data_in != 0) &&
                                 ((weight_load ? weight_in : stored_weight) != 0);
            end else begin
                stage1_mac_en <= 1'b0;
            end
        end
    end

    assign token_valid_out = stage2_valid;
    assign data_out = stage2_data;
    assign psum_out = stage2_psum;

endmodule
