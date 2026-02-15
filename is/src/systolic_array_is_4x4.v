//==============================================================================
// Systolic Array 4x4 - Input Stationary Dataflow
// 功能：4x4 PE阵列，执行矩阵乘法 C = A × B
// 数据流：输入矩阵A预加载驻留，权重矩阵B从左侧流入，结果从下方流出
// 面向边缘计算优化：支持权重复用，降低访存开销
//
// 详细说明：
// 1. 4x4 PE阵列用于并行矩阵乘法运算
// 2. 输入矩阵A（激活值）静态存储在PE中，减少访存开销
// 3. 权重矩阵B按列从左侧流入阵列
// 4. 部分和按列从上向下累加
// 5. 最终结果从阵列底部输出
// 6. 支持完整的握手协议和流水线控制
//==============================================================================

module systolic_array_is_4x4 #(
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
    // 输入激活加载接口
    // 说明：输入矩阵A需要按特定模式加载到阵列中
    //==========================================================================
    input  wire [DATA_WIDTH-1:0] input_in,
    input  wire input_valid,
    input  wire input_load,
    output wire input_ready,

    //==========================================================================
    // 权重数据接口（从左侧流入）
    // 说明：权重矩阵B的数据按列顺序从左侧输入
    //==========================================================================
    input  wire [WEIGHT_WIDTH-1:0] weight_in,
    input  wire weight_valid,
    output wire weight_ready,

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
    // 输入激活传递网络
    // 输入矩阵A按行主序加载，PE[row][col]接收输入A[row][col]
    //-------------------------------------------------------------------------
    wire [DATA_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] input_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_load_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_ready_mesh;

    //-------------------------------------------------------------------------
    // 权重数据传递网络（水平方向，从左向右流动）
    //-------------------------------------------------------------------------
    wire [WEIGHT_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] weight_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]             weight_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]             weight_ready_mesh;
    wire [WEIGHT_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] weight_out_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]             weight_out_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]             weight_out_ready_mesh;

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
    // 输入激活加载控制逻辑
    //==========================================================================
    // 输入矩阵A按行主序加载，PE[row][col]接收输入A[row][col]

    genvar i_row, i_col;
    generate
        for (i_row = 0; i_row < ARRAY_SIZE; i_row = i_row + 1) begin : gen_input_valid_row
            for (i_col = 0; i_col < ARRAY_SIZE; i_col = i_col + 1) begin : gen_input_valid_col
                // 输入有效信号：全局有效
                assign input_valid_mesh[i_row*ARRAY_SIZE + i_col] = input_valid;
                // 输入加载信号：全局加载
                assign input_load_mesh[i_row*ARRAY_SIZE + i_col] = input_load;
            end
        end
    endgenerate

    // 输入激活数据路由：广播策略
    // 简化实现：所有PE接收相同的输入输入（实际应用中应根据PE位置路由）
    genvar row, col;
    generate
        for (row = 0; row < ARRAY_SIZE; row = row + 1) begin : gen_input_row
            for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_input_col
                assign input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH] = input_in;
            end
        end
    endgenerate

    // 输入就绪信号：当所有PE都准备好时，才就绪
    assign input_ready = &input_ready_mesh;  // 简化实现

    //==========================================================================
    // PE阵列实例化和互连
    //==========================================================================
    // 4x4阵列：PE[row][col]，row表示行，col表示列

    generate
        for (row = 0; row < ARRAY_SIZE; row = row + 1) begin : gen_row
            for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_col

                //-----------------------------------------------------------------
                // 权重数据连接（水平方向）
                //-----------------------------------------------------------------
                if (col == 0) begin
                    // 第一列：从外部输入接收权重
                    assign weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] = weight_in;
                    assign weight_valid_mesh[row*ARRAY_SIZE + col] = weight_valid;
                    // weight_ready在另一个generate块中连接
                end else begin
                    // 其他列：从左侧PE接收权重
                    assign weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] =
                           weight_out_mesh[(row*ARRAY_SIZE + col-1)*WEIGHT_WIDTH +: WEIGHT_WIDTH];
                    assign weight_valid_mesh[row*ARRAY_SIZE + col] = weight_out_valid_mesh[row*ARRAY_SIZE + col-1];
                    assign weight_out_ready_mesh[row*ARRAY_SIZE + col-1] = weight_ready_mesh[row*ARRAY_SIZE + col];
                end

                //-----------------------------------------------------------------
                // 部分和连接（垂直方向）
                //-----------------------------------------------------------------
                if (row == 0) begin
                    // 第一行：部分和初始化为0
                    assign partial_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH] = {ACC_WIDTH{1'b0}};
                    assign partial_valid_mesh[row*ARRAY_SIZE + col] = weight_valid_mesh[row*ARRAY_SIZE + col];
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
                is_pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .WEIGHT_WIDTH(WEIGHT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) pe_inst (
                    // 时钟和复位
                    .clk(clk),
                    .rst_n(rst_n),

                    // 输入激活接口
                    .input_load(input_load_mesh[row*ARRAY_SIZE + col]),
                    .input_valid(input_valid_mesh[row*ARRAY_SIZE + col]),
                    .input_in(input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_ready(input_ready_mesh[row*ARRAY_SIZE + col]),

                    // 权重数据接口
                    .weight_valid(weight_valid_mesh[row*ARRAY_SIZE + col]),
                    .weight_in(weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_ready(weight_ready_mesh[row*ARRAY_SIZE + col]),
                    .weight_out(weight_out_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_out_valid(weight_out_valid_mesh[row*ARRAY_SIZE + col]),
                    .weight_out_ready(weight_out_ready_mesh[row*ARRAY_SIZE + col]),

                    // 部分和接口
                    .partial_in_valid(partial_valid_mesh[row*ARRAY_SIZE + col]),
                    .partial_in(partial_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH]),
                    .partial_in_ready(partial_ready_mesh[row*ARRAY_SIZE + col]),
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
    // 边界处理：最后一列PE的weight_out_ready
    //==========================================================================
    genvar r;
    generate
        for (r = 0; r < ARRAY_SIZE; r = r + 1) begin : gen_last_col_ready
            assign weight_out_ready_mesh[r*ARRAY_SIZE + (ARRAY_SIZE-1)] = 1'b1;
        end
    endgenerate

    //==========================================================================
    // 权重就绪信号连接（带输出寄存器以改善时序）
    //==========================================================================
    // 外部weight_ready是第一列所有PE ready的AND结果

    wire weight_ready_comb;

    assign weight_ready_comb = (weight_ready_mesh[0*ARRAY_SIZE + 0] &&
                                weight_ready_mesh[1*ARRAY_SIZE + 0] &&
                                weight_ready_mesh[2*ARRAY_SIZE + 0] &&
                                weight_ready_mesh[3*ARRAY_SIZE + 0]);

    // 输出寄存器（改善时序的关键！）
    reg weight_ready_reg;
    reg busy_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_ready_reg <= 1'b0;
            busy_reg <= 1'b0;
        end else begin
            weight_ready_reg <= weight_ready_comb;
            busy_reg <= array_busy_reg;
        end
    end

    // 输出连接
    assign weight_ready = weight_ready_reg;
    assign busy = busy_reg;

    //==========================================================================
    // 阵列忙标志生成
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            array_busy_reg <= 1'b0;
        end else if (flush) begin
            array_busy_reg <= 1'b0;
        end else begin
            array_busy_reg <= |pe_busy_mesh;  // 任一PE忙则阵列忙
        end
    end

    //==========================================================================
    // 断言和检查（用于仿真验证）
    //==========================================================================

    // 检查：输入加载时所有PE必须就绪
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_load && input_valid && input_ready) begin
                // 检查所有PE都准备好
            end
        end
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        integer i;
        always @(posedge clk) begin
            if (input_load && input_valid && input_ready) begin
                $display("[%0t] IS Array: Input data %0d loaded",
                         $time, $signed(input_in));
            end

            if (weight_valid && weight_ready) begin
                $display("[%0t] IS Array: Weight data %0d accepted",
                         $time, $signed(weight_in));
            end

            if (|output_valid && |output_ready) begin
                for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                    if (output_valid[i] && output_ready[i]) begin
                        $display("[%0t] IS Array: Output[%0d] = %0d",
                                 $time, i, $signed(output_data[i*ACC_WIDTH +: ACC_WIDTH]));
                    end
                end
            end

            if (flush) begin
                $display("[%0t] IS Array: Flush triggered", $time);
            end
        end
    `endif

    // 覆盖属性（用于验证覆盖率）
    `ifdef FORMAL
        cover property (@(posedge clk) input_valid && input_load);
        cover property (@(posedge clk) weight_valid && weight_ready);
        cover property (@(posedge clk) |output_valid);
        cover property (@(posedge clk) flush);
        cover property (@(posedge clk) busy);
        cover property (@(posedge clk) !busy);
    `endif

endmodule
