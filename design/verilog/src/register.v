/**
 * @module register
 * @brief D filp flop
 * @param DATA_WIDTH data width
 * @input clk clock signal
 * @input rst reset signal
 * @input en enable signal
 * @input din data in
 * @ouput dout data out
 */
module register
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    always @ (posedge clk) begin
        if (rst) begin
            dout <= 0;      // reset
        end else if (en) begin
            dout <= din;    // update
        end else begin
            dout <= dout;   // hold
        end
    end

endmodule // register
