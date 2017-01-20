/**
 * @module shift2
 * @brief 2 bits left shifter for PC update logic
 * @param DATA_WIDTH data width
 * @input din raw data
 * @ouput dout shifted data
 */
module shift2
#(paramter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout
);

    assign dout = din << 2;

endmodule // shift2
