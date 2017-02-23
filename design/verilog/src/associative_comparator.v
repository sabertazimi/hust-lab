`include "defines.vh"

/**
 * @module associative_comparator
 * @brief brief_introduction
 * @param DATA_WIDTH data width
 * @input input1 input1_introduction
 * @input input2 input2_introduction
 * @output output1 output1_introduction
 * @output output2 output2_introduction
 */
module associative_comparator
(
    input [`BTB_TAG_SIZE-1:0] src_tag,
    input valid0,
    input valid1,
    input valid2,
    input valid3,
    input valid4,
    input valid5,
    input valid6,
    input valid7,
    input [`BTB_TAG_SIZE-1:0] tag0,
    input [`BTB_TAG_SIZE-1:0] tag1,
    input [`BTB_TAG_SIZE-1:0] tag2,
    input [`BTB_TAG_SIZE-1:0] tag3,
    input [`BTB_TAG_SIZE-1:0] tag4,
    input [`BTB_TAG_SIZE-1:0] tag5,
    input [`BTB_TAG_SIZE-1:0] tag6,
    input [`BTB_TAG_SIZE-1:0] tag7,
    output hit,
    output [`BTB_LINE_SIZE-1:0] hit_line
);

    wire hit0;
    wire hit1;
    wire hit2;
    wire hit3;
    wire hit4;
    wire hit5;
    wire hit6;
    wire hit7;
    wire [`BTB_LINE_NUM-1:0] hits;
    
    assign hit0 = valid0 && (src_tag == tag0);
    assign hit1 = valid1 && (src_tag == tag1);
    assign hit2 = valid2 && (src_tag == tag2);
    assign hit3 = valid3 && (src_tag == tag3);
    assign hit4 = valid4 && (src_tag == tag4);
    assign hit5 = valid5 && (src_tag == tag5);
    assign hit6 = valid6 && (src_tag == tag6);
    assign hit7 = valid7 && (src_tag == tag7);
    
    always @ ( * ) begin
        if (hit0) begin
            hit <= 1;
            hit_line <= 3'd0;
        end else if (hit1) begin
            hit <= 1;
            hit_line <= 3'd1;
        end else if (hit2) begin
            hit <= 1;
            hit_line <= 3'd2;
        end else if (hit3) begin
            hit <= 1;
            hit_line <= 3'd3;
        end else if (hit4) begin
            hit <= 1;
            hit_line <= 3'd4;
        end else if (hit5) begin
            hit <= 1;
            hit_line <= 3'd5;
        end else if (hit6) begin
            hit <= 1;
            hit_line <= 3'd6;
        end else if (hit7) begin
            hit <= 1;
            hit_line <= 3'd7;
        end else begin
            hit <= 0;           // miss
            hit_line <= 3'd8;
        end
    end

endmodule // associative_comparator
