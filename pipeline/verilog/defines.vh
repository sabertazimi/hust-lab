// `ifndef DEFINES_INCLUDED
// `define DEFINES_INCLUDED

// for bit 6, 1 -> R_type, 0 -> not R_type
// for bit [5:0], R_type -> funct, not R_type -> op_code
`define ADD     7'b1100000
`define ADDI    7'b0001000
`define ADDIU   7'b0001001
`define ADDU    7'b1100001
`define AND     7'b1100100
`define ANDI    7'b0001100
`define SLL     7'b1000000
`define SRA     7'b1000011
`define SRL     7'b1000010
`define SUB     7'b1100010
`define OR      7'b1100101
`define ORI     7'b0001101
`define NOR     7'b1100111
`define LW      7'b0100011
`define SW      7'b0101011
`define BEQ     7'b0000100
`define BNE     7'b0000101
`define SLT     7'b1101010
`define SLTI    7'b0001010
`define SLTU    7'b1101011
`define J       7'b0000010
`define JAL     7'b0000011
`define JR      7'b1001000
`define SYSCALL 7'b1001100

// `define ADD     6'b100000
// `define ADDI    6'b001000
// `define ADDIU   6'b001001
// `define ADDU    6'b100001
// `define AND     6'b100100
// `define ANDI    6'b001100
// `define SLL     6'b000000
// `define SRA     6'b000011
// `define SRL     6'b000010
// `define SUB     6'b100010
// `define OR      6'b100101
// `define ORI     6'b001101
// `define NOR     6'b100111
// `define LW      6'b100011
// `define SW      6'b101011
// `define BEQ     6'b000100
// `define BNE     6'b000101
// `define SLT     6'b101010
// `define SLTI    6'b001010
// `define SLTU    6'b101011
// `define J       6'b000010
// `define JAL     6'b000011
// `define JR      6'b001000
// `define SYSCALL 6'b001100

// `endif
