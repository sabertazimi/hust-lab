`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 11:30:18
// Design Name: 
// Module Name: rca_dataflow
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


module rca_dataflow(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output cout,
    output [3:0] s
    );
    
    wire [2:0] out;
    fulladder_dataflow ZERO (.a(a[0]), .b(b[0]), .cin(cin), .cout(out[0]), .s(s[0]));
    fulladder_dataflow ONE (.a(a[1]), .b(b[1]), .cin(out[0]), .cout(out[1]), .s(s[1]));
    fulladder_dataflow TWO (.a(a[2]), .b(b[2]), .cin(out[1]), .cout(out[2]), .s(s[2]));
    fulladder_dataflow THREE (.a(a[3]), .b(b[3]), .cin(out[2]), .cout(cout), .s(s[3]));
endmodule
