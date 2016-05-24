`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 22:59:56
// Design Name: 
// Module Name: delay_line1_behavior_tb
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


module delay_line1_behavior_tb(

    );
    
    reg Clk, ShiftIn;
    wire ShiftOut;
    
    delay_line1_behavior DUT (.Clk(Clk), .ShiftIn(ShiftIn), .ShiftOut(ShiftOut));
    
    initial begin
        #180 $finish;
    end
    
    initial begin
        Clk = 0; ShiftIn = 0;
        #10 Clk = 1;
        #10 Clk = 0; ShiftIn = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0; ShiftIn = 0;
        #10 Clk = 1;
        #10 Clk = 0; ShiftIn = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0; ShiftIn = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
    end
endmodule
