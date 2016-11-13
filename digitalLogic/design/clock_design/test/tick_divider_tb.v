`timescale 1ns / 1ps

module tick_divider_tb();

    parameter DELAY = 10;
    parameter TIME = 1000;
    
    reg clk_src;
    wire [3:0] clk_group;
    
    tick_divider DUT (
        .clk_src(clk_src),
        .clk_group(clk_group)
    ); 
    
    initial begin
        clk_src <= 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk_src <= ~clk_src;
    end

endmodule
