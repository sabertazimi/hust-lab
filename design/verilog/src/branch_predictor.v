module branch_predictor
#(parameter DATA_WIDTH = 32)
(
    input taken,
    input [DATA_WIDTH-1:0] pc,
    input [DATA_WIDTH-1:0] ir,
    output [DATA_WIDTH-1:0] predict_addr
);

    wire [5:0] op;
    wire [5:0] funct;
    wire [15:0] imm16;
    wire [25:0] imm26;
    wire beq, bne, j, jal, bgtz;
    wire [DATA_WIDTH-1:0] addr_imm;
    wire [DATA_WIDTH-1:0] addr_branch;
    wire [DATA_WIDTH-1:0] pcp4;
    wire [DATA_WIDTH-1:0] predict_branch_addr;

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
        .addr_branch(addr_branch)
    );
    
    assign pcp4 = pc + 4;
    assign predict_branch_addr = (taken && (beq || bne || bgtz)) ? addr_branch : pcp4;
    assign predict_addr = (j || jal) ? addr_imm : predict_branch_addr;
    
endmodule // branch_predictor