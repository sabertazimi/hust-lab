/**
 * @module EX_MEM
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief EX_MEM pipeline register
 * @input clk clock signal
 * @input rst reset signal
 * @input en load enable signal
 * @input EX_PC PC value in EX stage
 * @input EX_IR instruction value in EX stage
 * @input EX_writetolo writetolo signal in EX stage
 * @input EX_regwe regwe signal in EX stage
 * @input EX_ramtoreg ramtoreg signal in EX stage
 * @input EX_lotoreg lotoreg signal in EX stage
 * @input EX_syscall syscall signal in EX stage
 * @input EX_ramwe ramwe signal in EX stage
 * @input EX_rambyte rambyte signal in EX stage
 * @input EX_rt rt value in EX stage
 * @input EX_result result value in EX stage
 * @input EX_RW RW value in EX stage
 * @input EX_r2 r2 value in EX stage
 * @output MEM_PC PC value in MEM stage
 * @output MEM_IR instruction value in MEM stage
 * @output MEM_writetolo writetolo signal in MEM stage
 * @output MEM_regwe regwe signal in MEM stage
 * @output MEM_ramtoreg ramtoreg signal in MEM stage
 * @output MEM_lotoreg lotoreg signal in MEM stage
 * @output MEM_syscall syscall signal in MEM stage
 * @output MEM_ramwe ramwe signal in MEM stage
 * @output MEM_rambyte rambyte signal in MEM stage
 * @output MEM_rt rt value in MEM stage
 * @output MEM_result result value in MEM stage
 * @output MEM_RW RW value in MEM stage
 * @output MEM_r2 r2 value in MEM stage
 */
module EX_MEM
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] EX_PC,
    input [DATA_WIDTH-1:0] EX_IR,
    input EX_writetolo,
    input EX_regwe,
    input EX_ramtoreg,
    input EX_lotoreg,
    input EX_syscall,
    input EX_ramwe,
    input EX_rambyte,
    input [4:0] EX_rt,
    input [DATA_WIDTH-1:0] EX_result,
    input [4:0] EX_RW,
    input [DATA_WIDTH-1:0] EX_r2,
    output [DATA_WIDTH-1:0] MEM_PC,
    output [DATA_WIDTH-1:0] MEM_IR,
    output MEM_writetolo,
    output MEM_regwe,
    output MEM_ramtoreg,
    output MEM_lotoreg,
    output MEM_syscall,
    output MEM_ramwe,
    output MEM_rambyte,
    output [4:0] MEM_rt,
    output [DATA_WIDTH-1:0] MEM_result,
    output [4:0] MEM_RW,
    output [DATA_WIDTH-1:0] MEM_r2
);

    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_PC),
        .dout(MEM_PC)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IR (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_IR),
        .dout(MEM_IR)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) writetolo (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_writetolo),
        .dout(MEM_writetolo)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) regwe (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_regwe),
        .dout(MEM_regwe)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) ramtoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_ramtoreg),
        .dout(MEM_ramtoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) lotoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_lotoreg),
        .dout(MEM_lotoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) syscall (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_syscall),
        .dout(MEM_syscall)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) ramwe (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_ramwe),
        .dout(MEM_ramwe)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) rambyte (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_rambyte),
        .dout(MEM_rambyte)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) rt (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_rt),
        .dout(MEM_rt)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) result (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_result),
        .dout(MEM_result)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) RW (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_RW),
        .dout(MEM_RW)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) r2 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(EX_r2),
        .dout(MEM_r2)
    );
    
endmodule // EX_MEM
