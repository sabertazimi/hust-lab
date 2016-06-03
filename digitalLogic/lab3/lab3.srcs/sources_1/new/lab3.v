`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 11:29:41
// Design Name: 
// Module Name: lab3
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


module lab3
#(parameter DELAY = 1)
(D, Q, Clk, reset);
    input D,Clk, reset;
    output reg Q;
    always @ (posedge Clk)
    begin
    if (reset) #DELAY Q<= 0;
    else #DELAY Q<=D;
    end
endmodule
