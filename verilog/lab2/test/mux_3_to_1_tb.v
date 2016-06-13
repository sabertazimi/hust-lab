`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 21:10:46
// Design Name: 
// Module Name: mux_3_to_1_tb
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


module mux_3_to_1_tb(

    );
    reg u,  v, w, s0, s1;
    wire m;
    
    mux_3_to_1 DUT (.u(u), .v(v), .w(w), .s0(s0), .s1(s1), .m(m));
    
    initial begin
    u = 0; v = 0; w = 0; s0 = 0; s1 = 0;
    #10 s0 = 0; s1 = 0;
    #10 u = 1;
    #10 u = 0;
    #10 u = 1;
    #10 u = 0;
    #10 u = 1;
    #10 u = 0;
    #10 s0 = 1; s1 = 0;
    #10 v = 1;
    #10 v = 0;
    #10 v = 1;
    #10 v = 0;
    #10 v = 1;
    #10 v = 0;
    #10 s0 = 0; s1 = 1;
    #10 w = 1;
    #10 w = 0;
    #10 w = 1;
    #10 w = 0;
    #10 w = 1;
    #10 w = 0;
    #10 s0 = 1; s1 = 1;
    #10 w = 1;
    #10 w = 0;
    #10 w = 1;
    #10 w = 0;
    #10 w = 1;
    #10 w = 0;
    #20;
    end
endmodule
