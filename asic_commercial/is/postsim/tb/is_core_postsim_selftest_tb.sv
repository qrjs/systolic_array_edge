`timescale 1ns/1ps

module is_core_postsim_selftest_tb;
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

    integer i;
    integer failures;
    reg [1023:0] sdf_path;

    is_core_top_4x4 dut (
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
        if (!rst_n || flush) begin
            observed_output_data <= {(ACC_WIDTH*ARRAY_SIZE){1'b0}};
        end else begin
            if (output_valid[0]) observed_output_data[0*ACC_WIDTH +: ACC_WIDTH] <= output_data[0*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[1]) observed_output_data[1*ACC_WIDTH +: ACC_WIDTH] <= output_data[1*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[2]) observed_output_data[2*ACC_WIDTH +: ACC_WIDTH] <= output_data[2*ACC_WIDTH +: ACC_WIDTH];
            if (output_valid[3]) observed_output_data[3*ACC_WIDTH +: ACC_WIDTH] <= output_data[3*ACC_WIDTH +: ACC_WIDTH];
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
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        input_in = '0;
        input_valid = 1'b0;
        input_load = 1'b0;
        input_addr = '0;
        weight_in = '0;
        weight_valid = 1'b0;
        output_ready = 4'b1111;
        flush = 1'b0;
        clk_enable = 1'b1;
        failures = 0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        input_load = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            input_in = 16'd1;
            input_valid = 1'b1;
            input_addr = i[3:0];
        end
        @(posedge clk);
        input_valid = 1'b0;
        input_load = 1'b0;

        repeat (10) @(posedge clk);

        weight_valid = 1'b1;
        repeat (16) begin
            @(posedge clk);
            weight_in = 16'd1;
        end
        weight_valid = 1'b0;

        repeat (120) @(posedge clk);

        for (i = 0; i < 4; i = i + 1) begin
            reg signed [ACC_WIDTH-1:0] observed;
            observed = observed_output_data[i*ACC_WIDTH +: ACC_WIDTH];
            if (observed !== 32'd4) begin
                failures = failures + 1;
            end
        end

        if (failures == 0) begin
            $display("[IS_GATE][PASS] selftest");
            $finish;
        end else begin
            $fatal(1, "[IS_GATE] failures=%0d", failures);
        end
    end
endmodule
