`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 13:33:41
// Design Name: 
// Module Name: down_counter_tb
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


module down_counter_tb(

    );
    
    parameter COUNT = 100;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg clk, start;
    wire cnt_done;
    integer i;
    
    down_counter #(5) DUT (start, clk, cnt_done);
    
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
        #DELAY start = 1;
        #DELAY start = 0;
    end
endmodule
