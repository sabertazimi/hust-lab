`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 15:17:56
// Design Name: 
// Module Name: lab3_15s_tb
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


module lab3_15s_tb(

    );
    reg INPUT,Clk, reset;
    parameter DELAY=7.5;
    parameter TIME=150; 
    wire OUT;
    integer i;
    lab3_15s DUT (.INPUT(INPUT), .Clk(Clk), .OUT(OUT), .reset(reset));
    
    initial
    begin
    #TIME $finish;
    end
    
    initial begin
        Clk = 0;
        for (i = 0; i < (TIME/DELAY); i = i + 1) begin
            #DELAY Clk = ~Clk;
        end
    end
    
    initial
    begin
    reset = 1; INPUT = 0;
    #(2*DELAY) reset = 0;
    #DELAY INPUT=1;
    #(2*DELAY) INPUT=1;
    #(2*DELAY) INPUT=0;
    #(2*DELAY) INPUT=1;
    #(2*DELAY) INPUT=0;
    #(2*DELAY) INPUT=0;
    #(2*DELAY) INPUT=0;
    #DELAY;
    end
endmodule
