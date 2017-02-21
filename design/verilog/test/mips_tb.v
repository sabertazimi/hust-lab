`timescale 1ns / 1ps
`include "defines.vh"

module mips_tb;
    parameter DATA_WIDTH = 32;
    parameter CODE_FILE = "mips/benchmark.hex";
    parameter IM_BUS_WIDTH = 10;
    parameter DM_BUS_WIDTH = 24;
    parameter COUNT = 5000;
    parameter DELAY = 5;
    parameter TIME = (COUNT * DELAY);
    
    reg raw_clk;
    reg raw_rst;
    reg raw_en;
    wire [7:0] anodes;
    wire [7:0] cnodes;

    mips #(
        .DATA_WIDTH(DATA_WIDTH),
        .CODE_FILE(CODE_FILE),
        .IM_BUS_WIDTH(IM_BUS_WIDTH),
        .DM_BUS_WIDTH(DM_BUS_WIDTH)
    ) mips (
        .raw_clk(raw_clk),
        .raw_rst(raw_rst),
        .raw_en(raw_en),
        .anodes(anodes),
        .cnodes(cnodes)
    );
    
    always begin
        #DELAY raw_clk <= ~raw_clk;
    end
    
	initial begin
		$dumpfile("vcd/mips_tb.vcd");
		$dumpvars(0, mips_tb);

		$display("raw_rst,\traw_en,\tled_data,\t$v0,\t$a0,\t$WB_ir");
		$monitor("%x,\t%x,\t%x",
            raw_rst,
            raw_en,
            mips.led_data,
            // mips.regfile.regfile[`V0][31:0],	/* $v0 */
            // mips.regfile.regfile[`A0][31:0],	/* $a0 */
            // mips.MEM_WB.WB_IR
        );
        
        raw_clk <= 1'b0;
		raw_rst <= 1'b1;
		raw_en <= 1'b1;
        
		@(posedge raw_clk);
		@(posedge raw_clk);
        
		raw_rst <= 1'b0;
        #TIME $finish;
	end

endmodule // mips_tb

