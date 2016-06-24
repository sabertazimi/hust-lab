module d_ff_with_async_clear_by_deassign (
	input clock,
	input d,
	input clear,
	output reg q
);

	always @(clear)
		begin
			if (!clear)
				begin
					assign q = 0;
				end
			else
				begin
					deassign q;
				end
		end

	always @(negedge clock)
		begin
			q <= d;
		end
endmodule
