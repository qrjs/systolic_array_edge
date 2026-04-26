`timescale 1ns/1ps

module dip_core_std_postsim_file_tb;
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

    wire result_valid;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix;
    wire busy;

    reg result_valid_q;
    reg [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix_q;

    integer row_idx;
    integer col_idx;
    integer timeout;
    integer failures;
    integer cycle_count;
    integer launch_cycle;
    integer done_cycle;
    integer case_cycles;
    integer capture_row_idx;
    integer capture_col_idx;
    string input_path = "";
    string expected_path = "";
    reg [1023:0] sdf_path;
    reg [1023:0] vcd_path;
    reg [1023:0] trace_path;
    integer trace_fd;
    bit soft_fail_mode;

    reg signed [DATA_WIDTH-1:0] a_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_rot    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] expected_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ROW_COUNT_WIDTH-1:0] gate_stream_rows_captured;
    reg [ROW_COUNT_WIDTH-1:0] gate_stream_completed_rows_q;
    reg signed [ACC_WIDTH-1:0] gate_stream_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    `include "tb/common/txt_matrix_tasks.svh"

    dip_core_std_top_4x4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush),
        .clk_enable(clk_enable),
        .weight_row_valid(weight_row_valid),
        .weight_row_idx(weight_row_idx),
        .weight_row_data(weight_row_data),
        .input_row_valid(input_row_valid),
        .input_row_data(input_row_data),
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

`ifdef TB_DIP_STREAM_CAPTURE
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gate_stream_rows_captured <= '0;
            gate_stream_completed_rows_q <= '0;
            for (capture_row_idx = 0; capture_row_idx < ARRAY_SIZE; capture_row_idx = capture_row_idx + 1) begin
                for (capture_col_idx = 0; capture_col_idx < ARRAY_SIZE; capture_col_idx = capture_col_idx + 1) begin
                    gate_stream_matrix[capture_row_idx][capture_col_idx] <= '0;
                end
            end
        end else if (flush) begin
            gate_stream_rows_captured <= '0;
            gate_stream_completed_rows_q <= '0;
            for (capture_row_idx = 0; capture_row_idx < ARRAY_SIZE; capture_row_idx = capture_row_idx + 1) begin
                for (capture_col_idx = 0; capture_col_idx < ARRAY_SIZE; capture_col_idx = capture_col_idx + 1) begin
                    gate_stream_matrix[capture_row_idx][capture_col_idx] <= '0;
                end
            end
        end else if (dut.u_dip_std_array.u_stream_dip.completed_output_rows != gate_stream_completed_rows_q) begin
            gate_stream_completed_rows_q <= dut.u_dip_std_array.u_stream_dip.completed_output_rows;
            gate_stream_rows_captured <= dut.u_dip_std_array.u_stream_dip.completed_output_rows;
            if ((dut.u_dip_std_array.u_stream_dip.completed_output_rows > 0) &&
                (dut.u_dip_std_array.u_stream_dip.completed_output_rows <= ARRAY_SIZE[ROW_COUNT_WIDTH-1:0])) begin
                capture_row_idx = dut.u_dip_std_array.u_stream_dip.completed_output_rows - 1;
                for (capture_col_idx = 0; capture_col_idx < ARRAY_SIZE; capture_col_idx = capture_col_idx + 1) begin
                    gate_stream_matrix[capture_row_idx][capture_col_idx] <=
                        $signed(dut.u_dip_std_array.output_row_data[((capture_col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]);
                end
            end
        end
    end
`endif

    initial begin
        trace_fd = 0;
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
                $dumpvars(0, dip_core_std_postsim_file_tb);
            end
        end
        if ($value$plusargs("TRACE=%s", trace_path)) begin
            if (trace_path != "") begin
                trace_fd = $fopen(trace_path, "w");
                if (trace_fd != 0) begin
`ifdef TB_DIP_INTERNAL_TRACE
                    $fdisplay(trace_fd, "cycle rst_n flush wv iv rv rv_q busy wrapper_ov wrapper_stream_busy wrapper_captured_rows wrapper_result_pending wrapper_started stream_bottom_valid stream_staged_input stream_drain accepted_rows completed_rows stream_output_data result_matrix_q");
`else
                    $fdisplay(trace_fd, "cycle rst_n flush wv iv rv rv_q busy result_matrix_q");
`endif
                end
            end
        end
    end

    always @(posedge clk) begin
        if (trace_fd != 0) begin
`ifdef TB_DIP_INTERNAL_TRACE
            $fdisplay(
                trace_fd,
                "%0d %0b %0b %0b %0b %0b %0b %0b %0b %0b %0d %0b %0b %0b %0b %0d %0d %h %h",
                cycle_count,
                rst_n,
                flush,
                weight_row_valid,
                input_row_valid,
                result_valid,
                result_valid_q,
                busy,
                dut.u_dip_std_array.output_row_valid,
                dut.u_dip_std_array.stream_busy,
                dut.u_dip_std_array.captured_rows,
                dut.u_dip_std_array.result_pending_reg,
                dut.u_dip_std_array.started_reg,
                dut.u_dip_std_array.u_stream_dip.bottom_row_valid,
                dut.u_dip_std_array.u_stream_dip.staged_input_valid,
                dut.u_dip_std_array.u_stream_dip.drain_issued_reg,
                dut.u_dip_std_array.u_stream_dip.accepted_input_rows,
                dut.u_dip_std_array.u_stream_dip.completed_output_rows,
                dut.u_dip_std_array.output_row_data,
                result_matrix_q
            );
