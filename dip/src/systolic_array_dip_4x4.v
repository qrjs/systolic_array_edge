`timescale 1ns/1ps

// DiP 核心流式阵列。
// 关键特征：输入沿对角方向传播，左边界会绕接到下一行的最右侧，
// 权重在 PE 中静止保存，部分和仍沿列方向向下累加。
module systolic_array_dip_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                   clk,
    input  wire                                   rst_n,
    input  wire                                   flush,
    input  wire                                   clk_enable,
    input  wire                                   weight_row_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0]          weight_row_idx,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]     weight_row_data,
    input  wire                                   input_row_valid,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]       input_row_data,
    output wire                                   output_row_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0]        output_row_data,
    output wire                                   busy
);

    // activity_sr 用来粗略跟踪阵列内部是否还存在尚未排空的活动 token。
    localparam integer ACTIVITY_DEPTH = (ARRAY_SIZE * 2) + 4;

    wire [DATA_WIDTH-1:0] pe_data_in   [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ACC_WIDTH-1:0]  pe_psum_in   [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire                  pe_valid_in  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    wire [DATA_WIDTH-1:0] pe_data_out  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ACC_WIDTH-1:0]  pe_psum_out  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire                  pe_valid_out [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ARRAY_SIZE-1:0] bottom_row_valid;
    wire                  row_ready;

    reg                   row_capture_valid_reg;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] row_capture_data_reg;
    reg                   output_row_valid_reg;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] output_row_data_reg;
    reg [ACTIVITY_DEPTH-1:0] activity_sr;
    reg                   busy_reg;

    // busy_comb 汇总了输入、权重、结果采集以及内部 token 排空状态。
    // 这里不直接把组合锥送到顶层端口，而是寄存一拍，避免 activity_sr 到 busy
    // 成为综合报告中的最差 control-to-output 路径。
    wire                  busy_comb;

    genvar row_idx;
    genvar col_idx;

    generate
        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin : gen_rows
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin : gen_cols
                if (row_idx == 0) begin : gen_top_inputs
                    assign pe_valid_in[row_idx][col_idx] = input_row_valid;
                    assign pe_data_in[row_idx][col_idx] =
                        input_row_data[((col_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH];
                    assign pe_psum_in[row_idx][col_idx] = {ACC_WIDTH{1'b0}};
                end else begin : gen_internal_inputs
                    // DiP 的关键连接方式：上一行不是直接喂给同列，而是循环右移一列后喂给下一行。
                    // 这正是“对角输入传播”的硬件体现。
                    localparam integer PREV_COL = (col_idx + 1) % ARRAY_SIZE;
                    assign pe_valid_in[row_idx][col_idx] = pe_valid_out[row_idx - 1][PREV_COL];
                    assign pe_data_in[row_idx][col_idx]  = pe_data_out[row_idx - 1][PREV_COL];
                    assign pe_psum_in[row_idx][col_idx]  = pe_psum_out[row_idx - 1][col_idx];
                end

                dip_pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .WEIGHT_WIDTH(WEIGHT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) u_dip_pe (
                    .clk(clk),
                    .rst_n(rst_n),
                    .flush(flush),
                    .clk_enable(clk_enable),
                    .weight_load(weight_row_valid && (weight_row_idx == row_idx)),
                    .weight_in(weight_row_data[((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]),
                    .token_valid_in(pe_valid_in[row_idx][col_idx]),
                    .data_in(pe_data_in[row_idx][col_idx]),
                    .psum_in(pe_psum_in[row_idx][col_idx]),
                    .token_valid_out(pe_valid_out[row_idx][col_idx]),
                    .data_out(pe_data_out[row_idx][col_idx]),
                    .psum_out(pe_psum_out[row_idx][col_idx])
                );
            end
        end
    endgenerate

    generate
        for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin : gen_outputs
            assign bottom_row_valid[col_idx] = pe_valid_out[ARRAY_SIZE - 1][col_idx];
        end
    endgenerate

    // 当底部一整行的 valid 同时为 1 时，说明一整行输出已经准备好。
    assign row_ready = &bottom_row_valid;
    assign busy_comb = weight_row_valid | input_row_valid | row_capture_valid_reg |
                       output_row_valid_reg | row_ready | (|activity_sr);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            activity_sr <= {ACTIVITY_DEPTH{1'b0}};
            row_capture_valid_reg <= 1'b0;
            row_capture_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            output_row_valid_reg <= 1'b0;
            output_row_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            busy_reg <= 1'b0;
        end else if (flush) begin
            activity_sr <= {ACTIVITY_DEPTH{1'b0}};
            row_capture_valid_reg <= 1'b0;
            row_capture_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            output_row_valid_reg <= 1'b0;
            output_row_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            busy_reg <= 1'b0;
        end else if (clk_enable) begin
            activity_sr <= {activity_sr[ACTIVITY_DEPTH-2:0], input_row_valid};

            row_capture_valid_reg <= row_ready;
            if (row_ready) begin
                for (integer out_col_idx = 0; out_col_idx < ARRAY_SIZE; out_col_idx = out_col_idx + 1) begin
                    row_capture_data_reg[((out_col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH] <=
                        pe_psum_out[ARRAY_SIZE - 1][out_col_idx];
                end
            end

            // 再寄存一拍，把从底部采集到的整行结果整理成稳定输出。
            // 无新结果时保持 output_row_data_reg 稳定，避免输出总线无效翻转。
            output_row_valid_reg <= row_capture_valid_reg;
            if (row_capture_valid_reg) begin
                output_row_data_reg <= row_capture_data_reg;
            end
            busy_reg <= busy_comb;
        end
    end

    assign output_row_valid = output_row_valid_reg;
    assign output_row_data = output_row_data_reg;
    assign busy = busy_reg;

    `ifdef FORMAL
        cover property (@(posedge clk) weight_row_valid);
        cover property (@(posedge clk) input_row_valid);
        cover property (@(posedge clk) row_ready);
        cover property (@(posedge clk) row_ready ##1 output_row_valid_reg);
        cover property (@(posedge clk) pe_valid_out[ARRAY_SIZE - 1][0]);
        cover property (@(posedge clk) pe_valid_out[ARRAY_SIZE - 1][ARRAY_SIZE - 1]);
        cover property (@(posedge clk) busy_reg);
        cover property (@(posedge clk) !busy_reg);
    `endif

endmodule
