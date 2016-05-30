`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 19:14:13
// Design Name: 
// Module Name: Register_behavior
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


module Register_behavior
#(parameter DATA_WIDTH = 8)
(
    input Clk,
    input [(DATA_WIDTH - 1):0] D,
    input reset,
    input [(DATA_WIDTH - 1):0] reset_value,
    output reg [(DATA_WIDTH - 1):0] Q
    );
    
    always @(posedge Clk) begin
        if (reset) Q <= reset_value;
        else Q <= D;
    end
endmodule
