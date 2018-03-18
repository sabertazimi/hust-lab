`include "defines.vh"

/**
 * @module branch_target_buffer
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief branch target buffer for branch prediction
 * @param DATA_WIDTH data width
 * @input clk clock signal
 * @input rst reset signal
 * @input en enable signal
 * @input branch imply whether current instruction is branch or not
 * @input misprediction imply whether prediction success or not
 * @input IF_branch_pc pc addr of current branch instruction in IF stage
 * @input IF_predict_addr jmp addr of current branch instruction in ID stage
 * @input ID_branch_pc pc addr of current branch instruction in ID stage
 * @input ID_branch_addr jmp addr of current branch instruction in ID stage
 * @output taken prediction taken or not taken
 * @output IF_hit BTB access / miss in IF stage 
 * @output btb_branch_addr target address read from BTB
 */
module branch_target_buffer 
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input IF_branch,
    input ID_branch,
    input misprediction,
    input [DATA_WIDTH-1:0] IF_branch_pc,
    input [DATA_WIDTH-1:0] IF_predict_addr,
    input [DATA_WIDTH-1:0] ID_branch_pc,
    input [DATA_WIDTH-1:0] ID_branch_addr,
    output [`BTB_PREDICT_SIZE-1:0] taken,
    output IF_hit,
    output [DATA_WIDTH-1:0] btb_branch_addr
);

    integer i;

    // BTB table entries
    reg valid [`BTB_LINE_NUM-1:0];
    reg [`BTB_PREDICT_SIZE-1:0] predict_bits [`BTB_LINE_NUM-1:0];
    reg [DATA_WIDTH-1:0] branch_tags [`BTB_LINE_NUM-1:0];
    reg [DATA_WIDTH-1:0] target_PCs [`BTB_LINE_NUM-1:0];
    
    // hit line
    wire [`BTB_LINE_SIZE-1:0] IF_hit_line;
    wire ID_hit;
    wire [`BTB_LINE_SIZE-1:0] ID_hit_line;
    wire [`BTB_LINE_SIZE-1:0] hit_line;
    
    // rewrite line
    wire [`BTB_LINE_SIZE-1:0] lru_line;
    
    // true access line
    wire [`BTB_LINE_SIZE-1:0] IF_access_line;
    wire [`BTB_LINE_SIZE-1:0] ID_access_line;
    
    associative_comparator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IF_comparator (
        .src_tag(IF_branch_pc),
        .valid0(valid[0]),
        .valid1(valid[1]),
        .valid2(valid[2]),
        .valid3(valid[3]),
        .valid4(valid[4]),
        .valid5(valid[5]),
        .valid6(valid[6]),
        .valid7(valid[7]),
        .tag0(branch_tags[0]),
        .tag1(branch_tags[1]),
        .tag2(branch_tags[2]),
        .tag3(branch_tags[3]),
        .tag4(branch_tags[4]),
        .tag5(branch_tags[5]),
        .tag6(branch_tags[6]),
        .tag7(branch_tags[7]),
        .hit(IF_hit),
        .hit_line(IF_hit_line)
    );
    
    associative_comparator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ID_comparator (
        .src_tag(ID_branch_pc),
        .valid0(valid[0]),
        .valid1(valid[1]),
        .valid2(valid[2]),
        .valid3(valid[3]),
        .valid4(valid[4]),
        .valid5(valid[5]),
        .valid6(valid[6]),
        .valid7(valid[7]),
        .tag0(branch_tags[0]),
        .tag1(branch_tags[1]),
        .tag2(branch_tags[2]),
        .tag3(branch_tags[3]),
        .tag4(branch_tags[4]),
        .tag5(branch_tags[5]),
        .tag6(branch_tags[6]),
        .tag7(branch_tags[7]),
        .hit(ID_hit),
        .hit_line(ID_hit_line)
    );
    
    assign hit_line = IF_hit ? IF_hit_line
                    : ID_hit ? ID_hit_line
                    : lru_line;
    
    lru_counter #(
        .DATA_WIDTH(DATA_WIDTH)
    ) lru_counter (
        .clk(clk),
        .rst(rst),
        .en(en && IF_branch && ID_branch),
        .hit(IF_hit || ID_hit),
        .hit_line(hit_line),
        .lru_line(lru_line)
    );

    assign IF_access_line = IF_hit ? IF_hit_line : lru_line;
    assign ID_access_line = ID_hit ? ID_hit_line : lru_line;

    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < `BTB_LINE_NUM; i = i + 1) begin
                valid[i] <= 0;
                predict_bits[i] <= `WEAKLY_TAKEN;
                branch_tags[i] <= 0;
                target_PCs[i] <= 4;
		    end
        end else if (en) begin
            if (~IF_hit && IF_branch) begin
                valid[IF_access_line] <= 1;
                predict_bits[IF_access_line] <=  `WEAKLY_TAKEN;
                branch_tags[IF_access_line] <=  IF_branch_pc;
                target_PCs[IF_access_line] <= IF_predict_addr;
            end
            
            if (ID_branch) begin
                if (~ID_hit) begin
                    valid[ID_access_line] <= 1;
                    predict_bits[ID_access_line] <=  `WEAKLY_TAKEN;
                    branch_tags[ID_access_line] <=  ID_branch_pc;
                    target_PCs[ID_access_line] <= ID_branch_addr;
                end else begin
                    target_PCs[ID_access_line] <= ID_branch_addr;
                    case (predict_bits[ID_access_line])
                        `STRONGLY_TAKEN:
                            case (misprediction)
                                0:predict_bits[ID_access_line] <= `STRONGLY_TAKEN;
                                1: predict_bits[ID_access_line] <= `WEAKLY_TAKEN;
                            endcase
                        `WEAKLY_TAKEN:
                            case (misprediction)
                                0: predict_bits[ID_access_line] <= `STRONGLY_TAKEN;
                                1: predict_bits[ID_access_line] <= `WEAKLY_NOT_TAKEN;
                            endcase
                        `WEAKLY_NOT_TAKEN:
                            case (misprediction)
                                0: predict_bits[ID_access_line] <= `STRONGLY_NOT_TAKEN;
                                1: predict_bits[ID_access_line] <= `WEAKLY_TAKEN;
                            endcase
                        `STRONGLY_NOT_TAKEN:
                            case (misprediction)
                                0: predict_bits[ID_access_line] <= `STRONGLY_NOT_TAKEN;
                                1: predict_bits[ID_access_line] <= `WEAKLY_NOT_TAKEN;
                            endcase
                    endcase
                end
            end
        end
    end
    
    assign taken = IF_hit ? predict_bits[IF_access_line] : `WEAKLY_TAKEN;
    assign btb_branch_addr = IF_hit ? target_PCs[IF_access_line] : IF_predict_addr;
    
endmodule // associative_comparator
