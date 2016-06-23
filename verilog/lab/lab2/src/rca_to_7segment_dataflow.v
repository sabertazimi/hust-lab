`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 12:03:19
// Design Name: 
// Module Name: rca_to_7segment_dataflow
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


module rca_to_7segment_dataflow(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output z,
    output [6:0] seg
    );
    
    wire flag;
    wire [3:0] s;
    
    rca_dataflow ADD (.a(a), .b(b), .cin(cin), .cout(z), .s(s));
    
    lab2_2_2_1 SEG (.v(s), .z(flag), .seg(seg));
endmodule
