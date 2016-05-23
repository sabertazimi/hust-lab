`timescale 1ns / 1ps

module mux_2_to_1_gate_tb(
    );
	reg x, y, s;
	wire m;

	mux_2_to_1_gate DUT(.x(x), .y(y), .s(s), .m(m));

	initial begin
		x = 0; y = 0; s = 0;
		#10 x = 1;
		#10 x = 0;
		#10 x = 1;
		#10 x = 0;
		#10 x = 1;
		#10 x = 0;
		#10 x = 1;
		#10 x = 0;
		#10 x = 1;
		#10 x = 0;
		#10 s = 1;y = 1;
		#10 y = 0;
		#10 y = 1;
		#10 y = 0;
		#10 y = 1;
		#10 y = 0;
		#10 y = 1;
		#10 y = 0;
		#10 y = 1;
		#10 y = 0;
		#10 y = 1;
		#20;
	end
endmodule
