`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/06 19:21:08
// Design Name: 
// Module Name: Moore_FSM_tb
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


module Moore_FSM_tb(

    );
    
    reg clk, reset;
    reg [1:0] x;
    wire yout;
    integer i;
    
    Moore_FSM DUT (clk, reset, x, yout);
    
    initial begin
        #250 $finish;
    end
    
    initial begin
        clk = 0;
        for (i = 0; i < 50; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        reset = 1;
        #20 reset = 0;
        #150 reset = 1;
        #10 reset = 0;
    end
    
    initial begin
        x = 0;
        #40 x = 3;
        #10 x = 2;
        #10 x = 0;
        #20 x = 2;
        #10 x = 0;
        #10 x = 3;
        #10 x = 0;
        #10 x = 1;
        #10 x = 0;
        #10 x = 2;
        #10 x = 3;
        #10 x = 0;
        #30 x = 2;
        #30 x = 0;
    end
endmodule
