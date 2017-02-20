/**
 * @module controller
 * @brief control signals generator
 * @input op op code
 * @input functy functy code
 * @input zero equal flag (srcA == srcB)
 * @output control signals
 * @output alusrc 1 => imm32, 0 => rt, may be ignored by jal signal
 * @output regdst 1 => rd, 0 => rt, may be ignored by jal signal
 * @output extop 1 => signed, 0 => unsigned
 */
module controller
(
    input [5:0] op,
    input [5:0] functy,
    input zero,
    output [3:0] aluop,
    output alusrc,
    output alusham,
    output regdst,
    output regwrite,
    output extop,
    output memtoreg,
    output memwrite,
    output sig_jal,
    output pcbranch,
    output pcjmp,
    output pcreg
);

`include defines.vh

    wire add, addi, addiu, addu;
    wire s_and, andi, sll, sra, srl;
    wire sub, s_or, ori, s_nor;
    wire lw, sw;
    wire beq, bne;
    wire slt, slti, sltu;
    wire j, jal, jr;
    wire syscall;
    wire divu, mflo;
    wire lb;
    wire bgtz;
    
    assign add = (op == 0 && functy == ADD) ? 1 : 0; 
    assign addi = (op == ADDI) ? 1 : 0;
    assign addiu = (op == ADDIU) ? 1 : 0;
    assign addu = (op == 0 && functy == ADDU) ? 1 : 0;
    assign s_and = (op == 0 && functy == AND) ? 1 : 0;
    assign andi = (op == ANDI) ? 1 : 0;
    assign sll = (op == 0 && functy == SLL) ? 1 : 0;
    assign sra = (op == 0 && functy == SRA) ? 1 : 0;
    assign srl = (op == 0 && functy == SRL) ? 1 : 0;
    assign sub = (op == 0 && functy == SUB) ? 1 : 0;
    assign s_or = (op == 0 && functy == OR) ? 1 : 0;
    assign ori = (op == ORI) ? 1 : 0;
    assign s_nor = (op == 0 && functy == NOR) ? 1 : 0;
    assign lw = (op == LW) ? 1 : 0;
    assign sw = (op == SW) ? 1 : 0;
    assign beq = (op == BEQ) ? 1 : 0;
    assign bne = (op == BNE) ? 1 : 0;
    assign slt = (op == 0 && functy == SLT) ? 1 : 0;
    assign slti = (op == SLTI) ? 1 : 0;
    assign sltu = (op == 0 && functy == SLTU) ? 1 : 0;
    assign j = (op == J) ? 1 : 0;
    assign jal = (op == JAL) ? 1 : 0;
    assign jr = (op == 0 && functy == JR) ? 1 : 0;
    assign syscall = (op == 0 && functy == SYSCALL) ? 1 : 0;
    
    assign aluop[0] = add || addi || addiu || addu || s_and || andi
                    || sra || lw || sw || slt || slti || jal;
    assign aluop[1] = s_and || andi || srl || sub || s_nor || slt || slti;
    assign aluop[2] = add || addi || addiu || addu || s_and || andi
                    || sub || lw || sw || sltu || jal;
    assign aluop[3] = s_or || ori || s_nor || slt || slti || sltu; 
    assign alusrc = addi || addiu || andi || ori || lw || sw || slti;
    assign alusham = sll || sra || srl;
    assign regdst = add || addu || s_and || sll || sra || srl
                    || sub || s_or || s_nor || slt || sltu;
    assign regwrite = add || addi || addiu || addu || s_and || andi
                    || sll || sra || srl || sub || s_or || ori || s_nor || lw
                    || slt || slti || sltu || jal;
    assign extop = addi || addiu || lw || sw || slti;
    assign memtoreg = lw;
    assign memwrite = sw;
    assign sig_jal = jal;
    assign pcbranch = (~zero && bne) || (zero && beq);
    assign pcjmp = jmp || jal;
    assign pcreg = jr;
    
endmodule // controller