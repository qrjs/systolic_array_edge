`timescale 1ns/1ps

// DiP 核心流式阵列。
// 关键特征：
// 1) 权重以“整行银行”的形式在阵列顶层静止保存；
// 2) 输入沿对角方向传播，左边界会绕接到下一行的最右侧；
// 3) 最后一拍权重加载与第一拍输入仍可在外部重叠，但内部会先暂存输入，
//    等权重完成提交后再真正注入阵列，避免形成控制到 MAC 的关键路径。
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

    localparam integer ROW_INDEX_WIDTH = (ARRAY_SIZE > 1) ? $clog2(ARRAY_SIZE) : 1;
    localparam integer ROW_COUNT_WIDTH = $clog2(ARRAY_SIZE + 1);

    reg  [WEIGHT_WIDTH*ARRAY_SIZE-1:0]    committed_weight_rows         [0:ARRAY_SIZE-1];
    reg  [ARRAY_SIZE-1:0]                 committed_weight_nonzero_rows [0:ARRAY_SIZE-1];
    reg  [ARRAY_SIZE-1:0]                 loaded_weight_rows;

    reg                                   staged_input_valid;
    reg  [DATA_WIDTH*ARRAY_SIZE-1:0]      staged_input_data;
    reg  [ROW_COUNT_WIDTH-1:0]            accepted_input_rows;
    reg  [ROW_COUNT_WIDTH-1:0]            completed_output_rows;
    reg                                   drain_issued_reg;

    wire [DATA_WIDTH-1:0] pe_data_in   [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ACC_WIDTH-1:0]  pe_psum_in   [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire                  pe_valid_in  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    wire [DATA_WIDTH-1:0] pe_data_out  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ACC_WIDTH-1:0]  pe_psum_out  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire                  pe_valid_out [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire [ARRAY_SIZE-1:0] bottom_row_valid;
    wire                  row_ready;

    wire [ARRAY_SIZE-1:0]                 weight_row_select;
    wire                                  weight_commit_complete;
    wire [ROW_COUNT_WIDTH:0]              accepted_or_staged_rows;
    wire                                  overlap_capture_allowed;
    wire                                  capture_external_input;
    wire                                  use_direct_input;
    wire                                  stream_real_input_valid;
    wire [DATA_WIDTH*ARRAY_SIZE-1:0]      stream_real_input_data;
    wire                                  issue_drain_now;
    wire                                  stream_input_row_valid;
    wire [DATA_WIDTH*ARRAY_SIZE-1:0]      stream_input_row_data;

    reg                                   output_row_valid_reg;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0]        output_row_data_reg;
    integer                               col_idx_int;
    integer                               out_col_idx;

    genvar row_idx;
    genvar col_idx;

    assign weight_row_select = weight_row_valid
        ? ({{(ARRAY_SIZE-1){1'b0}}, 1'b1} << weight_row_idx)
        : {ARRAY_SIZE{1'b0}};
    assign weight_commit_complete = &(loaded_weight_rows | weight_row_select);

    assign accepted_or_staged_rows = accepted_input_rows +
        {{ROW_COUNT_WIDTH{1'b0}}, staged_input_valid};
    assign overlap_capture_allowed = weight_row_valid && weight_commit_complete;
    assign capture_external_input = input_row_valid &&
        (accepted_or_staged_rows < ARRAY_SIZE) &&
        (staged_input_valid || overlap_capture_allowed);
    assign use_direct_input = input_row_valid &&
        (accepted_or_staged_rows < ARRAY_SIZE) &&
        !staged_input_valid &&
        !weight_row_valid;

    assign stream_real_input_valid = staged_input_valid || use_direct_input;
    assign stream_real_input_data = staged_input_valid ? staged_input_data : input_row_data;
    assign issue_drain_now = (accepted_input_rows == ARRAY_SIZE[ROW_COUNT_WIDTH-1:0]) &&
        !staged_input_valid &&
        !stream_real_input_valid &&
        !drain_issued_reg;

    assign stream_input_row_valid = stream_real_input_valid || issue_drain_now;
    assign stream_input_row_data = stream_real_input_valid
        ? stream_real_input_data
        : {(DATA_WIDTH*ARRAY_SIZE){1'b0}};

    generate
        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin : gen_rows
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin : gen_cols
                if (row_idx == 0) begin : gen_top_inputs
                    assign pe_valid_in[row_idx][col_idx] = stream_input_row_valid;
                    assign pe_data_in[row_idx][col_idx] =
                        stream_input_row_data[((col_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH];
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
                    .committed_weight(committed_weight_rows[row_idx][((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]),
                    .committed_weight_nonzero(committed_weight_nonzero_rows[row_idx][col_idx]),
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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            loaded_weight_rows <= {ARRAY_SIZE{1'b0}};
            staged_input_valid <= 1'b0;
            staged_input_data <= {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
            accepted_input_rows <= {ROW_COUNT_WIDTH{1'b0}};
            completed_output_rows <= {ROW_COUNT_WIDTH{1'b0}};
            drain_issued_reg <= 1'b0;
            output_row_valid_reg <= 1'b0;
            output_row_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            for (col_idx_int = 0; col_idx_int < ARRAY_SIZE; col_idx_int = col_idx_int + 1) begin
                committed_weight_rows[col_idx_int] <= {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
                committed_weight_nonzero_rows[col_idx_int] <= {ARRAY_SIZE{1'b0}};
            end
        end else if (flush) begin
            loaded_weight_rows <= {ARRAY_SIZE{1'b0}};
            staged_input_valid <= 1'b0;
            staged_input_data <= {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
            accepted_input_rows <= {ROW_COUNT_WIDTH{1'b0}};
            completed_output_rows <= {ROW_COUNT_WIDTH{1'b0}};
            drain_issued_reg <= 1'b0;
            output_row_valid_reg <= 1'b0;
            output_row_data_reg <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
            for (col_idx_int = 0; col_idx_int < ARRAY_SIZE; col_idx_int = col_idx_int + 1) begin
                committed_weight_rows[col_idx_int] <= {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
                committed_weight_nonzero_rows[col_idx_int] <= {ARRAY_SIZE{1'b0}};
            end
        end else if (clk_enable) begin
            if (weight_row_valid) begin
                committed_weight_rows[weight_row_idx] <= weight_row_data;
                loaded_weight_rows[weight_row_idx] <= 1'b1;
                for (col_idx_int = 0; col_idx_int < ARRAY_SIZE; col_idx_int = col_idx_int + 1) begin
                    committed_weight_nonzero_rows[weight_row_idx][col_idx_int] <=
                        ($signed(weight_row_data[((col_idx_int + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]) != 0);
                end
            end

            if (capture_external_input) begin
                staged_input_valid <= 1'b1;
                staged_input_data <= input_row_data;
            end else if (staged_input_valid) begin
                staged_input_valid <= 1'b0;
            end

            if (stream_real_input_valid) begin
                accepted_input_rows <= accepted_input_rows + {{(ROW_COUNT_WIDTH-1){1'b0}}, 1'b1};
            end

            if (issue_drain_now) begin
                drain_issued_reg <= 1'b1;
            end

            if (output_row_valid_reg && (completed_output_rows < ARRAY_SIZE[ROW_COUNT_WIDTH-1:0])) begin
                completed_output_rows <= completed_output_rows + {{(ROW_COUNT_WIDTH-1){1'b0}}, 1'b1};
            end

            output_row_valid_reg <= row_ready;
            if (row_ready) begin
                for (out_col_idx = 0; out_col_idx < ARRAY_SIZE; out_col_idx = out_col_idx + 1) begin
                    output_row_data_reg[((out_col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH] <=
                        pe_psum_out[ARRAY_SIZE - 1][out_col_idx];
                end
            end
        end
    end

    assign output_row_valid = output_row_valid_reg;
    assign output_row_data = output_row_data_reg;
    assign busy = weight_row_valid ||
                  staged_input_valid ||
                  stream_real_input_valid ||
                  issue_drain_now ||
                  output_row_valid_reg ||
                  (accepted_input_rows != completed_output_rows);

    `ifdef FORMAL
        cover property (@(posedge clk) weight_row_valid);
        cover property (@(posedge clk) input_row_valid);
        cover property (@(posedge clk) weight_row_valid && input_row_valid);
        cover property (@(posedge clk) capture_external_input);
        cover property (@(posedge clk) issue_drain_now);
        cover property (@(posedge clk) row_ready);
        cover property (@(posedge clk) row_ready ##1 output_row_valid_reg);
        cover property (@(posedge clk) pe_valid_out[ARRAY_SIZE - 1][0]);
        cover property (@(posedge clk) pe_valid_out[ARRAY_SIZE - 1][ARRAY_SIZE - 1]);
        cover property (@(posedge clk) busy);
        cover property (@(posedge clk) !busy);
    `endif

endmodule
