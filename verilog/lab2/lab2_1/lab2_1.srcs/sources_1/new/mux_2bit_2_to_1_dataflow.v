`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 20:29:04
// Design Name: 
// Module Name: mux_2bit_2_to_1_dataflow
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


module mux_2bit_2_to_1_dataflow(input [1:0] x, input [1:0] y, input s, output [1:0] m);
	wire [1:0] two_s;

	assign two_s[0] = s;
	assign two_s[1] = s;
	assign m = (x & ~two_s) | (y & two_s);
endmodule

