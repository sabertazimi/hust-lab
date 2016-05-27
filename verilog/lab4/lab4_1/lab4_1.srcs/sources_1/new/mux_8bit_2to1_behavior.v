`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 19:09:33
// Design Name: 
// Module Name: mux_8bit_2to1_behavior
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


module mux_8bit_2to1_behavior(
    input [7:0] x,
    input [7:0] y,
    input s,
    output reg [7:0] m
    );

    always @(x or y or s) begin
        if (s == 0) m = x;
        else m = y;
    end
endmodule
