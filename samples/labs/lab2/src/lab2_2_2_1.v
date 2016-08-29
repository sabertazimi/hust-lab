`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 10:39:35
// Design Name: 
// Module Name: lab2_2_2_1
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


module lab2_2_2_1(
    input [3:0] v,
    output z,
    output [6:0] seg
    );
    
    wire [3:0] bcd;
    wire [3:0] an;
    lab2_2_2_1_partA BCD (.v(v), .z(z), .bcd(bcd));
    bcd_to_7segment_decoder SEG (.x(bcd), .an(an), .seg(seg));
endmodule
