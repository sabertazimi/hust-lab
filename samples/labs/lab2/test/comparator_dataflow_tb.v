`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 23:37:45
// Design Name: 
// Module Name: comparator_dataflow_tb
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


module comparator_dataflow_tb(
    );
    reg [3:0] in;
    wire flag;
    integer i;
   
   comparator_dataflow DUT (.in(in), .flag(flag));
   
   initial begin
       in = 0;
       for (i = 0;i < 16;i = i + 1)
           #10 in = i;
       #20;
   end
endmodule
