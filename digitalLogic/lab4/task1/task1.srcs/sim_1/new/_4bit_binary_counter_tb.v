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
    parameter COUNT = 85;
    parameter DELAY = 10;
    reg CP, M, LD_n, CLR_n;
    reg [3:0] D;
    wire [3:0] Q;
    wire Qcc_n;
    integer i;
    
    _4bit_binary_counter DUT (.CP(CP), .M(M), .D(D), .LD_n(LD_n), .CLR_n(CLR_n), .Q(Q), .Qcc_n(Qcc_n));
    
    initial begin
        #(COUNT * DELAY) $finish;
    end
    
    initial begin
        CP = 0;
        for (i = 0; i < COUNT; i = i + 1) begin
            #DELAY CP = ~CP;
        end
    end
    
    initial begin
        M = 1;
        #(COUNT*DELAY/2) M = 0;
    end
        
    initial begin
        D = 4'b1111; LD_n = 1; CLR_n = 0;
        #DELAY CLR_n = 1;
        #(5*DELAY) CLR_n = 0;
        #(3*DELAY) CLR_n = 1;
        #(5*DELAY) LD_n = 0;
        #(2*DELAY) D = 4'b0111;
        #(4*DELAY) LD_n = 1;
    end
endmodule
