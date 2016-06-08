`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:54:07
// Design Name: 
// Module Name: signal_source
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


module signal_source
#(parameter CYCLE = 5)
(
    output reg clk
);

    initial begin
        clk = 0;
    end
    
    always begin
        #(CYCLE/2.0) clk = ~clk;
    end
endmodule