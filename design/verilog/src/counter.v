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
            count <= 8'b0 ;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule // counter
