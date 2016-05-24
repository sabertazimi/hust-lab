`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 11:09:40
// Design Name: 
// Module Name: lab2_2_2_2
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


module lab2_2_2_2(
    input [3:0] x,
    output [4:0] y
    );
    assign y[4] = (x[1] & x [2]) | x[3];
    assign y[3] = (x[0] & x[1] & ~x[2]) | (~x[1] & x[2]) | (x[0] & x[3]);
    assign y[2] = (~x[0] & x[1] & ~x[2]) | (~x[0] & x[3]) | (x[0] & ~x[1] & ~x[3]);
    assign y[1] = (~x[0] & ~x[1] & ~x[3]) | (x[0] & x[1] & x[2]) | (~x[0] & x[1] & ~x[2]);
    assign y[0] = (~x[0] & x[1] & x[2]) | (~x[1] & ~x[2] & ~x[3]) | (x[0] & ~x[2] & ~x[3]);
endmodule
