`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 17:02:53
// Design Name: 
// Module Name: _3bit_binary_multiplier_tb
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


module _3bit_binary_multiplier_tb(

    );

        parameter COUNT = 150;
        parameter DELAY = 10;
        parameter TIME = (COUNT * DELAY);
        parameter WIDTH = 3;
        
        reg start, clk;
        reg [(WIDTH-1):0] multiplier, multiplicand;
        wire [((WIDTH*2)-1):0] p;
        wire done;
        integer i, j, k;
        
        _3bit_binary_multiplier #(WIDTH) DUT (start, clk, multiplier, multiplicand, p, done);
 
        initial begin
            #TIME $finish;
        end
        
        initial begin
            clk = 0;
            for (i = 0; i < COUNT; i = i + 1) begin
                #DELAY clk = ~clk;
            end
        end
        
        initial begin
            start = 0; 
            #(DELAY/2);
            #(DELAY);
            for (j = 0; j < COUNT;j = j + 1) begin
                #(15*DELAY) start = 1;
                #DELAY start = 0;
            end
        end
        
        initial begin
            multiplier = 0; multiplicand = 1;
            for (k = 0; k < 7; k = k + 1) begin
                #(16*DELAY) multiplier = k; multiplicand = k + 1;
            end
        end
    endmodule
