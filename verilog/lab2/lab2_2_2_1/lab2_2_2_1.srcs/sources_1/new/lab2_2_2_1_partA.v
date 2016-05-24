`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 00:03:02
// Design Name: 
// Module Name: lab2_2_2_1_partA
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


module lab2_2_2_1_partA(
    input [3:0] v,
    output z,
    output [3:0] bcd
    );
    wire flag;
    wire [2:0] circuit_v; 
    
    // get compare result
    comparator_dataflow CMP (.in(v), .flag(flag));
    
    // manipulate v[2:0]
    lab2_circuitA_dataflow CIR (.in_v2_0(v[2:0]), .out_v2_0(circuit_v));
    
    // output flag
    assign z = flag;
    
    // with flag , using multiplexer
    mux_2_to_1_gate ZERO (.x(v[0]), .y(circuit_v[0]), .s(flag), .m(bcd[0]));
    mux_2_to_1_gate ONE (.x(v[1]), .y(circuit_v[1]), .s(flag), .m(bcd[1]));
    mux_2_to_1_gate TWO (.x(v[2]), .y(circuit_v[2]), .s(flag), .m(bcd[2]));
    mux_2_to_1_gate THREE (.x(v[3]), .y(0), .s(flag), .m(bcd[3]));
endmodule
