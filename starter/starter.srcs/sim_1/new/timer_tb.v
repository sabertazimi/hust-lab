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
    
    parameter COUNT = 64;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg clk_src, sig_en;
    wire sig_start, sig_end;

    timer #(.WIDTH(WIDTH), .RANGE(59)) SEC_TIMER (
        .clk_src(clk_dst),
        .power(power),
        .switch_en(switch_en),
        .sig_up_time(sig_up_sec),
        .sig_reset(sig_reset),
        .count(sec),
        .sig_start(),
        .sig_end(sig_sec)
    ); 
    
    initial begin
        clk_src <= 0;
        #TIME $finish;
    end
    
    always begin
        #DELAY clk_src <= ~clk_src;
    end
    
    initial begin
        sig_en <= 1;
    end
endmodule
