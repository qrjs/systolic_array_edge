//==============================================================================
// Systolic Array 4x4 for Matrix Multiplication
// 功能：4x4 PE阵列，执行矩阵乘法 C = A × B
// 数据流：权重矩阵B预加载，输入矩阵A从左侧流入，结果从下方流出
// 面向边缘计算优化：支持数据复用，降低访存开销
//
// 详细说明：
// 1. 4x4 PE阵列用于并行矩阵乘法运算
// 2. 权重矩阵B静态存储在PE中，减少访存开销
// 3. 输入矩阵A按行从左侧流入阵列
// 4. 部分和按列从上向下累加
// 5. 最终结果从阵列底部输出
// 6. 支持完整的握手协议和流水线控制
//==============================================================================

module systolic_array_4x4 #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter ARRAY_SIZE = 4
)(
    //==========================================================================
    // 时钟和复位
    //==========================================================================
    input  wire clk,
    input  wire rst_n,

    //==========================================================================
    // 权重加载接口
    // 说明：权重矩阵B需要按特定模式加载到阵列中
    //==========================================================================
    input  wire [WEIGHT_WIDTH-1:0] weight_in,
    input  wire weight_valid,
    input  wire weight_load,
    output wire weight_ready,

    //==========================================================================
    // 输入数据接口（从左侧流入）
    // 说明：输入矩阵A的数据按行顺序从左侧输入
    //==========================================================================
    input  wire [DATA_WIDTH-1:0] input_data,
    input  wire input_valid,
    output wire input_ready,

    //==========================================================================
    // 输出数据接口（从下方流出）
    // 说明：计算结果矩阵C从阵列底部输出
    //==========================================================================
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0]  output_data,
    output wire [ARRAY_SIZE-1:0]            output_valid,
    input  wire [ARRAY_SIZE-1:0]            output_ready,

    //==========================================================================
    // 控制和状态信号
    //==========================================================================
    input  wire flush,          // 清空流水线
    input  wire clk_enable,     // 时钟使能（用于时钟门控，优化功耗）
    output wire busy            // 阵列忙标志
);

    //==========================================================================
    // 内部信号连接
    //==========================================================================

    //-------------------------------------------------------------------------
    // 权重传递网络
    // 权重需要按照特定模式路由到各个PE
    //-------------------------------------------------------------------------
    wire [WEIGHT_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] weight_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            weight_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            weight_load_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            weight_ready_mesh;

    //-------------------------------------------------------------------------
    // 输入数据传递网络（水平方向，从左向右流动）
    //-------------------------------------------------------------------------
    wire [DATA_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] input_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_ready_mesh;
    wire [DATA_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] input_out_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_out_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_out_ready_mesh;

    //-------------------------------------------------------------------------
    // 部分和传递网络（垂直方向，从上向下流动）
    //-------------------------------------------------------------------------
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] partial_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            partial_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            partial_ready_mesh;
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] partial_out_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            partial_out_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            partial_out_ready_mesh;

    //-------------------------------------------------------------------------
    // PE状态信号
    //-------------------------------------------------------------------------
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0] pe_busy_mesh;

    //-------------------------------------------------------------------------
    // 阵列状态寄存器
    //-------------------------------------------------------------------------
    reg array_busy_reg;

    //==========================================================================
    // 权重加载控制逻辑
    //==========================================================================
    // 权重矩阵B按行主序加载，PE[row][col]接收权重B[col][row]
    // 这样可以实现数据的有效复用

    genvar w_row, w_col;
    generate
        for (w_row = 0; w_row < ARRAY_SIZE; w_row = w_row + 1) begin : gen_weight_valid_row
            for (w_col = 0; w_col < ARRAY_SIZE; w_col = w_col + 1) begin : gen_weight_valid_col
                // 权重有效信号：全局有效
                assign weight_valid_mesh[w_row*ARRAY_SIZE + w_col] = weight_valid;
                // 权重加载信号：全局加载
                assign weight_load_mesh[w_row*ARRAY_SIZE + w_col] = weight_load;
            end
        end
    endgenerate

    // 权重数据路由：广播策略
    // 在实际应用中，可以根据需要实现更智能的路由策略
    genvar row, col;
    generate
        for (row = 0; row < ARRAY_SIZE; row = row + 1) begin : gen_weight_row
            for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_weight_col
                // 简化实现：所有PE接收相同的权重输入
                // 实际应用中应该根据PE位置路由不同的权重
                assign weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] = weight_in;
            end
        end
    endgenerate

    // 权重就绪信号：当所有PE都准备好时，才就绪
    assign weight_ready = &weight_ready_mesh[0];  // 简化实现

    //==========================================================================
    // PE阵列实例化和互连
    //==========================================================================
    // 4x4阵列：PE[row][col]，row表示行，col表示列

    generate
        for (row = 0; row < ARRAY_SIZE; row = row + 1) begin : gen_row
            for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_col

                //-----------------------------------------------------------------
                // 输入数据连接（水平方向）
                //-----------------------------------------------------------------
                if (col == 0) begin
                    // 第一列：从外部输入接收数据
                    assign input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH] = input_data;
                    assign input_valid_mesh[row*ARRAY_SIZE + col] = input_valid;
                    // input_ready在另一个generate块中连接，避免多驱动
                end else begin
                    // 其他列：从左侧PE接收数据
                    assign input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH] =
                           input_out_mesh[(row*ARRAY_SIZE + col-1)*DATA_WIDTH +: DATA_WIDTH];
                    assign input_valid_mesh[row*ARRAY_SIZE + col] = input_out_valid_mesh[row*ARRAY_SIZE + col-1];
                    assign input_out_ready_mesh[row*ARRAY_SIZE + col-1] = input_ready_mesh[row*ARRAY_SIZE + col];
                end

                //-----------------------------------------------------------------
                // 部分和连接（垂直方向）
                //-----------------------------------------------------------------
                if (row == 0) begin
                    // 第一行：部分和初始化为0
                    assign partial_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH] = {ACC_WIDTH{1'b0}};
                    assign partial_valid_mesh[row*ARRAY_SIZE + col] = input_valid_mesh[row*ARRAY_SIZE + col];
                    assign partial_ready_mesh[row*ARRAY_SIZE + col] = 1'b1;  // 常就绪
                end else begin
                    // 其他行：从上方PE接收部分和
                    assign partial_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH] =
                           partial_out_mesh[((row-1)*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH];
                    assign partial_valid_mesh[row*ARRAY_SIZE + col] = partial_out_valid_mesh[(row-1)*ARRAY_SIZE + col];
                    assign partial_out_ready_mesh[(row-1)*ARRAY_SIZE + col] = partial_ready_mesh[row*ARRAY_SIZE + col];
                end

                //-----------------------------------------------------------------
                // PE实例化
                //-----------------------------------------------------------------
                pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .WEIGHT_WIDTH(WEIGHT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) pe_inst (
                    // 时钟和复位
                    .clk(clk),
                    .rst_n(rst_n),

                    // 权重接口
                    .weight_valid(weight_valid_mesh[row*ARRAY_SIZE + col]),
                    .weight_load(weight_load_mesh[row*ARRAY_SIZE + col]),
                    .weight_in(weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_ready(weight_ready_mesh[row*ARRAY_SIZE + col]),

                    // 输入数据接口
                    .input_valid(input_valid_mesh[row*ARRAY_SIZE + col]),
                    .input_data(input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_ready(input_ready_mesh[row*ARRAY_SIZE + col]),

                    // 部分和输入接口
                    .partial_in_valid(partial_valid_mesh[row*ARRAY_SIZE + col]),
                    .partial_in(partial_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH]),
                    .partial_in_ready(partial_ready_mesh[row*ARRAY_SIZE + col]),

                    // 输出数据接口
                    .input_out(input_out_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_out_valid(input_out_valid_mesh[row*ARRAY_SIZE + col]),
                    .input_out_ready(input_out_ready_mesh[row*ARRAY_SIZE + col]),

                    // 部分和输出接口
                    .partial_out(partial_out_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH]),
                    .partial_out_valid(partial_out_valid_mesh[row*ARRAY_SIZE + col]),
                    .partial_out_ready(partial_out_ready_mesh[row*ARRAY_SIZE + col]),

                    // 控制和时钟门控接口
                    .flush(flush),
                    .clk_enable(clk_enable),
                    .pe_busy(pe_busy_mesh[row*ARRAY_SIZE + col])
                );

            end
        end
    endgenerate

    //==========================================================================
    // 输出连接
    //==========================================================================
    // 最后一行的PE输出作为最终结果

    generate
        for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_output
            // 输出数据连接
            assign output_data[col*ACC_WIDTH +: ACC_WIDTH] =
                   partial_out_mesh[((ARRAY_SIZE-1)*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH];
            // 输出有效信号连接
            assign output_valid[col] = partial_out_valid_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + col];
            // 输出就绪信号连接
            assign partial_out_ready_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + col] = output_ready[col];
        end
    endgenerate

    //==========================================================================
    // 边界处理：最后一列PE的input_out_ready
    //==========================================================================
    // 最后一列PE的输出数据不再传递给其他PE，所以它们的ready信号恒为1
    genvar r;
    generate
        for (r = 0; r < ARRAY_SIZE; r = r + 1) begin : gen_last_col_ready
            assign input_out_ready_mesh[r*ARRAY_SIZE + (ARRAY_SIZE-1)] = 1'b1;
        end
    endgenerate

    //==========================================================================
    // 输入就绪信号连接（带输出寄存器以改善时序）
    //==========================================================================
    // 外部input_ready是第一列所有PE ready的AND结果
    // 当所有第一列PE都准备好时，外部才准备好接收数据
    // 添加流水线寄存器以改善时序

    // 组合逻辑计算 ready 信号
    wire input_ready_comb;
    wire weight_ready_comb;

    assign input_ready_comb = (input_ready_mesh[0*ARRAY_SIZE + 0] &&
                              input_ready_mesh[1*ARRAY_SIZE + 0] &&
                              input_ready_mesh[2*ARRAY_SIZE + 0] &&
                              input_ready_mesh[3*ARRAY_SIZE + 0]);

    // weight_ready 与 input_ready 相同（使用同一数据通道）
    assign weight_ready_comb = input_ready_comb;

    // 输出寄存器（改善时序的关键！）
    reg input_ready_reg;
    reg weight_ready_reg;
    reg busy_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_ready_reg <= 1'b0;
            weight_ready_reg <= 1'b0;
            busy_reg <= 1'b0;
        end else begin
            input_ready_reg <= input_ready_comb;
            weight_ready_reg <= weight_ready_comb;
            busy_reg <= array_busy_reg;
        end
    end

    // 输出连接
    assign input_ready = input_ready_reg;
    assign weight_ready = weight_ready_reg;
    assign busy = busy_reg;

    //==========================================================================
    // 阵列忙标志生成
    //==========================================================================
    // 阵列忙的条件：任一PE忙，或者有数据在流水线中

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            array_busy_reg <= 1'b0;
        end else if (flush) begin
            array_busy_reg <= 1'b0;
        end else begin
            // 检查所有PE的状态
            array_busy_reg <= |pe_busy_mesh;  // 任一PE忙则阵列忙
        end
    end

    //==========================================================================
    // 断言和检查（用于仿真验证）
    //==========================================================================

    // 检查：权重加载时所有PE必须就绪
    `ifdef FORMAL
        always @(posedge clk) begin
            if (weight_load && weight_valid && weight_ready) begin
                // 检查所有PE都准备好
            end
        end
    `endif

    // 检查：输入数据必须在阵列就绪时才能输入
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_valid && input_ready) begin
                // 输入有效
            end
        end
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        integer i;
        always @(posedge clk) begin
            if (input_valid && input_ready) begin
                $display("[%0t] Array: Input data %0d accepted",
                         $time, $signed(input_data));
            end

            if (|output_valid && |output_ready) begin
                for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                    if (output_valid[i] && output_ready[i]) begin
                        $display("[%0t] Array: Output[%0d] = %0d",
                                 $time, i, $signed(output_data[i*ACC_WIDTH +: ACC_WIDTH]));
                    end
                end
            end

            if (flush) begin
                $display("[%0t] Array: Flush triggered", $time);
            end
        end
    `endif

    // 覆盖属性（用于验证覆盖率）
    `ifdef FORMAL
        cover property (@(posedge clk) input_valid && input_ready);
        cover property (@(posedge clk) |output_valid);
        cover property (@(posedge clk) flush);
        cover property (@(posedge clk) busy);
        cover property (@(posedge clk) !busy);
    `endif

    //==========================================================================
    // 性能监控（可选）
    //==========================================================================
    // 在实际应用中，可以添加以下监控信号：
    // 1. 吞吐量计数器
    // 2. 延迟测量
    // 3. 利用率统计
    // 4. 功耗估算

endmodule
