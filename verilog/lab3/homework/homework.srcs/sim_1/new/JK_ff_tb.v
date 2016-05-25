`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 23:55:29
// Design Name: 
// Module Name: JK_ff_tb
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


module JK_ff_tb(
    );
    
    reg Clk, J, K, reset_n;
    wire Q, Qbar;
    
    JK_ff DUT (.Clk(Clk), .J(J), .K(K), .reset_n(reset_n), .Q(Q), .Qbar(Qbar));
    
    initial begin
        #200 $finish;
    end
    
        initial begin
        Clk = 0; J = 1; K = 1; reset_n = 0;
        #4 Clk = 1;
        #3 Clk = 0;
        #3 reset_n = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #5 J = 0; K = 1;
        #5 Clk = 1;
        #5 Clk = 0;
        #5 Clk = 1;
        #5 J = 1; K = 0;
        #5 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #2 J = 0; K = 0;
        #8 Clk = 1;
        #10 Clk = 0; // 100ns
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #2 J = 1; K = 1;
        #8 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
    end
endmodule
