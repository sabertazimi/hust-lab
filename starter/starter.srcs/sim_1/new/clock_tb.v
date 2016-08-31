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

    parameter COUNT = 64;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg clk_src, sig_en;
    wire sig_start, sig_end;

    clock DUT (
        .clk_src(clk_src),
        .sig_en(sig_en),
        .sig_start(sig_start),
        .sig_end(sig_end)
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
