`timescale 1ns/1ps

module os_core_postsim_selftest_tb;
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

    integer i;
    integer failures;
    string sdf_path = "";

    os_core_top_4x4 dut (
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

    initial begin
        if ($value$plusargs("SDF=%s", sdf_path)) begin
            if (sdf_path != "") begin
                $sdf_annotate(sdf_path, dut, , , "MAXIMUM");
            end
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        input_in = '0;
        input_valid = '0;
        input_row_sel = 2'b00;
        weight_in = '0;
        weight_valid = 1'b0;
        output_read = 1'b0;
        accumulator_clr = 1'b0;
        flush = 1'b0;
        clk_enable = 1'b1;
        failures = 0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        accumulator_clr = 1'b1;
        repeat (2) @(posedge clk);
        accumulator_clr = 1'b0;
        repeat (5) @(posedge clk);

        input_in = {(ARRAY_SIZE){16'd1}};
        input_valid = 4'b1111;
        weight_in = {(ARRAY_SIZE){16'd1}};
        weight_valid = 1'b1;
        repeat (4) @(posedge clk);
        input_in = '0;
        input_valid = '0;
        weight_in = '0;
        weight_valid = 1'b0;

        repeat (100) @(posedge clk);

        output_read = 1'b1;
        repeat (5) @(posedge clk);
        output_read = 1'b0;

        // Expected stable broadcast-OS pattern for the current implementation.
        if (output_data[0*ACC_WIDTH +: ACC_WIDTH]  !== 32'd4) failures = failures + 1;
        if (output_data[1*ACC_WIDTH +: ACC_WIDTH]  !== 32'd2) failures = failures + 1;
        if (output_data[2*ACC_WIDTH +: ACC_WIDTH]  !== 32'd0) failures = failures + 1;
        if (output_data[3*ACC_WIDTH +: ACC_WIDTH]  !== 32'd0) failures = failures + 1;
        if (output_data[4*ACC_WIDTH +: ACC_WIDTH]  !== 32'd4) failures = failures + 1;
        if (output_data[5*ACC_WIDTH +: ACC_WIDTH]  !== 32'd4) failures = failures + 1;
        if (output_data[6*ACC_WIDTH +: ACC_WIDTH]  !== 32'd2) failures = failures + 1;
        if (output_data[7*ACC_WIDTH +: ACC_WIDTH]  !== 32'd0) failures = failures + 1;
        if (output_data[8*ACC_WIDTH +: ACC_WIDTH]  !== 32'd4) failures = failures + 1;
        if (output_data[9*ACC_WIDTH +: ACC_WIDTH]  !== 32'd4) failures = failures + 1;
        if (output_data[10*ACC_WIDTH +: ACC_WIDTH] !== 32'd4) failures = failures + 1;
        if (output_data[11*ACC_WIDTH +: ACC_WIDTH] !== 32'd2) failures = failures + 1;
        if (output_data[12*ACC_WIDTH +: ACC_WIDTH] !== 32'd4) failures = failures + 1;
        if (output_data[13*ACC_WIDTH +: ACC_WIDTH] !== 32'd4) failures = failures + 1;
        if (output_data[14*ACC_WIDTH +: ACC_WIDTH] !== 32'd4) failures = failures + 1;
        if (output_data[15*ACC_WIDTH +: ACC_WIDTH] !== 32'd4) failures = failures + 1;

        if (failures == 0) begin
            $display("[OS_GATE][PASS] selftest");
            $finish;
        end else begin
            $fatal(1, "[OS_GATE] failures=%0d", failures);
        end
    end
endmodule
