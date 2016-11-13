`timescale 1ns / 1ps

// @module
// divide clock source
// @input
// clk_src: raw clock source
// @output
// clk_dst: divided clock source
module range_divider
#(parameter WIDTH = 32, RANGE = 27'b101111101011110000100000000)
(
    input clk_src,
    output reg clk_dst    
);

    reg[(WIDTH-1):0] count;
    
    initial begin
        count <= 0;
    end

    // dividing clock source
    always@(posedge clk_src) begin
        count = count + 1;
        if (count == RANGE) begin
            count = 0;
            clk_dst = 1;
        end else begin
            clk_dst = 0;
        end
    end

endmodule
