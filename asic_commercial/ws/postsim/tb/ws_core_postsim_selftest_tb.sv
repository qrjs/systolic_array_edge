`timescale 1ns/1ps

module ws_core_postsim_selftest_tb;
    localparam integer DATA_WIDTH = 16;
    localparam integer WEIGHT_WIDTH = 16;
    localparam integer ACC_WIDTH = 32;
    localparam integer ARRAY_SIZE = 4;

    reg clk;
    reg rst_n;
    reg [WEIGHT_WIDTH-1:0] weight_in;
    reg weight_valid;
    reg weight_load;
    reg [3:0] weight_addr;
    wire weight_ready;
    reg [DATA_WIDTH-1:0] input_data;
    reg input_valid;
    reg [1:0] input_row_sel;
    wire input_ready;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_data;
    wire [ARRAY_SIZE-1:0] output_valid;
    reg [ARRAY_SIZE-1:0] output_ready;
    reg flush;
    reg clk_enable;
    wire busy;

    integer i;
    integer failures;
    integer timeout;
    string sdf_path;

    ws_core_top_4x4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_load(weight_load),
        .weight_addr(weight_addr),
        .weight_ready(weight_ready),
        .input_data(input_data),
        .input_valid(input_valid),
        .input_row_sel(input_row_sel),
        .input_ready(input_ready),
        .output_data(output_data),
        .output_valid(output_valid),
        .output_ready(output_ready),
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
        weight_in = '0;
        weight_valid = 1'b0;
        weight_load = 1'b0;
        weight_addr = '0;
        input_data = '0;
        input_valid = 1'b0;
        input_row_sel = '0;
        output_ready = 4'b1111;
        flush = 1'b0;
        clk_enable = 1'b1;
        failures = 0;
        timeout = 0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        weight_load = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            weight_in = 16'd1;
            weight_valid = 1'b1;
            weight_addr = i[3:0];
        end
        @(posedge clk);
        weight_valid = 1'b0;
        weight_load = 1'b0;

        repeat (10) @(posedge clk);

        input_valid = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            input_data = 16'd1;
            input_row_sel = (i / 4);
        end
        @(posedge clk);
        input_valid = 1'b0;
        input_data = '0;

        while ((output_valid != 4'b1111) && (timeout < 500)) begin
            @(posedge clk);
            timeout = timeout + 1;
        end

        if (output_valid != 4'b1111) begin
            $fatal(1, "[WS_GATE] timed out waiting for output_valid");
        end

        repeat (5) @(posedge clk);

        for (i = 0; i < 4; i = i + 1) begin
            reg signed [ACC_WIDTH-1:0] observed;
            observed = output_data[i*ACC_WIDTH +: ACC_WIDTH];
            if (observed !== 32'd4) begin
                failures = failures + 1;
            end
        end

        if (failures == 0) begin
            $display("[WS_GATE][PASS] selftest");
            $finish;
        end else begin
            $fatal(1, "[WS_GATE] failures=%0d", failures);
        end
    end
endmodule
