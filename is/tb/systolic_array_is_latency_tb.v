`timescale 1ns/1ps

module systolic_array_is_latency_tb;

    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;

    reg clk;
    reg rst_n;
    reg [DATA_WIDTH-1:0] input_in;
    reg input_valid;
    reg input_load;
    reg [3:0] input_addr;
    wire input_ready;
    reg [WEIGHT_WIDTH-1:0] weight_in;
    reg weight_valid;
    wire weight_ready;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_data;
    wire [ARRAY_SIZE-1:0] output_valid;
    reg [ARRAY_SIZE-1:0] output_ready;
    reg flush;
    reg clk_enable;
    wire busy;
    reg [ACC_WIDTH*ARRAY_SIZE-1:0] observed_output_data;

    integer cycle_count;
    integer launch_cycle;
    integer first_output_cycle;
    integer all_output_cycle;
    integer timeout;
    integer i;
    integer failures;

    wire signed [ACC_WIDTH-1:0] out0 = observed_output_data[0*ACC_WIDTH +: ACC_WIDTH];
    wire signed [ACC_WIDTH-1:0] out1 = observed_output_data[1*ACC_WIDTH +: ACC_WIDTH];
    wire signed [ACC_WIDTH-1:0] out2 = observed_output_data[2*ACC_WIDTH +: ACC_WIDTH];
    wire signed [ACC_WIDTH-1:0] out3 = observed_output_data[3*ACC_WIDTH +: ACC_WIDTH];

    systolic_array_is_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .input_in(input_in),
        .input_valid(input_valid),
        .input_load(input_load),
        .input_addr(input_addr),
        .input_ready(input_ready),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_ready(weight_ready),
        .output_data(output_data),
        .output_valid(output_valid),
        .output_ready(output_ready),
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

    // Keep the most recent handshaken outputs so both Icarus and VCS compare
    // against the same architecturally valid samples.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            observed_output_data <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
        end else begin
            if (output_valid[0])
                observed_output_data[0*ACC_WIDTH +: ACC_WIDTH] <= output_data[0*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[1])
                observed_output_data[1*ACC_WIDTH +: ACC_WIDTH] <= output_data[1*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[2])
                observed_output_data[2*ACC_WIDTH +: ACC_WIDTH] <= output_data[2*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[3])
                observed_output_data[3*ACC_WIDTH +: ACC_WIDTH] <= output_data[3*ACC_WIDTH +: ACC_WIDTH];
        end
    end

    initial begin
        $dumpfile("systolic_array_is_latency_tb.vcd");
        $dumpvars(0, systolic_array_is_latency_tb);
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        input_in = {DATA_WIDTH{1'b0}};
        input_valid = 1'b0;
        input_load = 1'b0;
        input_addr = 4'd0;
        weight_in = {WEIGHT_WIDTH{1'b0}};
        weight_valid = 1'b0;
        output_ready = {ARRAY_SIZE{1'b1}};
        flush = 1'b0;
        clk_enable = 1'b1;
        launch_cycle = -1;
        first_output_cycle = -1;
        all_output_cycle = -1;
        timeout = 0;
        failures = 0;
        observed_output_data = {(ACC_WIDTH*ARRAY_SIZE){1'b0}};

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        input_load = 1'b1;
        input_valid = 1'b1;
        input_in = 16'd1;
        for (i = 0; i < 16; i = i + 1) begin
            input_addr = i[3:0];
            @(posedge clk);
        end
        input_load = 1'b0;
        input_valid = 1'b0;
        input_addr = 4'd0;

        repeat (4) @(posedge clk);

        weight_valid = 1'b1;
        weight_in = 16'd1;
        launch_cycle = cycle_count;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
        end
        weight_valid = 1'b0;

        while ((all_output_cycle < 0) && (timeout < 400)) begin
            @(posedge clk);

            if ((first_output_cycle < 0) &&
                ((out0 != 0) || (out1 != 0) || (out2 != 0) || (out3 != 0))) begin
                first_output_cycle = cycle_count;
            end

            if ((out0 == 4) && (out1 == 4) && (out2 == 4) && (out3 == 4)) begin
                all_output_cycle = cycle_count;
            end

            timeout = timeout + 1;
        end

        if (out0 !== 32'sd4) failures = failures + 1;
        if (out1 !== 32'sd4) failures = failures + 1;
        if (out2 !== 32'sd4) failures = failures + 1;
        if (out3 !== 32'sd4) failures = failures + 1;

        if (first_output_cycle < 0 || all_output_cycle < 0) begin
            failures = failures + 1;
            $display("BENCH_FAIL ARCH=IS timeout=%0d first=%0d all=%0d", timeout, first_output_cycle, all_output_cycle);
        end

        $display(
            "METRIC ARCH=IS launch_cycle=%0d first_output_cycle=%0d all_output_cycle=%0d latency_to_first=%0d latency_to_all=%0d",
            launch_cycle,
            first_output_cycle,
            all_output_cycle,
            first_output_cycle - launch_cycle,
            all_output_cycle - launch_cycle
        );

        if (failures == 0) begin
            $display("METRIC_STATUS ARCH=IS PASS");
            $finish;
        end else begin
            $fatal(
                1,
                "METRIC_STATUS ARCH=IS FAIL failures=%0d outputs=%0d,%0d,%0d,%0d",
                failures,
                out0,
                out1,
                out2,
                out3
            );
        end
    end

endmodule
