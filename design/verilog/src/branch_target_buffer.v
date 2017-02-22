/**
 * @module branch_target_buffer
 * @brief branch target buffer for branch prediction
 * @param DATA_WIDTH data width
 * @input clk clock signal
 * @input rst reset signal
 * @input en enable signal
 * @input misprediction imply whether prediction success or not
 * @input ID_branch_pc pc addr of current branch instruction in ID stage
 * @output taken prediction taken or not taken
 */
module branch_target_buffer 
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input misprediction,
    input [DATA_WIDTH-1:0] ID_branch_pc,
    output taken
);

`include "defines.vh"

    wire [`BTB_TAG_SIZE-1:0] source_tag;
    
    assign source_tag = ID_branch_pc[11:2];

endmodule // associative_comparator
