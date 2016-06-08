`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 21:20:19
// Design Name: 
// Module Name: timing_signal_generator_tb
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


module timing_signal_generator_tb(

    );
    
    parameter CYCLE = 5;
    parameter LEN = 4;
    parameter TIME = 500;
    
    reg clr_n, on, off;
    reg [3:0] power;
    wire [(LEN-1):0] T;
    
    timing_signal_generator #(.CYCLE(CYCLE), .LEN(LEN)) DUT (
        .clr_n(clr_n),
        .on(on),
        .off(off),
        .power(power),
        .T(T));
    
    initial begin
        #TIME $stop;
    end
    
    initial begin
        clr_n = 1;
        on = 0; off = 1;
        power = 4'b0000;
        #10 clr_n = 0;
        #10 clr_n = 1;
        #10 power = 4'b0001;
    end
endmodule
