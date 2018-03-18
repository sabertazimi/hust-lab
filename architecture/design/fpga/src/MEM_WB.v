/**
 * @module MEM_WB
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief MEM_WB pipeline register
 * @input clk clock signal
 * @input rst reset signal
 * @input en load enable signal
 * @input MEM_PC PC value in MEM stage
 * @input MEM_IR instruction value in MEM stage
 * @input MEM_writetolo writetolo signal in MEM stage
 * @input MEM_regwe regwe signal in MEM stage
 * @input MEM_ramtoreg ramtoreg signal in MEM stage
 * @input MEM_lotoreg lotoreg signal in MEM stage
 * @input MEM_syscall syscall signal in MEM stage
 * @input MEM_ramdata ramdata value in MEM stage
 * @input MEM_result result value in MEM stage
 * @input MEM_RW RW value in MEM stage
 * @output WB_PC PC value in WB stage
 * @output WB_IR instruction value in WB stage
 * @output WB_writetolo writetolo signal in WB stage
 * @output WB_regwe regwe signal in WB stage
 * @output WB_ramtoreg ramtoreg signal in WB stage
 * @output WB_lotoreg lotoreg signal in WB stage
 * @output WB_syscall syscall signal in WB stage
 * @output WB_ramdata ramdata value in WB stage
 * @output WB_result result value in WB stage
 * @output WB_RW RW value in WB stage
 */
module MEM_WB
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] MEM_PC,
    input [DATA_WIDTH-1:0] MEM_IR,
    input MEM_writetolo,
    input MEM_regwe,
    input MEM_ramtoreg,
    input MEM_lotoreg,
    input MEM_syscall,
    input [DATA_WIDTH-1:0] MEM_ramdata,
    input [DATA_WIDTH-1:0] MEM_result,
    input [4:0] MEM_RW,
    output [DATA_WIDTH-1:0] WB_PC,
    output [DATA_WIDTH-1:0] WB_IR,
    output WB_writetolo,
    output WB_regwe,
    output WB_ramtoreg,
    output WB_lotoreg,
    output WB_syscall,
    output [DATA_WIDTH-1:0] WB_ramdata,
    output [DATA_WIDTH-1:0] WB_result,
    output [4:0] WB_RW
);

    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_PC),
        .dout(WB_PC)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IR (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_IR),
        .dout(WB_IR)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) writetolo (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_writetolo),
        .dout(WB_writetolo)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) regwe (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_regwe),
        .dout(WB_regwe)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) ramtoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_ramtoreg),
        .dout(WB_ramtoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) lotoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_lotoreg),
        .dout(WB_lotoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) syscall (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_syscall),
        .dout(WB_syscall)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ramdata (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_ramdata),
        .dout(WB_ramdata)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) result (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_result),
        .dout(WB_result)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) RW (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(MEM_RW),
        .dout(WB_RW)
    );
    
endmodule // MEM_WB
