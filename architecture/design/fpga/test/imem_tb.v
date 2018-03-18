module imem_tb;

    parameter DATA_WIDTH = 32;
    parameter BUS_WIDTH = 10;
    parameter CODE_FILE= "mips/benchmark.hex";

	reg clk;
    reg [DATA_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] rdata;

	imem #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUS_WIDTH(BUS_WIDTH),
        .CODE_FILE(CODE_FILE)
    ) imem (
        .addr(addr[BUS_WIDTH+1:2]),
        .rdata(rdata)
    );

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("vcd/imem_tb.vcd");
		$dumpvars(0, imem_tb);
        
		$display("addr,\t\trdata");
		$monitor("%x,\t%x", addr, rdata);

		clk <= 1'b0;
		addr <= 32'h0;
        
		@(posedge clk);

		addr <= 32'h4;
        
		@(posedge clk);

		addr <= 32'h2c;
        
		@(posedge clk);

		addr <= 32'h40;
        
		$finish;
	end

endmodule