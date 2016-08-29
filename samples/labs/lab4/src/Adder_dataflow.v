`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 19:16:50
// Design Name: 
// Module Name: Adder_dataflow
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


module Adder_dataflow
#(parameter DATA_WIDTH = 8)
(
    input [(DATA_WIDTH - 1):0] a,
    input [(DATA_WIDTH - 1):0] b,
    output [(DATA_WIDTH - 1):0] s
    );
    
    assign s = a + b;
endmodule