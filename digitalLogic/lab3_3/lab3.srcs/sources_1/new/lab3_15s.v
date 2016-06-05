`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 15:09:17
// Design Name: 
// Module Name: lab3_15s
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


module lab3_15s(
    INPUT,OUT,Clk, reset
    );
    
    input INPUT,Clk, reset;
    output OUT;
    wire q1, s1;
    lab3 #(.DELAY(2)) DUT1 (.D(INPUT), .Q(q1), .Clk(Clk), .reset(reset));
    assign #10 s1=~q1;
    lab3 #(.DELAY(1)) DUT2 (.D(s1), .Q(OUT), .Clk(Clk), .reset(reset));
endmodule