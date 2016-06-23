`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 12:23:27
// Design Name: 
// Module Name: carry_look_ahead_adder
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


module carry_look_ahead_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output cout,
    output [3:0] s,
    output p,
    output g,
    output c
    );
    
    wire [3:0] p;
    wire [3:0] g;
    wire [3:0] c;
    
    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = p[0] & cin | g[0];
    assign c[1] = p[1] &  (p[0] & cin | g[0]) | g[1];
    assign c[2] = p[2] & (p[1] &  (p[0] & cin | g[0]) | g[1]) | g[2];
    assign c[3] = p[3] & (p[2] & (p[1] &  (p[0] & cin | g[0]) |  g[1]) | g[2]) | g[3];
    assign cout = c[3];
    assign s[0] = a[0] + b[0] + cin;
    assign s[1] = a[1] + b[1] + c[0];
    assign s[2] = a[2] + b[2] + c[1];
    assign s[3] = a[3] + b[3] + c[2];
endmodule
