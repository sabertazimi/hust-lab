`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 21:56:20
// Design Name: 
// Module Name: timer_tb
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

module timer_tb();

    parameter DELAY = 10;
    parameter TIME = 500;
    parameter WIDTH = 32;
    
    reg clk_normal, clk_change_time, power, enable, reset, add_time, sub_time;
    wire [WIDTH-1:0] count;
    wire sig_end;

    timer #(.WIDTH(WIDTH), .RANGE(5)) SEC_TIMER (
        .clk_normal(clk_normal),
        .clk_change_time(clk_change_time),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time),
        .sub_time(sub_time),
        .count(count),
        .sig_end(sig_end)
    ); 
    
    initial begin
        clk_normal <= 0;
        clk_change_time <= 0;
        power <= 0;
        enable <= 0;
        reset <= 0;
        add_time <= 0;
        sub_time <= 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk_normal <= ~clk_normal;
    end
    
    always begin
        #(DELAY/2) clk_change_time <= ~clk_change_time;
    end
    
    always begin
        // power = 0, enable = 0
        // all buttons don't work
        #(DELAY) add_time = 1;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 1;
        #(DELAY) sub_time = 0;
        
        // power = 0, enable = 1
        // all buttons don't work
        enable = 1;
        #(DELAY) add_time = 1;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 1;
        #(DELAY) sub_time = 0;

        // power = 1, enable = 1
        // reset works, add_time/sub_time doesn't work
        // feat: reset && count
        #(DELAY) power = 1;
        #(DELAY/2);
        #(DELAY) add_time = 1;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 1;
        #(DELAY) sub_time = 0;
        #(3*DELAY) reset = 1;
        #(DELAY) reset = 0;
        
        // power = 1, enable = 0
        // reset works, add_time/sub_time works
        // feat: add time && sub time
        #(10*DELAY) enable = 0;
        #(10*DELAY); // pause
        #(DELAY) add_time = 1;
        #(2*DELAY) add_time = 0;
        #(DELAY) sub_time = 1;
        #(DELAY) sub_time = 0;
        
        // power = 0
        // when power off, automatically reset all clock
        #(DELAY) power = 0;
    end
endmodule
