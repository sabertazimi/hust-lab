`timescale 1ns / 1ps

module mux_2bit_2_to_1_dataflow(input [1:0] x, input [1:0] y, input s, output [1:0] m);
	wire [1:0] two_s;

	assign two_s[0] = s;
	assign two_s[1] = s;
	assign #3 m = (x & ~two_s) | (y & two_s);
endmodule
