
/**
 * @module decoder
 * @brief decode intruction to rs/rt/rd, sham/imm16/imm26, op/functy
 * @param DATA_WIDTH data width
 * @input instruction input instruction code
 * @output op op field in intruction code 
 * @output rs rs field in intruction code 
 * @output rt rt field in intruction code 
 * @output rd rd field in intruction code 
 * @output sham sham field in intruction code 
 * @output funct funct field in intruction code 
 * @output imm16 imm16 field in intruction code 
 * @output imm26 imm26 field in intruction code 
 */
module decoder
(
    input [31:0] instruction,
    output [5:0] op,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] sham,
    output [5:0] funct,
    output [15:0] imm16,
    output [25:0] imm26
);

`include "defines.vh"

    assign op    = instruction[`OP];
    assign rs    = instruction[`RS];
    assign rt    = instruction[`RT];
    assign rd    = instruction[`RD];
    assign sham  = instruction[`SHAM];
    assign funct = instruction[`FUNCT];
    assign imm16 = instruction[`IMM16];
    assign imm26 = instruction[`IMM26];

endmodule // decoder