`else
            $fdisplay(
                trace_fd,
                "%0d %0b %0b %0b %0b %0b %0b %0b %h",
                cycle_count,
                rst_n,
                flush,
                weight_row_valid,
                input_row_valid,
                result_valid,
                result_valid_q,
                busy,
                result_matrix_q
            );
`endif
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
        gate_stream_rows_captured = '0;
        gate_stream_completed_rows_q = '0;
        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                gate_stream_matrix[row_idx][col_idx] = '0;
            end
        end

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
        @(negedge clk);
        rst_n = 1'b1;

        weight_row_valid = 1'b1;
        for (row_idx = ARRAY_SIZE - 1; row_idx > 0; row_idx = row_idx - 1) begin
            weight_row_idx = row_idx[$clog2(ARRAY_SIZE)-1:0];
            weight_row_data = {b_rot[row_idx][3], b_rot[row_idx][2], b_rot[row_idx][1], b_rot[row_idx][0]};
            input_row_valid = 1'b0;
            input_row_data = '0;
            @(posedge clk);
            @(negedge clk);
        end

`ifdef TB_GATE_SAFE_INPUT_LAUNCH
        // Gate-level VCS needs one clean cycle to commit the final weight row,
        // but the four input rows must still launch as one contiguous burst.
        weight_row_idx = '0;
        weight_row_data = {b_rot[0][3], b_rot[0][2], b_rot[0][1], b_rot[0][0]};
        input_row_valid = 1'b0;
        input_row_data = '0;
        @(posedge clk);
        #1;
        weight_row_valid = 1'b0;
        weight_row_data = '0;
        input_row_valid = 1'b1;
        input_row_data = {a_matrix[0][3], a_matrix[0][2], a_matrix[0][1], a_matrix[0][0]};
        launch_cycle = cycle_count + 1;
        @(posedge clk);
        @(negedge clk);
`else
        weight_row_idx = '0;
        weight_row_data = {b_rot[0][3], b_rot[0][2], b_rot[0][1], b_rot[0][0]};
        input_row_valid = 1'b1;
        input_row_data = {a_matrix[0][3], a_matrix[0][2], a_matrix[0][1], a_matrix[0][0]};
        launch_cycle = cycle_count + 1;
        @(posedge clk);
        @(negedge clk);

        weight_row_valid = 1'b0;
        weight_row_data = '0;
`endif

        for (row_idx = 1; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            input_row_valid = 1'b1;
            input_row_data = {a_matrix[row_idx][3], a_matrix[row_idx][2], a_matrix[row_idx][1], a_matrix[row_idx][0]};
            @(posedge clk);
            @(negedge clk);
        end

        input_row_valid = 1'b0;
        input_row_data = '0;

`ifdef TB_DIP_STREAM_CAPTURE
        while ((gate_stream_rows_captured < ARRAY_SIZE[ROW_COUNT_WIDTH-1:0]) && (timeout < 256)) begin
            @(negedge clk);
            timeout = timeout + 1;
        end
`else
        while (!result_valid_q && (timeout < 256)) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
`endif

`ifdef TB_DIP_STREAM_CAPTURE
        if (gate_stream_rows_captured < ARRAY_SIZE[ROW_COUNT_WIDTH-1:0]) begin
            if (soft_fail_mode) begin
                $display("[DIP_CORE][FAIL] %0s reason=timeout", input_path);
                $finish;
            end else begin
                $fatal(1, "[DIP_CORE] timed out waiting for output rows");
            end
        end
`else
        if (!result_valid_q) begin
            if (soft_fail_mode) begin
                $display("[DIP_CORE][FAIL] %0s reason=timeout", input_path);
                $finish;
            end else begin
                $fatal(1, "[DIP_CORE] timed out waiting for result_valid");
            end
        end
`endif

        done_cycle = cycle_count;
        case_cycles = done_cycle - launch_cycle;
        $display("[DIP_CORE][CASE_METRIC] launch_cycle=%0d done_cycle=%0d cycles=%0d", launch_cycle, done_cycle, case_cycles);

`ifndef TB_DIP_STREAM_CAPTURE
        @(posedge clk);
        @(posedge clk);
`endif

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                reg signed [ACC_WIDTH-1:0] observed;
`ifdef TB_DIP_STREAM_CAPTURE
                observed = gate_stream_matrix[row_idx][col_idx];
`else
                observed = result_matrix_q[((row_idx * ARRAY_SIZE + col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH];
`endif
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
