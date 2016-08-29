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
 
    parameter COUNT = 1000;   // number of T
    parameter DELAY = 5;    // T = 10ns, f = 100MHz
       
    reg clk_src, reset, M;
    reg [4:0] clk_sel;
    wire [3:0] state;
    integer i;
    
    flow_led DUT (.clk_src(clk_src), .reset(reset), .clk_sel(clk_sel), .M(M), .state(state));
    
    initial begin
        #(COUNT*DELAY) $finish;
    end
    
    initial begin
        clk_src = 0;
        for(i = 0; i < COUNT; i = i + 1) begin
            #DELAY clk_src = ~clk_src;
        end
    end
    
    initial begin
        M = 1;
        #(COUNT*DELAY/2) M = 0;
    end
    
    initial begin
        reset = 0;
        #DELAY reset = 1;
        #DELAY reset = 0;
        #((COUNT-5)*DELAY/2) reset = 0;
        #DELAY reset = 1;
        #DELAY reset = 0;
    end
    
    initial begin
        clk_sel = 5'b0000;
        #(COUNT*DELAY/5) clk_sel = clk_sel + 1;
        #(COUNT*DELAY/5) clk_sel = clk_sel + 1;
        #(COUNT*DELAY/5) clk_sel = clk_sel + 1;
        #(COUNT*DELAY/5) clk_sel = clk_sel + 1;
        #(COUNT*DELAY/5) clk_sel = clk_sel + 1;
    end
endmodule
