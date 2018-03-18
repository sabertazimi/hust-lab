/**
 * @module counter
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief up counter 
 * @param DATA_WIDTH data width
 * @param STEP counting step
 * @input clk clock signal
 * @input rst reset signal
 * @output en enable signal 
 * @output count counting value
 */
module counter
#(parameter DATA_WIDTH = 1, STEP = 1)
(
    input clk,
    input rst,
    input en,
    output reg [(DATA_WIDTH-1):0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 0 ;
        end else if (en) begin
            count <= count + 1;
        end else begin
            count <= count;
        end
    end

endmodule // counter
