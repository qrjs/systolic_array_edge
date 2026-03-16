`timescale 1ns/1ps

// OS（Output Stationary）标准 4x4 阵列。
// 设计意图：A 沿行方向传播，B 沿列方向传播，
// 每个 PE 在本地维护自己的输出累加值 acc，不再把部分和继续向外传递。
module standard_os_array_4x4 #(
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

    localparam integer TOTAL_RESULTS = ARRAY_SIZE * ARRAY_SIZE;
    localparam integer RESULT_COUNT_WIDTH = $clog2(TOTAL_RESULTS + 1);
    localparam integer ACCUM_COUNT_WIDTH = $clog2(ARRAY_SIZE + 1);

    // a_pipe / b_pipe：分别表示 A、B 在阵列中的流动状态。
    // acc：每个 PE 本地保存的输出累加值，是 OS 数据流最关键的状态。
    reg signed [DATA_WIDTH-1:0]   a_pipe       [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_pipe       [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           a_valid_pipe [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           b_valid_pipe [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0]    acc          [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ACCUM_COUNT_WIDTH-1:0]   accum_count  [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg                           cell_done    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    reg [RESULT_COUNT_WIDTH-1:0]  done_count;
    reg                           result_valid_reg;
    reg                           started_reg;
    reg                           done_reg;

    integer row_idx;
    integer col_idx;
    integer new_done_cells;
    reg signed [DATA_WIDTH-1:0] current_a;
    reg signed [WEIGHT_WIDTH-1:0] current_b;
    reg current_a_valid;
    reg current_b_valid;
    reg signed [ACC_WIDTH-1:0] next_acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // OS 每拍推进整个阵列：
            // 1) A 从左向右推进，B 从上向下推进；
            // 2) 只有当同一个 PE 同拍拿到有效的 A/B 时，才更新本地 acc；
            // 3) 每个单元独立统计自己已经累加了多少次，用于判断整块结果是否完成。
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    a_pipe[row_idx][col_idx] <= {DATA_WIDTH{1'b0}};
                    b_pipe[row_idx][col_idx] <= {WEIGHT_WIDTH{1'b0}};
                    a_valid_pipe[row_idx][col_idx] <= 1'b0;
                    b_valid_pipe[row_idx][col_idx] <= 1'b0;
                    acc[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    accum_count[row_idx][col_idx] <= {ACCUM_COUNT_WIDTH{1'b0}};
                    cell_done[row_idx][col_idx] <= 1'b0;
                end
            end
            done_count <= {RESULT_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
        end else if (flush) begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    a_pipe[row_idx][col_idx] <= {DATA_WIDTH{1'b0}};
                    b_pipe[row_idx][col_idx] <= {WEIGHT_WIDTH{1'b0}};
                    a_valid_pipe[row_idx][col_idx] <= 1'b0;
                    b_valid_pipe[row_idx][col_idx] <= 1'b0;
                    acc[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                    accum_count[row_idx][col_idx] <= {ACCUM_COUNT_WIDTH{1'b0}};
                    cell_done[row_idx][col_idx] <= 1'b0;
                end
            end
            done_count <= {RESULT_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
        end else if (clk_enable) begin
            result_valid_reg <= 1'b0;
            new_done_cells = 0;

            if ((|a_valid) || (|b_valid)) begin
                started_reg <= 1'b1;
            end

            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if (col_idx == 0) begin
                        current_a = $signed(a_data[((row_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH]);
                        current_a_valid = a_valid[row_idx];
                    end else begin
                        current_a = a_pipe[row_idx][col_idx - 1];
                        current_a_valid = a_valid_pipe[row_idx][col_idx - 1];
                    end

                    if (row_idx == 0) begin
                        current_b = $signed(b_data[((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]);
                        current_b_valid = b_valid[col_idx];
                    end else begin
                        current_b = b_pipe[row_idx - 1][col_idx];
                        current_b_valid = b_valid_pipe[row_idx - 1][col_idx];
                    end

                    // 低翻转优化：仅在 valid=1 时推进 A/B 数据；无效时保持数据寄存器不变。
                    if (current_a_valid) begin
                        a_pipe[row_idx][col_idx] <= current_a;
                        a_valid_pipe[row_idx][col_idx] <= 1'b1;
                    end else begin
                        a_valid_pipe[row_idx][col_idx] <= 1'b0;
                    end

                    if (current_b_valid) begin
                        b_pipe[row_idx][col_idx] <= current_b;
                        b_valid_pipe[row_idx][col_idx] <= 1'b1;
                    end else begin
                        b_valid_pipe[row_idx][col_idx] <= 1'b0;
                    end

                    if (current_a_valid && current_b_valid) begin
                        // 低功耗优化：OS 中虽然每个输出单元都必须经历 ARRAY_SIZE 次“到达事件”，
                        // 但若当前 A/B 任一操作数为 0，就不必真正切换乘法器与加法器；
                        // 仍然要推进 accum_count，保证完成判定与功能时序不变。
                        next_acc = acc[row_idx][col_idx];
                        if ((current_a != 0) && (current_b != 0)) begin
                            next_acc = acc[row_idx][col_idx] + (current_a * current_b);
                        end
                        acc[row_idx][col_idx] <= next_acc;
                        if (accum_count[row_idx][col_idx] < ARRAY_SIZE[ACCUM_COUNT_WIDTH-1:0]) begin
                            accum_count[row_idx][col_idx] <= accum_count[row_idx][col_idx] + {{(ACCUM_COUNT_WIDTH-1){1'b0}}, 1'b1};
                            if ((accum_count[row_idx][col_idx] + {{(ACCUM_COUNT_WIDTH-1){1'b0}}, 1'b1}) ==
                                ARRAY_SIZE[ACCUM_COUNT_WIDTH-1:0]) begin
                                if (!cell_done[row_idx][col_idx]) begin
                                    cell_done[row_idx][col_idx] <= 1'b1;
                                    new_done_cells = new_done_cells + 1;
                                end
                            end
                        end
                    end
                end
            end

            if (new_done_cells != 0) begin
                done_count <= done_count + new_done_cells[RESULT_COUNT_WIDTH-1:0];
                if ((done_count + new_done_cells[RESULT_COUNT_WIDTH-1:0]) == TOTAL_RESULTS[RESULT_COUNT_WIDTH-1:0]) begin
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
                    acc[out_row][out_col];
            end
        end
    endgenerate

    // result_valid 在所有输出单元都完成 ARRAY_SIZE 次乘加后拉高。
    assign result_valid = result_valid_reg;
    // busy 表示仍有输入流在推进，或者本次矩阵乘还没有完全结束。
    assign busy = (|a_valid) | (|b_valid) | (started_reg & ~done_reg);

endmodule
