`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 09:44:15
// Design Name: 
// Module Name: T_ff_with_D_ff
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


module T_ff_with_D_ff(
    input Clk,
    input T,
    input reset_n,
    output Q
    );
    
    D_ff_with_synch_reset_behavior DFF (.Clk(Clk), .D(T ^ Q), .reset(~reset_n), .Q(Q));
endmodule
