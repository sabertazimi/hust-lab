`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 20:36:12
// Design Name: 
// Module Name: D_behavior_tb
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


module D_behavior_tb(

    );
    
    reg D, Clk;
    wire Qa, Qb, Qc;
    
    D_behavior DUT (.D(D), .Clk(Clk), .Qa(Qa), .Qb(Qb), .Qc(Qc));
    
    initial begin
        #180 $finish;
    end
    
    initial begin
        Clk = 0; D = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 D = 1;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0; D = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 D = 1;
        #10 Clk = 0; 
        #10 Clk = 1;
        #10 Clk = 0; D = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #10 Clk = 1;
        #10 Clk = 0;
        #20;
    end
endmodule
