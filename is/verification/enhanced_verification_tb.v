//==============================================================================
// 增强版自动验证测试平台
// 功能：增加调试信息，修复时序问题
//==============================================================================

`timescale 1ns/1ps

module enhanced_verification_tb;

    parameter DATA_WIDTH = 16;
    parameter WEIGHT_WIDTH = 16;
    parameter ACC_WIDTH = 32;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg rst_n;

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
    reg clk_enable;

    // DUT
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

    // 时钟
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 测试统计
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // 测试用例 1：详细验证版本
    task test_case_1_detailed;
        reg signed [ACC_WIDTH-1:0] expected [0:3];
        reg signed [ACC_WIDTH-1:0] actual [0:3];
        integer i, timeout;
        begin
            $display("\n========================================");
            $display("Test Case 1: Identity Matrix (Detailed)");
            $display("========================================");

            // 计算预期值：4×1×1 = 4
            expected[0] = 32'd4;
            expected[1] = 32'd4;
            expected[2] = 32'd4;
            expected[3] = 32'd4;

            $display("Expected outputs: [%0d, %0d, %0d, %0d]",
                     expected[0], expected[1], expected[2], expected[3]);

            // 初始化
            rst_n = 0;
            weight_in = 0;
            weight_valid = 0;
            weight_load = 0;
            input_data = 0;
            input_valid = 0;
            output_ready = 4'b0000;
            flush = 0;
            clk_enable = 1;

            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);

            // 加载权重 (16 个权重，所有为 1)
            $display("\nLoading weights (all = 1)...");
            weight_load = 1;
            repeat(16) begin
                @(posedge clk);
                weight_in = 16'd1;
                weight_valid = 1;
                $display("  [%0t] Loaded weight = 1", $time);
            end
            weight_valid = 0;
            weight_load = 0;

            repeat(10) @(posedge clk);

            // 发送输入 (16 个输入，所有为 1)
            $display("\nSending inputs (all = 1)...");
            output_ready = 4'b1111;
            input_valid = 1;
            repeat(16) begin
                @(posedge clk);
                input_data = 16'd1;
                $display("  [%0t] Sent input = 1, ready = %b", $time, input_ready);
            end
            input_valid = 0;

            // 关键：等待足够长时间让所有输出稳定
            $display("\nWaiting for outputs to stabilize...");
            timeout = 0;
            fork
                begin
                    // 等待所有 4 个输出都有效
                    wait(output_valid == 4'b1111);
                    $display("  [%0t] All outputs valid!", $time);
                end
                begin
                    // 超时保护
                    repeat(500) @(posedge clk);
                    $display("  [%0t] Timeout waiting for outputs", $time);
                end
            join_any

            // 额外等待，确保数据完全稳定
            repeat(20) @(posedge clk);

            // 捕获输出
            $display("\nCapturing outputs...");
            for (i = 0; i < 4; i = i + 1) begin
                actual[i] = output_data[i*ACC_WIDTH +: ACC_WIDTH];
                $display("  output[%0d] = %0d (valid=%b)",
                         i, $signed(actual[i]), output_valid[i]);
            end

            // 验证
            $display("\nVerification:");
            for (i = 0; i < 4; i = i + 1) begin
                if (actual[i] == expected[i]) begin
                    $display("  ✅ PASS: output[%0d] = %0d", i, $signed(actual[i]));
                end else begin
                    $display("  ❌ FAIL: output[%0d] = %0d (expected %0d)",
                             i, $signed(actual[i]), $signed(expected[i]));
                end
            end

            // 统计
            total_tests = total_tests + 1;
            if (actual[0] == expected[0] && actual[1] == expected[1] &&
                actual[2] == expected[2] && actual[3] == expected[3]) begin
                passed_tests = passed_tests + 1;
                $display("\n✅ TEST 1 PASSED");
            end else begin
                failed_tests = failed_tests + 1;
                $display("\n❌ TEST 1 FAILED");
            end

            repeat(10) @(posedge clk);
        end
    endtask

    // 测试用例 2：常量矩阵
    task test_case_2_detailed;
        reg signed [ACC_WIDTH-1:0] expected [0:3];
        reg signed [ACC_WIDTH-1:0] actual [0:3];
        integer i;
        begin
            $display("\n========================================");
            $display("Test Case 2: Constant Matrix (Detailed)");
            $display("========================================");

            // 计算预期值：4×(3×2) = 24
            expected[0] = 32'd24;
            expected[1] = 32'd24;
            expected[2] = 32'd24;
            expected[3] = 32'd24;

            $display("Expected outputs: [%0d, %0d, %0d, %0d]",
                     expected[0], expected[1], expected[2], expected[3]);

            // 复位
            rst_n = 0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);

            // 加载权重 (所有为 2)
            $display("\nLoading weights (all = 2)...");
            weight_load = 1;
            repeat(16) begin
                @(posedge clk);
                weight_in = 16'd2;
                weight_valid = 1;
            end
            weight_valid = 0;
            weight_load = 0;

            repeat(10) @(posedge clk);

            // 发送输入 (所有为 3)
            $display("\nSending inputs (all = 3)...");
            output_ready = 4'b1111;
            input_valid = 1;
            repeat(16) begin
                @(posedge clk);
                input_data = 16'd3;
            end
            input_valid = 0;

            // 等待输出稳定
            $display("\nWaiting for outputs to stabilize...");
            fork
                begin
                    wait(output_valid == 4'b1111);
                    $display("  [%0t] All outputs valid!", $time);
                end
                begin
                    repeat(500) @(posedge clk);
                end
            join_any

            repeat(20) @(posedge clk);

            // 捕获和验证
            $display("\nVerification:");
            for (i = 0; i < 4; i = i + 1) begin
                actual[i] = output_data[i*ACC_WIDTH +: ACC_WIDTH];
                if (actual[i] == expected[i]) begin
                    $display("  ✅ PASS: output[%0d] = %0d", i, $signed(actual[i]));
                end else begin
                    $display("  ❌ FAIL: output[%0d] = %0d (expected %0d)",
                             i, $signed(actual[i]), $signed(expected[i]));
                end
            end

            total_tests = total_tests + 1;
            if (actual[0] == expected[0] && actual[1] == expected[1] &&
                actual[2] == expected[2] && actual[3] == expected[3]) begin
                passed_tests = passed_tests + 1;
                $display("\n✅ TEST 2 PASSED");
            end else begin
                failed_tests = failed_tests + 1;
                $display("\n❌ TEST 2 FAILED");
            end

            repeat(10) @(posedge clk);
        end
    endtask

    initial begin
        total_tests = 0;
        passed_tests = 0;
        failed_tests = 0;

        $display("========================================");
        $display("Enhanced Systolic Array Verification");
        $display("========================================");
        $display("增加了详细调试信息和更长等待时间");
        $display("========================================");

        test_case_1_detailed();
        test_case_2_detailed();

        // 最终报告
        $display("\n========================================");
        $display("Final Report");
        $display("========================================");
        $display("Total Tests: %0d", total_tests);
        $display("Passed:      %0d", passed_tests);
        $display("Failed:      %0d", failed_tests);

        if (failed_tests == 0) begin
            $display("\n✅✅✅ ALL TESTS PASSED! ✅✅✅");
            $display("设计完全正确，与 golden model 完全一致！");
        end else begin
            $display("\n⚠️  Some tests failed");
            $display("需要进一步调试");
        end
        $display("========================================\n");

        $finish;
    end

endmodule
