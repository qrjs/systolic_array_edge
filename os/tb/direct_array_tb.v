//==============================================================================
// 直接测试Systolic Array 4x4模块
// 跳过复杂的顶层控制，直接驱动阵列
//==============================================================================

`timescale 1ns/1ps

module direct_array_tb;

    parameter DATA_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter ACC_WIDTH = 32;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg rst_n;

    // 阵列接口
    reg [WEIGHT_WIDTH-1:0] weight_in;
    reg weight_valid;
    reg weight_load;
    wire weight_ready;

    reg [DATA_WIDTH-1:0] input_data;
    reg input_valid;
    wire input_ready;

    wire [ACC_WIDTH*4-1:0] output_data;
    wire [3:0] output_valid;
    reg [3:0] output_ready;

    reg flush;
    wire busy;
    reg clk_enable;  // 时钟使能信号

    //==========================================================================
    // DUT实例化
    //==========================================================================
    systolic_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(weight_in),
        .weight_valid(weight_valid),
        .weight_load(weight_load),
        .weight_ready(weight_ready),
        .input_data(input_data),
        .input_valid(input_valid),
        .input_ready(input_ready),
        .output_data(output_data),
        .output_valid(output_valid),
        .output_ready(output_ready),
        .flush(flush),
        .clk_enable(clk_enable),
        .busy(busy)
    );

    //==========================================================================
    // 时钟生成
    //==========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    //==========================================================================
    // 测试任务
    //==========================================================================
    integer i, j, k;
    reg signed [ACC_WIDTH-1:0] expected [0:3];

    initial begin
        $display("\n========================================");
        $display("Direct Systolic Array Test");
        $display("========================================\n");

        // 初始化
        rst_n = 0;
        weight_in = 0;
        weight_valid = 0;
        weight_load = 0;
        input_data = 0;
        input_valid = 0;
        output_ready = 4'b0000;
        flush = 0;
        clk_enable = 1;  // 启用时钟

        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);

        $display("[%0t] Reset complete\n", $time);

        //----------------------------------------------------------------------
        // 测试1：简单测试 - 所有权重为1，输入为1，预期输出为4
        //----------------------------------------------------------------------
        $display("=== Test 1: All weights = 1, all inputs = 1 ===");
        $display("Loading weights...");

        weight_load = 1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            weight_in = 16'sd1;
            weight_valid = 1;
            @(posedge clk);
            $display("  Weight[%0d] valid=%d, ready=%d", i, weight_valid, weight_ready);
            if (!weight_ready) begin
                $display("  WARNING: weight not ready!");
            end
        end
        weight_valid = 0;
        weight_load = 0;
        $display("Weights loaded\n");

        // 等待一些周期
        repeat(5) @(posedge clk);

        $display("Sending inputs...");
        output_ready = 4'b1111;

        // 发送输入数据
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                @(posedge clk);
                input_data = 16'sd1;
                input_valid = 1;
                @(posedge clk);
                $display("  Input[%0d][%0d] valid=%d, ready=%d", i, j, input_valid, input_ready);
                if (!input_ready) begin
                    $display("  WARNING: input not ready!");
                end
            end
        end
        input_valid = 0;

        $display("Inputs sent, waiting for output...");

        // 等待输出并监控
        fork
            begin
                // 等待最多100个周期
                repeat(100) @(posedge clk);
            end
            begin
                // 监控输出端口，等待有效数据
                wait(|output_valid);
                $display("\n[%0t] Output detected!", $time);
            end
        join_any

        // 收集输出数据
        $display("\nResults:");
        for (i = 0; i < 4; i = i + 1) begin
            if (output_valid[i]) begin
                $display("  output[%0d] = %0d (valid=%b)",
                         i, $signed(output_data[i*ACC_WIDTH +: ACC_WIDTH]), output_valid[i]);
            end
        end

        repeat(10) @(posedge clk);

        //----------------------------------------------------------------------
        // 测试2：不同权重和输入
        //----------------------------------------------------------------------
        $display("\n=== Test 2: Weights = 2, inputs = 3 ===");
        $display("Loading weights...");

        weight_load = 1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            weight_in = 16'sd2;
            weight_valid = 1;
            wait(weight_ready);
        end
        weight_valid = 0;
        weight_load = 0;
        $display("Weights loaded\n");

        repeat(5) @(posedge clk);

        $display("Sending inputs...");

        // 发送输入数据
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                @(posedge clk);
                input_data = 16'sd3;
                input_valid = 1;
                wait(input_ready);
            end
        end
        input_valid = 0;

        $display("Inputs sent, waiting for output...");

        repeat(30) @(posedge clk);

        $display("\nResults:");
        for (i = 0; i < 4; i = i + 1) begin
            if (output_valid[i]) begin
                $display("  output[%0d] = %0d", i, $signed(output_data[i*ACC_WIDTH +: ACC_WIDTH]));
            end
        end

        repeat(20) @(posedge clk);

        //----------------------------------------------------------------------
        // 测试总结
        //----------------------------------------------------------------------
        $display("\n========================================");
        $display("Test completed");
        $display("========================================\n");

        $finish;
    end

    //==========================================================================
    // 超时保护
    //==========================================================================
    initial begin
        #100000;
        $display("\n[ERROR] Simulation timeout!");
        $finish;
    end

    //==========================================================================
    // 波形导出
    //==========================================================================
    initial begin
        $dumpfile("direct_array_tb.vcd");
        $dumpvars(0, direct_array_tb);
        $dumpon;
    end

endmodule
