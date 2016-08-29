`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:58:35
// Design Name: 
// Module Name: clock_generator_tb
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


module clock_generator_tb(

    );
    
    parameter CYCLE = 250;
    parameter LEN = 4;
    parameter TIME = 5000;
    
    wire [(LEN-1):0] clk;
    
    clock_generator #(.CYCLE(CYCLE), .LEN(LEN)) DUT (.clk(clk));
    
    initial begin
        #TIME $stop;
    end
endmodule
