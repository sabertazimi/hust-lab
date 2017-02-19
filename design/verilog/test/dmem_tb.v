module dmem_tb;

    parameter DATA_WIDTH = 32;
    parameter BUS_WIDTH = 24;
    
	reg clk;
    reg re;
    reg we;
    reg [DATA_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] wdata;
    wire [DATA_WIDTH-1:0] rdata;

	dmem #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUS_WIDTH(BUS_WIDTH)
    ) dmem (
        .clk(clk),
        .re(re),
        .we(we),
        .addr(addr[BUS_WIDTH+1:2]),
        .wdata(wdata),
		.rdata(rdata)
    );

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("dmem_tb.vcd");
		$dumpvars(0, dmem_tb);

		$display("clk,\taddr,\t\tre,\twe,\twdata,\t\trdata");
		$monitor("%x,\t%x,\t%x,\t%x,\t%x,\t%x",clk, addr, re, we, wdata, rdata);

		clk <= 1'b0;
		re <= 1'b0;
		we <= 1'b0;
		addr <= 7'd0;

		@(posedge clk);

		wdata <= 32'habcdfe01;
		addr <= 7'd0;
		re <= 1'b0;
		we <= 1'b1;

		@(posedge clk);
        
        re <= 1'b1;
        we <= 1'b0;
        
		@(posedge clk);

		wdata <= 32'hffffaaaa;
		addr <= 7'd1;
		re <= 1'b0;
		we <= 1'b1;

		@(posedge clk);

		re <= 1'b1;
		we <= 1'b0;
		addr <= 7'd0;

		@(posedge clk);

		re <= 1'b1;
		we <= 1'b0;
		addr <= 7'd1;

		@(posedge clk);

		re <= 1'b1;
		we <= 1'b1;
		wdata <= 32'hFEFEFEFE;
		addr <= 7'd0;
        
        @(posedge clk);
        
		$finish;
	end

endmodule