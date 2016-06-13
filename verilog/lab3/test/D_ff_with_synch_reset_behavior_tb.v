`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 20:45:40
// Design Name: 
// Module Name: D_ff_with_synch_reset_behavior_tb
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


module D_ff_with_synch_reset_behavior_tb(

    );
    
    reg D, Clk, reset;
    wire Q;
    
    D_ff_with_synch_reset_behavior DUT (.D(D), .Clk(Clk), .reset(reset), .Q(Q));
    
    initial begin
        #120 $finish;
    end
    
    initial begin
        D = 0; Clk = 0; reset = 0;
        #10 Clk = 1;
        #10 Clk = 0; D = 1;
        #10 Clk = 1;
        #5 reset = 1;
        #5 Clk = 0; reset = 0;
        #5 reset = 1;
        #5 Clk = 1;
        #5 reset = 0;
        #5 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #5 D = 0;
        #2 reset = 1;
        #3 Clk = 1;
        #2 reset = 0;
        #20;
    end
endmodule
