`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 21:31:11
// Design Name: 
// Module Name: counter
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


module counter
#(parameter WIDTH = 32)
(
    input clk_src,
    output reg [(WIDTH-1): 0] clk_group
);

    initial begin
        clk_group <= {(WIDTH){1'b0}};
    end
    
    always @(posedge clk_src) begin
        clk_group <= clk_group + 1;
    end
endmodule
