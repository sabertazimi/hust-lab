`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 16:12:07
// Design Name: 
// Module Name: test_bench_tb
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


module test_bench_tb(

    );
    
    reg a;
    wire #20 g1;
    wire #40 g2;
    
    test_bench DUT (.a(a), .g1(g1), .g2(g2));
    
    initial begin
        #150 $finish;
    end
    
    initial begin
        a = 0;
        #40 a = 1;
        #60 a = 0;
    end
    
endmodule
