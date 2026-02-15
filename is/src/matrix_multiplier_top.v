//==============================================================================
// Matrix Multiplier Top Module
// 功能：封装Systolic阵列，提供标准矩阵乘法接口
// 支持：4x4矩阵乘法，可配置参数
//==============================================================================

module matrix_multiplier_top #(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 16,
    parameter ACC_WIDTH = 32,
    parameter MATRIX_SIZE = 4
)(
    // 系统信号
    input  wire clk,
    input  wire rst_n,

    // 控制接口
    input  wire start,           // 开始计算
    output wire done,            // 计算完成
    output wire busy,            // 忙标志

    // 矩阵A输入接口（按行主序输入）
    input  wire [DATA_WIDTH-1:0] matrix_a_in,
    input  wire matrix_a_valid,
    output wire matrix_a_ready,

    // 矩阵B输入接口（权重矩阵）
    input  wire [WEIGHT_WIDTH-1:0] matrix_b_in,
    input  wire matrix_b_valid,
    output wire matrix_b_ready,

    // 矩阵C输出接口（结果矩阵）
    output wire [ACC_WIDTH-1:0]  matrix_c_out,
    output wire matrix_c_valid,
    input  wire matrix_c_ready
);

    //==========================================================================
    // 状态机定义
    //==========================================================================
    localparam IDLE         = 3'd0;
    localparam LOAD_WEIGHT  = 3'd1;
    localparam LOAD_INPUT   = 3'd2;
    localparam COMPUTING    = 3'd3;
    localparam OUTPUT       = 3'd4;
    localparam DONE_STATE   = 3'd5;

    reg [2:0] state, next_state;

    //==========================================================================
    // 计数器和控制信号
    //==========================================================================
    reg [7:0] weight_count;      // 权重加载计数器（0-15）
    reg [7:0] input_count;       // 输入数据计数器（0-15）
    reg [7:0] output_count;      // 输出数据计数器（0-16）

    reg weight_load_en;
    reg input_valid_reg;
    reg [DATA_WIDTH-1:0] input_data_reg;

    //==========================================================================
    // FIFO/Memory缓冲（简化版，实际可使用真FIFO）
    //==========================================================================
    // 矩阵B存储（16个权重）
    reg [WEIGHT_WIDTH-1:0] weight_buffer [0:15];

    // 矩阵A存储（16个输入）
    reg [DATA_WIDTH-1:0] input_buffer [0:15];

    // 结果缓冲（16个输出）
    reg [ACC_WIDTH-1:0] output_buffer [0:15];
    reg [4:0] output_write_ptr;

    //==========================================================================
    // Systolic阵列实例化
    //==========================================================================
    wire [ACC_WIDTH-1:0] array_output [MATRIX_SIZE-1:0];
    wire [MATRIX_SIZE-1:0] array_output_valid;
    wire [MATRIX_SIZE-1:0] array_output_ready;
    wire array_busy;

    systolic_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ARRAY_SIZE(MATRIX_SIZE)
    ) systolic_array_inst (
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(matrix_b_in),
        .weight_valid(matrix_b_valid && state == LOAD_WEIGHT),
        .weight_load(weight_load_en),
        .weight_ready(matrix_b_ready),
        .input_data(input_data_reg),
        .input_valid(input_valid_reg),
        .input_ready(),  // 未使用
        .output_data(array_output),
        .output_valid(array_output_valid),
        .output_ready(array_output_ready),
        .flush(1'b0),
        .busy(array_busy)
    );

    //==========================================================================
    // 输出就绪信号生成
    //==========================================================================
    generate
        genvar i;
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin : gen_ready
            assign array_output_ready[i] = (state == COMPUTING) || (state == OUTPUT);
        end
    endgenerate

    //==========================================================================
    // 状态机时序逻辑
    //==========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            weight_count <= 0;
            input_count <= 0;
            output_count <= 0;
            output_write_ptr <= 0;
            weight_load_en <= 1'b0;
            input_valid_reg <= 1'b0;
            input_data_reg <= 0;
        end else begin
            state <= next_state;

            // 权重加载计数器
            case (state)
                LOAD_WEIGHT: begin
                    if (matrix_b_valid && matrix_b_ready) begin
                        weight_buffer[weight_count] <= matrix_b_in;
                        if (weight_count < 15)
                            weight_count <= weight_count + 1;
                        else
                            weight_count <= 0;
                    end
                end
                default: begin
                    weight_count <= 0;
                end
            endcase

            // 输入数据计数器
            case (state)
                LOAD_INPUT: begin
                    if (matrix_a_valid && matrix_a_ready) begin
                        input_buffer[input_count] <= matrix_a_in;
                        if (input_count < 15)
                            input_count <= input_count + 1;
                        else
                            input_count <= 0;
                    end
                end
                default: begin
                    input_count <= 0;
                end
            endcase

            // 输出计数器
            case (state)
                COMPUTING, OUTPUT: begin
                    if (|array_output_valid) begin
                        output_count <= output_count + 1;
                    end
                end
                default: begin
                    output_count <= 0;
                end
            endcase
        end
    end

    //==========================================================================
    // 状态机组合逻辑
    //==========================================================================
    always @(*) begin
        next_state = state;
        weight_load_en = 1'b0;
        input_valid_reg = 1'b0;

        case (state)
            IDLE: begin
                if (start)
                    next_state = LOAD_WEIGHT;
            end

            LOAD_WEIGHT: begin
                weight_load_en = 1'b1;
                if (weight_count == 15 && matrix_b_valid && matrix_b_ready)
                    next_state = LOAD_INPUT;
            end

            LOAD_INPUT: begin
                if (input_count == 15 && matrix_a_valid && matrix_a_ready)
                    next_state = COMPUTING;
            end

            COMPUTING: begin
                // 驱动输入数据到阵列
                input_valid_reg = 1'b1;
                if (output_count >= 19)  // 等待流水线填满
                    next_state = OUTPUT;
            end

            OUTPUT: begin
                if (output_count >= 20)
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    //==========================================================================
    // 输出数据收集和缓冲
    //==========================================================================
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_write_ptr <= 0;
        end else begin
            // 收集阵列输出
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                if (array_output_valid[j]) begin
                    output_buffer[output_write_ptr] <= array_output[j];
                    output_write_ptr <= output_write_ptr + 1;
                end
            end
        end
    end

    //==========================================================================
    // 输出接口
    //==========================================================================
    reg [4:0] output_read_ptr;
    reg matrix_c_valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            output_read_ptr <= 0;
            matrix_c_valid_reg <= 1'b0;
        end else begin
            if (state == OUTPUT && matrix_c_ready) begin
                if (output_read_ptr < 16) begin
                    output_read_ptr <= output_read_ptr + 1;
                    matrix_c_valid_reg <= 1'b1;
                end else begin
                    matrix_c_valid_reg <= 1'b0;
                end
            end else begin
                matrix_c_valid_reg <= 1'b0;
            end
        end
    end

    assign matrix_c_out = output_buffer[output_read_ptr];
    assign matrix_c_valid = matrix_c_valid_reg;

    // 输入就绪信号
    assign matrix_a_ready = (state == LOAD_INPUT);
    assign matrix_b_ready = (state == LOAD_WEIGHT);

    // 状态输出
    assign done = (state == DONE_STATE);
    assign busy = (state != IDLE) && (state != DONE_STATE);

endmodule
