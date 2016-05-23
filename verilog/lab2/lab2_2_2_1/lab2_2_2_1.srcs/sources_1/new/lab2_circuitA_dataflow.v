`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 23:37:03
// Design Name: 
// Module Name: lab2_circuitA_dataflow
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


module lab2_circuitA_dataflow(
    input [2:0] in_v2_0,
    output [2:0] out_v2_0
    );
    assign out_v2_0 = in_v2_0- 3'b010;
endmodule
