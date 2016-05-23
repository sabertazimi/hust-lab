`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 22:48:13
// Design Name: 
// Module Name: _4bit_to_7segment
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


module _4bit_to_7segment(
    input [3:0] x,
    output [6:0] seg
    );
    
    wire [3:0] an;
    
    bcd_to_7segment_decoder DUT (.x(x), .an(an), .seg(seg));
endmodule
