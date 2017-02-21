module tick_divider
#(parameter DATA_WIDTH = 32)
(
    input clk_src,
    output reg [(DATA_WIDTH-1): 0] clk_group
);

    initial begin
        clk_group <= {(DATA_WIDTH){1'b0}};
    end
    
    always @(posedge clk_src) begin
        clk_group <= clk_group + 1;
    end
endmodule