`timescale 1ns / 1ps

// @module
// divide clock source
// @input
// clk_src: raw clock source
// @output
// clk_group: divided clock source group(32 different Hz)
module tick_divider
#(parameter WIDTH = 32)
(
    input clk_src,
    output reg [(WIDTH-1): 0] clk_group
);

    initial begin
        clk_group <= {(WIDTH){1'b0}};
    end
    
    // divide clock source
    always @(posedge clk_src) begin
        clk_group <= clk_group + 1;
    end
endmodule
