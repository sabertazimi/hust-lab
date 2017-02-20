/**
 * @module latch_counter
 * @brief latch counter (latching when reaching max vlaue)
 * @input clk clock signal
 * @input rst reset signal
 * @output en enable signal 
 * @output count counting value
 */
module latch_counter
(
    input clk,
    input rst,
    input en,
    output reg count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 0 ;
        end else if (en) begin
            if (count != 1) begin
                count <= count + 1;
            end else begin
                count <= count;
            end
        end else begin
            count <= count;
        end
    end

endmodule // latch_counter