`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 15:43:28
// Design Name: 
// Module Name: _3bit_binary_multiplier_control_unit_tb
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


module _3bit_binary_multiplier_control_unit_tb(

    );

    parameter COUNT = 64;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg start, clk, cnt_done, lsb;
    wire start_process, add, shift, count_up, done;
    // wire [2:0] state;
    integer i;
    
    _3bit_binary_multiplier_control_unit DUT (start, clk, cnt_done, lsb, start_process, add, shift, count_up, done 
        // ,state
        );
    
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
        start = 1; lsb = 1; cnt_done = 0;
        #(16*DELAY) lsb = 1; cnt_done = 1;
        #(16*DELAY) lsb = 0; cnt_done = 0;
        #(16*DELAY) lsb = 0; cnt_done = 1;
        #(16*DELAY);
    end
endmodule
