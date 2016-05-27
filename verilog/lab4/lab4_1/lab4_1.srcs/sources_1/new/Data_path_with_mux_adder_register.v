`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 19:18:50
// Design Name: 
// Module Name: Data_path_with_mux_adder_register
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

module Data_path_with_mux_adder_register(
    input Clk,
    input reset,
    input [7:0] reset_value,
    input s0,
    input s1,
    input s2,
    input s3,
    output [7:0] s0_o,
    output [7:0] s1_o,
    output [7:0] s2_o,
    output [7:0] s3_o,
    output [7:0] r0_o,
    output [7:0] r1_o,
    output [7:0] acc_o,
    output [7:0] s
    );

    mux_8bit_2to1_behavior S0 (.x(s3_o), .y(r0_o), .s(s0), .m(s0_o));
    mux_8bit_2to1_behavior S1 (.x(s3_o), .y(r1_o), .s(s1), .m(s1_o));
    mux_8bit_2to1_behavior S2 (.x(r0_o), .y(r1_o), .s(s2), .m(s2_o));
    mux_8bit_2to1_behavior S3 (.x(s2_o), .y(acc_o), .s(s3), .m(s3_o));
    
    Register_behavior R0 (.Clk(Clk), .reset(reset), .reset_value(reset_value), .D(s0_o), .Q(r0_o));
    Register_behavior R1 (.Clk(Clk), .reset(reset), .reset_value(reset_value), .D(s1_o), .Q(r1_o));
    Register_behavior ACC (.Clk(Clk), .reset(reset), .reset_value(reset_value), .D(s), .Q(acc_o));
    
    Adder_dataflow ADD (.a(acc_o), .b(s2_o), .s(s));
endmodule
