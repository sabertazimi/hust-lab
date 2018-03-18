/**
 * @module alu_flags
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief get flags after alu calculation
 * @param DATA_WIDTH data width
 * @input srcA A port data
 * @input srcB B port data
 * @input aluop operation code
 * @output zero equal flag
 * @output of signed overflow flag
 * @output uof unsigned overflow flag
 */
module alu_flags 
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] srcA,
    input [DATA_WIDTH-1:0] srcB,
    input [3:0] aluop,
    output zero,
    output of,
    output uof
);

    wire [DATA_WIDTH-1:0] sum, diff;
    wire carry1, carry2;
    
    assign {carry1, sum} = srcA + srcB;    // awesome tip
    assign {carry2, diff} = srcA - srcB;    // awesome tip
    
    assign zero = (srcA == srcB);
    assign of = (aluop == 4'd5) ? ((srcA[DATA_WIDTH-1] & srcB[DATA_WIDTH-1] & ~sum[DATA_WIDTH-1]) | (~srcA[DATA_WIDTH-1] & ~srcB[DATA_WIDTH-1] & sum[DATA_WIDTH-1]))
                : (aluop == 4'd6) ? ((srcA[DATA_WIDTH-1] & ~srcB[DATA_WIDTH-1] & ~diff[DATA_WIDTH-1]) | (~srcA[DATA_WIDTH-1] & srcB[DATA_WIDTH-1] & diff[DATA_WIDTH-1]))
                : 0;
    assign uof = (aluop == 4'd5) ? (carry1)
                : (aluop == 4'd6) ? (carry2)
                : 0;
    
endmodule // alu_flags
