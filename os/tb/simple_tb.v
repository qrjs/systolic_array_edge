//==============================================================================
// 简单Testbench用于快速仿真验证
// 功能：基本的矩阵乘法测试，兼容iverilog
//==============================================================================

`timescale 1ns/1ps

module simple_tb;

    //==========================================================================
    // 参数定义
    //==========================================================================
    parameter DATA_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter ACC_WIDTH = 32;
    parameter MATRIX_SIZE = 4;
    parameter CLK_PERIOD = 10;  // 100MHz

    //==========================================================================
    // 信号声明
    //==========================================================================
    reg clk;
    reg rst_n;

    // 控制信号
    reg start;
    wire done;
    wire busy;

    // 矩阵A输入
    reg [DATA_WIDTH-1:0] matrix_a_in;
    reg matrix_a_valid;
    wire matrix_a_ready;

    // 矩阵B输入
    reg [WEIGHT_WIDTH-1:0] matrix_b_in;
    reg matrix_b_valid;
    wire matrix_b_ready;

    // 矩阵C输出
    wire [ACC_WIDTH-1:0] matrix_c_out;
    wire matrix_c_valid;
    reg matrix_c_ready;

    // 测试数据存储
    reg signed [DATA_WIDTH-1:0] test_matrix_a [0:15];
    reg signed [WEIGHT_WIDTH-1:0] test_matrix_b [0:15];
    reg signed [ACC_WIDTH-1:0] expected_result [0:15];

    // 测试统计
    integer tests_passed;
    integer tests_failed;

    //==========================================================================
    // DUT实例化
    //==========================================================================
    matrix_multiplier_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .MATRIX_SIZE(MATRIX_SIZE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .busy(busy),
        .matrix_a_in(matrix_a_in),
        .matrix_a_valid(matrix_a_valid),
        .matrix_a_ready(matrix_a_ready),
        .matrix_b_in(matrix_b_in),
        .matrix_b_valid(matrix_b_valid),
        .matrix_b_ready(matrix_b_ready),
        .matrix_c_out(matrix_c_out),
        .matrix_c_valid(matrix_c_valid),
        .matrix_c_ready(matrix_c_ready)
    );

    //==========================================================================
    // 时钟生成
    //==========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    //==========================================================================
    // 测试数据准备：单位矩阵
    //==========================================================================
    initial begin
        // 单位矩阵A
        test_matrix_a[0]  = 16'sd1; test_matrix_a[1]  = 16'sd0;
        test_matrix_a[2]  = 16'sd0; test_matrix_a[3]  = 16'sd0;
        test_matrix_a[4]  = 16'sd0; test_matrix_a[5]  = 16'sd1;
        test_matrix_a[6]  = 16'sd0; test_matrix_a[7]  = 16'sd0;
        test_matrix_a[8]  = 16'sd0; test_matrix_a[9]  = 16'sd0;
        test_matrix_a[10] = 16'sd1; test_matrix_a[11] = 16'sd0;
        test_matrix_a[12] = 16'sd0; test_matrix_a[13] = 16'sd0;
        test_matrix_a[14] = 16'sd0; test_matrix_a[15] = 16'sd1;

        // 单位矩阵B
        test_matrix_b[0]  = 16'sd1; test_matrix_b[1]  = 16'sd0;
        test_matrix_b[2]  = 16'sd0; test_matrix_b[3]  = 16'sd0;
        test_matrix_b[4]  = 16'sd0; test_matrix_b[5]  = 16'sd1;
        test_matrix_b[6]  = 16'sd0; test_matrix_b[7]  = 16'sd0;
        test_matrix_b[8]  = 16'sd0; test_matrix_b[9]  = 16'sd0;
        test_matrix_b[10] = 16'sd1; test_matrix_b[11] = 16'sd0;
        test_matrix_b[12] = 16'sd0; test_matrix_b[13] = 16'sd0;
        test_matrix_b[14] = 16'sd0; test_matrix_b[15] = 16'sd1;

        // 预期结果：I × I = I
        expected_result[0]  = 32'sd1; expected_result[1]  = 32'sd0;
        expected_result[2]  = 32'sd0; expected_result[3]  = 32'sd0;
        expected_result[4]  = 32'sd0; expected_result[5]  = 32'sd1;
        expected_result[6]  = 32'sd0; expected_result[7]  = 32'sd0;
        expected_result[8]  = 32'sd0; expected_result[9]  = 32'sd0;
        expected_result[10] = 32'sd1; expected_result[11] = 32'sd0;
        expected_result[12] = 32'sd0; expected_result[13] = 32'sd0;
        expected_result[14] = 32'sd0; expected_result[15] = 32'sd1;
    end

    //==========================================================================
    // 主测试流程
    //==========================================================================
    integer i;
    initial begin
        // 初始化
        tests_passed = 0;
        tests_failed = 0;
        rst_n = 0;
        start = 0;
        matrix_a_in = 0;
        matrix_a_valid = 0;
        matrix_b_in = 0;
        matrix_b_valid = 0;
        matrix_c_ready = 0;

        $display("\n==========================================");
        $display("Simple Systolic Array Testbench");
        $display("==========================================\n");

        // 复位
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
        $display("[%0t] Reset complete", $time);

        // 启动测试
        $display("\n[%0t] Loading Matrix B...", $time);
        start = 1;
        @(posedge clk);
        start = 0;

        // 加载矩阵B
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            matrix_b_in = test_matrix_b[i];
            matrix_b_valid = 1;
            wait(matrix_b_ready);
            $display("  B[%0d] = %0d loaded", i, $signed(test_matrix_b[i]));
        end
        matrix_b_valid = 0;

        // 加载矩阵A
        $display("\n[%0t] Loading Matrix A...", $time);
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            matrix_a_in = test_matrix_a[i];
            matrix_a_valid = 1;
            wait(matrix_a_ready);
            $display("  A[%0d] = %0d loaded", i, $signed(test_matrix_a[i]));
        end
        matrix_a_valid = 0;

        // 等待计算完成
        $display("\n[%0t] Waiting for computation...", $time);
        wait(done);
        @(posedge clk);
        $display("[%0t] Computation complete", $time);

        // 读取输出
        $display("\n[%0t] Reading results...", $time);
        matrix_c_ready = 1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            if (matrix_c_valid) begin
                $display("  C[%0d] = %0d (expected: %0d)",
                         i, $signed(matrix_c_out), $signed(expected_result[i]));
                if (matrix_c_out == expected_result[i]) begin
                    $display("  ✓ PASS");
                    tests_passed = tests_passed + 1;
                end else begin
                    $display("  ✗ FAIL");
                    tests_failed = tests_failed + 1;
                end
            end
        end
        matrix_c_ready = 0;

        // 打印总结
        $display("\n==========================================");
        $display("Test Summary:");
        $display("  Passed: %0d", tests_passed);
        $display("  Failed: %0d", tests_failed);
        if (tests_failed == 0) begin
            $display("  *** ALL TESTS PASSED ***");
        end else begin
            $display("  *** SOME TESTS FAILED ***");
        end
        $display("==========================================\n");

        repeat(10) @(posedge clk);
        $finish;
    end

    //==========================================================================
    // 超时保护
    //==========================================================================
    initial begin
        #50000;  // 50us超时
        $display("\n[ERROR] Simulation timeout!");
        $finish;
    end

    //==========================================================================
    // 波形导出
    //==========================================================================
    initial begin
        $dumpfile("simple_tb.vcd");
        $dumpvars(0, simple_tb);
        $dumpon;
    end

endmodule
