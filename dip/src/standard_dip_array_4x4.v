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
    localparam integer ROW_INDEX_WIDTH = (ARRAY_SIZE > 1) ? $clog2(ARRAY_SIZE) : 1;

    wire                                output_row_valid;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0]     output_row_data;
    wire                                stream_busy;

    reg signed [ACC_WIDTH-1:0]          result_buf [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ROW_COUNT_WIDTH-1:0]           captured_rows;
    reg                                 result_valid_reg;
    reg                                 result_pending_reg;
    reg                                 started_reg;
    reg                                 done_reg;
    integer                             input_nonzero_count;
    integer                             weight_nonzero_count;

    integer row_idx;
    integer col_idx;
    integer density_idx;

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
        .input_row_valid(input_row_valid),
        .input_row_data(input_row_data),
        .output_row_valid(output_row_valid),
        .output_row_data(output_row_data),
        .busy(stream_busy)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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

            if (result_pending_reg) begin
                result_valid_reg <= 1'b1;
                result_pending_reg <= 1'b0;
                done_reg <= 1'b1;
            end

            if (input_row_valid) begin
                started_reg <= 1'b1;
            end

            // DiP 内核是逐行吐结果的；这里把每一行结果依次收集进 result_buf。
            if (output_row_valid && !done_reg && (captured_rows < ARRAY_SIZE)) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    result_buf[captured_rows[ROW_INDEX_WIDTH-1:0]][col_idx] <=
                        $signed(output_row_data[((col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]);
                end

                if (captured_rows == (ARRAY_SIZE - 1)) begin
                    result_pending_reg <= 1'b1;
                end

                captured_rows <= captured_rows + {{(ROW_COUNT_WIDTH-1){1'b0}}, 1'b1};
            end
        end
    end

    always @(*) begin
        input_nonzero_count = 0;
        weight_nonzero_count = 0;
        for (density_idx = 0; density_idx < ARRAY_SIZE; density_idx = density_idx + 1) begin
            if ($signed(input_row_data[((density_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH]) != 0) begin
                input_nonzero_count = input_nonzero_count + 1;
            end
            if ($signed(weight_row_data[((density_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH]) != 0) begin
                weight_nonzero_count = weight_nonzero_count + 1;
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
    // busy 同时覆盖：内部阵列仍忙、或整块结果尚未收齐。
    assign busy = stream_busy | (started_reg & ~done_reg);

    `ifdef FORMAL
        covergroup dip_flow_cg @(posedge clk);
            option.per_instance = 1;

            cp_weight_row_valid: coverpoint weight_row_valid {
                bins seen = {1'b1};
            }

            cp_input_row_valid: coverpoint input_row_valid {
                bins seen = {1'b1};
            }

            cp_output_row_valid: coverpoint output_row_valid {
                bins seen = {1'b1};
            }

            cp_result_valid: coverpoint result_valid_reg {
                bins seen = {1'b1};
            }

            cp_result_pending: coverpoint result_pending_reg {
                bins idle = {1'b0};
                bins pending = {1'b1};
            }

            cp_captured_rows: coverpoint captured_rows {
                bins none = {0};
                bins partial = {[1:ARRAY_SIZE-1]};
                bins full = {ARRAY_SIZE};
            }

            cp_input_density: coverpoint input_nonzero_count iff (input_row_valid) {
                bins zero = {0};
                bins sparse = {[1:2]};
                bins dense = {[3:ARRAY_SIZE]};
            }

            cp_weight_density: coverpoint weight_nonzero_count iff (weight_row_valid) {
                bins zero = {0};
                bins sparse = {[1:2]};
                bins dense = {[3:ARRAY_SIZE]};
            }

            cp_busy: coverpoint busy {
                bins idle = {1'b0};
                bins active = {1'b1};
            }

            cross cp_input_density, cp_weight_density;
        endgroup

        dip_flow_cg u_dip_flow_cg = new();

        cover property (@(posedge clk) input_row_valid ##[1:16] output_row_valid);
        cover property (@(posedge clk) output_row_valid ##[1:8] result_valid_reg);
    `endif

endmodule
