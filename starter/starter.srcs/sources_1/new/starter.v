`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 21:46:06
// Design Name: 
// Module Name: starter
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


module starter
(
    input clk_src,
    input sig_en,
    output sig_start,
    output sig_end
);
  
  parameter WIDTH = 32;
  wire [WIDTH-1:0] clk_group;
  counter COUNTER (.clk_src(clk_src), .clk_group(clk_group));
  timer TIMER (.clk_src(clk_group[0]), .sig_en(sig_en), .sig_start(sig_start), .sig_end(sig_end));
endmodule
