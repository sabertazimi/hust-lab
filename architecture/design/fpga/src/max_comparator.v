`include "defines.vh"

/**
 * @module max_comparator
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief find line that has max reference count
 * @input cntX reference count of lineX
 * @output lru_line line that has max reference count(lru line)
 */
module max_comparator
(
    input [`BTB_LINE_SIZE-1:0] cnt0,
    input [`BTB_LINE_SIZE-1:0] cnt1,
    input [`BTB_LINE_SIZE-1:0] cnt2,
    input [`BTB_LINE_SIZE-1:0] cnt3,
    input [`BTB_LINE_SIZE-1:0] cnt4,
    input [`BTB_LINE_SIZE-1:0] cnt5,
    input [`BTB_LINE_SIZE-1:0] cnt6,
    input [`BTB_LINE_SIZE-1:0] cnt7,
    output reg [`BTB_LINE_SIZE-1:0] lru_line
);

    integer i;
    reg [`BTB_LINE_SIZE-1:0] max_cnt;
    reg [`BTB_LINE_SIZE-1:0] max_line;
    
    initial begin
        lru_line <= 0;
    end

    always @ (cnt0 or cnt1 or cnt2 or cnt3 or cnt4 or cnt5 or cnt6 or cnt7) begin
        max_cnt = 0;
        max_line = 0;
        
        if (cnt0 >= max_cnt) begin
            max_cnt = cnt0;
            max_line = 0;
        end
        
        if (cnt1 >= max_cnt) begin
            max_cnt = cnt1;
            max_line = 1;
        end
        
        if (cnt2 >= max_cnt) begin
            max_cnt = cnt2;
            max_line = 2;
        end
        
        if (cnt3 >= max_cnt) begin
            max_cnt = cnt3;
            max_line = 3;
        end
        
        if (cnt4 >= max_cnt) begin
            max_cnt = cnt4;
            max_line = 4;
        end
        
        if (cnt5 >= max_cnt) begin
            max_cnt = cnt5;
            max_line = 5;
        end
        
        if (cnt6 >= max_cnt) begin
            max_cnt = cnt6;
            max_line = 6;
        end
        
        if (cnt7 >= max_cnt) begin
            max_cnt = cnt7;
            max_line = 7;
        end
    end
    
    always @ (max_line) begin
        lru_line <= max_line;
    end
    
endmodule // max_comparator
