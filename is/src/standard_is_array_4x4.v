`timescale 1ns/1ps

// IS（Input Stationary）标准 4x4 阵列。
// 设计意图：输入矩阵先预装在阵列内部并保持静止，权重从顶端向下流动，
// 部分和沿行方向向右累加，最后按标准矩阵顺序写回 result_buf。
module standard_is_array_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                       clk,
    input  wire                                       rst_n,
    input  wire                                       flush,
    input  wire                                       clk_enable,
    input  wire                                       input_load_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0]              input_load_row_idx,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           input_load_row_data,
    input  wire [ARRAY_SIZE-1:0]                      weight_valid_vec,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]         weight_data_vec,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    localparam integer TAG_WIDTH = (ARRAY_SIZE > 1) ? $clog2(ARRAY_SIZE) : 1;
    localparam integer TOTAL_RESULTS = ARRAY_SIZE * ARRAY_SIZE;
    localparam integer RESULT_COUNT_WIDTH = $clog2(TOTAL_RESULTS + 1);

    // stored_input：预先装入并静止保存的输入，是 IS 数据流的核心状态。
    // weight_pipe：权重从阵列顶部向下传播。
    // psum_pipe：部分和从左向右传播。
    reg signed [DATA_WIDTH-1:0]   stored_input    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] weight_pipe     [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0]    psum_pipe       [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           valid_pipe      [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg        [TAG_WIDTH-1:0]    col_tag_pipe    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg        [TAG_WIDTH-1:0]    input_col_tag   [0:ARRAY_SIZE-1];

    reg signed [ACC_WIDTH-1:0]    result_buf      [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           result_seen     [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [RESULT_COUNT_WIDTH-1:0]  result_count;
    reg                           result_valid_reg;
    reg                           started_reg;
    reg                           done_reg;

    integer row_idx;
    integer col_idx;
    integer new_results;
    reg signed [WEIGHT_WIDTH-1:0] current_weight;
    reg signed [ACC_WIDTH-1:0]    current_psum;
    reg signed [ACC_WIDTH-1:0]    next_psum;
    reg                           current_valid;
    reg [TAG_WIDTH-1:0]           current_tag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                input_col_tag[row_idx] <= {TAG_WIDTH{1'b0}};
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    stored_input[row_idx][col_idx] <= {DATA_WIDTH{1'b0}};
                    weight_pipe[row_idx][col_idx] <= {WEIGHT_WIDTH{1'b0}};
                    psum_pipe[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    valid_pipe[row_idx][col_idx] <= 1'b0;
                    col_tag_pipe[row_idx][col_idx] <= {TAG_WIDTH{1'b0}};
                    result_buf[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    result_seen[row_idx][col_idx] <= 1'b0;
                end
            end
            result_count <= {RESULT_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
        end else if (flush) begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                input_col_tag[row_idx] <= {TAG_WIDTH{1'b0}};
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    weight_pipe[row_idx][col_idx] <= {WEIGHT_WIDTH{1'b0}};
                    psum_pipe[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    valid_pipe[row_idx][col_idx] <= 1'b0;
                    col_tag_pipe[row_idx][col_idx] <= {TAG_WIDTH{1'b0}};
                    result_buf[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    result_seen[row_idx][col_idx] <= 1'b0;
                end
            end
            result_count <= {RESULT_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
        end else if (clk_enable) begin
            result_valid_reg <= 1'b0;
            new_results = 0;

            // 先按行把输入矩阵装入阵列内部，装入后这些输入保持不动。
            if (input_load_valid) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    stored_input[input_load_row_idx][col_idx] <=
                        $signed(input_load_row_data[((col_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH]);
                end
            end

            if (|weight_valid_vec) begin
                started_reg <= 1'b1;
            end

            // 每拍推进整个阵列：
            // 1) 第 0 行从输入端接收新的权重 token；其余行从上一行接收权重。
            // 2) 第 0 列从 0 开始累加；其余列接收左侧部分和。
            // 3) 最后一列把完成的结果写回 result_buf。
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if (row_idx == 0) begin
                        current_weight = $signed(weight_data_vec[((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]);
                        current_valid = weight_valid_vec[col_idx];
                        current_tag = input_col_tag[col_idx];
                    end else begin
                        current_weight = weight_pipe[row_idx - 1][col_idx];
                        current_valid = valid_pipe[row_idx - 1][col_idx];
                        current_tag = col_tag_pipe[row_idx - 1][col_idx];
                    end

                    if (col_idx == 0) begin
                        current_psum = {ACC_WIDTH{1'b0}};
                    end else begin
                        current_psum = psum_pipe[row_idx][col_idx - 1];
                    end

                    next_psum = current_psum;
                    if (current_valid) begin
                        // 低功耗优化：输入静止阵列中，若静止输入或流动权重为 0，
                        // 则这一级直接透传部分和，避免无效 MAC 翻转。
                        if ((stored_input[row_idx][col_idx] != 0) && (current_weight != 0)) begin
                            next_psum = current_psum + (stored_input[row_idx][col_idx] * current_weight);
                        end
                    end

                    weight_pipe[row_idx][col_idx] <= current_weight;
                    valid_pipe[row_idx][col_idx] <= current_valid;
                    col_tag_pipe[row_idx][col_idx] <= current_tag;
                    psum_pipe[row_idx][col_idx] <= current_valid ? next_psum : {ACC_WIDTH{1'b0}};

                    if ((row_idx == 0) && current_valid) begin
                        input_col_tag[col_idx] <= input_col_tag[col_idx] + {{(TAG_WIDTH-1){1'b0}}, 1'b1};
                    end

                    if ((col_idx == ARRAY_SIZE - 1) && current_valid) begin
                        result_buf[row_idx][current_tag] <= next_psum;
                        if (!result_seen[row_idx][current_tag]) begin
                            result_seen[row_idx][current_tag] <= 1'b1;
                            new_results = new_results + 1;
                        end
                    end
                end
            end

            if (new_results != 0) begin
                result_count <= result_count + new_results[RESULT_COUNT_WIDTH-1:0];
                if ((result_count + new_results[RESULT_COUNT_WIDTH-1:0]) == TOTAL_RESULTS[RESULT_COUNT_WIDTH-1:0]) begin
                    result_valid_reg <= 1'b1;
                    done_reg <= 1'b1;
                end
            end
        end
    end

    generate
        genvar out_row;
        genvar out_col;
        for (out_row = 0; out_row < ARRAY_SIZE; out_row = out_row + 1) begin : gen_out_rows
            for (out_col = 0; out_col < ARRAY_SIZE; out_col = out_col + 1) begin : gen_out_cols
                assign result_matrix[((out_row * ARRAY_SIZE + out_col + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH] =
                    result_buf[out_row][out_col];
            end
        end
    endgenerate

    // result_valid 只在整块输出全部收齐时拉高。
    assign result_valid = result_valid_reg;
    // busy 表示正在装载输入、正在流动权重，或仍处于计算未完成状态。
    assign busy = input_load_valid | (|weight_valid_vec) | (started_reg & ~done_reg);

endmodule
