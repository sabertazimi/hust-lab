/**
 * @module forward_unit
 * @brief data hazards detection and forward signals generation
 * @input ID_rs rs value in ID stage
 * @input ID_rt rt value in ID stage
 * @input EX_rs rs value in EX stage
 * @input EX_rt  rt value in EX stage
 * @input MEM_rt rt value in MEM stage
 * @input MEM_ramwe ramwe signal in MEM stage
 * @input MEM_regwe regwe signal in MEM stage
 * @input WB_regwe  regwe signal in WB stage
 * @input MEM_RW RW value in MEM stage
 * @input WB_RW RW value in WB stage
 * @output ID_forwardA forward signal for R1out in ID stage
 * @output ID_forwardB forward signal for R2out in ID stage
 * @output EX_forwardA forward signal for ALUXin in EX stage
 * @output EX_forwardB forward signal for ALUYin in EX stage
 * @output MEM_forward forward signal for RAMin in MEM stage
 */
module forward_unit
(
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] EX_rs,
    input [4:0] EX_rt,
    input [4:0] MEM_rt,
    input MEM_ramwe,
    input MEM_regwe,
    input WB_regwe,
    input [4:0] MEM_RW,
    input [4:0] WB_RW,
    output reg [1:0] ID_forwardA,
    output reg [1:0] ID_forwardB,
    output reg [1:0] EX_forwardA,
    output reg [1:0] EX_forwardB,
    output MEM_forward
);

    // ID stage forward
    // for branch usage in decode stage
    // for WB.RegData -> ID/EX pipeline register data hazard
    if ((ID_rs != 0) && (ID_rs == MEM_RW) && MEM_regwe) begin
        ID_forwardA = 2'b10 // from MEM stage
    end else if ((ID_rs != 0) && (ID_rs == WB_RW) && WB_regwe) begin
        ID_forwardA = 2'b01 // from WB stage
    end else begin
        ID_forwardA = 2'b00 // no forwarding
    end

    if ((ID_rt != 0) && (ID_rt == MEM_RW) && MEM_regwe) begin
        ID_forwardA = 2'b10 // from MEM stage
    end else if ((ID_rt != 0) && (ID_rt == WB_RW) && WB_regwe) begin
        ID_forwardA = 2'b01 // from WB stage
    end else begin
        ID_forwardA = 2'b00 // no forwarding
    end

    // EX stage forward
    // id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb r-r-alu: $rd => $rs/$rt
    // id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb r-imm-alu: $rd => $rs/$rt
    // id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb load: $rt => $rs/$rt
    // id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb jal : $ra => $rs/$rt
    if ((EX_rs != 0) && (EX_rs == MEM_RW) && MEM_regwe) begin
        EX_forwardA = 2'b10 (from memory access stage)
    end else if ((EX_rs != 0) && (EX_rs == WB_RW) && WB_regwe) begin
        EX_forwardA = 2'b01 (from write back stage)
    end else begin
        EX_forwardA = 2'b00 (no forwarding)
    end

    if ((EX_rt != 0) && (EX_rt == MEM_RW) && MEM_regwe) begin
        EX_forwardB = 2'b10 (from memory access stage)
    end else if ((EX_rt != 0) && (EX_rt == WB_RW) && WB_regwe) begin
        EX_forwardB = 2'b01 (from write back stage)
    end else begin
        EX_forwardB = 2'b00 (no forwarding)
    end

    // MEM stage forward
    // ex/mem sw + mem/wb load: $rt => $rt
    assign MEM_forward = (WB_regwe && MEM_ramwe && MEM_rt != 0 && MEM_rt == WB_RW)

endmodule // forward_unit
