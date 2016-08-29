`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 10:30:58
// Design Name: 
// Module Name: lab2_2_2_1_partA_tb
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


module lab2_2_2_1_partA_tb(

    );
    reg [3:0] v;
    wire z;
    wire [3:0] bcd;
    integer i;
    
    lab2_2_2_1_partA DUT (.v(v), .z(z), .bcd(bcd));
    
    initial begin
        v = 0;
        for (i = 0; i < 16; i = i + 1)
            #10 v = i;
        #20;
    end
endmodule
