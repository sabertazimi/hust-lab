`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 10:44:13
// Design Name: 
// Module Name: lab2_2_2_1_tb
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


module lab2_2_2_1_tb(

    );
    reg [3:0] v;
    wire z;
    wire [6:0] seg;
    integer i;
    
    lab2_2_2_1 DUT (.v(v), .z(z), .seg(seg));
    
    initial begin
    v = 0;
    for (i = 0; i < 16; i = i + 1)
        #10 v = i;
    #20;
    end
endmodule
