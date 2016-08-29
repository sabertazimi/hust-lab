`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/05 19:28:10
// Design Name: 
// Module Name: _2bit_binary_comparator
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


module _2bit_binary_comparator(
    input [1:0] A,
    input [1:0] B,
    output reg [2:0] F
    );
    
    wire [2:0] F1, F0;
    
    _1bit_binary_comparator COM1 (.A(A[1]), .B(B[1]), .F(F1));
    _1bit_binary_comparator COM0 (.A(A[0]), .B(B[0]), .F(F0));
    
    always @ * begin
        if (F1 == 3'b010) F <= F0;
        else F <= F1;
    end
endmodule

