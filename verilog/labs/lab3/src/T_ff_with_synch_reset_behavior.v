`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 08:55:33
// Design Name: 
// Module Name: T_ff_with_ce_and_synch_reset_behavior
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


module T_ff_with_synch_reset_behavior(
    input Clk,
    input T,
    input reset_n,
    output reg Q
    );
    
    always @(negedge Clk) begin
        if (!reset_n) Q <= 1'b0;
        else if (T) Q <= ~Q;
    end
endmodule
