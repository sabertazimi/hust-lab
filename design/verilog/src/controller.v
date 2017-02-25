/**
 * @module controller
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief control signals generator
 * @input op op code
 * @input funct functy code
 * @output aluop,
 * @output alusrc 1 => imm16, 0 => rt
 * @output alusham 1 => sham, 0=> rt 
 * @output regdst 1 => rd, 0 => rt
 * @output regwe 1 => enable, 0 => disable
 * @output extop 1 => signed, 0 => unsigned
 * @output ramtoreg 1 => ram to regfile, 0 => alu to regfile
 * @output ramwe 1 => enable, 0 => disable
 * @output beq 1 => current instruction is beq
 * @output bne 1 => current instruction is bne
 * @output bgtz 1 => current instruction is bgtz
 * @output j 1 => current instruction is j
 * @output jal 1 => current instruction is jal
 * @output jr 1 => current instruction is jr
 * @output syscall 1 => current instruction is syscall
 * @output writetolo  1 => lo register write enable, 0 => lo register write disable
 * @output lotoreg 1 => lo register to regfile, 0 => ram/alu to regfile
 * @output rambyte 1 => load byte from ram, 0 => load word from ram
 */
module controller
(
    input [5:0] op,
    input [5:0] funct,
    output [3:0] aluop,
    output alusrc,
    output alusham,
    output regdst,
    output regwe,
    output extop,
    output ramtoreg,
    output ramwe,
    output beq,
    output bne,
    output bgtz,
    output j,
    output jal,
    output jr,
    output syscall,
    output writetolo,
    output lotoreg,
    output rambyte
);

    wire add, addi, addiu, addu;
    wire s_and, andi, sll, sra, srl;
    wire sub, s_or, ori, s_nor;
    wire lw, sw;
    wire slt, slti, sltu;
    wire divu, mflo;
    wire lb;
    
    instruction_typer instruction_typer (
        .op(op),
        .funct(funct),
        .add(add),
        .addi(addi),
        .addiu(addiu),
        .addu(addu),
        .s_and(s_and),
        .andi(andi),
        .sll(sll),
        .sra(sra),
        .srl(srl),
        .sub(sub),
        .s_or(s_or),
        .ori(ori),
        .s_nor(s_nor),
        .lw(lw),
        .sw(sw),
        .beq(beq),
        .bne(bne),
        .slt(slt),
        .slti(slti),
        .sltu(sltu),
        .j(j),
        .jal(jal),
        .jr(jr),
        .syscall(syscall),
        .divu(divu),
        .mflo(mflo),
        .lb(lb),
        .bgtz(bgtz)
    );
    
    assign aluop[0] = add || addi || addiu || addu || s_and || andi
                    || sra || lw || sw || slt || slti || jal || lb || bgtz;
    assign aluop[1] = s_and || andi || srl || sub || s_nor || slt || slti || bgtz;
    assign aluop[2] = add || addi || addiu || addu || s_and || andi
                    || sub || lw || sw || sltu || jal || divu || lb;
    assign aluop[3] = s_or || ori || s_nor || slt || slti || sltu || bgtz; 
    assign alusrc = addi || addiu || andi || ori || lw || sw || slti || lb;
    assign alusham = sll || sra || srl;
    assign regdst = add || addu || s_and || sll || sra || srl
                    || sub || s_or || s_nor || slt || sltu || mflo;
    assign regwe = add || addi || addiu || addu || s_and || andi
                    || sll || sra || srl || sub || s_or || ori || s_nor || lw
                    || slt || slti || sltu || jal || mflo || lb;
    assign extop = addi || addiu || lw || sw || slti || lb;
    assign ramtoreg = lw || lb;
    assign ramwe = sw;
    assign writetolo = divu;
    assign lotoreg = mflo;
    assign rambyte = lb;
    
endmodule // controller
