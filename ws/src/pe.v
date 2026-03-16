`timescale 1ns/1ps

//==============================================================================
// Processing Element (PE) for Systolic Array
// 功能：执行乘加运算 (MAC)，支持权重保持和数据流动
// 面向边缘计算优化：低功耗、资源高效
//
// 详细说明：
// 1. PE是Systolic阵列的基本计算单元
// 2. 执行MAC运算：output = partial_sum + input * weight
// 3. 支持权重的静态存储和动态更新
// 4. 实现完整的valid-ready握手协议
// 5. 支持数据流水线传递
// 6. 包含完整的边界检查和错误处理
//==============================================================================

module pe #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32
)(
    //==========================================================================
    // 时钟和复位
    //==========================================================================
    input  wire                   clk,
    input  wire                   rst_n,

    //==========================================================================
    // 权重接口
    //==========================================================================
    input  wire                   weight_valid,    // 权重加载有效信号
    input  wire                   weight_load,     // 权重加载控制信号
    input  wire [WEIGHT_WIDTH-1:0] weight_in,      // 输入权重数据
    output wire                   weight_ready,    // PE准备好接收权重

    //==========================================================================
    // 输入数据接口（来自左侧或上级PE）
    //==========================================================================
    input  wire                   input_valid,     // 输入数据有效信号
    input  wire [DATA_WIDTH-1:0]  input_data,      // 输入数据
    output wire                   input_ready,     // PE准备好接收输入数据

    //==========================================================================
    // 部分和接口（来自上方PE）
    //==========================================================================
    input  wire                   partial_in_valid,// 部分和输入有效信号
    input  wire [ACC_WIDTH-1:0]   partial_in,      // 上级PE的部分和
    output wire                   partial_in_ready,// PE准备好接收部分和

    //==========================================================================
    // 输出数据接口（传递给右侧PE）
    //==========================================================================
    output wire [DATA_WIDTH-1:0]  input_out,       // 数据传递给下一个PE
    output wire                   input_out_valid, // 输出数据有效信号
    input  wire                   input_out_ready, // 下级PE准备好

    //==========================================================================
    // 部分和输出接口（传递给下方PE）
    //==========================================================================
    output reg  [ACC_WIDTH-1:0]   partial_out,     // 部分和输出给下级PE
    output reg                    partial_out_valid,// 部分和输出有效
    input  wire                   partial_out_ready,// 下级PE准备好接收

    //==========================================================================
    // 配置和调试接口
    //==========================================================================
    input  wire                   flush,           // 清空流水线
    input  wire                   clk_enable,      // 时钟使能（用于时钟门控）
    output wire                   pe_busy          // PE忙标志
);

    //==========================================================================
    // 内部信号和寄存器声明
    //==========================================================================

    // 权重存储
    reg [WEIGHT_WIDTH-1:0] stored_weight;           // 存储的权重值
    reg weight_valid_reg;                          // 权重有效标志

    // 输入数据寄存器
    reg [DATA_WIDTH-1:0]  input_reg;               // 输入数据寄存器
    reg [DATA_WIDTH-1:0]  input_out_reg;           // 输出数据寄存器
    reg                   input_valid_reg;         // 输入有效寄存器
    reg                   input_out_valid_reg;     // 输出有效寄存器

    // 部分和寄存器
    reg [ACC_WIDTH-1:0]   partial_reg;             // 部分和寄存器
    reg [ACC_WIDTH-1:0]   partial_out_reg;         // 部分和输出寄存器
    reg                   partial_valid_reg;       // 部分和有效寄存器

    // 累加器
    reg [ACC_WIDTH-1:0]   accumulator;             // 累加器
    reg                   accumulator_valid;       // 累加器有效标志

    // MAC运算中间信号
    wire [ACC_WIDTH-1:0]  multiplier_out;          // 乘法器输出
    wire [ACC_WIDTH-1:0]  mac_result;              // MAC结果
    wire signed [ACC_WIDTH-1:0] signed_mac_result; // 有符号MAC结果

    // 状态和控制信号
    reg                   processing;              // 处理中标志
    wire                  stall;                   // 停顿标志
    wire                  can_accept_input;        // 可以接受输入
    wire                  can_accept_partial;      // 可以接受部分和

    //==========================================================================
    // 就绪信号生成
    //==========================================================================
    // PE可以接受新输入的条件：未停顿且输出未阻塞
    assign can_accept_input = !stall && (!input_out_valid || input_out_ready);
    assign can_accept_partial = !stall && (!partial_out_valid || partial_out_ready);
    assign input_ready = can_accept_input;
    assign weight_ready = can_accept_input;  // 权重和输入使用同一通道
    assign partial_in_ready = can_accept_partial;

    //==========================================================================
    // 停顿逻辑
    //==========================================================================
    // 当输出阻塞或需要等待时，停顿流水线
    assign stall = flush
                || (input_out_valid_reg && !input_out_ready)   // 输出阻塞
                || (partial_out_valid && !partial_out_ready);  // 部分和输出阻塞

    //==========================================================================
    // 权重加载逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_weight <= {WEIGHT_WIDTH{1'b0}};
            weight_valid_reg <= 1'b0;
        end else if (flush) begin
            // 刷新时不清除权重，权重是静态配置
        end else if (clk_enable && weight_load && weight_valid && weight_ready) begin
            // 加载新权重
            stored_weight <= weight_in;
            weight_valid_reg <= 1'b1;
        end
    end

    //==========================================================================
    // 输入数据流水线寄存器（多级流水线）
    //==========================================================================
    // 第一级：捕获输入数据
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_reg <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        end else if (flush) begin
            input_reg <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        // clk_enable=0 时保持当前流水线状态，等价于局部时钟门控效果，
        // 可在不改接口协议的前提下减少无效翻转。
        end else if (clk_enable && !stall) begin
            if (input_valid && input_ready) begin
                input_reg <= input_data;
                input_valid_reg <= 1'b1;
            end else if (!accumulator_valid) begin
                input_valid_reg <= 1'b0;
            end
        end
    end

    // 第二级：输出数据寄存（传递给下一级PE）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_out_reg <= {DATA_WIDTH{1'b0}};
            input_out_valid_reg <= 1'b0;
        end else if (flush) begin
            input_out_reg <= {DATA_WIDTH{1'b0}};
            input_out_valid_reg <= 1'b0;
        // 输出级与输入级同样受 clk_enable 控制，保证冻结期间 valid/data 一致保持。
        end else if (clk_enable && !stall) begin
            if (input_valid_reg) begin
                input_out_reg <= input_reg;
                input_out_valid_reg <= 1'b1;
            end else if (input_out_ready) begin
                input_out_valid_reg <= 1'b0;
            end
        end
    end

    // 输出端口连接
    assign input_out = input_out_reg;
    assign input_out_valid = input_out_valid_reg;

    //==========================================================================
    // 部分和流水线寄存器（多级流水线）
    //==========================================================================
    // 第一级：捕获部分和
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_reg <= {ACC_WIDTH{1'b0}};
            partial_valid_reg <= 1'b0;
        end else if (flush) begin
            partial_reg <= {ACC_WIDTH{1'b0}};
            partial_valid_reg <= 1'b0;
        // 部分和输入寄存级也门控，避免上游空拍导致无意义写入。
        end else if (clk_enable && !stall) begin
            if (partial_in_valid && partial_in_ready) begin
                partial_reg <= partial_in;
                partial_valid_reg <= 1'b1;
            end else if (!accumulator_valid) begin
                partial_valid_reg <= 1'b0;
            end
        end
    end

    //==========================================================================
    // MAC运算单元
    //==========================================================================
    // 乘法器：input_data × stored_weight
    assign multiplier_out = input_reg * stored_weight;

    // 加法器：partial_sum + multiplication_result
    assign signed_mac_result = $signed(partial_reg) + $signed(multiplier_out);
    assign mac_result = signed_mac_result;

    //==========================================================================
    // 累加器和输出控制逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= {ACC_WIDTH{1'b0}};
            accumulator_valid <= 1'b0;
            processing <= 1'b0;
        end else if (flush) begin
            accumulator <= {ACC_WIDTH{1'b0}};
            accumulator_valid <= 1'b0;
            processing <= 1'b0;
        end else if (clk_enable && !stall) begin
            // 当有有效输入和部分和时，执行MAC运算
            if (input_valid_reg && partial_valid_reg) begin
                accumulator <= mac_result;
                accumulator_valid <= 1'b1;
                processing <= 1'b1;
            end else if (partial_out_ready && partial_out_valid) begin
                // Clear accumulator_valid only after partial_out has been consumed
                accumulator_valid <= 1'b0;
                processing <= 1'b0;
            end
            // Otherwise keep accumulator_valid as-is (sticky until consumed)
        end
    end

    //==========================================================================
    // 部分和输出寄存
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_out_reg <= {ACC_WIDTH{1'b0}};
            partial_out <= {ACC_WIDTH{1'b0}};
            partial_out_valid <= 1'b0;
        end else if (flush) begin
            partial_out_reg <= {ACC_WIDTH{1'b0}};
            partial_out <= {ACC_WIDTH{1'b0}};
            partial_out_valid <= 1'b0;
        end else if (clk_enable && !stall) begin
            if (accumulator_valid) begin
                // 新的计算结果
                partial_out_reg <= accumulator;
                partial_out <= accumulator;
                partial_out_valid <= 1'b1;
            end else if (partial_out_ready && partial_out_valid) begin
                // 握手完成
                partial_out_valid <= 1'b0;
            end
        end
    end

    //==========================================================================
    // 忙标志生成
    //==========================================================================
    assign pe_busy = processing || accumulator_valid || partial_out_valid;

    //==========================================================================
    // 断言和检查（用于仿真验证）
    //==========================================================================

    // 检查：权重加载时必须有valid信号
    `ifdef FORMAL
        always @(posedge clk) begin
            if (weight_load && !weight_valid)
                $error("%0t Error: weight_load asserted without weight_valid", $time);
        end
    `endif

    // 检查：数据宽度匹配
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_valid && $bits(input_data) != DATA_WIDTH)
                $error("%0t Error: input_data width mismatch", $time);
            if (weight_valid && $bits(weight_in) != WEIGHT_WIDTH)
                $error("%0t Error: weight_in width mismatch", $time);
        end
    `endif

    // 覆盖属性（用于验证覆盖率）
    `ifdef FORMAL
        cover property (@(posedge clk) weight_valid && weight_load);
        cover property (@(posedge clk) input_valid && input_ready);
        cover property (@(posedge clk) partial_in_valid && partial_in_ready);
        cover property (@(posedge clk) flush);
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        always @(posedge clk) begin
            if (weight_load && weight_valid && weight_ready)
                $display("[%0t] PE[%0d,%0d] Weight loaded: %0d",
                         $time, 0, 0, $signed(weight_in));

            if (input_valid && input_ready)
                $display("[%0t] PE[%0d,%0d] Input data: %0d",
                         $time, 0, 0, $signed(input_data));

            if (partial_in_valid && partial_in_ready)
                $display("[%0t] PE[%0d,%0d] Partial in: %0d",
                         $time, 0, 0, $signed(partial_in));

            if (partial_out_valid && partial_out_ready)
                $display("[%0t] PE[%0d,%0d] Partial out: %0d",
                         $time, 0, 0, $signed(partial_out));
        end
    `endif

    //==========================================================================
    // 功耗优化：时钟门控建议
    //==========================================================================
    // 在实际ASIC实现中，建议：
    // 1. 当PE空闲时，对输入寄存器使用时钟门控
    // 2. 当没有权重更新时，关闭权重寄存器的时钟
    // 3. 根据stall信号动态控制时钟使能
    //
    // 示例代码（综合时需要工具支持）：
    // wire clk_en = input_valid || weight_valid || partial_in_valid;
    // assign gated_clk = clk_en ? clk : 1'b0;

endmodule
