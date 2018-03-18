/**
 * @module branch_hazard_detector
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief branch hazard detection
 * @input ID_rs rs value in ID stage
 * @input ID_rt rt value in ID stage
 * @input EX_regwe regwe signal in EX stage
 * @input EX_RW RW value in EX stage
 * @input MEM_ramtoreg ramtoreg signal in EX stage
 * @input MEM_RW RW value in MEM stage
 * @input ID_jmp_need_reg signal imply whether current branch instruction need read regs or not
 * @input ID_jmp_reg signal imply whether current instruction is jr or not
 * @input ID_misprediction signal imply whether current instruction is successful predict branch or not
 * @output flushD signal for flushing IF/ID pipeline register
 * @output flushE signal for flushing ID/EX pipeline register
 */
module branch_hazard_detector
(
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input EX_regwe,
    input [4:0] EX_RW,
    input MEM_ramtoreg,
    input [4:0] MEM_RW,
    input ID_jmp_need_reg,
    input ID_jmp_reg,
    input ID_misprediction,
    output branch_flushD,
    output branch_flushE
);

    assign branch_flushD = ID_jmp_reg || ID_misprediction;
    assign branch_flushE = (ID_jmp_need_reg && EX_regwe && EX_RW != 0 && (EX_RW == ID_rs || EX_RW == ID_rt))
    || (ID_jmp_need_reg && MEM_ramtoreg && MEM_RW != 0 && (MEM_RW == ID_rs || MEM_RW == ID_rt));
        
endmodule // branch_hazard_detector
