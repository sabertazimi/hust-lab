`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/26 21:17:40
// Design Name: 
// Module Name: tick_divider_tb
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


module tick_divider_tb();

    parameter DELAY = 10;
    parameter TIME = 1000;
    
    reg clk_src;
    wire [3:0] clk_group;
    
    tick_divider DUT (
        .clk_src(clk_src),
        .clk_group(clk_group)
    ); 
    
    initial begin
        clk_src <= 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk_src <= ~clk_src;
    end

endmodule
