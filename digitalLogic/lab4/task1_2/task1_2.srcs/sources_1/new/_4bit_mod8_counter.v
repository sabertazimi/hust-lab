`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 20:41:26
// Design Name: 
// Module Name: _4bit_mod4_counter
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


module _4bit_mod8_counter(
    input CP,
    input [3:0] D,
    input LD_n,
    output [3:0] Q,
    output Qcc_n
    );
    
    _4bit_binary_counter COUNT (.CP(CP), .M(1), .D(D), .LD_n(LD_n), .CLR_n(~Q[3]), .Q(Q), .Qcc_n(Qcc_n));
endmodule
