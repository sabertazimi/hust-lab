`timescale 1ns / 1ps

module mux_2_to_1_gate(input x, input y, input s, output m);
	wire neg_s, x_s, y_s;

	not (neg_s, s);
	and (x_s, x, neg_s);
	and (y_s, y, s);
	or  (m, x_s, y_s);
endmodule
