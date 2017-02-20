/**
 * @module ID_EX
 * @brief ID_EX pipeline register
 * @input clk clock signal
 * @input rst reset signal
 * @input en load enable signal
 * @input ID_PC PC value in ID stage
 * @input ID_IR instruction value in ID stage
 * @input ID_writetolo writetolo signal in ID stage
 * @input ID_regwe regwe signal in ID stage
 * @input ID_ramtoreg ramtoreg signal in ID stage
 * @input ID_lotoreg lotoreg signal in ID stage
 * @input ID_syscall syscall signal in ID stage
 * @input ID_ramwe ramwe signal in ID stage
 * @input ID_rambyte rambyte signal in ID stage
 * @input ID_regdst regdst signal in ID stage
 * @input ID_aluop aluop signal in ID stage
 * @input ID_alusrc alusrcc signal in ID stage
 * @input ID_extop extop signal in ID stage
 * @input ID_alusham alusham signal in ID stage
 * @input ID_jal jal signal in ID stage
 * @input ID_rs rs value in ID stage
 * @input ID_rt rt value in ID stage
 * @input ID_rd rd value in ID stage
 * @input ID_sham sham value in ID stage
 * @input ID_imm16 imm16 value in ID stage
 * @input ID_r1 r1 value in ID stage
 * @input ID_r2 r2 value in ID stage
 * @output EX_PC PC value in EX stage
 * @output EX_IR instruction value in EX stage
 * @output EX_writetolo writetolo signal in EX stage
 * @output EX_regwe regwe signal in EX stage
 * @output EX_ramtoreg ramtoreg signal in EX stage
 * @output EX_lotoreg lotoreg signal in EX stage
 * @output EX_syscall syscall signal in EX stage
 * @output EX_ramwe ramwe signal in EX stage
 * @output EX_rambyte rambyte signal in EX stage
 * @output EX_regdst regdst signal in EX stage
 * @output EX_aluop aluop signal in EX stage
 * @output EX_alusrc alusrcc signal in EX stage
 * @output EX_extop extop signal in EX stage
 * @output EX_alusham alusham signal in EX stage
 * @output EX_jal jal signal in EX stage
 * @output EX_rs rs value in EX stage
 * @output EX_rt rt value in EX stage
 * @output EX_rd rd value in EX stage
 * @output EX_sham sham value in EX stage
 * @output EX_imm16 imm16 value in EX stage
 * @output EX_r1 r1 value in EX stage
 * @output EX_r2 r2 value in EX stage
 */
module ID_EX
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] ID_PC,
    input [DATA_WIDTH-1:0] ID_IR,
    input ID_writetolo,
    input ID_regwe,
    input ID_ramtoreg,
    input ID_lotoreg,
    input ID_syscall,
    input ID_ramwe,
    input ID_rambyte,
    input ID_regdst,
    input [3:0] ID_aluop,
    input ID_alusrc,
    input ID_extop,
    input ID_alusham,
    input ID_jal,
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] ID_rd,
    input [4:0] ID_sham,
    input [15:0] ID_imm16,
    input [DATA_WIDTH-1:0] ID_r1,
    input [DATA_WIDTH-1:0] ID_r2,
    output [DATA_WIDTH-1:0] EX_PC,
    output [DATA_WIDTH-1:0] EX_IR,
    output EX_writetolo,
    output EX_regwe,
    output EX_ramtoreg,
    output EX_lotoreg,
    output EX_syscall,
    output EX_ramwe,
    output EX_rambyte,
    output EX_regdst,
    output [3:0] EX_aluop,
    output EX_alusrc,
    output EX_extop,
    output EX_alusham,
    output EX_jal,
    output [4:0] EX_rs,
    output [4:0] EX_rt,
    output [4:0] EX_rd,
    output [4:0] EX_sham,
    output [15:0] EX_imm16,
    output [DATA_WIDTH-1:0] EX_r1,
    output [DATA_WIDTH-1:0] EX_r2
);

    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_PC),
        .dout(EX_PC)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IR (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_IR),
        .dout(EX_IR)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) writetolo (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_writetolo),
        .dout(EX_writetolo)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) regwe (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_regwe),
        .dout(EX_regwe)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) ramtoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_ramtoreg),
        .dout(EX_ramtoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) lotoreg (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_lotoreg),
        .dout(EX_lotoreg)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) syscall (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_syscall),
        .dout(EX_syscall)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) ramwe (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_ramwe),
        .dout(EX_ramwe)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) rambyte (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_rambyte),
        .dout(EX_rambyte)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) regdst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_regdst),
        .dout(EX_regdst)
    );
    
    register #(
        .DATA_WIDTH(4)
    ) aluop (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_aluop),
        .dout(EX_aluop)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) alusrc (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_alusrc),
        .dout(EX_alusrc)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) extop (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_extop),
        .dout(EX_extop)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) alusham (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_alusham),
        .dout(EX_alusham)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) jal (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_jal),
        .dout(EX_jal)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) rs (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_rs),
        .dout(EX_rs)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) rt (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_rt),
        .dout(EX_rt)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) rd (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_rd),
        .dout(EX_rd)
    );
    
    register #(
        .DATA_WIDTH(5)
    ) sham (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_sham),
        .dout(EX_sham)
    );
    
    register #(
        .DATA_WIDTH(16)
    ) imm16 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_imm16),
        .dout(EX_imm16)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) r1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_r1),
        .dout(EX_r1)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) r2 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(ID_r2),
        .dout(EX_r2)
    );
    
endmodule // ID_EX