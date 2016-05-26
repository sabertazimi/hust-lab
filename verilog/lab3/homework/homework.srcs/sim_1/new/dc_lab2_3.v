`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/26 07:27:09
// Design Name: 
// Module Name: dc_lab2_3
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


module dc_lab2_3(

    );
    
    reg x, Clk, reset_n;
    wire [1:0] J, K;
    wire [1:0] Q, Qbar;
    wire Z;
    
    assign J[1] = x ^ Q[0];
    assign K[1] =  x ^ Q[0];
    assign J[0] = 1;
    assign K[0] = 1;
    assign Z = ~(~(~x & Q[0] & Q[1]) & ~(x & & Qbar[0] & Qbar[1]));
    
    JK_ff JK1 (.Clk(Clk), .J(J[0]), .K(K[0]), .reset_n(reset_n), .Q(Q[0]), .Qbar(Qbar[0]));
    JK_ff JK2 (.Clk(Clk), .J(J[1]), .K(K[1]), .reset_n(reset_n), .Q(Q[1]), .Qbar(Qbar[1]));
    
    initial begin
        #400 $finish;
    end
    
    initial begin
        Clk = 1; x = 0; reset_n = 0;
        #10 Clk = 0;
        #10 reset_n = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 x = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
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
