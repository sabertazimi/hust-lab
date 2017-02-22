`timescale 1ns / 1ps
`include "defines.vh"

module mips_tb;
    parameter DATA_WIDTH = 32;
    parameter CODE_FILE = "mips/waterfall_lamp.hex";
    parameter IM_BUS_WIDTH = 10;
    parameter DM_BUS_WIDTH = 24;
    parameter CLK_HZ = 0;
    parameter COUNT = 10000;
    parameter DELAY = 5;
    parameter TIME = (COUNT * DELAY);
    
    reg raw_clk;
    reg raw_rst;
    reg raw_en;
    reg switch_rst;
    reg switch_stat;
    reg switch_ram;
    reg switch_correctprediction;
    reg switch_misprediction;
    reg [4:0] switch_addr;
    wire [7:0] anodes;
    wire [7:0] cnodes;

    mips #(
        .DATA_WIDTH(DATA_WIDTH),
        .CODE_FILE(CODE_FILE),
        .IM_BUS_WIDTH(IM_BUS_WIDTH),
        .DM_BUS_WIDTH(DM_BUS_WIDTH),
        .CLK_HZ(CLK_HZ)
    ) mips (
        .raw_clk(raw_clk),
        .raw_rst(raw_rst),
        .raw_en(raw_en),
        .switch_rst(switch_rst),
        .switch_stat(switch_stat),
        .switch_ram(switch_ram),
        .switch_correctprediction(switch_correctprediction),
        .switch_misprediction(switch_misprediction),
        .switch_addr(switch_addr),
        .anodes(anodes),
        .cnodes(cnodes)
    );
    
    always begin
        #DELAY raw_clk <= ~raw_clk;
    end
    
	initial begin
		$dumpfile("vcd/mips_tb.vcd");
		$dumpvars(0, mips_tb);

		$display("raw_rst,raw_en,\tled_data,\tstat_count,\tstat_misprediction,\tstat_correctprediction");
		$monitor("%x,\t%x,\t%x,\t%d,\t%d,\t%d",
            raw_rst,
            raw_en,
            mips.led_data,
            mips.stat_count,
            mips.stat_misprediction,
            mips.stat_correctprediction
            // mips.regfile.regfile[`V0][31:0],	/* $v0 */
            // mips.regfile.regfile[`A0][31:0],	/* $a0 */
            // mips.MEM_WB.WB_IR
        );
        
        raw_clk <= 1'b0;
		raw_rst <= 1'b1;
		raw_en <= 1'b1;
        switch_rst <= 1'b0;
        switch_stat <= 1'b0;
        switch_ram <= 1'b0;
        switch_addr <= 5'b00000;
        
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
		@(posedge raw_clk);
        
		raw_rst <= 1'b0;
        #TIME $finish;
	end

endmodule // mips_tb

