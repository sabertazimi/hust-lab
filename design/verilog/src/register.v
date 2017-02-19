/**
 * @module register
 * @brief D filp flop
 * @param WIDTH data width
 * @input clk clock signal
 * @input rst reset signal
 * @input en enable signal
 * @input din data in
 * @ouput dout data out
 */
module register
#(parameter WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:)] dout
);

    always @ (posedge clk or rst) begin
        if (rst) begin
            dout <= 0;
        end else if (en) begin
            dout <= din;
        end else begin
            dout <= dout;
        end
    end

endmodule // register
