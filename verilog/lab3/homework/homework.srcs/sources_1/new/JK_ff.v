`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 23:09:45
// Design Name: 
// Module Name: JK_ff
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


module JK_ff(
    input Clk,
    input J,
    input K,
    input reset_n,
    output reg Q,
    output Qbar
    );
    
    assign Qbar = ~Q;
    
    always @(negedge Clk) begin
        if (!reset_n) Q <= 0;
        else Q <= (J & Qbar) | (~K & Q);
    end
endmodule
