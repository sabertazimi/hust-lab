`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 12:52:58
// Design Name: 
// Module Name: decoder_3to8_dataflow
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


module decoder_3to8_dataflow(
    input [0:2] x,
    output [7:0] y
    );
    assign y[7] = x[0] & x[1] & x[2];
    assign y[6] = x[0] & x[1] & ~x[2];
    assign y[5] = x[0] & ~x[1] & x[2];
    assign y[4] = x[0] & ~x[1] & ~x[2];
    assign y[3] = ~x[0] & x[1] & x[2];
    assign y[2] = ~x[0] & x[1] & ~x[2];
    assign y[1] = ~x[0] & ~x[1] & x[2];
    assign y[0] = ~x[0] & ~x[1] & ~x[2];
endmodule
