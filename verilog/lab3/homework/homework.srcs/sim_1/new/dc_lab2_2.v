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
    
    reg x, Clk, reset;
    wire [2:0] D;
    wire [2:0] Q, Qbar;
    wire Z;
    
    assign D[2] = ~(~(~x & Q[0] & Qbar[1]));
    assign D[1] =  ~(~x & ~(Q[0] & Qbar[1]));
    assign D[0] = ~(~(~x & Q[1] & Qbar[2]) & ~(x & Q[2]));
    assign Z = ~(~(Q[0] & Q[1] & Qbar[2]));
    
   D_ff D1 (.D(D[2]), .Clk(Clk), .reset(reset), .Q(Q[2]), .Qbar(Qbar[2]));
   D_ff D2 (.D(D[1]), .Clk(Clk), .reset(reset), .Q(Q[1]), .Qbar(Qbar[1]));
   D_ff D3 (.D(D[0]), .Clk(Clk), .reset(reset), .Q(Q[0]), .Qbar(Qbar[0]));
   
    initial begin
        #200 $finish;
    end
    
    initial begin
        Clk = 0; x = 0; reset = 1;
        #2 Clk = 0;
        #3 Clk = 1;
        #5 reset = 0;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;    
        #5 x = 1;
        #5 Clk = 1;
        #5 x = 0;
        #5 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #2 x = 1;
        #8 Clk = 1;
        #3 x = 0;
        #7 Clk = 0; // 100ns
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #2 x = 1;
        #8 Clk = 1;
        #3 x = 0;
        #7 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
    end
endmodule
