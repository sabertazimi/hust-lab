`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 21:10:30
// Design Name: 
// Module Name: mux_3_to_1
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


module mux_3_to_1(input u, input v, input w, input s0, input s1, output m);
	wire u_v;

	mux_2_to_1_gate Mux1 (.x(u), .y(v), .s(s0), .m(u_v));
	mux_2_to_1_gate Mux2 (.x(u_v), .y(w), .s(s1), .m(m));
endmodule
