/**
 * @module mux2
 * @brief 2 way multiplexer
 * @param WIDTH data width
 * @input s selector
 * @input d0 s == 0
 * @input d1 s == 1
 * @output y 
 */
module mux2 
#(parameter WIDTH = 32)
(
    input [WIDTH-1:0] d0,
    input [WIDTH-1:0] d1,
    input s,
    output [WIDTH-1:0] y
);

    assign y = (s) ? d1 : d0
    
endmodule // mux2