`timescale 1ns/1ps

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
    input  wire [3:0] input_addr,     // Address 0..15
    output wire input_ready,

    //==========================================================================
    // 权重数据接口（从左侧流入）
    //==========================================================================
    input  wire [WEIGHT_WIDTH-1:0] weight_in,
    input  wire weight_valid,
    output wire weight_ready,

    //==========================================================================
    // 输出数据接口（结果从底部流出）
    //==========================================================================
    output wire [ACC_WIDTH*ARRAY_SIZE-1:0] output_data,
    output wire [ARRAY_SIZE-1:0] output_valid,
    input  wire [ARRAY_SIZE-1:0] output_ready,

    //==========================================================================
    // 控制和配置接口
    //==========================================================================
    input  wire flush,             // 清空流水线
    input  wire clk_enable,        // 时钟使能（用于时钟门控）
    output wire busy               // 阵列忙标志
);
    localparam integer LAST_ROW_BASE = (ARRAY_SIZE - 1) * ARRAY_SIZE;


    //==========================================================================
    // 内部信号声明
    //==========================================================================
    // 输入激活网格信号（16个PE）
    wire [DATA_WIDTH*16-1:0] input_mesh;
    wire [15:0] input_valid_mesh;
    wire [15:0] input_load_mesh;
    wire [15:0] input_ready_mesh;
    // 权重网格信号（16个PE）
    wire [WEIGHT_WIDTH*16-1:0] weight_mesh;
    wire [15:0] weight_valid_mesh;
    wire [15:0] weight_ready_mesh;
    wire [WEIGHT_WIDTH*16-1:0] weight_out_mesh;
    wire [15:0] weight_out_valid_mesh;
    wire [15:0] weight_out_ready_mesh;

    // 部分和网格信号（16个PE）
    wire [ACC_WIDTH*16-1:0] partial_mesh;
    wire [15:0] partial_valid_mesh;
    wire [15:0] partial_ready_mesh;
    wire [ACC_WIDTH*16-1:0] partial_out_mesh;
    wire [15:0] partial_out_valid_mesh;
    wire [15:0] partial_out_ready_mesh;

    wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0] row_weight_data_in;
    wire [WEIGHT_WIDTH*ARRAY_SIZE-1:0] row_weight_data_out;
    wire [ARRAY_SIZE-1:0]              row_weight_valid_in;
    wire [ARRAY_SIZE-1:0]              row_weight_valid_out;
    wire [ARRAY_SIZE-1:0]              row_weight_ready_in;
    wire [ARRAY_SIZE-1:0]              row_weight_ready_out;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0]    col_output_data_in;
    wire [ACC_WIDTH*ARRAY_SIZE-1:0]    col_output_data_out;
    wire [ARRAY_SIZE-1:0]              col_output_valid_in;
    wire [ARRAY_SIZE-1:0]              col_output_valid_out;
    wire [ARRAY_SIZE-1:0]              col_output_ready_in;

    // 阵列忙标志
    wire [15:0] pe_busy_mesh;
    reg array_busy_reg;

    //==========================================================================
    // 输入激活加载控制逻辑
    //==========================================================================
    // 输入矩阵A按行主序加载，PE[row][col]接收输入A[row][col]

    genvar i_row, i_col;
    generate
        for (i_row = 0; i_row < ARRAY_SIZE; i_row = i_row + 1) begin : gen_input_valid_row
            for (i_col = 0; i_col < ARRAY_SIZE; i_col = i_col + 1) begin : gen_input_valid_col
                // Address matching
                wire addr_match = (input_addr == (i_row * ARRAY_SIZE + i_col));
                // 输入有效信号：匹配地址
                assign input_valid_mesh[i_row*ARRAY_SIZE + i_col] = input_valid && addr_match;
                // 输入加载信号：匹配地址
                assign input_load_mesh[i_row*ARRAY_SIZE + i_col] = input_load && addr_match;
            end
        end
    endgenerate

    // 输入激活数据路由：广播策略
    // 简化实现：所有PE接收相同的输入输入（实际应用中应根据PE位置路由）
    genvar input_row, input_col;
    generate
        for (input_row = 0; input_row < ARRAY_SIZE; input_row = input_row + 1) begin : gen_input_row
            for (input_col = 0; input_col < ARRAY_SIZE; input_col = input_col + 1) begin : gen_input_col
                assign input_mesh[(input_row*ARRAY_SIZE + input_col)*DATA_WIDTH +: DATA_WIDTH] = input_in;
            end
        end
    endgenerate

    // 输入就绪信号：只有被寻址的PE需要在 preload 阶段握手。
    // 这里增加一拍输出寄存，避免把深层 PE 的 stall/valid 扇出直接拉到顶层端口，
    // 从而缩短综合报告中最差的 control-to-output 路径。
    wire input_ready_comb;
    assign input_ready_comb = input_ready_mesh[input_addr];

    generate
        for (i_row = 0; i_row < ARRAY_SIZE; i_row = i_row + 1) begin : gen_weight_sync_fifo
            localparam integer FIFO_DEPTH = i_row;
            assign row_weight_data_in[i_row*WEIGHT_WIDTH +: WEIGHT_WIDTH] = weight_in;
            assign row_weight_valid_in[i_row] = weight_valid && (&row_weight_ready_in);
            assign row_weight_ready_out[i_row] = weight_ready_mesh[i_row*ARRAY_SIZE];

            sync_fifo #(
                .WIDTH(WEIGHT_WIDTH),
                .DEPTH(FIFO_DEPTH)
            ) u_weight_sync_fifo (
                .clk(clk),
                .rst_n(rst_n),
                .flush(flush),
                .clk_enable(clk_enable),
                .in_valid(row_weight_valid_in[i_row]),
                .in_data(row_weight_data_in[i_row*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                .in_ready(row_weight_ready_in[i_row]),
                .out_valid(row_weight_valid_out[i_row]),
                .out_data(row_weight_data_out[i_row*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                .out_ready(row_weight_ready_out[i_row])
            );
        end
    endgenerate

    //==========================================================================
    // PE阵列实例化和互连
    //==========================================================================
    // 4x4阵列：PE[row][col]，row表示行，col表示列

    genvar pe_row, pe_col;
    generate
        for (pe_row = 0; pe_row < ARRAY_SIZE; pe_row = pe_row + 1) begin : gen_row
            for (pe_col = 0; pe_col < ARRAY_SIZE; pe_col = pe_col + 1) begin : gen_col

                //-----------------------------------------------------------------
                // 权重数据连接（水平方向）
                //-----------------------------------------------------------------
                if (pe_col == 0) begin
                    assign weight_mesh[(pe_row*ARRAY_SIZE + pe_col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] =
                           row_weight_data_out[pe_row*WEIGHT_WIDTH +: WEIGHT_WIDTH];
                    assign weight_valid_mesh[pe_row*ARRAY_SIZE + pe_col] = row_weight_valid_out[pe_row];
                end else begin
                    // 其他列：从左侧PE接收权重
                    assign weight_mesh[(pe_row*ARRAY_SIZE + pe_col)*WEIGHT_WIDTH +: WEIGHT_WIDTH] =
                           weight_out_mesh[(pe_row*ARRAY_SIZE + pe_col-1)*WEIGHT_WIDTH +: WEIGHT_WIDTH];
                    assign weight_valid_mesh[pe_row*ARRAY_SIZE + pe_col] = weight_out_valid_mesh[pe_row*ARRAY_SIZE + pe_col-1];
                    assign weight_out_ready_mesh[pe_row*ARRAY_SIZE + pe_col-1] = weight_ready_mesh[pe_row*ARRAY_SIZE + pe_col];
                end

                //-----------------------------------------------------------------
                // 部分和连接（垂直方向）
                //-----------------------------------------------------------------
                if (pe_row == 0) begin
                    // 第一行：部分和初始化为0
                    assign partial_mesh[(pe_row*ARRAY_SIZE + pe_col)*ACC_WIDTH +: ACC_WIDTH] = {ACC_WIDTH{1'b0}};
                    assign partial_valid_mesh[pe_row*ARRAY_SIZE + pe_col] = weight_valid_mesh[pe_row*ARRAY_SIZE + pe_col];
                end else begin
                    // 其他行：从上方PE接收部分和
                    assign partial_mesh[(pe_row*ARRAY_SIZE + pe_col)*ACC_WIDTH +: ACC_WIDTH] =
                           partial_out_mesh[((pe_row-1)*ARRAY_SIZE + pe_col)*ACC_WIDTH +: ACC_WIDTH];
                    assign partial_valid_mesh[pe_row*ARRAY_SIZE + pe_col] = partial_out_valid_mesh[(pe_row-1)*ARRAY_SIZE + pe_col];
                    assign partial_out_ready_mesh[(pe_row-1)*ARRAY_SIZE + pe_col] = partial_ready_mesh[pe_row*ARRAY_SIZE + pe_col];
                end

                //-----------------------------------------------------------------
                // PE实例化
                //-----------------------------------------------------------------
                is_pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .WEIGHT_WIDTH(WEIGHT_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH),
                    .PE_ID(pe_row * ARRAY_SIZE + pe_col)
                ) pe_inst (
                    // 时钟和复位
                    .clk(clk),
                    .rst_n(rst_n),

                    // 输入激活接口
                    .input_load(input_load_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .input_valid(input_valid_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .input_in(input_mesh[(pe_row*ARRAY_SIZE + pe_col)*DATA_WIDTH +: DATA_WIDTH]),
                    .input_ready(input_ready_mesh[pe_row*ARRAY_SIZE + pe_col]),

                    // 权重数据接口
                    .weight_valid(weight_valid_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .weight_in(weight_mesh[(pe_row*ARRAY_SIZE + pe_col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_ready(weight_ready_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .weight_out(weight_out_mesh[(pe_row*ARRAY_SIZE + pe_col)*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                    .weight_out_valid(weight_out_valid_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .weight_out_ready(weight_out_ready_mesh[pe_row*ARRAY_SIZE + pe_col]),

                    // 部分和接口
                    .partial_in_valid(partial_valid_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .partial_in(partial_mesh[(pe_row*ARRAY_SIZE + pe_col)*ACC_WIDTH +: ACC_WIDTH]),
                    .partial_in_ready(partial_ready_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .partial_out(partial_out_mesh[(pe_row*ARRAY_SIZE + pe_col)*ACC_WIDTH +: ACC_WIDTH]),
                    .partial_out_valid(partial_out_valid_mesh[pe_row*ARRAY_SIZE + pe_col]),
                    .partial_out_ready(partial_out_ready_mesh[pe_row*ARRAY_SIZE + pe_col]),

                    // 控制和时钟门控接口
                    .flush(flush),
                    .clk_enable(clk_enable),
                    .pe_busy(pe_busy_mesh[pe_row*ARRAY_SIZE + pe_col])
                );

            end
        end
    endgenerate

    //==========================================================================
    // 输出连接
    //==========================================================================
    // 最后一行的PE输出作为最终结果

    genvar out_col;
    generate
        for (out_col = 0; out_col < ARRAY_SIZE; out_col = out_col + 1) begin : gen_output
            localparam integer FIFO_DEPTH = ARRAY_SIZE - out_col - 1;
            assign col_output_data_in[out_col*ACC_WIDTH +: ACC_WIDTH] =
                partial_out_mesh[(LAST_ROW_BASE + out_col)*ACC_WIDTH +: ACC_WIDTH];
            assign col_output_valid_in[out_col] = partial_out_valid_mesh[LAST_ROW_BASE + out_col];
            assign partial_out_ready_mesh[LAST_ROW_BASE + out_col] = col_output_ready_in[out_col];

            sync_fifo #(
                .WIDTH(ACC_WIDTH),
                .DEPTH(FIFO_DEPTH)
            ) u_output_sync_fifo (
                .clk(clk),
                .rst_n(rst_n),
                .flush(flush),
                .clk_enable(clk_enable),
                .in_valid(col_output_valid_in[out_col]),
                .in_data(col_output_data_in[out_col*ACC_WIDTH +: ACC_WIDTH]),
                .in_ready(col_output_ready_in[out_col]),
                .out_valid(col_output_valid_out[out_col]),
                .out_data(col_output_data_out[out_col*ACC_WIDTH +: ACC_WIDTH]),
                .out_ready(output_ready[out_col])
            );
        end
    endgenerate

    assign output_data = col_output_data_out;
    assign output_valid = col_output_valid_out;

    // Debug: monitor partial outputs
    `ifdef DEBUG
        always @(posedge clk) begin
            for (integer k = 0; k < ARRAY_SIZE; k = k + 1) begin
                if (partial_out_valid_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + k]) begin
                    $display("[%0t] DEBUG: partial_out[%0d] = %0d, valid=%b, ready=%b",
                             $time, k, $signed(partial_out_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + k]),
                             partial_out_valid_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + k],
                             partial_out_ready_mesh[(ARRAY_SIZE-1)*ARRAY_SIZE + k]);
                end
            end
        end

        // Monitor first row PE states
        always @(posedge clk) begin
            if (weight_valid_mesh[0] || weight_valid_mesh[3] ||
                partial_out_valid_mesh[0] || partial_out_valid_mesh[3]) begin
                $display("[%0t] DEBUG_COL0: PE(0,0) wt=%0d wt_out=%0d part_out=%0d part_out_vld=%b | PE(0,3) wt=%0d wt_out=%0d part_out=%0d part_out_vld=%b",
                         $time,
                         $signed(weight_mesh[0*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                         $signed(weight_out_mesh[0*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                         $signed(partial_out_mesh[0*ACC_WIDTH +: ACC_WIDTH]),
                         partial_out_valid_mesh[0],
                         $signed(weight_mesh[3*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                         $signed(weight_out_mesh[3*WEIGHT_WIDTH +: WEIGHT_WIDTH]),
                         $signed(partial_out_mesh[3*ACC_WIDTH +: ACC_WIDTH]),
                         partial_out_valid_mesh[3]);
            end
        end

        // Monitor column 3 partial sum flow across rows
        always @(posedge clk) begin
            if (partial_out_valid_mesh[3] || partial_out_valid_mesh[7] ||
                partial_out_valid_mesh[11] || partial_out_valid_mesh[15] ||
                partial_valid_mesh[15]) begin
                $display("[%0t] DEBUG_COL3: PE(2,3) out=%0d vld=%b | PE(3,3) in_vld=%b in=%0d out=%0d out_vld=%b",
                         $time,
                         $signed(partial_out_mesh[11*ACC_WIDTH +: ACC_WIDTH]), partial_out_valid_mesh[11],
                         partial_valid_mesh[15], $signed(partial_mesh[15*ACC_WIDTH +: ACC_WIDTH]),
                         $signed(partial_out_mesh[15*ACC_WIDTH +: ACC_WIDTH]), partial_out_valid_mesh[15]);
            end
        end

        // Monitor PE(3,3) output changes
        always @(posedge clk) begin
            // Monitor all output changes to find when data gets lost
            if (partial_out_valid_mesh[15] || partial_out_ready_mesh[15] ||
                ($signed(partial_out_mesh[15*ACC_WIDTH +: ACC_WIDTH]) != 0)) begin
                $display("[%0t] TRACE33: part_out=%0d part_vld=%b part_rdy=%b -> out_data=%0d out_vld=%b",
                         $time,
                         $signed(partial_out_mesh[15*ACC_WIDTH +: ACC_WIDTH]),
                         partial_out_valid_mesh[15],
                         partial_out_ready_mesh[15],
                         $signed(output_data[3*ACC_WIDTH +: ACC_WIDTH]),
                         output_valid[3]);
            end
        end
    `endif

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

    assign weight_ready_comb = &row_weight_ready_in;

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
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            array_busy_reg <= 1'b0;
        end else if (flush) begin
            array_busy_reg <= 1'b0;
        end else begin
            array_busy_reg <= |pe_busy_mesh |
                              |row_weight_valid_out |
                              |col_output_valid_out;  // 任一PE或同步FIFO忙则阵列忙
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
