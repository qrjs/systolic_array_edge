//==============================================================================
// Processing Element (PE) for Output Stationary Systolic Array
// 功能：执行乘加运算 (MAC)，输出驻留数据流
// 面向边缘计算优化：低功耗、资源高效
//
// 详细说明：
// 1. Output Stationary (OS) 数据流：部分和（输出）驻留在 PE 中
// 2. 执行MAC运算：accumulator += input * weight
// 3. 输入激活从上方垂直流过
// 4. 权重从左侧水平流过
// 5. 部分和在 PE 内累加，最终输出被读取
// 6. 支持完整的valid-ready握手协议
//==============================================================================

module os_pe #(
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
    // 输入数据接口（来自上方PE，垂直流动）
    //==========================================================================
    input  wire                   input_valid,     // 输入数据有效信号
    input  wire [DATA_WIDTH-1:0]  input_in,        // 输入数据（从上方）
    output wire                   input_ready,     // PE准备好接收输入
    output wire [DATA_WIDTH-1:0]  input_out,       // 输入传递给下方PE
    output wire                   input_out_valid, // 输入输出有效信号
    input  wire                   input_out_ready,  // 下级PE准备好

    //==========================================================================
    // 权重数据接口（来自左侧PE，水平流动）
    //==========================================================================
    input  wire                   weight_valid,    // 权重数据有效信号
    input  wire [WEIGHT_WIDTH-1:0] weight_in,      // 输入权重数据（从左侧）
    output wire                   weight_ready,    // PE准备好接收权重
    output wire [WEIGHT_WIDTH-1:0] weight_out,     // 权重传递给右侧PE
    output wire                   weight_out_valid,// 权重输出有效信号
    input  wire                   weight_out_ready, // 下级PE准备好

    //==========================================================================
    // 累加器读写接口
    //==========================================================================
    input  wire                   accumulator_read,// 读取累加器结果
    output wire [ACC_WIDTH-1:0]   accumulator_out, // 累加器输出
    output wire                   accumulator_valid,// 累加器输出有效

    //==========================================================================
    // 控制和调试接口
    //==========================================================================
    input  wire                   accumulator_clr, // 清除累加器
    input  wire                   flush,           // 清空流水线
    input  wire                   clk_enable,      // 时钟使能（用于时钟门控）
    output wire                   pe_busy          // PE忙标志
);

    //==========================================================================
    // 内部信号和寄存器声明
    //==========================================================================

    // 输入数据流水线寄存器（垂直流动）
    reg [DATA_WIDTH-1:0]  input_reg;               // 输入寄存器
    reg [DATA_WIDTH-1:0]  input_out_reg;           // 输入输出寄存器
    reg                   input_valid_reg;         // 输入有效寄存器
    reg                   input_out_valid_reg;     // 输入输出有效寄存器

    // 权重数据流水线寄存器（水平流动）
    reg [WEIGHT_WIDTH-1:0] weight_reg;             // 权重寄存器
    reg [WEIGHT_WIDTH-1:0] weight_out_reg;         // 权重输出寄存器
    reg                   weight_valid_reg;        // 权重有效寄存器
    reg                   weight_out_valid_reg;    // 权重输出有效寄存器

    // 累加器（驻留数据）
    reg [ACC_WIDTH-1:0]   accumulator;             // 累加器（部分和）
    reg                   accumulator_valid_reg;   // 累加器有效标志

    // MAC运算中间信号
    wire [ACC_WIDTH-1:0]  multiplier_out;          // 乘法器输出
    wire [ACC_WIDTH-1:0]  mac_result;              // MAC结果
    wire signed [ACC_WIDTH-1:0] signed_mac_result; // 有符号MAC结果

    // 状态和控制信号
    reg                   processing;              // 处理中标志
    reg                   stall;                   // 停顿标志
    wire                  can_accept_input;        // 可以接受输入
    wire                  can_accept_weight;       // 可以接受权重
    reg                   computing;               // 计算标志

    //==========================================================================
    // 就绪信号生成
    //==========================================================================
    assign can_accept_input = !stall && (!input_out_valid || input_out_ready);
    assign can_accept_weight = !stall && (!weight_out_valid || weight_out_ready);
    assign input_ready = can_accept_input;
    assign weight_ready = can_accept_weight;

    //==========================================================================
    // 停顿逻辑
    //==========================================================================
    always @(*) begin
        stall = 1'b0;
        if (input_out_valid && !input_out_ready) begin
            stall = 1'b1;  // 输入输出阻塞
        end
        if (weight_out_valid_reg && !weight_out_ready) begin
            stall = 1'b1;  // 权重输出阻塞
        end
        if (flush) begin
            stall = 1'b1;  // 刷新时停顿
        end
    end

    //==========================================================================
    // 输入数据流水线寄存器（垂直方向）
    //==========================================================================
    // 第一级：捕获输入数据
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_reg <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        end else if (flush) begin
            input_reg <= {DATA_WIDTH{1'b0}};
            input_valid_reg <= 1'b0;
        end else if (!stall) begin
            if (input_valid && input_ready) begin
                input_reg <= input_in;
                input_valid_reg <= 1'b1;
            end else begin
                input_valid_reg <= 1'b0;
            end
        end
    end

    // 第二级：输出数据寄存（传递给下方PE）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_out_reg <= {DATA_WIDTH{1'b0}};
            input_out_valid_reg <= 1'b0;
        end else if (flush) begin
            input_out_reg <= {DATA_WIDTH{1'b0}};
            input_out_valid_reg <= 1'b0;
        end else if (!stall) begin
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

    //==========================================================================
    // 权重数据流水线寄存器（水平方向）
    //==========================================================================
    // 第一级：捕获权重数据
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_valid_reg <= 1'b0;
        end else if (flush) begin
            weight_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_valid_reg <= 1'b0;
        end else if (!stall) begin
            if (weight_valid && weight_ready) begin
                weight_reg <= weight_in;
                weight_valid_reg <= 1'b1;
            end else begin
                weight_valid_reg <= 1'b0;
            end
        end
    end

    // 第二级：权重输出寄存（传递给右侧PE）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_out_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_out_valid_reg <= 1'b0;
        end else if (flush) begin
            weight_out_reg <= {WEIGHT_WIDTH{1'b0}};
            weight_out_valid_reg <= 1'b0;
        end else if (!stall) begin
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
    assign input_out_valid = input_out_valid_reg;
    assign accumulator_valid = accumulator_valid_reg;

    //==========================================================================
    // MAC运算单元
    //==========================================================================
    // 乘法器：input_in × weight_in
    assign multiplier_out = input_reg * weight_reg;

    // 加法器：accumulator + multiplication_result
    assign signed_mac_result = $signed(accumulator) + $signed(multiplier_out);
    assign mac_result = signed_mac_result;

    //==========================================================================
    // 累加器控制逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= {ACC_WIDTH{1'b0}};
            accumulator_valid_reg <= 1'b0;
            computing <= 1'b0;
        end else if (accumulator_clr || flush) begin
            // 清除累加器
            accumulator <= {ACC_WIDTH{1'b0}};
            accumulator_valid_reg <= 1'b0;
            computing <= 1'b0;
        end else if (!stall) begin
            // 当有有效输入和权重时，执行累加
            if (input_valid_reg && weight_valid_reg) begin
                accumulator <= mac_result;
                accumulator_valid_reg <= 1'b1;
                computing <= 1'b1;
            end
        end
    end

    //==========================================================================
    // 累加器输出逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator_valid_reg <= 1'b0;
        end else if (flush) begin
            accumulator_valid_reg <= 1'b0;
        end else begin
            // 当请求读取且累加器有有效数据时
            if (accumulator_read && accumulator_valid_reg) begin
                accumulator_valid_reg <= 1'b1;
            end else if (accumulator_read) begin
                accumulator_valid_reg <= 1'b0;
            end
        end
    end

    // 累加器输出连接
    assign accumulator_out = accumulator;

    //==========================================================================
    // 忙标志生成
    //==========================================================================
    assign pe_busy = computing || input_valid_reg || weight_valid_reg ||
                     input_out_valid || weight_out_valid_reg;

    //==========================================================================
    // 断言和检查（用于仿真验证）
    //==========================================================================

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
        cover property (@(posedge clk) input_valid && input_ready);
        cover property (@(posedge clk) weight_valid && weight_ready);
        cover property (@(posedge clk) accumulator_read);
        cover property (@(posedge clk) accumulator_clr);
        cover property (@(posedge clk) flush);
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        always @(posedge clk) begin
            if (input_valid && input_ready)
                $display("[%0t] OS_PE[%0d,%0d] Input data: %0d",
                         $time, 0, 0, $signed(input_in));

            if (weight_valid && weight_ready)
                $display("[%0t] OS_PE[%0d,%0d] Weight data: %0d",
                         $time, 0, 0, $signed(weight_in));

            if (accumulator_read && accumulator_valid)
                $display("[%0t] OS_PE[%0d,%0d] Accumulator out: %0d",
                         $time, 0, 0, $signed(accumulator_out));

            if (accumulator_clr)
                $display("[%0t] OS_PE[%0d,%0d] Accumulator cleared",
                         $time, 0, 0);
        end
    `endif

endmodule
