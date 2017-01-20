/**
 * @module unsigext
 * @brief unsigned bits extender
 * @param INPUT_WIDTH input data width, extend it to DATA_WIDTH
 * @param DATA_WIDTH data width
 * @input din raw data
 * @ouput dout extended data
 */
module unsigext
#(parameter INPUT_WIDTH = 16, DATA_WIDTH = 32)
(
    input [INPUT_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout
);

    assign dout = {{(DATA_WIDTH-INPUT_WIDTH){1'b0}}, din};
    
endmodule // unsigext