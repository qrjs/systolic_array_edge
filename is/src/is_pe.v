`timescale 1ns/1ps

//==============================================================================
// Processing Element (PE) for Input Stationary Systolic Array
// 功能：执行乘加运算 (MAC)，输入激活驻留数据流
// 面向边缘计算优化：低功耗、资源高效
//
// 详细说明：
// 1. Input Stationary (IS) 数据流：输入激活驻留在 PE 中
// 2. 执行MAC运算：output = partial_sum + stored_input * weight
// 3. 输入激活在配置阶段加载，然后保持不变
// 4. 权重数据水平流过阵列
// 5. 部分和垂直累加
// 6. 支持完整的valid-ready握手协议
//==============================================================================

module is_pe #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter PE_ID = 0
)(
    //==========================================================================
    // 时钟和复位
    //==========================================================================
    input  wire                   clk,
    input  wire                   rst_n,

    //==========================================================================
    // 输入激活加载接口
    //==========================================================================
    input  wire                   input_load,      // 输入加载控制信号
    input  wire                   input_valid,     // 输入加载有效信号
    input  wire [DATA_WIDTH-1:0]  input_in,        // 输入激活数据
    output wire                   input_ready,     // PE准备好接收输入

    //==========================================================================
    // 权重数据接口（来自左侧PE，流向右侧）
    //==========================================================================
    input  wire                   weight_valid,    // 权重数据有效信号
    input  wire [WEIGHT_WIDTH-1:0] weight_in,      // 输入权重数据
    output wire                   weight_ready,    // PE准备好接收权重
    output wire [WEIGHT_WIDTH-1:0] weight_out,     // 权重传递给下一个PE
    output wire                   weight_out_valid,// 权重输出有效信号
    input  wire                   weight_out_ready,// 下级PE准备好

    //==========================================================================
    // 部分和接口（来自上方PE，流向下方）
    //==========================================================================
    input  wire                   partial_in_valid,// 部分和输入有效信号
    input  wire [ACC_WIDTH-1:0]   partial_in,      // 上级PE的部分和
    output wire                   partial_in_ready,// PE准备好接收部分和
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

    // 输入激活存储（驻留数据）
    reg [DATA_WIDTH-1:0]  stored_input;            // 存储的输入激活
    reg                   input_valid_reg;         // 输入有效标志

    // 权重数据流水线寄存器（流动数据）
    reg [WEIGHT_WIDTH-1:0] weight_reg;             // 权重寄存器
    reg [WEIGHT_WIDTH-1:0] weight_out_reg;         // 权重输出寄存器
    reg                   weight_valid_reg;         // 权重有效寄存器
    reg                   weight_out_valid_reg;     // 权重输出有效寄存器

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
    wire                  can_accept_weight;       // 可以接受权重
    wire                  can_accept_partial;      // 可以接受部分和

    //==========================================================================
    // 就绪信号生成
    //==========================================================================
    assign can_accept_weight = !stall && (!weight_out_valid || weight_out_ready);
    assign can_accept_partial = !stall && (!partial_out_valid || partial_out_ready);
    assign weight_ready = can_accept_weight;
    assign partial_in_ready = can_accept_partial;

    // 输入加载期间总是就绪（除非停顿）
    assign input_ready = !stall;

    //==========================================================================
    // 停顿逻辑
    //==========================================================================
    assign stall = flush
                || (weight_out_valid_reg && !weight_out_ready)   // 权重输出阻塞
                || (partial_out_valid && !partial_out_ready);    // 部分和输出阻塞

    //==========================================================================
    // 输入激活加载逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_input <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        end else if (flush) begin
            // 刷新时清除输入激活
            stored_input <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        // clk_enable=0 时保持 preload 状态，等效于局部门控，避免空拍改写寄存器。
        end else if (clk_enable && input_load && input_valid && input_ready) begin
            // 加载新的输入激活
            stored_input <= input_in;
            input_valid_reg <= 1'b1;
        end
    end

    //==========================================================================
    // 权重数据流水线寄存器（多级流水线）
    //==========================================================================
    // 第一级：捕获权重数据
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_valid_reg <= 1'b0;
        end else if (flush) begin
            weight_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_valid_reg <= 1'b0;
        // 权重通路在冻结期间保持寄存器内容不变，减少无效翻转并消除 clk_enable 空载告警。
        end else if (clk_enable && !stall) begin
            if (weight_valid && weight_ready) begin
                weight_reg <= weight_in;
                weight_valid_reg <= 1'b1;
            end else if (accumulator_valid) begin
                // Keep weight_valid_reg high until MAC consumes it
                weight_valid_reg <= weight_valid_reg;
            end else begin
                weight_valid_reg <= 1'b0;
            end
        end
    end

    // 第二级：权重输出寄存（传递给下一级PE）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_out_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_out_valid_reg <= 1'b0;
        end else if (flush) begin
            weight_out_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_out_valid_reg <= 1'b0;
        end else if (clk_enable && !stall) begin
            if (weight_valid_reg) begin
                weight_out_reg <= weight_reg;
                weight_out_valid_reg <= 1'b1;
            end else if (weight_out_ready) begin
                weight_out_valid_reg <= 1'b0;
            end
        end
    end

    // 输出端口连接
    assign weight_out = weight_out_reg;
    assign weight_out_valid = weight_out_valid_reg;

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
        end else if (clk_enable && !stall) begin
            if (partial_in_valid && partial_in_ready) begin
                partial_reg <= partial_in;
                partial_valid_reg <= 1'b1;
            end else begin
                partial_valid_reg <= 1'b0;
            end
        end
    end

    //==========================================================================
    // MAC运算单元
    //==========================================================================
    // 乘法器：stored_input × weight_in
    assign multiplier_out = stored_input * weight_reg;

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
            if (weight_valid_reg && partial_valid_reg && input_valid_reg) begin
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
                `ifdef DEBUG
                    $display("[%0t] PARTIAL_UPDATE: accum=%0d -> partial_out=%0d",
                             $time, $signed(accumulator), $signed(partial_out));
                `endif
            end else if (partial_out_ready && partial_out_valid) begin
                // 握手完成
                partial_out_valid <= 1'b0;
                `ifdef DEBUG
                    $display("[%0t] PARTIAL_HANDSHAKE: output ready, clearing valid", $time);
                `endif
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

    // 检查：输入加载时必须有valid信号
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_load && !input_valid)
                $error("%0t Error: input_load asserted without input_valid", $time);
        end
    `endif

    // 检查：数据宽度匹配
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_valid && $bits(input_in) != DATA_WIDTH)
                $error("%0t Error: input_in width mismatch", $time);
            if (weight_valid && $bits(weight_in) != WEIGHT_WIDTH)
                $error("%0t Error: weight_in width mismatch", $time);
        end
    `endif

    // 覆盖属性（用于验证覆盖率）
    `ifdef FORMAL
        cover property (@(posedge clk) input_valid && input_load);
        cover property (@(posedge clk) weight_valid && weight_ready);
        cover property (@(posedge clk) partial_in_valid && partial_in_ready);
        cover property (@(posedge clk) flush);
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        // 监控累加器和stall状态（仅用于调试PE(3,3)）
        always @(posedge clk) begin
            if (input_valid_reg || weight_valid_reg || partial_valid_reg ||
                accumulator_valid || stall) begin
                $display("[%0t] PE_DBG: in_loaded=%b wt_vld_reg=%b part_vld_reg=%b accum_vld=%b stall=%b accum=%0d",
                         $time, input_valid_reg, weight_valid_reg, partial_valid_reg,
                         accumulator_valid, stall, $signed(accumulator));
            end
        end

        always @(posedge clk) begin
            if (input_load && input_ready)
                $display("[%0t] IS_PE[%0d,%0d] Input loaded: %0d",
                         $time, 0, 0, $signed(input_in));

            if (weight_valid && weight_ready)
                $display("[%0t] IS_PE[%0d,%0d] Weight data: %0d",
                         $time, 0, 0, $signed(weight_in));

            if (partial_in_valid && partial_in_ready)
                $display("[%0t] IS_PE[%0d,%0d] Partial in: %0d",
                         $time, 0, 0, $signed(partial_in));

            if (partial_out_valid && partial_out_ready)
                $display("[%0t] IS_PE[%0d,%0d] Partial out: %0d",
                         $time, 0, 0, $signed(partial_out));
        end

        // 监控MAC运算的输入值
        always @(posedge clk) begin
            if (weight_valid_reg || partial_valid_reg || accumulator_valid) begin
                $display("[%0t] PE[%0d] MAC_IN: stored_in=%0d wt_reg=%0d part_reg=%0d mac_res=%0d accum=%0d accum_vld=%b",
                         $time, PE_ID, $signed(stored_input), $signed(weight_reg),
                         $signed(partial_reg), $signed(mac_result),
                         $signed(accumulator), accumulator_valid);
            end
        end
    `endif

endmodule
