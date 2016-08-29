`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 11:20:27
// Design Name: 
// Module Name: lab2_2_2_2_tb
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


module lab2_2_2_2_tb(

    );
    reg [3:0] x;
    wire [4:0] y;
    integer i;
    
    lab2_2_2_2 DUT (.x(x), .y(y));
    
    initial begin
    x = 0;
    for (i = 0; i < 10; i = i + 1)
        #10 x = i;
    #20;
    end
endmodule
