`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:30:02
// Design Name: 
// Module Name: clock_generator
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


module clock_generator
#(parameter CYCLE = 5, LEN = 4)
(
    output [(LEN-1):0] clk
);

    wire src;
    
    signal_source #(CYCLE) SOURCE (.clk(src));
    binary_counter #(LEN) DIVIDER (.clk(src), .Q(clk));
endmodule
