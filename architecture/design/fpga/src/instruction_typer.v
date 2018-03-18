/**
 * @module instruction_typer
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief instruction typer
 * @input op op code
 * @input funct funct code
 * @output add instruction signal
 * @output addi instruction signal
 * @output addiu instruction signal
 * @output addu instruction signal
 * @output s_and instruction signal
 * @output andi instruction signal
 * @output sll  instruction signal
 * @output sra  instruction signal
 * @output srl  instruction signal
 * @output sub instruction signal
 * @output s_or instruction signal
 * @output ori instruction signal
 * @output s_nor instruction signal
 * @output lw instruction signal
 * @output sw instruction signal
 * @output beq instruction signal
 * @output bne instruction signal
 * @output slt instruction signal
 * @output slti instruction signal
 * @output sltu instruction signal
 * @output j instruction signal
 * @output jal instruction signal
 * @output jr instruction signal
 * @output syscall instruction signal
 * @output divu instruction signal
 * @output mflo instruction signal
 * @output lb instruction signal
 * @output bgtz instruction signal
 */
module instruction_typer
(
    input [5:0] op,
    input [5:0] funct,
    output add,
    output addi,
    output addiu,
    output addu,
    output s_and,
    output andi,
    output sll,
    output sra,
    output srl,
    output sub,
    output s_or,
    output ori,
    output s_nor,
    output lw,
    output sw,
    output beq,
    output bne,
    output slt,
    output slti,
    output sltu,
    output j,
    output jal,
    output jr,
    output syscall,
    output divu,
    output mflo,
    output lb,
    output bgtz
);

`include "defines.vh"

    assign add = (op == 0 && funct == `ADD) ? 1 : 0; 
    assign addi = (op == `ADDI) ? 1 : 0;
    assign addiu = (op == `ADDIU) ? 1 : 0;
    assign addu = (op == 0 && funct == `ADDU) ? 1 : 0;
    assign s_and = (op == 0 && funct == `AND) ? 1 : 0;
    assign andi = (op == `ANDI) ? 1 : 0;
    assign sll = (op == 0 && funct == `SLL) ? 1 : 0;
    assign sra = (op == 0 && funct == `SRA) ? 1 : 0;
    assign srl = (op == 0 && funct == `SRL) ? 1 : 0;
    assign sub = (op == 0 && funct == `SUB) ? 1 : 0;
    assign s_or = (op == 0 && funct == `OR) ? 1 : 0;
    assign ori = (op == `ORI) ? 1 : 0;
    assign s_nor = (op == 0 && funct == `NOR) ? 1 : 0;
    assign lw = (op == `LW) ? 1 : 0;
    assign sw = (op == `SW) ? 1 : 0;
    assign beq = (op == `BEQ) ? 1 : 0;
    assign bne = (op == `BNE) ? 1 : 0;
    assign slt = (op == 0 && funct == `SLT) ? 1 : 0;
    assign slti = (op == `SLTI) ? 1 : 0;
    assign sltu = (op == 0 && funct == `SLTU) ? 1 : 0;
    assign j = (op == `J) ? 1 : 0;
    assign jal = (op == `JAL) ? 1 : 0;
    assign jr = (op == 0 && funct == `JR) ? 1 : 0;
    assign syscall = (op == 0 && funct == `SYSCALL) ? 1 : 0;
    assign divu = (op == 0 && funct == `DIVU) ? 1 : 0;
    assign mflo = (op == 0 && funct == `MFLO) ? 1 : 0;
    assign lb = (op == `LB) ? 1 : 0;
    assign bgtz = (op == `BGTZ) ? 1 : 0;

endmodule // instruction_typer

