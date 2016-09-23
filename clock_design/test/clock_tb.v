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

    parameter DELAY = 10;
    parameter TIME = 1000;
    
    reg clk_src, power, enable, reset;
    reg [2:0] add_time, sub_time;
    wire alarm;
    wire [7:0] anodes, cnodes;

    clock DUT (
        .clk_src(clk_src),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time),
        .sub_time(sub_time),
        .alarm(alarm),
        .anodes(anodes),
        .cnodes(cnodes)
    );
    
    initial begin
        clk_src <= 0;
        power <= 0;
        enable <= 0;
        reset <= 0;
        add_time <= 3'b000;
        sub_time <= 3'b000;
        #TIME $finish;
    end
    
    always begin
        #DELAY clk_src <= ~clk_src;
    end
    
endmodule
