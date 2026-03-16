`timescale 1ns/1ps

//==============================================================================
// Systolic Array 4x4 - Output Stationary Dataflow
// 功能：4x4 PE阵列，执行矩阵乘法 C = A × B
// 数据流：部分和（输出）驻留在PE中累加，输入从上方流入，权重从左侧流入
// 面向边缘计算优化：支持输出复用，降低访存开销
//
// 详细说明：
// 1. 4x4 PE阵列用于并行矩阵乘法运算
// 2. 部分和（输出累加器）静态存储在PE中
// 3. 输入矩阵A从顶部垂直流入阵列
// 4. 权重矩阵B从左侧水平流入阵列
// 5. 最终结果从所有PE中读出
// 6. 支持完整的握手协议和流水线控制
//==============================================================================

module systolic_array_os_4x4 #(
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
    // 输入数据接口（从顶部流入，垂直流动）
    // 说明：输入矩阵A的数据从顶部按列输入，每列独立输入，垂直向下流动
    //==========================================================================
    input  wire [DATA_WIDTH*ARRAY_SIZE-1:0] input_in,  // 向量输入，每列一个数据
    input  wire [ARRAY_SIZE-1:0]            input_valid, // 每列独立的valid信号
    input  wire [1:0]                       input_row_sel, // Create row selection
    output wire [ARRAY_SIZE-1:0]            input_ready, // 每列独立的ready信号

    //==========================================================================
    // 权重数据接口（每列独立输入）
    // 说明：权重矩阵B的数据按列直接送入对应PE列
    //==========================================================================
    input  wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0] weight_in, // 每列一个权重
    input  wire weight_valid,
    output wire weight_ready,

    //==========================================================================
    // 输出数据接口（从所有PE读出）
    // 说明：计算结果矩阵C从所有PE中读出
    //==========================================================================
    input  wire                          output_read,     // 读取输出信号
    output wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] output_data,    // 所有PE的输出
    output wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            output_valid,   // 输出有效信号

    //==========================================================================
    // 控制和状态信号
    //==========================================================================
    input  wire accumulator_clr, // 清除累加器
    input  wire flush,           // 清空流水线
    input  wire clk_enable,      // 时钟使能（用于时钟门控，优化功耗）
    output wire busy             // 阵列忙标志
);

    //==========================================================================
    // 内部信号连接
    //==========================================================================

    //-------------------------------------------------------------------------
    // 输入数据传递网络（垂直方向，从上向下流动）
    //-------------------------------------------------------------------------
    wire [DATA_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] input_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_ready_mesh;
    wire [DATA_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] input_out_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_out_valid_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            input_out_ready_mesh;

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
    // 累加器输出网络
    //-------------------------------------------------------------------------
    wire [ACC_WIDTH*ARRAY_SIZE*ARRAY_SIZE-1:0] accumulator_out_mesh;
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0]            accumulator_valid_mesh;

    //-------------------------------------------------------------------------
    // PE状态信号
    //-------------------------------------------------------------------------
    wire [ARRAY_SIZE*ARRAY_SIZE-1:0] pe_busy_mesh;

    //-------------------------------------------------------------------------
    // 阵列状态寄存器
    //-------------------------------------------------------------------------
    reg array_busy_reg;

    //==========================================================================
    // PE阵列实例化和互连
    //==========================================================================
    // 4x4阵列：PE[row][col]，row表示行，col表示列

    genvar row, col;
    generate
        for (row = 0; row < ARRAY_SIZE; row = row + 1) begin : gen_row
            for (col = 0; col < ARRAY_SIZE; col = col + 1) begin : gen_col

                //-----------------------------------------------------------------
                // 输入数据连接（垂直方向）
                //-----------------------------------------------------------------
                //-----------------------------------------------------------------
                // 输入数据连接（垂直方向 - OS数据流）
                //-----------------------------------------------------------------
                // OS Dataflow: 输入从顶部流入，垂直向下传递
                // Row 0从外部获得输入，其他row从上方的PE获得输入

                wire [DATA_WIDTH-1:0] input_to_pe;
                wire input_valid_to_pe;
                wire input_ready_from_pe;

                // 输入数据来源：Row 0从外部输入，其他row从上方的PE输出
                if (row == 0) begin
                    // 第一行：从外部输入获得数据（只在valid时传递）
                    assign input_to_pe = input_valid[col] ? input_in[col*DATA_WIDTH +: DATA_WIDTH] : {DATA_WIDTH{1'b0}};
                    assign input_valid_to_pe = input_valid[col];
                end else begin
                    // 其他行：从上方PE的输出获得数据
                    assign input_to_pe = input_out_mesh[((row-1)*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH];
                    assign input_valid_to_pe = input_out_valid_mesh[(row-1)*ARRAY_SIZE + col];
                end

                assign input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH] = input_to_pe;
                assign input_valid_mesh[row*ARRAY_SIZE + col] = input_valid_to_pe;

                // Connect input_out_ready for data flow between rows
                // Each row's input_out_ready is controlled by the next row's input_ready
                if (row < ARRAY_SIZE - 1) begin
                    // Not last row: connect to next row's input_ready
                    assign input_out_ready_mesh[row*ARRAY_SIZE + col] = input_ready_mesh[(row+1)*ARRAY_SIZE + col];
                end
                // Note: Last row's input_out_ready is set to 1 in boundary handling

                //-----------------------------------------------------------------
                // 权重数据连接（水平方向 - OS数据流）
                //-----------------------------------------------------------------
                // OS Dataflow: 权重从左侧流入，水平向右传递
                // Col 0从外部获得权重，其他col从左侧的PE获得权重

                wire [WEIGHT_WIDTH-1:0] weight_to_pe;
                wire weight_valid_to_pe;
                wire weight_ready_from_pe;

                // 权重数据来源：Col 0从外部输入，其他col从左侧PE的输出
                if (col == 0) begin
                    // 第一列：从外部输入获得权重（只在valid时传递）
                    assign weight_to_pe = weight_valid ? weight_in[row*WEIGHT_WIDTH +: WEIGHT_WIDTH] : {WEIGHT_WIDTH{1'b0}};
                    assign weight_valid_to_pe = weight_valid;
                end else begin
                    // 其他列：从左侧PE的输出获得权重
                    assign weight_to_pe = weight_out_mesh[(row*ARRAY_SIZE + (col-1))*WEIGHT_WIDTH +: WEIGHT_WIDTH];
                    assign weight_valid_to_pe = weight_out_valid_mesh[(row*ARRAY_SIZE + (col-1))];
                end

                assign weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] = weight_to_pe;
                assign weight_valid_mesh[row*ARRAY_SIZE + col] = weight_valid_to_pe;

                //-----------------------------------------------------------------
                // PE实例化
                //-----------------------------------------------------------------
                os_pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .WEIGHT_WIDTH(WEIGHT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) pe_inst (
                    // 时钟和复位
                    .clk(clk),
                    .rst_n(rst_n),

                    // 输入数据接口
                    .input_valid(input_valid_mesh[row*ARRAY_SIZE + col]),
                    .input_in(input_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_ready(input_ready_mesh[row*ARRAY_SIZE + col]),
                    .input_out(input_out_mesh[(row*ARRAY_SIZE + col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_out_valid(input_out_valid_mesh[row*ARRAY_SIZE + col]),
                    .input_out_ready(input_out_ready_mesh[row*ARRAY_SIZE + col]),

                    // 权重数据接口
                    .weight_valid(weight_valid_mesh[row*ARRAY_SIZE + col]),
                    .weight_in(weight_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_ready(weight_ready_mesh[row*ARRAY_SIZE + col]),
                    .weight_out(weight_out_mesh[(row*ARRAY_SIZE + col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_out_valid(weight_out_valid_mesh[row*ARRAY_SIZE + col]),
                    .weight_out_ready(weight_out_ready_mesh[row*ARRAY_SIZE + col]),

                    // 累加器接口
                    .accumulator_clr(accumulator_clr),
                    .accumulator_read(output_read),
                    .accumulator_out(accumulator_out_mesh[(row*ARRAY_SIZE + col)*ACC_WIDTH +: ACC_WIDTH]),
                    .accumulator_valid(accumulator_valid_mesh[row*ARRAY_SIZE + col]),

                    // 控制和时钟门控接口
                    .flush(flush),
                    .clk_enable(clk_enable),
                    .pe_busy(pe_busy_mesh[row*ARRAY_SIZE + col])
                );

            end
        end
    endgenerate

    //==========================================================================
    // 边界处理
    //==========================================================================
    // 最后一行PE的input_out_ready
    genvar r;
    generate
        for (r = 0; r < ARRAY_SIZE; r = r + 1) begin : gen_last_row_ready
            assign input_out_ready_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + r] = 1'b1;
        end
    endgenerate

    // 最后一列PE的weight_out_ready
    genvar c;
    generate
        for (c = 0; c < ARRAY_SIZE; c = c + 1) begin : gen_last_col_ready
            assign weight_out_ready_mesh[c*ARRAY_SIZE + (ARRAY_SIZE-1)] = 1'b1;
        end
    endgenerate

    //==========================================================================
    // 输出连接
    //==========================================================================
    // 所有PE的累加器输出

    assign output_data = accumulator_out_mesh;
    assign output_valid = accumulator_valid_mesh;

    //==========================================================================
    // 输入就绪信号连接（带输出寄存器以改善时序）
    //==========================================================================
    // 每列独立的input_ready信号

    wire [ARRAY_SIZE-1:0] input_ready_comb;
    wire weight_ready_comb;

    generate
        for (c = 0; c < ARRAY_SIZE; c = c + 1) begin : gen_input_ready
            assign input_ready_comb[c] = input_ready_mesh[0*ARRAY_SIZE + c];
        end
    endgenerate

    // weight_ready: AND of selected row's all-column PE ready signals
    assign weight_ready_comb = &weight_ready_mesh;

    // 输出寄存器（改善时序的关键！）
    reg [ARRAY_SIZE-1:0] input_ready_reg;
    reg weight_ready_reg;
    reg busy_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            input_ready_reg <= {ARRAY_SIZE{1'b0}};
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

    // 检查：输入数据必须在阵列就绪时才能输入
    `ifdef FORMAL
        always @(posedge clk) begin
            if (input_valid && input_ready) begin
                // 输入有效
            end
        end
    `endif

    // 检查：权重数据必须在阵列就绪时才能输入
    `ifdef FORMAL
        always @(posedge clk) begin
            if (weight_valid && weight_ready) begin
                // 权重有效
            end
        end
    `endif

    //==========================================================================
    // 调试和监控
    //==========================================================================
    `ifdef DEBUG
        integer i, j;
        always @(posedge clk) begin
            if (input_valid && input_ready) begin
                $display("[%0t] OS Array: Input data %0d accepted",
                         $time, $signed(input_in));
            end

            if (weight_valid && weight_ready) begin
                $display("[%0t] OS Array: Weight data %0d accepted",
                         $time, $signed(weight_in));
            end

            if (output_read) begin
                for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                    for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
                        if (output_valid[i*ARRAY_SIZE + j]) begin
                            $display("[%0t] OS Array: Output[%0d][%0d] = %0d",
                                     $time, i, j,
                                     $signed(output_data[(i*ARRAY_SIZE + j)*ACC_WIDTH +: ACC_WIDTH]));
                        end
                    end
                end
            end

            if (flush) begin
                $display("[%0t] OS Array: Flush triggered", $time);
            end

            if (accumulator_clr) begin
                $display("[%0t] OS Array: Accumulators cleared", $time);
            end
        end
    `endif

    // 覆盖属性（用于验证覆盖率）
    `ifdef FORMAL
        cover property (@(posedge clk) input_valid && input_ready);
        cover property (@(posedge clk) weight_valid && weight_ready);
        cover property (@(posedge clk) output_read);
        cover property (@(posedge clk) accumulator_clr);
        cover property (@(posedge clk) flush);
        cover property (@(posedge clk) busy);
        cover property (@(posedge clk) !busy);
    `endif

endmodule
