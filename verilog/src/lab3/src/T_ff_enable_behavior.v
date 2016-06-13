`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 21:16:39
// Design Name: 
// Module Name: T_ff_enable_behavior
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


module T_ff_enable_behavior(
    input T,
    input Clk,
    input reset_n,
    output reg Q
    );
    
    always @(negedge Clk) begin
        if (!reset_n) begin
            Q <= 1'b0;
        end
        else if (T) begin
            Q <= ~Q;
        end
    end
endmodule
