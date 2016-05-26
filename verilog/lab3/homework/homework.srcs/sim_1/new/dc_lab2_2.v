`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/26 07:45:58
// Design Name: 
// Module Name: dc_lab2_2
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


module dc_lab2_2(

    );
    
    
    reg x, Clk, reset_n;
    wire [2:0] J, K;
    wire [2:0] Q, Qbar;
    wire Z;
    
    assign J[0] = x;
    assign K[0] =  ~(x | Q[1]);;
    assign J[1] = 1;
    assign K[1] = ~(x | Qbar[0]);
    assign J[2] = ~(~(~x & Q[0] & Qbar[1]));
    assign K[2] = ~(x & Qbar[0]);
    assign Z =Q[2] & Q[1] & Q[0];
    
    JK_ff JK1 (.Clk(Clk), .J(J[0]), .K(K[0]), .reset_n(reset_n), .Q(Q[0]), .Qbar(Qbar[0]));
    JK_ff JK2 (.Clk(Clk), .J(J[1]), .K(K[1]), .reset_n(reset_n), .Q(Q[1]), .Qbar(Qbar[1]));
    JK_ff JK3 (.Clk(Clk), .J(J[2]), .K(K[2]), .reset_n(reset_n), .Q(Q[2]), .Qbar(Qbar[2]));
    
    initial begin
        #200 $finish;
    end
    
    initial begin
        Clk = 1; x = 0; reset_n = 0;
        #4 Clk = 0;
        #3 Clk = 1;
        #3 reset_n = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #5 x = 1;
        #5 Clk = 0;
        #5 x = 0;
        #5 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #2 x = 1;
        #8 Clk = 0;
        #3 x = 0;
        #7 Clk = 1; // 100ns
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #2 x = 1;
        #8 Clk = 0;
        #3 x = 0;
        #7 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
    end
endmodule
