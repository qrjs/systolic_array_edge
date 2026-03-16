`timescale 1ns/1ps

module systolic_array_dip_latency_tb;

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

    integer cycle_count;
    integer launch_cycle;
    integer first_output_cycle;
    integer all_output_cycle;
    integer timeout;
    integer row_idx;
    integer col_idx;
    integer failures;
    integer captured_rows;
    integer candidate_count;
    integer match_start;
    integer matched;

    reg [ACC_WIDTH-1:0] captured [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] current_output_row_data;
    reg output_row_valid_q;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] output_row_data_q;
    reg [ACC_WIDTH-1:0] candidate_rows [0:15][0:ARRAY_SIZE-1];

    systolic_array_dip_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) dut (
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
            cycle_count <= 0;
            output_row_valid_q <= 1'b0;
            output_row_data_q <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
        end else begin
            cycle_count <= cycle_count + 1;
            output_row_valid_q <= output_row_valid;
            output_row_data_q <= output_row_data;
        end
    end

    task append_candidate_row;
        input [ACC_WIDTH*ARRAY_SIZE-1:0] row_data;
        integer append_col;
        reg same_as_previous;
        begin
            same_as_previous = 1'b0;
            if (candidate_count > 0) begin
                same_as_previous = 1'b1;
                for (append_col = 0; append_col < ARRAY_SIZE; append_col = append_col + 1) begin
                    if (candidate_rows[candidate_count - 1][append_col] !==
                        row_data[((append_col + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH]) begin
                        same_as_previous = 1'b0;
                    end
                end
            end

            if (!same_as_previous && (candidate_count < 16)) begin
                for (append_col = 0; append_col < ARRAY_SIZE; append_col = append_col + 1) begin
                    candidate_rows[candidate_count][append_col] =
                        row_data[((append_col + 1) * ACC_WIDTH) - 1 -: ACC_WIDTH];
                end
                candidate_count = candidate_count + 1;
            end
        end
    endtask

    task drive_idle;
        begin
            weight_row_valid = 1'b0;
            weight_row_idx = {($clog2(ARRAY_SIZE)){1'b0}};
            weight_row_data = {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
            input_row_valid = 1'b0;
            input_row_data = {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("systolic_array_dip_latency_tb.vcd");
        $dumpvars(0, systolic_array_dip_latency_tb);
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        weight_row_valid = 1'b0;
        weight_row_idx = {($clog2(ARRAY_SIZE)){1'b0}};
        weight_row_data = {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
        input_row_valid = 1'b0;
        input_row_data = {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
        launch_cycle = -1;
        first_output_cycle = -1;
        all_output_cycle = -1;
        timeout = 0;
        failures = 0;
        captured_rows = 0;
        candidate_count = 0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        drive_idle();

        // Preload W_rot rows 3..1 for identity.
        weight_row_valid = 1'b1;
        weight_row_idx = 3;
        weight_row_data = {16'd0, 16'd0, 16'd0, 16'd1};
        @(posedge clk);

        weight_row_idx = 2;
        weight_row_data = {16'd0, 16'd0, 16'd1, 16'd0};
        @(posedge clk);

        weight_row_idx = 1;
        weight_row_data = {16'd0, 16'd1, 16'd0, 16'd0};
        @(posedge clk);

        weight_row_idx = 0;
        weight_row_data = {16'd1, 16'd0, 16'd0, 16'd0};
        input_row_valid = 1'b1;
        input_row_data = {16'd1, 16'd1, 16'd1, 16'd1};
        launch_cycle = cycle_count;
        @(posedge clk);

        weight_row_valid = 1'b0;
        input_row_data = {16'd2, 16'd2, 16'd2, 16'd2};
        @(posedge clk);

        input_row_data = {16'd3, 16'd3, 16'd3, 16'd3};
        @(posedge clk);

        input_row_data = {16'd4, 16'd4, 16'd4, 16'd4};
        @(posedge clk);

        input_row_valid = 1'b0;
        input_row_data = {(DATA_WIDTH*ARRAY_SIZE){1'b0}};

        while ((candidate_count < 8) && (timeout < 200)) begin
            @(posedge clk);
            #1;
            if (output_row_valid || output_row_valid_q) begin
                append_candidate_row(output_row_data_q);
            end
            if (output_row_valid_q) begin
                if (first_output_cycle < 0) begin
                    first_output_cycle = cycle_count;
                end
            end
            if (output_row_valid) begin
                if (first_output_cycle < 0) begin
                    first_output_cycle = cycle_count;
                end
                append_candidate_row(output_row_data);
            end
            timeout = timeout + 1;
        end

        matched = 0;
        for (match_start = 0; match_start <= candidate_count - ARRAY_SIZE; match_start = match_start + 1) begin
            integer row_match;
            integer search_row;
            integer search_col;
            row_match = 1;
            for (search_row = 0; search_row < ARRAY_SIZE; search_row = search_row + 1) begin
                for (search_col = 0; search_col < ARRAY_SIZE; search_col = search_col + 1) begin
                    if (candidate_rows[match_start + search_row][search_col] !== (search_row + 1)) begin
                        row_match = 0;
                    end
                end
            end
            if (row_match == 1) begin
                matched = 1;
                for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                    for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                        captured[row_idx][col_idx] = candidate_rows[match_start + row_idx][col_idx];
                    end
                end
            end
        end

        captured_rows = matched ? ARRAY_SIZE : 0;
        if (matched) begin
            all_output_cycle = first_output_cycle + ARRAY_SIZE - 1;
        end

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                if (captured[row_idx][col_idx] !== (row_idx + 1)) begin
                    failures = failures + 1;
                    $display(
                        "BENCH_FAIL ARCH=DIP row=%0d col=%0d got=%0d expected=%0d",
                        row_idx,
                        col_idx,
                        captured[row_idx][col_idx],
                        row_idx + 1
                    );
                end
            end
        end

        if (first_output_cycle < 0 || all_output_cycle < 0) begin
            failures = failures + 1;
            $display("BENCH_FAIL ARCH=DIP timeout=%0d first=%0d all=%0d", timeout, first_output_cycle, all_output_cycle);
        end

        $display(
            "METRIC ARCH=DIP launch_cycle=%0d first_output_cycle=%0d all_output_cycle=%0d latency_to_first=%0d latency_to_all=%0d",
            launch_cycle,
            first_output_cycle,
            all_output_cycle,
            first_output_cycle - launch_cycle,
            all_output_cycle - launch_cycle
        );

        if (failures == 0) begin
            $display("METRIC_STATUS ARCH=DIP PASS");
            $finish;
        end else begin
            $fatal(1, "METRIC_STATUS ARCH=DIP FAIL failures=%0d", failures);
        end
    end

endmodule
