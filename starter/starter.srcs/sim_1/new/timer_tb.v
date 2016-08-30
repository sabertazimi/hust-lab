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


module timer_tb(

    );
    
    parameter COUNT = 1000;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    parameter WIDTH = 32;
    
    reg clk_src, power, switch_en, sig_up_time, sig_reset;
    wire [WIDTH-1:0] count;
    wire sig_end;

    timer #(.WIDTH(WIDTH), .RANGE(10)) SEC_TIMER (
        .clk_src(clk_src),
        .power(power),
        .switch_en(switch_en),
        .sig_up_time(sig_up_time),
        .sig_reset(sig_reset),
        .count(count),
        .sig_end(sig_end)
    ); 
    
    initial begin
        clk_src <= 0;
        power <= 1;
        switch_en <= 1;
        sig_up_time <= 0;
        sig_reset <= 0;
        #TIME $finish;
    end
    
    always begin
        #DELAY clk_src <= ~clk_src;
    end
    
    always begin
        #1000 switch_en = 0;
        #10 sig_up_time = 1;
        #10 sig_up_time = 0;
        #10 sig_up_time = 1;
        #10 sig_up_time = 0;
        #10 sig_reset = 1;
        #10 sig_reset = 0;
    end
endmodule
