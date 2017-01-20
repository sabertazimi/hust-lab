/**
 * @module mux2
 * @brief 2 way multiplexer
 * @param WIDTH data width
 * @input sel selector
 * @input data0 s == 0
 * @input data1 s == 1
 * @output dout data out
 */
module mux2 
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] data0,
    input [DATA_WIDTH-1:0] data1,
    input sel,
    output [DATA_WIDTH-1:0] dout
);

    assign dout = (sel) ? data1 : data0

endmodule // mux2
