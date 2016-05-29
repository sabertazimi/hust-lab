`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 21:31:52
// Design Name: 
// Module Name: _1bit_binary_comparator
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


module _1bit_binary_comparator(
    input A,
    input B,
    output [2:0] F
    );
    
    assign F[2] = ~A & B; // A < B
    assign F[1] = A ~^ B; // A == B
    assign F[0] = A & ~B; // A > B
endmodule
