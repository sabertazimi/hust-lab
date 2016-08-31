`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 22:12:21
// Design Name: 
// Module Name: starter_tb
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


module clock_tb();

    parameter COUNT = 10000;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg clk_src, power, switch_en, sig_up_sec, sig_up_min, sig_up_hour, sig_reset;
    wire bell;
    wire [7:0] seg_control, seg_time;

    clock DUT (
        .clk_src(clk_src),
        .power(power),
        .switch_en(switch_en),
        .sig_up_sec(sig_up_sec),
        .sig_up_min(sig_up_min),
        .sig_up_hour(sig_up_hour),
        .sig_reset(sig_reset),
        .bell(bell),
        .seg_control(seg_control),
        .seg_time(seg_time)
    );
    
    initial begin
        clk_src <= 0;
        power <= 1;
        switch_en <= 1;
        sig_up_sec <= 0;
        sig_up_min <= 0;
        sig_up_hour <= 0;
        sig_reset <= 0;
        #TIME $finish;
    end
    
    always begin
        #DELAY clk_src <= ~clk_src;
    end
    
    always begin
        #(TIME/3) switch_en <= 0;
        #(DELAY) sig_up_sec <= 1;
        #(DELAY) sig_up_sec <= 0;
        #(DELAY) sig_up_sec <= 1;
        #(DELAY) sig_up_sec <= 0;
        #(DELAY) sig_up_sec <= 1;
        #(DELAY) sig_up_sec <= 0;
        #(DELAY) sig_up_sec <= 1;
        #(DELAY) sig_up_sec <= 0;
        #(DELAY) sig_up_sec <= 1;
        #(DELAY) sig_up_sec <= 0;
        #(5*DELAY) sig_reset <= 1;
        #DELAY sig_reset <= 0;
    end
    
    always begin
        #(TIME/3) switch_en <= 0;
        #(DELAY) sig_up_min <= 1;
        #(DELAY) sig_up_min <= 0;
        #(DELAY) sig_up_min <= 1;
        #(DELAY) sig_up_min <= 0;
        #(DELAY) sig_up_min <= 1;
        #(DELAY) sig_up_min <= 0;
        #(DELAY) sig_up_min <= 1;
        #(DELAY) sig_up_min <= 0;
        #(5*DELAY) sig_reset <= 1;
        #DELAY sig_reset <= 0;
    end    
       
    always begin
        #(TIME/3) switch_en <= 0; 
        #(DELAY) sig_up_hour <= 1;
        #(DELAY) sig_up_hour <= 0;
        #(DELAY) sig_up_hour <= 1;
        #(DELAY) sig_up_hour <= 0;
        #(DELAY) sig_up_hour <= 1;
        #(DELAY) sig_up_hour <= 0;
        #(DELAY) sig_up_hour <= 1;
        #(DELAY) sig_up_hour <= 0;
        #(5*DELAY) sig_reset <= 1;
        #DELAY sig_reset <= 0;
    end
    
endmodule
