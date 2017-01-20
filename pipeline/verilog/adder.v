/**
 * @module adder
 * @brief bits adder for jump address calculation
 * @param DATA_WIDTH data width
 * @input data0 addend
 * @input data1 another addend
 * @ouput sum summary of two addends
 */
module adder
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] data0,
    input [DATA_WIDTH-1:0] data1,
    output [DATA_WIDTH-1:0] sum,
);

    assign sum = data0 + data1;
    
endmodule // adder