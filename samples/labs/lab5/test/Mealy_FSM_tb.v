`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/30 20:05:42
// Design Name: 
// Module Name: Mealy_FSM_tb
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


module Mealy_FSM_tb(

    );
    
    reg Clk, reset, ain;
    wire [3:0] count;
    wire yout;
    integer i;
    
    Mealy_FSM DUT (Clk, reset, ain, count, yout);
    
    initial begin
        #330 $finish;
    end
    
    initial begin
        Clk = 0;
        for (i = 0; i < 66;i = i + 1) begin
            #5 Clk = ~Clk;
        end
    end
    
    initial begin
        reset = 1;
        #20 reset = 0;
        #170 reset = 1;
        #10 reset = 0;
    end
    
    initial begin
        ain = 0;
        #40 ain = 1;
        #20 ain = 0;
        #60 ain = 1;
        #40 ain = 0;
        #20 ain = 1;
        #30 ain = 0;
        #30 ain = 1;
    end
endmodule
