`include "defines.vh"

module lru_counter
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input hit,
    input [`BTB_LINE_SIZE-1:0] hit_line,
    output [`BTB_LINE_SIZE-1:0] lru_line
);

    wire [`BTB_LINE_SIZE-1:0] access_line;
    wire rst0, rst1, rst2, rst3, rst4, rst5, rst6, rst7;
    wire [`BTB_LINE_SIZE-1:0] cnt0, cnt1, cnt2, cnt3, cnt4, cnt5, cnt6, cnt7;
    
    initial begin
        lru_line <= 0;
    end
    
    assign access_line = hit ? hit_line : lru_line;
    assign rst0 = (access_line == 0);
    assign rst1 = (access_line == 1);
    assign rst2 = (access_line == 2);
    assign rst3 = (access_line == 3);
    assign rst4 = (access_line == 4);
    assign rst5 = (access_line == 5);
    assign rst6 = (access_line == 6);
    assign rst7 = (access_line == 7);
    
    latch_counter #(
        .DATA_WIDTH(`BTB_LINE_SIZE),
        .MAX(`BTB_LINE_NUM-1)
    ) counter1 (
        .clk(clk),
        .rst(rst || rst0),
        .en(en),
        .count(cnt0)
    );
    
endmodule // lru_counter