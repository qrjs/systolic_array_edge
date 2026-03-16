`timescale 1ns/1ps

module systolic_array_os_latency_tb;

    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;

    reg clk;
    reg rst_n;
    reg [DATA_WIDTH*ARRAY_SIZE-1:0] input_in;
    reg [ARRAY_SIZE-1:0] input_valid;
    reg [1:0] input_row_sel;
    wire [ARRAY_SIZE-1:0] input_ready;
    reg [WEIGHT_WIDTH*ARRAY_SIZE-1:0] weight_in;
    reg weight_valid;
    wire weight_ready;
    reg output_read;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] output_data;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0] output_valid;
    reg accumulator_clr;
    reg flush;
    reg clk_enable;
    wire busy;

    integer cycle_count;
    integer launch_cycle;
    integer first_output_cycle;
    integer all_output_cycle;
    integer timeout;
    integer idx;
    integer failures;

    reg signed [ACC_WIDTH-1:0] expected [0:15];
    reg signed [ACC_WIDTH-1:0] observed [0:15];

    task wait_for_ready;
        integer ready_timeout;
        begin
            ready_timeout = 0;
            #1;
            while (((input_ready !== {ARRAY_SIZE{1'b1}}) || (weight_ready !== 1'b1)) && (ready_timeout < 64)) begin
                @(posedge clk);
                #1;
                ready_timeout = ready_timeout + 1;
            end

            if ((input_ready !== {ARRAY_SIZE{1'b1}}) || (weight_ready !== 1'b1)) begin
                $fatal(1, "Timed out waiting for OS array ready");
            end
        end
    endtask

    systolic_array_os_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .input_in(input_in),
        .input_valid(input_valid),
        .input_row_sel(input_row_sel),
        .input_ready(input_ready),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_ready(weight_ready),
        .output_read(output_read),
        .output_data(output_data),
        .output_valid(output_valid),
        .accumulator_clr(accumulator_clr),
        .flush(flush),
        .clk_enable(clk_enable),
        .busy(busy)
    );

    always #5 clk = ~clk;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end

    initial begin
        $dumpfile("systolic_array_os_latency_tb.vcd");
        $dumpvars(0, systolic_array_os_latency_tb);
    end

    function automatic integer matches_expected;
        integer k;
        begin
            matches_expected = 1;
            for (k = 0; k < 16; k = k + 1) begin
                if ($signed(output_data[k*ACC_WIDTH +: ACC_WIDTH]) !== expected[k]) begin
                    matches_expected = 0;
                end
            end
        end
    endfunction

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        input_in = {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
        input_valid = {ARRAY_SIZE{1'b0}};
        input_row_sel = 2'b00;
        weight_in = {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
        weight_valid = 1'b0;
        output_read = 1'b0;
        accumulator_clr = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        launch_cycle = -1;
        first_output_cycle = -1;
        all_output_cycle = -1;
        timeout = 0;
        failures = 0;

        expected[0] = 4; expected[1] = 2; expected[2] = 0; expected[3] = 0;
        expected[4] = 4; expected[5] = 4; expected[6] = 2; expected[7] = 0;
        expected[8] = 4; expected[9] = 4; expected[10] = 4; expected[11] = 2;
        expected[12] = 4; expected[13] = 4; expected[14] = 4; expected[15] = 4;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        accumulator_clr = 1'b1;
        repeat (2) @(posedge clk);
        accumulator_clr = 1'b0;
        wait_for_ready();
        @(posedge clk);
        #1;

        input_in = {16'd1, 16'd1, 16'd1, 16'd1};
        input_valid = 4'b1111;
        weight_in = {16'd1, 16'd1, 16'd1, 16'd1};
        weight_valid = 1'b1;
        launch_cycle = cycle_count + 1;
        for (idx = 0; idx < 4; idx = idx + 1) begin
            @(posedge clk);
        end

        #1;
        input_in = {(DATA_WIDTH*ARRAY_SIZE){1'b0}};
        input_valid = 4'b0000;
        weight_in = {(WEIGHT_WIDTH*ARRAY_SIZE){1'b0}};
        weight_valid = 1'b0;
        output_read = 1'b1;

        while ((all_output_cycle < 0) && (timeout < 400)) begin
            @(posedge clk);

            if (first_output_cycle < 0) begin
                for (idx = 0; idx < 16; idx = idx + 1) begin
                    if ($signed(output_data[idx*ACC_WIDTH +: ACC_WIDTH]) != 0) begin
                        first_output_cycle = cycle_count;
                    end
                end
            end

            if (matches_expected()) begin
                all_output_cycle = cycle_count;
            end

            timeout = timeout + 1;
        end

        for (idx = 0; idx < 16; idx = idx + 1) begin
            observed[idx] = output_data[idx*ACC_WIDTH +: ACC_WIDTH];
            if (observed[idx] !== expected[idx]) begin
                failures = failures + 1;
                $display(
                    "BENCH_FAIL ARCH=OS output[%0d][%0d]=%0d expected=%0d",
                    idx / ARRAY_SIZE,
                    idx % ARRAY_SIZE,
                    observed[idx],
                    expected[idx]
                );
            end
        end

        if (first_output_cycle < 0 || all_output_cycle < 0) begin
            failures = failures + 1;
            $display("BENCH_FAIL ARCH=OS timeout=%0d first=%0d all=%0d", timeout, first_output_cycle, all_output_cycle);
        end

        $display(
            "METRIC ARCH=OS launch_cycle=%0d first_output_cycle=%0d all_output_cycle=%0d latency_to_first=%0d latency_to_all=%0d",
            launch_cycle,
            first_output_cycle,
            all_output_cycle,
            first_output_cycle - launch_cycle,
            all_output_cycle - launch_cycle
        );

        if (failures == 0) begin
            $display("METRIC_STATUS ARCH=OS PASS");
            $finish;
        end else begin
            $fatal(1, "METRIC_STATUS ARCH=OS FAIL failures=%0d", failures);
        end
    end

endmodule
