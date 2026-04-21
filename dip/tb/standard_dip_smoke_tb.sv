`timescale 1ns/1ps

module standard_dip_smoke_tb;
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

    wire result_valid;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix;
    wire busy;

    integer row_idx;
    integer col_idx;
    integer timeout;
    integer total_failures;
    integer case_failures;
    integer case_id;
    integer k_idx;
    integer acc_value;

    reg result_valid_q;
    reg [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] result_matrix_q;

    reg signed [DATA_WIDTH-1:0] a_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [WEIGHT_WIDTH-1:0] b_rot    [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg signed [ACC_WIDTH-1:0] expected_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    standard_dip_array_4x4 dut (
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
        end else begin
            result_valid_q <= result_valid;
            result_matrix_q <= result_matrix;
        end
    end

    task clear_matrices;
        begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    a_matrix[row_idx][col_idx] = '0;
                    b_matrix[row_idx][col_idx] = '0;
                    b_rot[row_idx][col_idx] = '0;
                    expected_matrix[row_idx][col_idx] = '0;
                end
            end
        end
    endtask

    task compute_expected;
        begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    acc_value = 0;
                    for (k_idx = 0; k_idx < ARRAY_SIZE; k_idx = k_idx + 1) begin
                        acc_value = acc_value + (a_matrix[row_idx][k_idx] * b_matrix[k_idx][col_idx]);
                    end
                    expected_matrix[row_idx][col_idx] = acc_value;
                end
            end
        end
    endtask

    task compute_rotated_weights;
        begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    b_rot[row_idx][col_idx] = b_matrix[(row_idx + col_idx) % ARRAY_SIZE][col_idx];
                end
            end
        end
    endtask

    task apply_flush;
        begin
            flush = 1'b1;
            weight_row_valid = 1'b0;
            input_row_valid = 1'b0;
            weight_row_idx = '0;
            weight_row_data = '0;
            input_row_data = '0;
            @(posedge clk);
            flush = 1'b0;
        end
    endtask

    task drive_case_overlap;
        begin
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
        end
    endtask

    task drive_case_no_overlap;
        begin
            weight_row_valid = 1'b1;
            for (row_idx = ARRAY_SIZE - 1; row_idx >= 0; row_idx = row_idx - 1) begin
                weight_row_idx = row_idx[$clog2(ARRAY_SIZE)-1:0];
                weight_row_data = {b_rot[row_idx][3], b_rot[row_idx][2], b_rot[row_idx][1], b_rot[row_idx][0]};
                input_row_valid = 1'b0;
                input_row_data = '0;
                @(posedge clk);
                @(negedge clk);
            end

            weight_row_valid = 1'b0;
            weight_row_data = '0;

            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                input_row_valid = 1'b1;
                input_row_data = {a_matrix[row_idx][3], a_matrix[row_idx][2], a_matrix[row_idx][1], a_matrix[row_idx][0]};
                @(posedge clk);
                @(negedge clk);
            end

            input_row_valid = 1'b0;
            input_row_data = '0;
        end
    endtask

    task wait_and_check_result;
        reg signed [ACC_WIDTH-1:0] observed;
        begin
            timeout = 0;
            case_failures = 0;

            while (!result_valid_q && (timeout < 128)) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            if (!result_valid_q) begin
                $display("[DIP_SMOKE][FAIL] case=%0d timed out waiting for result_valid", case_id);
                total_failures = total_failures + 1;
            end else begin
                @(posedge clk);
                @(posedge clk);
                for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                    for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                        observed = result_matrix[((row_idx * ARRAY_SIZE + col_idx + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH];
                        if (observed !== expected_matrix[row_idx][col_idx]) begin
                            $display("[DIP_SMOKE][FAIL] case=%0d row=%0d col=%0d got=%0d expected=%0d",
                                case_id, row_idx, col_idx, observed, expected_matrix[row_idx][col_idx]);
                            case_failures = case_failures + 1;
                        end
                    end
                end

                if (case_failures == 0) begin
                    $display("[DIP_SMOKE][PASS] case=%0d", case_id);
                end
                total_failures = total_failures + case_failures;
            end
        end
    endtask

    task load_case_identity;
        begin
            clear_matrices();
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    a_matrix[row_idx][col_idx] = (row_idx * ARRAY_SIZE) + col_idx + 1;
                    b_matrix[row_idx][col_idx] = (row_idx == col_idx) ? 1 : 0;
                end
            end
        end
    endtask

    task load_case_signed_mix;
        begin
            clear_matrices();
            a_matrix[0][0] = 3;   a_matrix[0][1] = -2;  a_matrix[0][2] = 1;   a_matrix[0][3] = 4;
            a_matrix[1][0] = -1;  a_matrix[1][1] = 5;   a_matrix[1][2] = -3;  a_matrix[1][3] = 2;
            a_matrix[2][0] = 6;   a_matrix[2][1] = 0;   a_matrix[2][2] = -2;  a_matrix[2][3] = 1;
            a_matrix[3][0] = 2;   a_matrix[3][1] = -4;  a_matrix[3][2] = 3;   a_matrix[3][3] = -1;

            b_matrix[0][0] = 1;   b_matrix[0][1] = -2;  b_matrix[0][2] = 0;   b_matrix[0][3] = 3;
            b_matrix[1][0] = 4;   b_matrix[1][1] = 1;   b_matrix[1][2] = -1;  b_matrix[1][3] = 2;
            b_matrix[2][0] = -3;  b_matrix[2][1] = 2;   b_matrix[2][2] = 5;   b_matrix[2][3] = -2;
            b_matrix[3][0] = 0;   b_matrix[3][1] = -1;  b_matrix[3][2] = 2;   b_matrix[3][3] = 1;
        end
    endtask

    task load_case_sparse_signed;
        begin
            clear_matrices();
            a_matrix[0][0] = 7;   a_matrix[0][1] = 0;   a_matrix[0][2] = 0;   a_matrix[0][3] = -1;
            a_matrix[1][0] = 0;   a_matrix[1][1] = 0;   a_matrix[1][2] = 0;   a_matrix[1][3] = 0;
            a_matrix[2][0] = -3;  a_matrix[2][1] = 0;   a_matrix[2][2] = 2;   a_matrix[2][3] = 0;
            a_matrix[3][0] = 0;   a_matrix[3][1] = 5;   a_matrix[3][2] = 0;   a_matrix[3][3] = 0;

            b_matrix[0][0] = 0;   b_matrix[0][1] = 4;   b_matrix[0][2] = 0;   b_matrix[0][3] = 0;
            b_matrix[1][0] = 0;   b_matrix[1][1] = 0;   b_matrix[1][2] = 0;   b_matrix[1][3] = -2;
            b_matrix[2][0] = 3;   b_matrix[2][1] = 0;   b_matrix[2][2] = 0;   b_matrix[2][3] = 0;
            b_matrix[3][0] = 0;   b_matrix[3][1] = 0;   b_matrix[3][2] = 1;   b_matrix[3][3] = 0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        weight_row_valid = 1'b0;
        weight_row_idx = '0;
        weight_row_data = '0;
        input_row_valid = 1'b0;
        input_row_data = '0;
        total_failures = 0;
        case_failures = 0;
        case_id = 0;

        clear_matrices();
        repeat (4) @(posedge clk);
        rst_n = 1'b1;

        case_id = 1;
        load_case_identity();
        compute_rotated_weights();
        compute_expected();
        apply_flush();
        drive_case_overlap();
        wait_and_check_result();

        case_id = 2;
        load_case_signed_mix();
        compute_rotated_weights();
        compute_expected();
        apply_flush();
        drive_case_overlap();
        wait_and_check_result();

        case_id = 3;
        load_case_signed_mix();
        compute_rotated_weights();
        compute_expected();
        apply_flush();
        drive_case_no_overlap();
        wait_and_check_result();

        case_id = 4;
        load_case_sparse_signed();
        compute_rotated_weights();
        compute_expected();
        apply_flush();
        drive_case_overlap();
        wait_and_check_result();

        if (total_failures == 0) begin
            $display("[DIP_SMOKE][PASS] all cases passed");
            $finish;
        end else begin
            $fatal(1, "[DIP_SMOKE] failures=%0d", total_failures);
        end
    end
endmodule
