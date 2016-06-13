`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 19:45:51
// Design Name: 
// Module Name: D_latch_dataflow_tb
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


module D_latch_dataflow_tb(

    );
    reg D;
    reg Enable;
    wire Q;
    wire Qbar;
    
    D_latch_dataflow DUT (.D(D), .Enable(Enable), .Q(Q), .Qbar(Qbar));
    
    initial begin
        #120 $finish;
    end
    
    initial begin
        D = 0; Enable = 0;
        #10 D = 1;
        #10 Enable = 1;
        #10 D = 0;
        #10 D = 1;
        #10 Enable = 0;
        #10 D = 0;
        #10 D = 1;
        #10 D = 0;
        #10 Enable = 1;
        #10 D = 1;
        #10 D = 0;
        #20;
    end
endmodule
