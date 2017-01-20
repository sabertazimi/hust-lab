/**
 * @module register
 * @brief D filp flop
 * @param WIDTH data width
 * @input clk clock signal
 * @input rst reset signal
 * @input en enable signal
 * @input d data in
 * @ouput q data out
 */
module register
#(parameter WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:)] q
);

    always @ (posedge clk or rst) begin
        if (rst) begin
            q <= 0;
        end else if (en) begin
            q <= d;
        end else begin
            q <= q;
        end
    end
    
endmodule // register