//==============================================================================
// Testbench for Systolic Array Matrix Multiplier
// 功能：全面测试4x4 Systolic阵列的功能和性能
//==============================================================================

`timescale 1ns/1ps

module systolic_array_tb;

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

    // 参考结果（用于验证）
    reg signed [ACC_WIDTH-1:0] golden_result [0:15];

    // 测试统计
    integer test_passed;
    integer test_failed;
    integer total_tests;

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
    // 复位任务
    //==========================================================================
    task automatic reset_system();
        begin
            rst_n = 0;
            start = 0;
            matrix_a_in = 0;
            matrix_a_valid = 0;
            matrix_b_in = 0;
            matrix_b_valid = 0;
            matrix_c_ready = 0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);
            $display("[%0t] System reset complete", $time);
        end
    endtask

    //==========================================================================
    // 计算参考结果（黄金模型）
    //==========================================================================
    task automatic compute_golden(
        input signed [DATA_WIDTH-1:0] A [0:15],
        input signed [WEIGHT_WIDTH-1:0] B [0:15]
    );
        integer i, j, k;
        begin
            for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
                for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                    golden_result[i*MATRIX_SIZE+j] = 0;
                    for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                        golden_result[i*MATRIX_SIZE+j] =
                            golden_result[i*MATRIX_SIZE+j] +
                            (A[i*MATRIX_SIZE+k] * B[k*MATRIX_SIZE+j]);
                    end
                end
            end
        end
    endtask

    //==========================================================================
    // 加载矩阵B（权重）
    //==========================================================================
    task automatic load_matrix_b(
        input signed [WEIGHT_WIDTH-1:0] B [0:15]
    );
        integer i;
        begin
            $display("[%0t] Loading Matrix B (Weights)...", $time);
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                matrix_b_in = B[i];
                matrix_b_valid = 1;
                $display("  B[%0d] = %0d", i, $signed(B[i]));
                wait(matrix_b_ready);
                @(posedge clk);
            end
            matrix_b_valid = 0;
            $display("[%0t] Matrix B loading complete", $time);
        end
    endtask

    //==========================================================================
    // 加载矩阵A（输入）
    //==========================================================================
    task automatic load_matrix_a(
        input signed [DATA_WIDTH-1:0] A [0:15]
    );
        integer i;
        begin
            $display("[%0t] Loading Matrix A (Inputs)...", $time);
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                matrix_a_in = A[i];
                matrix_a_valid = 1;
                $display("  A[%0d] = %0d", i, $signed(A[i]));
                wait(matrix_a_ready);
                @(posedge clk);
            end
            matrix_a_valid = 0;
            $display("[%0t] Matrix A loading complete", $time);
        end
    endtask

    //==========================================================================
    // 验证输出结果
    //==========================================================================
    task automatic verify_output();
        integer i;
        reg [ACC_WIDTH-1:0] received_result [0:15];
        begin
            $display("[%0t] Collecting output results...", $time);
            matrix_c_ready = 1;

            // 等待第一个有效输出
            wait(matrix_c_valid);

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                if (matrix_c_valid) begin
                    received_result[i] = matrix_c_out;
                    $display("  C[%0d] = %0d (expected: %0d)",
                             i, $signed(matrix_c_out), $signed(golden_result[i]));

                    // 验证结果
                    if (matrix_c_out == golden_result[i]) begin
                        $display("  ✓ PASS");
                        test_passed = test_passed + 1;
                    end else begin
                        $display("  ✗ FAIL - Mismatch!");
                        test_failed = test_failed + 1;
                    end
                    total_tests = total_tests + 1;
                end
            end

            matrix_c_ready = 0;
        end
    endtask

    //==========================================================================
    // 测试用例1：单位矩阵测试
    //==========================================================================
    task automatic test_identity();
        reg signed [DATA_WIDTH-1:0] A [0:15];
        reg signed [WEIGHT_WIDTH-1:0] B [0:15];
        integer i;

        begin
            $display("\n========================================");
            $display("TEST 1: Identity Matrix Multiplication");
            $display("========================================");

            // 准备测试数据：单位矩阵
            for (i = 0; i < 16; i = i + 1) begin
                if ((i % 5) == 0) begin  // 对角线元素
                    A[i] = 16'sd1;
                    B[i] = 16'sd1;
                end else begin
                    A[i] = 16'sd0;
                    B[i] = 16'sd0;
                end
            end

            compute_golden(A, B);
            start = 1;
            @(posedge clk);
            start = 0;

            load_matrix_b(B);
            load_matrix_a(A);

            wait(done);
            @(posedge clk);
            verify_output();

            wait(!busy);
        end
    endtask

    //==========================================================================
    // 测试用例2：随机矩阵测试
    //==========================================================================
    task automatic test_random();
        reg signed [DATA_WIDTH-1:0] A [0:15];
        reg signed [WEIGHT_WIDTH-1:0] B [0:15];
        integer i;

        begin
            $display("\n========================================");
            $display("TEST 2: Random Matrix Multiplication");
            $display("========================================");

            // 准备随机测试数据
            for (i = 0; i < 16; i = i + 1) begin
                A[i] = $random % 32;  // 小随机数
                B[i] = $random % 32;
            end

            compute_golden(A, B);
            start = 1;
            @(posedge clk);
            start = 0;

            load_matrix_b(B);
            load_matrix_a(A);

            wait(done);
            @(posedge clk);
            verify_output();

            wait(!busy);
        end
    endtask

    //==========================================================================
    // 测试用例3：常量矩阵测试
    //==========================================================================
    task automatic test_constant();
        reg signed [DATA_WIDTH-1:0] A [0:15];
        reg signed [WEIGHT_WIDTH-1:0] B [0:15];
        integer i;

        begin
            $display("\n========================================");
            $display("TEST 3: Constant Matrix (all 2s)");
            $display("========================================");

            // 准备常量测试数据：全是2
            for (i = 0; i < 16; i = i + 1) begin
                A[i] = 16'sd2;
                B[i] = 16'sd2;
            end

            compute_golden(A, B);
            start = 1;
            @(posedge clk);
            start = 0;

            load_matrix_b(B);
            load_matrix_a(A);

            wait(done);
            @(posedge clk);
            verify_output();

            wait(!busy);
        end
    endtask

    //==========================================================================
    // 测试用例4：负数测试
    //==========================================================================
    task automatic test_negative();
        reg signed [DATA_WIDTH-1:0] A [0:15];
        reg signed [WEIGHT_WIDTH-1:0] B [0:15];
        integer i;

        begin
            $display("\n========================================");
            $display("TEST 4: Negative Numbers");
            $display("========================================");

            // 准备包含负数的测试数据
            for (i = 0; i < 16; i = i + 1) begin
                A[i] = $signed({1'b0, $random}) % 16 - 8;
                B[i] = $signed({1'b0, $random}) % 16 - 8;
            end

            compute_golden(A, B);
            start = 1;
            @(posedge clk);
            start = 0;

            load_matrix_b(B);
            load_matrix_a(A);

            wait(done);
            @(posedge clk);
            verify_output();

            wait(!busy);
        end
    endtask

    //==========================================================================
    // 主测试流程
    //==========================================================================
    initial begin
        test_passed = 0;
        test_failed = 0;
        total_tests = 0;

        $display("\n");
        $display("////////////////////////////////////////");
        $display("// Systolic Array Testbench");
        $display("// 4x4 Matrix Multiplication");
        $display("////////////////////////////////////////");
        $display("");

        // 复位系统
        reset_system();

        // 运行测试用例
        test_identity();
        repeat(10) @(posedge clk);

        test_random();
        repeat(10) @(posedge clk);

        test_constant();
        repeat(10) @(posedge clk);

        test_negative();
        repeat(10) @(posedge clk);

        // 打印测试总结
        $display("\n========================================");
        $display("TEST SUMMARY");
        $display("========================================");
        $display("Total Tests: %0d", total_tests);
        $display("Passed:      %0d", test_passed);
        $display("Failed:      %0d", test_failed);

        if (test_failed == 0) begin
            $display("\n*** ALL TESTS PASSED ***");
        end else begin
            $display("\n*** SOME TESTS FAILED ***");
        end
        $display("========================================\n");

        repeat(100) @(posedge clk);
        $finish;
    end

    //==========================================================================
    // 超时监控
    //==========================================================================
    initial begin
        #100000;  // 100us超时
        $display("\n[ERROR] Simulation timeout!");
        $finish;
    end

    //==========================================================================
    // 波形导出 - 支持Surfer波形查看器
    //==========================================================================
    initial begin
        $dumpfile("systolic_array_tb.vcd");
        $dumpvars(0, systolic_array_tb);
        $dumpon;
    end

    // VCD关闭控制
    initial begin
        #100000;
        $dumpoff;
    end

endmodule
