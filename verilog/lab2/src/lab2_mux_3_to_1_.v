`timescale 1ns / 1ps

module mux_3_to_1(input u, input v, input w, input s0, input s1, output m);
	wire u_v;

	mux_2_to_1_gate Mux(.x(u), .y(v), .s(s0), .m(u_v));
	mux_2_to_1_gate Mux(.x(u_v), .y(w), .s(s1), .m(m));
endmodule
