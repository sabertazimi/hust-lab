/**
 * @module address_calculator
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief address calculation
 * @param DATA_WIDTH data width
 * @input pc pc value
 * @input imm16 16 bits immediate number
 * @input imm26 26 bits immediate number
 * @output addr_imm j/jal address 
 * @output addr_branch beq/bne/bgtz address
 */
module address_calculator
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] pc,
    input [15:0] imm16,
    input [25:0] imm26,
    output [DATA_WIDTH-1:0] addr_imm,
    output [DATA_WIDTH-1:0] addr_branch
);
    
    wire [DATA_WIDTH-1:0] extshft_imm16;
    wire [DATA_WIDTH-1:0] extshft_imm26;

    assign extshft_imm16 = {{(DATA_WIDTH-16){imm16[15]}}, imm16} << 2;
    assign extshft_imm26 = {{(DATA_WIDTH-26){imm26[25]}}, imm26} << 2;
    assign addr_imm = {pc[31:28], extshft_imm26[27:0]};
    assign addr_branch = extshft_imm16 + pc + 4;
    
endmodule // address_calculator
