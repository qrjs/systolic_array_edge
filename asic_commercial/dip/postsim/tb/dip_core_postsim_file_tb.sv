`timescale 1ns/1ps

module dip_core_postsim_file_tb;
    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;

    reg clk;
    reg rst_n;
    reg flush;
    reg clk_enable;
    reg weight_row_valid;
    reg [$clog2(ARRAY_SIZE)-1:0] weight_row_idx;
    reg [WEIGHT_WIDTH*ARRAY_SIZE-1:0] weight_row_data;
    reg input_row_valid;
    reg [DATA_WIDTH*ARRAY_SIZE-1:0] input_row_data;

    wire output_row_valid;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_row_data;
    wire busy;

    integer row_idx;
    integer col_idx;
    integer timeout;
    integer failures;
    integer candidate_count;
    integer match_start;
    integer matched_start;
    integer matched;
    string input_path;
    string expected_path;
    string sdf_path;

    reg signed [DATA_WIDTH-1:0] a_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_rot    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] expected_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg output_row_valid_q;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] output_row_data_q;
    reg signed [ACC_WIDTH-1:0] candidate_rows [0:15][0:ARRAY_SIZE-1];

    `include "tb/common/txt_matrix_tasks.svh"

    dip_core_top_4x4 dut (
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
        .busy(busy)
    );

    always #5 clk = ~clk;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_row_valid_q <= 1'b0;
            output_row_data_q <= '0;
        end else begin
            output_row_valid_q <= output_row_valid;
            output_row_data_q <= output_row_data;
        end
    end

    initial begin
        if ($value$plusargs("SDF=%s", sdf_path)) begin
            if (sdf_path != "") begin
                $display("[DIP_GATE][SDF] %0s", sdf_path);
                $sdf_annotate(sdf_path, dut, , , "MAXIMUM");
            end
        end
    end

    task automatic drive_case;
        begin
            weight_row_valid = 1'b1;
            for (row_idx = ARRAY_SIZE - 1; row_idx > 0; row_idx = row_idx - 1) begin
                weight_row_idx = row_idx[$clog2(ARRAY_SIZE)-1:0];
                weight_row_data = {b_rot[row_idx][3], b_rot[row_idx][2], b_rot[row_idx][1], b_rot[row_idx][0]};
                input_row_valid = 1'b0;
                input_row_data = '0;
                @(posedge clk);
            end

            weight_row_idx = '0;
            weight_row_data = {b_rot[0][3], b_rot[0][2], b_rot[0][1], b_rot[0][0]};
            input_row_valid = 1'b1;
            input_row_data = {a_matrix[0][3], a_matrix[0][2], a_matrix[0][1], a_matrix[0][0]};
            @(posedge clk);

            weight_row_valid = 1'b0;
            weight_row_data = '0;

            for (row_idx = 1; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                input_row_valid = 1'b1;
                input_row_data = {a_matrix[row_idx][3], a_matrix[row_idx][2], a_matrix[row_idx][1], a_matrix[row_idx][0]};
                @(posedge clk);
            end

            // 手动补一拍 0，冲出阵列最后一行结果。
            input_row_valid = 1'b1;
            input_row_data = '0;
            @(posedge clk);

            input_row_valid = 1'b0;
            input_row_data = '0;
        end
    endtask

    task automatic append_candidate_row(
        input [ACC_WIDTH*ARRAY_SIZE-1:0] row_data
    );
        integer append_col;
        reg same_as_previous;
        begin
            same_as_previous = 1'b0;
            if (candidate_count > 0) begin
                same_as_previous = 1'b1;
                for (append_col = 0; append_col < ARRAY_SIZE; append_col = append_col + 1) begin
                    if (candidate_rows[candidate_count - 1][append_col] !==
                        $signed(row_data[((append_col + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH])) begin
                        same_as_previous = 1'b0;
                    end
                end
            end

            if (!same_as_previous && (candidate_count < 16)) begin
                for (append_col = 0; append_col < ARRAY_SIZE; append_col = append_col + 1) begin
                    candidate_rows[candidate_count][append_col] =
                        $signed(row_data[((append_col + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]);
                end
                candidate_count = candidate_count + 1;
            end
        end
    endtask

    initial begin
        if (!$value$plusargs("INPUT=%s", input_path)) begin
            $fatal(1, "Missing +INPUT=<path>");
        end
        if (!$value$plusargs("EXPECTED=%s", expected_path)) begin
            $fatal(1, "Missing +EXPECTED=<path>");
        end

        clk = 1'b0;
        rst_n = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        weight_row_valid = 1'b0;
        weight_row_idx = '0;
        weight_row_data = '0;
        input_row_valid = 1'b0;
        input_row_data = '0;
        timeout = 0;
        failures = 0;
        candidate_count = 0;
        matched_start = -1;
        matched = 0;

        read_input_txt(input_path);
        read_expected_txt(expected_path);
        print_case_context("DIP_GATE", input_path, expected_path);
        report_zero_skip_stats("DIP_GATE");

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                b_rot[row_idx][col_idx] = b_matrix[(row_idx + col_idx) % ARRAY_SIZE][col_idx];
            end
        end

        repeat (4) @(posedge clk);
        rst_n = 1'b1;

        flush = 1'b1;
        @(posedge clk);
        flush = 1'b0;

        drive_case();

        while ((candidate_count < 8) && (timeout < 256)) begin
            @(posedge clk);
            timeout = timeout + 1;

            if (output_row_valid_q) begin
                append_candidate_row(output_row_data_q);
            end
            if (output_row_valid) begin
                append_candidate_row(output_row_data);
            end
        end

        for (match_start = 0; match_start <= candidate_count - ARRAY_SIZE; match_start = match_start + 1) begin
            integer row_match;
            integer search_row;
            integer search_col;
            row_match = 1;
            for (search_row = 0; search_row < ARRAY_SIZE; search_row = search_row + 1) begin
                for (search_col = 0; search_col < ARRAY_SIZE; search_col = search_col + 1) begin
                    if (candidate_rows[match_start + search_row][search_col] !== expected_matrix[search_row][search_col]) begin
                        row_match = 0;
                    end
                end
            end
            if (row_match == 1) begin
                matched = 1;
                matched_start = match_start;
            end
        end

        if (!matched) begin
            $display("[DIP_GATE] candidate_count=%0d", candidate_count);
            for (row_idx = 0; row_idx < candidate_count; row_idx = row_idx + 1) begin
                $display(
                    "[DIP_GATE] candidate_row[%0d] = %0d %0d %0d %0d",
                    row_idx,
                    candidate_rows[row_idx][0],
                    candidate_rows[row_idx][1],
                    candidate_rows[row_idx][2],
                    candidate_rows[row_idx][3]
                );
            end
            $fatal(1, "[DIP_GATE] failed to match expected 4-row output window");
        end

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                reg signed [ACC_WIDTH-1:0] observed;
                observed = candidate_rows[matched_start + row_idx][col_idx];
                report_cell_compare("DIP_GATE", row_idx, col_idx, expected_matrix[row_idx][col_idx], observed);
                if (observed !== expected_matrix[row_idx][col_idx]) begin
                    failures = failures + 1;
                end
            end
        end

        if (failures != 0) begin
            $fatal(1, "[DIP_GATE] failures=%0d", failures);
        end

        $display("[DIP_GATE][PASS] %0s", input_path);
        $finish;
    end
endmodule
