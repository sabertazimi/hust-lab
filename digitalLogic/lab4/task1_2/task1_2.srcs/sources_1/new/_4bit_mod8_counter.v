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
    input reset,
    input M,
    output [3:0] Q,
    output Qcc_n
    );
    
    reg LD_n;

    always @(reset or M or CP) begin
        if(M) LD_n = ~(Q[3]&Q[1])&~reset;
        else LD_n = (~Q[3]|Q[2]|~Q[1]|Q[0])&~reset;
    end
    
    _4bit_binary_counter COUNT (.CP(CP), .M(M), .D(4'b0010), .LD_n(LD_n), .CLR_n(1), .Q(Q), .Qcc_n(Qcc_n));

    
endmodule
