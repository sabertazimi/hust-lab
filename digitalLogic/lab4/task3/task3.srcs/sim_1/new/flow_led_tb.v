`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/05 22:54:09
// Design Name: 
// Module Name: flow_led_tb
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


module flow_led_tb(

    );
 
    parameter COUNT = 50;
    parameter DELAY = 10;
       
    reg Clk, reset, M;
    wire [3:0] state;
    integer i;
    
    flow_led DUT (.Clk(Clk), .reset(reset), .M(M), .state(state));
    
    initial begin
        #(COUNT*DELAY) $finish;
    end
    
    initial begin
        Clk = 0;
        for(i = 0; i < COUNT; i = i + 1) begin
            #DELAY Clk = ~Clk;
        end
    end
    
    initial begin
        M = 0;
        #(COUNT*DELAY/2) M = 1;
    end
    
    initial begin
        reset = 0;
        #DELAY reset = 1;
        #DELAY reset = 0;
        #((COUNT-5)*DELAY/2) reset = 0;
        #DELAY reset = 1;
        #DELAY reset = 0;
    end
endmodule
