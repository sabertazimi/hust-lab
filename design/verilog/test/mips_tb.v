module mips_tb;
    parameter DATA_WIDTH = 32, CODE_FILE = "mips/benchmark.hex", IM_BUS_WIDTH = 10, DM_BUS_WIDTH = 24;
    
    reg raw_clk;
    reg raw_rst;
    reg raw_en;
    wire [DATA_WIDTH-1:0] a0_data;
    
    mips #(
        .DATA_WIDTH(DATA_WIDTH),
        .CODE_FILE(CODE_FILE),
        .IM_BUS_WIDTH(IM_BUS_WIDTH),
        .DM_BUS_WIDTH(DM_BUS_WIDTH)
    ) mips (
        .raw_clk(raw_clk),
        .raw_rst(raw_rst),
        .raw_en(raw_en),
        .a0_data(a0_data)
    );
    
	always begin
		raw_clk <= ~raw_clk;
		#5;
	end

	initial begin
		$dumpfile("vcd/mips_tb.vcd");
		$dumpvars(0, mips_tb);

		$display("raw_clk,\traw_rst,\traw_en,\ta0_data");
		$monitor("%x,\t%x,\t%x,\t%x", raw_clk, raw_rst, raw_en, a0_data);

		raw_clk <= 1'b0;
		raw_rst <= 1'b0;
		raw_en <= 1'b1;

		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
        
		$finish;
	end

endmodule // mips_tb

