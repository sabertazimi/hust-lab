`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 21:57:37
// Design Name: 
// Module Name: Datapath_with_mux_adder_register_memory_tb
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


module Datapath_with_mux_adder_register_memory_tb(

    );
    
    parameter DATA_WIDTH = 8;
    
    reg Clk, reset, a_sel, next_sel, sum_sel;
    reg [(DATA_WIDTH - 1):0] reset_value;
    wire [(DATA_WIDTH - 1):0] a_o, next_o, sum_o, ld_next_o, ld_sum_o, add1_o, add2_o, mem_o;
    wire next_zero;
    integer i, j;
    
    Datapath_with_mux_adder_register_memory #(DATA_WIDTH) DUT (.Clk(Clk), .reset(reset), .reset_value(reset_value), .a_sel(a_sel), .next_sel(next_sel), .sum_sel(sum_sel), 
        .a_o(a_o), .next_o(next_o), .sum_o(sum_o), .ld_next_o(ld_next_o), .ld_sum_o(ld_sum_o), .add1_o(add1_o), .add2_o(add2_o), .mem_o(mem_o), .next_zero(next_zero));
    
    initial begin
        #1000 $finish;
    end
    
    initial begin
        Clk = 0;
        for (i = 0; i < 100; i = i + 1) begin
            #10 Clk = ~Clk;
        end
    end
    
    initial begin
        reset_value = {{(DATA_WIDTH/2){1'b0}}, {(DATA_WIDTH/2){1'b1}}};
        reset = 1;
        {a_sel, next_sel, sum_sel} = 7;
        #40 reset = 0;
        for (j = 7; j >= 0; j = j - 1) begin
            #10 {a_sel, next_sel, sum_sel} = j;
            #100;
        end
    end
endmodule
