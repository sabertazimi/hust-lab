`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 19:22:45
// Design Name: 
// Module Name: SR_latch_dataflow_tb
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


module SR_latch_dataflow_tb(

    );
    reg R;
    reg S;
    wire Q;
    wire Qbar;
    
    SR_latch_dataflow DUT (.R(R), .S(S), .Q(Q), .Qbar(Qbar));
    
    initial begin
        #100 $finish;
    end
    
    initial begin
        R = 0; S = 0;
        #10 S = 1;
        #10 S = 0;
        #10 R = 1;
        #10 R = 0; S = 1;
        #10 R = 1; S = 0;
        #10 R = 0; S = 1;
        #10 R = 1; S = 0;
        #10 S = 1;
        #20;
    end
endmodule
