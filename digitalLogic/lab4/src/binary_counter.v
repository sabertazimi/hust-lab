`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/10 19:39:34
// Design Name: 
// Module Name: binary_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module binary_counter
#(parameter LEN = 32)
(
    input clk_src,
    input reset,
    output reg [(LEN-1): 0] clk_group
);
    
    always @(posedge clk_src or posedge reset) begin
        if (reset) clk_group <= {(LEN){1'b0}};
        else clk_group <= clk_group + 1;
    end
endmodule
