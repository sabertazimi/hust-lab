`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 20:02:13
// Design Name: 
// Module Name: _4bit_binary_counter_tb
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


module _4bit_binary_counter_tb(

    );
    
    reg CP, M, LD_n, CLR_n;
    reg [3:0] D;
    wire [3:0] Q;
    wire Qcc_n;
    integer i;
    
    _4bit_binary_counter DUT (.CP(CP), .M(M), .D(D), .LD_n(LD_n), .CLR_n(CLR_n), .Q(Q), .Qcc_n(Qcc_n));
    
    initial begin
        #850 $finish;
    end
    
    initial begin
        CP = 0;
        for (i = 0; i < 85; i = i + 1) begin
            #10 CP = ~CP;
        end
    end
    
    initial begin
        M = 1; LD_n = 1; CLR_n = 0; D = 4'b0111;
        #10 CLR_n = 1;
        #350 CLR_n = 0;
        #10 CLR_n = 1;
        #10 LD_n = 0;
        #10 LD_n = 1;
        #10 M = 0;
    end
endmodule
