`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 21:16:49
// Design Name: 
// Module Name: T_ff_enable_behavior_tb
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


module T_ff_enable_behavior_tb(

    );
    
    reg T, Clk, reset_n;
    wire Q;
    
    T_ff_enable_behavior DUT (.T(T), .Clk(Clk), .reset_n(reset_n), .Q(Q));
    
    initial begin
        #300 $finish;
    end
    
    initial begin
        T = 0; Clk = 0; reset_n = 0;
        #10 reset_n = 1;
        #10 Clk = 1;
        #10 Clk = 0; T = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0; T = 0;
        #10 Clk = 1;
        #10 Clk = 0; reset_n = 0;
        #10 Clk = 1;
        #10 Clk = 0; reset_n = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0; T = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
    end
endmodule
