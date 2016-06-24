module d_ff_with_async_set_by_wait (
	input clk,
	input d,
	input set,
	output reg q,
	output reg qbar
);

	always
		begin
			wait (set == 1)
				begin
					#3 q <= 1;
					#2 qbar <= 0;
					wait (set == 0);
				end
		end

	always @(negedge clk)
		begin
			if (set != 1)
				begin
					#5 q <= d;
					#1 qbar = ~q;
				end
		end

endmodule