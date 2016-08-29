`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 12:07:27
// Design Name: 
// Module Name: mod10_counter_tb
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


module mod10_counter_tb(

    );
    parameter COUNT = 100;
    parameter DELAY = 5;
    reg X,reset;
    wire Z,Q1,Q2,Q3,Q4;
    integer i;
    mod10_counter DUT (.X(X), .Z(Z), .reset(reset), .Q1(Q1), .Q2(Q2), .Q3(Q3), .Q4(Q4));
    
    initial begin
        #(COUNT*DELAY) $finish;
    end
    
    initial begin
        X = 0;
        for (i = 0; i < COUNT; i = i + 1) begin
            #DELAY X = ~X;
        end
    end
    
    initial
    begin
    reset=1;
    #(3*DELAY) reset=0;
    end      
endmodule