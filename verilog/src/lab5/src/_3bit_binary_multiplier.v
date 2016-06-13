`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 13:06:03
// Design Name: 
// Module Name: _3bit_binary_multiplier
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


module _3bit_binary_multiplier
#(parameter WIDTH = 3)
(
    input start,
    input clk,
    input [(WIDTH-1):0] multiplier,
    input [(WIDTH-1):0] multiplicand,
    output [((WIDTH*2)-1):0] p,
    output done
);
    
    // control unit signal
    wire cnt_done, start_process, add, shift, count_up;
    wire clk_process;
    
    // adder variable
    wire [(WIDTH-1):0] b, s;
    wire cout;
    
    // register variable
    wire P_IN_out, P_H_shift_out, P_L_shift_out;
    wire [(WIDTH-1):0] P_H_parallel_out, P_L_parallel_out, MUL_parallel_out;
    
    
    assign b = MUL_parallel_out & {(WIDTH){P_L_parallel_out[0]}};
    assign p = {P_H_parallel_out, P_L_parallel_out};
    assign #7 clk_process = clk;
    
    _3bit_binary_multiplier_control_unit UNIT (start, clk, cnt_done, P_L_parallel_out[0], start_process, add, shift, count_up, done);
    
    shift_out_register #(1) P_IN (.start({1'b0, start_process}), .clk(clk_process), .load(~shift), .shift(shift), .D(cout), .shift_in(0), .Q(), .shift_out(P_IN_out));
    shift_out_register #(WIDTH) P_H (.start({{(WIDTH){1'b0}},start_process}), .clk(clk_process), .load(add), .shift(shift), .D(s), .shift_in(P_IN_out), .Q(P_H_parallel_out), .shift_out(P_H_shift_out));
    shift_out_register #(WIDTH) P_L (.start({multiplier, start_process}), .clk(clk_process), .load(1'b0), .shift(shift), .D(multiplier), .shift_in(P_H_shift_out), .Q(P_L_parallel_out), .shift_out(P_L_shift_out));
    
    parallel_out_register #(WIDTH) MUL (.start({multiplicand, start_process}), .clk(clk_process), .load(1'b0), .D(multiplicand), .Q(MUL_parallel_out));
    
    full_adder #(WIDTH) ADDER (.start(start_process), .add(add), .a(P_H_parallel_out), .b(b), .s(s), .cout(cout));
    
    down_counter #(WIDTH) COUNTER (.start(start), .clk(count_up), .cnt_done(cnt_done));
endmodule
