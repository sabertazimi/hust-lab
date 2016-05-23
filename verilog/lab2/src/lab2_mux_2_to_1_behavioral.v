`timescale 1ns / 1ps

module mux_2_to_1_behavioral(input x, input y, input s, output m);
	reg m;

	always @(x or y or s) begin
		if (s == 0) begin
			m = x;
		end
		else begin
			m = y;
		end
	end
endmodule
