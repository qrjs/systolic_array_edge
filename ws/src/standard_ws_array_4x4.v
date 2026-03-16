`timescale 1ns/1ps

// WS（Weight Stationary）标准 4x4 阵列。
// 设计意图：权重先装入阵列内部并保持不动，输入数据沿行方向传播，部分和沿列方向向下累加。
// 当最后一行收到某个输入 token 的最终部分和时，再按原始输入行号写回 result_buf。
module standard_ws_array_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    input  wire                                       clk,
    input  wire                                       rst_n,
    input  wire                                       flush,
    input  wire                                       clk_enable,
    input  wire                                       weight_row_valid,
    input  wire [$clog2(ARRAY_SIZE)-1:0]              weight_row_idx,
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0]         weight_row_data,
    input  wire [ARRAY_SIZE-1:0]                      input_valid_vec,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           input_data_vec,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    localparam integer TAG_WIDTH = (ARRAY_SIZE > 1) ? $clog2(ARRAY_SIZE) : 1;
    localparam integer TOTAL_RESULTS = ARRAY_SIZE * ARRAY_SIZE;
    localparam integer RESULT_COUNT_WIDTH = $clog2(TOTAL_RESULTS + 1);

    // stored_weight：阵列内部静止保存的权重，是 WS 数据流的核心状态。
    // data_pipe：输入 token 在每一行内从左向右传播。
    // psum_pipe：部分和在每一列内从上向下传播。
    // row_tag_pipe / input_row_tag：记录这个 token 原本属于哪一行输入，
    // 这样当结果到达阵列底部时，能够按正确的输出行写回 result_buf。
    reg signed [WEIGHT_WIDTH-1:0] stored_weight [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [DATA_WIDTH-1:0]   data_pipe     [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0]    psum_pipe     [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           valid_pipe    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg        [TAG_WIDTH-1:0]    row_tag_pipe  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg        [TAG_WIDTH-1:0]    input_row_tag [0:ARRAY_SIZE-1];

    // result_buf：按标准矩阵输出顺序缓存最终结果。
    reg signed [ACC_WIDTH-1:0]    result_buf    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           result_seen   [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [RESULT_COUNT_WIDTH-1:0]  result_count;
    reg                           result_valid_reg;
    reg                           started_reg;
    reg                           done_reg;

    integer row_idx;
    integer col_idx;
    integer new_results;
    reg signed [DATA_WIDTH-1:0] current_data;
    reg signed [ACC_WIDTH-1:0] current_psum;
    reg signed [ACC_WIDTH-1:0] next_psum;
    reg current_valid;
    reg [TAG_WIDTH-1:0] current_tag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                input_row_tag[row_idx] <= {TAG_WIDTH{1'b0}};
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    stored_weight[row_idx][col_idx] <= {WEIGHT_WIDTH{1'b0}};
                    data_pipe[row_idx][col_idx] <= {DATA_WIDTH{1'b0}};
                    psum_pipe[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    valid_pipe[row_idx][col_idx] <= 1'b0;
                    row_tag_pipe[row_idx][col_idx] <= {TAG_WIDTH{1'b0}};
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
                input_row_tag[row_idx] <= {TAG_WIDTH{1'b0}};
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    data_pipe[row_idx][col_idx] <= {DATA_WIDTH{1'b0}};
                    psum_pipe[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    valid_pipe[row_idx][col_idx] <= 1'b0;
                    row_tag_pipe[row_idx][col_idx] <= {TAG_WIDTH{1'b0}};
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

            // 先装入一整行权重；装入后权重保持不变，直到 flush 或下次覆盖。
            if (weight_row_valid) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    stored_weight[weight_row_idx][col_idx] <=
                        $signed(weight_row_data[((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]);
                end
            end

            if (|input_valid_vec) begin
                started_reg <= 1'b1;
            end

            // 每个时钟拍统一推进整个阵列：
            // 1) 第 0 列从输入口取数据；其余列从左边相邻 PE 取数据。
            // 2) 第 0 行从 0 开始累加；其余行从上一行拿到部分和。
            // 3) 最后一行把已经完成的结果写回 result_buf。
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if (col_idx == 0) begin
                        current_data = $signed(input_data_vec[((row_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH]);
                        current_valid = input_valid_vec[row_idx];
                        current_tag = input_row_tag[row_idx];
                    end else begin
                        current_data = data_pipe[row_idx][col_idx - 1];
                        current_valid = valid_pipe[row_idx][col_idx - 1];
                        current_tag = row_tag_pipe[row_idx][col_idx - 1];
                    end

                    if (row_idx == 0) begin
                        current_psum = {ACC_WIDTH{1'b0}};
                    end else begin
                        current_psum = psum_pipe[row_idx - 1][col_idx];
                    end

                    next_psum = current_psum;
                    if (current_valid) begin
                        // 低功耗优化：若当前输入或静止权重为 0，则该次 MAC 对结果没有贡献，
                        // 直接旁路乘法器与加法器，保留原部分和即可。
                        if ((current_data != 0) && (stored_weight[row_idx][col_idx] != 0)) begin
                            next_psum = current_psum + (current_data * stored_weight[row_idx][col_idx]);
                        end
                    end

                    data_pipe[row_idx][col_idx] <= current_data;
                    valid_pipe[row_idx][col_idx] <= current_valid;
                    row_tag_pipe[row_idx][col_idx] <= current_tag;
                    psum_pipe[row_idx][col_idx] <= current_valid ? next_psum : {ACC_WIDTH{1'b0}};

                    if ((col_idx == 0) && current_valid) begin
                        input_row_tag[row_idx] <= input_row_tag[row_idx] + {{(TAG_WIDTH-1){1'b0}}, 1'b1};
                    end

                    if ((row_idx == ARRAY_SIZE - 1) && current_valid) begin
                        result_buf[current_tag][col_idx] <= next_psum;
                        if (!result_seen[current_tag][col_idx]) begin
                            result_seen[current_tag][col_idx] <= 1'b1;
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

    // result_valid 只在当前整块矩阵结果全部到齐时拉高一个拍。
    assign result_valid = result_valid_reg;
    // busy 表示阵列还在装权重，或者已经开始计算但尚未完成。
    assign busy = weight_row_valid | (started_reg & ~done_reg);

endmodule
