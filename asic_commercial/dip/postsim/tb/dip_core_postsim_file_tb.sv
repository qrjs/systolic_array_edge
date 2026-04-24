`timescale 1ns/1ps

module dip_core_postsim_file_tb;
    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;
    localparam integer ROW_COUNT_WIDTH = $clog2(ARRAY_SIZE + 1);

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

    reg [ROW_COUNT_WIDTH-1:0] captured_rows;

    integer row_idx;
    integer col_idx;
    integer timeout;
    integer failures;
    integer cycle_count;
    integer launch_cycle;
    integer done_cycle;
    integer case_cycles;
    string input_path = "";
    string expected_path = "";
    reg [1023:0] sdf_path;
    reg [1023:0] vcd_path;
    bit soft_fail_mode;

    reg signed [DATA_WIDTH-1:0] a_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_rot    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] expected_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] captured_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

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
            captured_rows <= '0;
            cycle_count <= 0;
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    captured_matrix[row_idx][col_idx] <= '0;
                end
            end
        end else begin
            cycle_count <= cycle_count + 1;
            if (flush) begin
                captured_rows <= '0;
                for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                    for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                        captured_matrix[row_idx][col_idx] <= '0;
                    end
                end
            end else if (output_row_valid && (captured_rows < ARRAY_SIZE)) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    captured_matrix[captured_rows][col_idx] <=
                        $signed(output_row_data[((col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]);
                end
                captured_rows <= captured_rows + {{(ROW_COUNT_WIDTH-1){1'b0}}, 1'b1};
            end
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
                $dumpvars(0, dip_core_postsim_file_tb);
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
        weight_row_valid = 1'b0;
        weight_row_idx = '0;
        weight_row_data = '0;
        input_row_valid = 1'b0;
        input_row_data = '0;
        timeout = 0;
        failures = 0;
        cycle_count = 0;
        launch_cycle = -1;
        done_cycle = -1;
        case_cycles = -1;

        read_input_txt(input_path);
        read_expected_txt(expected_path);
        print_case_context("DIP_CORE", input_path, expected_path);
        report_zero_skip_stats("DIP_CORE");

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                b_rot[row_idx][col_idx] = b_matrix[(row_idx + col_idx) % ARRAY_SIZE][col_idx];
            end
        end

        repeat (4) @(posedge clk);
`ifdef TB_GATE_MODE
        @(negedge clk);
        rst_n = 1'b1;
        weight_row_valid = 1'b0;
        weight_row_idx = '0;
        weight_row_data = '0;
        input_row_valid = 1'b0;
        input_row_data = '0;
        @(posedge clk);
        @(negedge clk);
`else
        rst_n = 1'b1;
`endif

        weight_row_valid = 1'b1;
        for (row_idx = ARRAY_SIZE - 1; row_idx > 0; row_idx = row_idx - 1) begin
            weight_row_idx = row_idx[$clog2(ARRAY_SIZE)-1:0];
            weight_row_data = {b_rot[row_idx][3], b_rot[row_idx][2], b_rot[row_idx][1], b_rot[row_idx][0]};
            input_row_valid = 1'b0;
            input_row_data = '0;
            @(posedge clk);
            @(negedge clk);
        end

        weight_row_idx = '0;
        weight_row_data = {b_rot[0][3], b_rot[0][2], b_rot[0][1], b_rot[0][0]};
        input_row_valid = 1'b1;
        input_row_data = {a_matrix[0][3], a_matrix[0][2], a_matrix[0][1], a_matrix[0][0]};
        launch_cycle = cycle_count + 1;
        @(posedge clk);
        @(negedge clk);

        weight_row_valid = 1'b0;
        weight_row_data = '0;

        for (row_idx = 1; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            input_row_valid = 1'b1;
            input_row_data = {a_matrix[row_idx][3], a_matrix[row_idx][2], a_matrix[row_idx][1], a_matrix[row_idx][0]};
            @(posedge clk);
            @(negedge clk);
        end

        input_row_valid = 1'b0;
        input_row_data = '0;

        while ((captured_rows < ARRAY_SIZE) && (timeout < 256)) begin
            @(posedge clk);
            timeout = timeout + 1;
        end

        if (captured_rows < ARRAY_SIZE) begin
            if (soft_fail_mode) begin
                $display("[DIP_CORE][FAIL] %0s reason=timeout", input_path);
                $finish;
            end else begin
                $fatal(1, "[DIP_CORE] timed out waiting for output rows");
            end
        end

        done_cycle = cycle_count;
        case_cycles = done_cycle - launch_cycle;
        $display("[DIP_CORE][CASE_METRIC] launch_cycle=%0d done_cycle=%0d cycles=%0d", launch_cycle, done_cycle, case_cycles);

        @(posedge clk);

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                reg signed [ACC_WIDTH-1:0] observed;
                observed = captured_matrix[row_idx][col_idx];
                report_cell_compare("DIP_CORE", row_idx, col_idx, expected_matrix[row_idx][col_idx], observed);
                if (observed !== expected_matrix[row_idx][col_idx]) begin
                    failures = failures + 1;
                end
            end
        end

        if (failures == 0) begin
            $display("[DIP_CORE][PASS] %0s", input_path);
            $finish;
        end else if (soft_fail_mode) begin
            $display("[DIP_CORE][FAIL] %0s failures=%0d", input_path, failures);
            $finish;
        end else begin
            $fatal(1, "[DIP_CORE] failures=%0d", failures);
        end
    end
endmodule
