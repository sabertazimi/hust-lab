module two_bit_predictor
(
    input clk,
    input rst,
    input en,
    input branch,
    input misprediction,
    output reg taken
);

    parameter STRONGLY_TAKEN = 2'b11;
    parameter WEAKLY_TAKEN = 2'b10;
    parameter WEAKLY_NOT_TAKEN = 2'b01;
    parameter STRONGLY_NOT_TAKEN = 2'b00;
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    // update state
    always @(posedge clk) begin
        if(rst) begin
            state <= WEAKLY_TAKEN;
        end else if (en) begin
            state <= next_state;
        end else begin
            state <= state;
        end
    end
    
    // compute next state
    always @ (branch or misprediction or state) begin
        if (!branch) begin
            next_state <= state;
        end else begin
            case (state)
                STRONGLY_TAKEN:
                    case (misprediction)
                        0: next_state <= state;
                        1: next_state <= WEAKLY_TAKEN;
                        default: next_state <= state;
                    endcase
                WEAKLY_TAKEN:
                    case (misprediction)
                        0: next_state <= STRONGLY_TAKEN;
                        1: next_state <= WEAKLY_NOT_TAKEN;
                        default: next_state <= state;
                    endcase
                WEAKLY_NOT_TAKEN:
                    case (misprediction)
                        0: next_state <= STRONGLY_NOT_TAKEN;
                        1: next_state <= WEAKLY_TAKEN;
                        default: next_state <= state;
                    endcase
                STRONGLY_NOT_TAKEN:
                    case (misprediction)
                        0: next_state <= state;
                        1: next_state <= WEAKLY_NOT_TAKEN;
                        default: next_state <= state;
                    endcase
                default: next_state <= state;
            endcase
        end
    end
    
    // update taken output
    always @ (state) begin
        case (state)
            STRONGLY_TAKEN      : taken <= 1;
            WEAKLY_TAKEN        : taken <= 1;
            WEAKLY_NOT_TAKEN    : taken <= 0;
            STRONGLY_NOT_TAKEN  : taken <= 0;
        endcase
    end
    
endmodule // two_bit_predictor