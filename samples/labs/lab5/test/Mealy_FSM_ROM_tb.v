`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/06 20:44:21
// Design Name: 
// Module Name: Mealy_FSM_ROM_tb
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


module Mealy_FSM_ROM_tb(

    );
    
    reg clk, reset, x;
    wire [2:0] count;
    integer i;
    
    Mealy_FSM_ROM DUT (clk, reset, x, count);
    
    initial begin
        #330 $finish;
    end
    
    initial begin
        clk = 0;
        for (i = 0; i < 66;i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        reset = 1;
        #20 reset = 0;
        #170 reset = 1;
        #10 reset = 0;
    end
    
    initial begin
        x = 0;
        #40 x = 1;
        #20 x = 0;
        #60 x = 1;
        #40 x = 0;
        #20 x = 1;
        #30 x = 0;
        #30 x = 1;
    end
endmodule
