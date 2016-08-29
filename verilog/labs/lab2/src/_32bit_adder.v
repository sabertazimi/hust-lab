`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Hust
// Engineer: sabertazimi
//
// Create Date: 2016/05/24 16:46:52
// Design Name: lab2
// Module Name: _32bit_adder
// Project Name: verilog lab
// Target Devices: FPGA
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


module _32bit_adder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output cout,
    output [31:0] s
    );

    assign {cout, s} = a + b + cin;
endmodule
