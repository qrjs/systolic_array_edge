`timescale 1ns/1ps

module os_core_postsim_file_tb;
    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;

    reg clk;
    reg rst_n;
    reg flush;
    reg clk_enable;
    reg [ARRAY_SIZE-1:0] a_valid;
    reg [DATA_WIDTH*ARRAY_SIZE-1:0] a_data;
    reg [ARRAY_SIZE-1:0] b_valid;
    reg [WEIGHT_WIDTH*ARRAY_SIZE-1:0] b_data;

    wire result_valid;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix;
    wire busy;

    reg result_valid_q;
    reg [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix_q;
    integer cycle_count;
    integer launch_cycle;
    integer done_cycle;
    integer case_cycles;

    integer row_idx;
    integer col_idx;
    integer t;
    integer timeout;
    integer failures;
    string input_path = "";
    string expected_path = "";
    reg [1023:0] sdf_path;
    reg [1023:0] vcd_path;
    bit soft_fail_mode;

    reg signed [DATA_WIDTH-1:0] a_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] expected_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    `include "tb/common/txt_matrix_tasks.svh"

    os_core_std_top_4x4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .a_valid(a_valid),
        .a_data(a_data),
        .b_valid(b_valid),
        .b_data(b_data),
        .result_valid(result_valid),
        .result_matrix(result_matrix),
        .busy(busy)
    );

    always #5 clk = ~clk;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_valid_q <= 1'b0;
            result_matrix_q <= '0;
            cycle_count <= 0;
        end else begin
            result_valid_q <= result_valid;
            result_matrix_q <= result_matrix;
            cycle_count <= cycle_count + 1;
        end
    end

    initial begin
`ifndef TB_SKIP_SDF_ANNOTATE
        if ($value$plusargs("SDF=%s", sdf_path)) begin
            if (sdf_path != "") begin
                $sdf_annotate(sdf_path, dut, , , "MAXIMUM");
            end
        end
`endif
        if ($value$plusargs("VCD=%s", vcd_path)) begin
            if (vcd_path != "") begin
                $dumpfile(vcd_path);
                $dumpvars(0, os_core_postsim_file_tb);
            end
        end
    end

    initial begin
        if (!$value$plusargs("INPUT=%s", input_path)) begin
            $fatal(1, "Missing +INPUT=<path>");
        end
        if (!$value$plusargs("EXPECTED=%s", expected_path)) begin
            $fatal(1, "Missing +EXPECTED=<path>");
        end
        soft_fail_mode = $test$plusargs("SOFT_FAIL");

        clk = 1'b0;
        rst_n = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        a_valid = '0;
        a_data = '0;
        b_valid = '0;
        b_data = '0;
        timeout = 0;
        failures = 0;
        cycle_count = 0;
        launch_cycle = -1;
        done_cycle = -1;
        case_cycles = -1;

        read_input_txt(input_path);
        read_expected_txt(expected_path);
        print_case_context("OS_GATE", input_path, expected_path);
        report_zero_skip_stats("OS_GATE");

        repeat (4) @(posedge clk);
        rst_n = 1'b1;

        launch_cycle = cycle_count + 1;
        for (t = 0; t < (2 * ARRAY_SIZE) - 1; t = t + 1) begin
            reg [ARRAY_SIZE-1:0] a_valid_tmp;
            reg [DATA_WIDTH*ARRAY_SIZE-1:0] a_data_tmp;
            reg [ARRAY_SIZE-1:0] b_valid_tmp;
            reg [WEIGHT_WIDTH*ARRAY_SIZE-1:0] b_data_tmp;
            a_valid_tmp = '0;
            a_data_tmp = '0;
            b_valid_tmp = '0;
            b_data_tmp = '0;
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                integer k_a;
                k_a = t - row_idx;
                if ((k_a >= 0) && (k_a < ARRAY_SIZE)) begin
                    a_valid_tmp[row_idx] = 1'b1;
                    a_data_tmp[((row_idx + 1) * DATA_WIDTH) - 1 -: DATA_WIDTH] = a_matrix[row_idx][k_a];
                end
            end
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                integer k_b;
                k_b = t - col_idx;
                if ((k_b >= 0) && (k_b < ARRAY_SIZE)) begin
                    b_valid_tmp[col_idx] = 1'b1;
                    b_data_tmp[((col_idx + 1) * WEIGHT_WIDTH) - 1 -: WEIGHT_WIDTH] = b_matrix[k_b][col_idx];
                end
            end
            a_valid = a_valid_tmp;
            a_data = a_data_tmp;
            b_valid = b_valid_tmp;
            b_data = b_data_tmp;
            @(posedge clk);
        end
        a_valid = '0;
        a_data = '0;
        b_valid = '0;
        b_data = '0;

        while (!result_valid_q && (timeout < 128)) begin
            @(posedge clk);
            timeout = timeout + 1;
        end

        if (!result_valid_q) begin
            if (soft_fail_mode) begin
                $display("[OS_GATE][FAIL] %0s reason=timeout", input_path);
                $finish;
            end else begin
                $fatal(1, "[OS_GATE] timed out waiting for result_valid");
            end
        end

        done_cycle = cycle_count;
        case_cycles = done_cycle - launch_cycle;
        $display("[OS_GATE][CASE_METRIC] launch_cycle=%0d done_cycle=%0d cycles=%0d", launch_cycle, done_cycle, case_cycles);

        @(posedge clk);

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                reg signed [ACC_WIDTH-1:0] observed;
                observed = result_matrix_q[((row_idx * ARRAY_SIZE + col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH];
                report_cell_compare("OS_GATE", row_idx, col_idx, expected_matrix[row_idx][col_idx], observed);
                if (observed !== expected_matrix[row_idx][col_idx]) begin
                    failures = failures + 1;
                end
            end
        end

        if (failures == 0) begin
            $display("[OS_GATE][PASS] %0s", input_path);
            $finish;
        end else if (soft_fail_mode) begin
            $display("[OS_GATE][FAIL] %0s failures=%0d", input_path, failures);
            $finish;
        end else begin
            $fatal(1, "[OS_GATE] failures=%0d", failures);
        end
    end
endmodule
