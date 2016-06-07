`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 11:22:51
// Design Name: 
// Module Name: parallel_out_register
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


module parallel_out_register
#(parameter WIDTH = 3)
(
    input clk,
    input load,
    input [(WIDTH-1):0] D,
    output reg [(WIDTH-1):0] Q
);
    
    always @(posedge clk) begin
        if (load) begin
            Q <= D;
        end
    end
endmodule
