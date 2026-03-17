`timescale 1ns/1ps

// DiP 标准顶层包装。
// 对外暴露的是“按行输入、整块结果输出”的接口，
// 对内则调用真正的 DiP 流式阵列，并在输入结束后自动补一拍 drain。
module standard_dip_array_4x4 #(
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
    input  wire                                       input_row_valid,
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0]           input_row_data,
    output wire                                       result_valid,
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix,
    output wire                                       busy
);

    localparam integer ROW_COUNT_WIDTH = $clog2(ARRAY_SIZE + 1);

    // prev_input_row_valid：用于检测输入流是否刚刚结束。
    // drain_pending_reg / drain_issued_reg：在输入结束后自动补一拍全 0，
    // 让阵列内部剩余 token 能完整流出。这个 drain 逻辑放在 RTL，而不是 testbench。
    reg                                 prev_input_row_valid;
    reg                                 drain_pending_reg;
    reg                                 drain_issued_reg;
    reg                                 stream_input_row_valid;
    reg [DATA_WIDTH*ARRAY_SIZE-1:0]     stream_input_row_data;

    wire                                output_row_valid;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0]     output_row_data;
    wire                                stream_busy;

    reg signed [ACC_WIDTH-1:0]          result_buf [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ROW_COUNT_WIDTH-1:0]           captured_rows;
    reg                                 result_valid_reg;
    reg                                 result_pending_reg;
    reg                                 started_reg;
    reg                                 done_reg;

    integer row_idx;
    integer col_idx;

    systolic_array_dip_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) u_stream_dip (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .weight_row_valid(weight_row_valid),
        .weight_row_idx(weight_row_idx),
        .weight_row_data(weight_row_data),
        .input_row_valid(stream_input_row_valid),
        .input_row_data(stream_input_row_data),
        .output_row_valid(output_row_valid),
        .output_row_data(output_row_data),
        .busy(stream_busy)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_input_row_valid <= 1'b0;
            drain_pending_reg <= 1'b0;
            drain_issued_reg <= 1'b0;
            stream_input_row_valid <= 1'b0;
            stream_input_row_data <= {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
            captured_rows <= {ROW_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            result_pending_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    result_buf[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                end
            end
        end else if (flush) begin
            prev_input_row_valid <= 1'b0;
            drain_pending_reg <= 1'b0;
            drain_issued_reg <= 1'b0;
            stream_input_row_valid <= 1'b0;
            stream_input_row_data <= {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
            captured_rows <= {ROW_COUNT_WIDTH{1'b0}};
            result_valid_reg <= 1'b0;
            result_pending_reg <= 1'b0;
            started_reg <= 1'b0;
            done_reg <= 1'b0;
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    result_buf[row_idx][col_idx] <= {ACC_WIDTH{1'b0}};
                end
            end
        end else if (clk_enable) begin
            result_valid_reg <= 1'b0;
            prev_input_row_valid <= input_row_valid;

            if (result_pending_reg) begin
                result_valid_reg <= 1'b1;
                result_pending_reg <= 1'b0;
                done_reg <= 1'b1;
            end

            // 输入结束后的下一拍自动注入一行 0，用于把阵列里的最后结果冲出来。
            if (drain_pending_reg) begin
                stream_input_row_valid <= 1'b1;
                stream_input_row_data <= {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
                drain_pending_reg <= 1'b0;
                drain_issued_reg <= 1'b1;
            end else begin
                stream_input_row_valid <= input_row_valid;
                if (input_row_valid) begin
                    // 对于边缘场景下大量空拍输入，让数据总线在 invalid 周期保持稳定，
                    // 避免把无效 input_row_data 的切换传播到 DiP 内核。
                    stream_input_row_data <= input_row_data;
                end
                if (!input_row_valid && prev_input_row_valid && started_reg && !done_reg && !drain_issued_reg) begin
                    drain_pending_reg <= 1'b1;
                end
            end

            if (stream_input_row_valid) begin
                started_reg <= 1'b1;
            end

            // DiP 内核是逐行吐结果的；这里把每一行结果依次收集进 result_buf。
            if (output_row_valid && !done_reg && (captured_rows < ARRAY_SIZE)) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    result_buf[captured_rows][col_idx] <=
                        $signed(output_row_data[((col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]);
                end

                if (captured_rows == (ARRAY_SIZE - 1)) begin
                    result_pending_reg <= 1'b1;
                end

                captured_rows <= captured_rows + {{(ROW_COUNT_WIDTH-1){1'b0}}, 1'b1};
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

    // result_valid 表示 result_buf 中已经收齐完整矩阵。
    assign result_valid = result_valid_reg;
    // busy 同时覆盖：内部阵列仍忙、drain 尚未完成、或整块结果尚未收齐。
    assign busy = stream_busy | drain_pending_reg | (started_reg & ~done_reg);

endmodule
