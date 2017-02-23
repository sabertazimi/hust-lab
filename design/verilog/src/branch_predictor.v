`include "defines.vh"
/**
 * @module branch_predictor
 * @brief branch predictor
 * @param DATA_WIDTH data width
 * @input taken whether branch taken or not taken
 * @input pc pc
 * @output ir ir
 * @output predict_addr predict_addr
 */
module branch_predictor
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] pc,
    input [DATA_WIDTH-1:0] ir,
    input hit,
    input [`BTB_DATA_SIZE-1:0] btb_branch_addr,
    output IF_branch,
    output [DATA_WIDTH-1:0] IF_predict_branch,
    output [DATA_WIDTH-1:0] predict_addr
);

    wire [5:0] op;
    wire [5:0] funct;
    wire [15:0] imm16;
    wire [25:0] imm26;
    wire beq, bne, j, jal, bgtz;
    wire [DATA_WIDTH-1:0] addr_imm;

    decoder decoder (
        .instruction(ir),
        .op(op),
        .rs(),
        .rt(),
        .rd(),
        .sham(),
        .funct(funct),
        .imm16(imm16),
        .imm26(imm26)
    );
    
    instruction_typer typer (
        .op(op),
        .funct(funct),
        .add(),
        .addi(),
        .addiu(),
        .addu(),
        .s_and(),
        .andi(),
        .sll(),
        .sra(),
        .srl(),
        .sub(),
        .s_or(),
        .ori(),
        .s_nor(),
        .lw(),
        .sw(),
        .beq(beq),
        .bne(bne),
        .slt(),
        .slti(),
        .sltu(),
        .j(j),
        .jal(jal),
        .jr(),
        .syscall(),
        .divu(),
        .mflo(),
        .lb(),
        .bgtz(bgtz)
    );
    
    address_calculator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) address_calculator (
        .pc(pc),
        .imm16(imm16),
        .imm26(imm26),
        .addr_imm(addr_imm),
        .addr_branch(IF_predict_branch)
    );
    
    assign IF_branch = (beq || bne || bgtz);
    assign predict_addr = (j || jal) ? addr_imm
                        : hit ? {{(DATA_WIDTH-12){1'b0}}, btb_branch_addr, 2'b00}
                        : IF_branch ? IF_predict_branch
                        : (pc + 4);
    
endmodule // branch_predictor