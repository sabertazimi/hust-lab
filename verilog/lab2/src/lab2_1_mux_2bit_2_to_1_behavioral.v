module mux_2bit_2_to_1_behavioral(input [1:0] x, input [1:0] y, input s, output [1:0] m);
	reg [1:0] m;

	always @(x or y or s) begin
		if (s == 0) begin
			m = x;
		end
		else begin
			m = y;
		end
	end
endmodule