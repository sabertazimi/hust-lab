`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 21:57:27
// Design Name: 
// Module Name: Datapath_with_mux_adder_register_memory
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

module Datapath_with_mux_adder_register_memory(
    input Clk,
    input reset,
    input [7:0] reset_value,
    input a_sel,
    input next_sel,
    input sum_sel,
    output [7:0] a_o,
    output [7:0] next_o,
    output [7:0] sum_o,
    output [7:0] ld_next_o,
    output [7:0] ld_sum_o,
    output [7:0] add1_o,
    output [7:0] add2_o,
    output [7:0] mem_o,
    output next_zero
    );
    
    assign next_zero = (next_o == 8'b0000_0000);
    
    mux_8bit_2to1_behavior A (.x(ld_next_o), .y(add2_o), .s(a_sel), .m(a_o));
    mux_8bit_2to1_behavior NEXT (.x(0), .y(mem_o), .s(next_sel), .m(next_o));
    mux_8bit_2to1_behavior SUM (.x(0), .y(add1_o), .s(sum_sel), .m(sum_o));
    
    Register_behavior LD_NEXT (.Clk(Clk), .D(next_o), .reset(reset), .reset_value(reset_value), .Q(ld_next_o));
    Register_behavior LD_SUM (.Clk(Clk), .D(sum_o), .reset(reset), .reset_value(reset_value), .Q(ld_sum_o));
    
    Adder_dataflow ADD1 (.a(ld_sum_o), .b(mem_o), .s(add1_o));
    Adder_dataflow ADD2 (.a(ld_next_o), .b(1), .s(add2_o));
    
    memory MEM (.address(a_o), .data(mem_o));
endmodule
