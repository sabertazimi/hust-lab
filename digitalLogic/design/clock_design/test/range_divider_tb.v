`timescale 1ns / 1ps

module range_divider_tb();

    parameter DELAY = 10;
    parameter WIDTH = 32;
    parameter TIME = 200;
    
    reg clk_src;
    wire clk_dst;
    
    range_divider #(.WIDTH(WIDTH), .RANGE(2)) DUT (
        .clk_src(clk_src),
        .clk_dst(clk_dst)
    ); 
    
    initial begin
        clk_src <= 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk_src <= ~clk_src;
    end
    
endmodule
