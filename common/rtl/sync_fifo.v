`timescale 1ns/1ps

module sync_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 1
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             flush,
    input  wire             clk_enable,
    input  wire             in_valid,
    input  wire [WIDTH-1:0] in_data,
    output wire             in_ready,
    output wire             out_valid,
    output wire [WIDTH-1:0] out_data,
    input  wire             out_ready
);

    generate
        if (DEPTH == 0) begin : gen_bypass
            assign in_ready = out_ready;
            assign out_valid = in_valid;
            assign out_data = in_data;
        end else begin : gen_storage
            localparam integer PTR_WIDTH = (DEPTH <= 1) ? 1 : $clog2(DEPTH);
            localparam integer COUNT_WIDTH = $clog2(DEPTH + 1);
            localparam [PTR_WIDTH-1:0] LAST_PTR = PTR_WIDTH'(DEPTH - 1);
            localparam [COUNT_WIDTH-1:0] DEPTH_COUNT = COUNT_WIDTH'(DEPTH);

            reg [WIDTH-1:0] storage [0:DEPTH-1];
            reg [PTR_WIDTH-1:0] rd_ptr;
            reg [PTR_WIDTH-1:0] wr_ptr;
            reg [COUNT_WIDTH-1:0] count;

            wire do_write;
            wire do_read;

            function [PTR_WIDTH-1:0] ptr_next;
                input [PTR_WIDTH-1:0] ptr;
                begin
                    if (ptr == LAST_PTR) begin
                        ptr_next = {PTR_WIDTH{1'b0}};
                    end else begin
                        ptr_next = ptr + {{(PTR_WIDTH-1){1'b0}}, 1'b1};
                    end
                end
            endfunction

            assign do_read = out_valid && out_ready;
            assign in_ready = (count < DEPTH_COUNT) || do_read;
            assign out_valid = (count != 0);
            assign out_data = storage[rd_ptr];
            assign do_write = in_valid && in_ready;

            integer idx;
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    rd_ptr <= {PTR_WIDTH{1'b0}};
                    wr_ptr <= {PTR_WIDTH{1'b0}};
                    count <= {COUNT_WIDTH{1'b0}};
                    for (idx = 0; idx < DEPTH; idx = idx + 1) begin
                        storage[idx] <= {WIDTH{1'b0}};
                    end
                end else if (flush) begin
                    rd_ptr <= {PTR_WIDTH{1'b0}};
                    wr_ptr <= {PTR_WIDTH{1'b0}};
                    count <= {COUNT_WIDTH{1'b0}};
                end else if (clk_enable) begin
                    if (do_write) begin
                        storage[wr_ptr] <= in_data;
                        wr_ptr <= ptr_next(wr_ptr);
                    end

                    if (do_read) begin
                        rd_ptr <= ptr_next(rd_ptr);
                    end

                    case ({do_write, do_read})
                        2'b10: count <= count + {{(COUNT_WIDTH-1){1'b0}}, 1'b1};
                        2'b01: count <= count - {{(COUNT_WIDTH-1){1'b0}}, 1'b1};
                        default: count <= count;
                    endcase
                end
            end
        end
    endgenerate

endmodule
