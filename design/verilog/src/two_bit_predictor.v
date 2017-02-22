module two_bit_predictor
(
    input clk,
    input rst,
    input en,
    input branch,
    input misprediction,
    output reg taken
);

`include "defines.vh"

    reg [1:0] state;
    reg [1:0] next_state;
    
    // update state
    always @(posedge clk) begin
        if(rst) begin
            state <= `WEAKLY_TAKEN;
        end else if (en) begin
            state <= next_state;
        end else begin
            state <= state;
        end
    end
    
    // compute next state
    always @ (rst or en or misprediction or state) begin
        if (rst) begin
            next_state <= state;
        end else if (!branch || !en) begin
            next_state <= next_state;
        end else begin
            case (state)
                `STRONGLY_TAKEN:
                    case (misprediction)
                        0: next_state <= `STRONGLY_TAKEN;
                        1: next_state <= `WEAKLY_TAKEN;
                        default: next_state <= next_state;
                    endcase
                `WEAKLY_TAKEN:
                    case (misprediction)
                        0: next_state <= `STRONGLY_TAKEN;
                        1: next_state <= `WEAKLY_NOT_TAKEN;
                        default: next_state <= next_state;
                    endcase
                `WEAKLY_NOT_TAKEN:
                    case (misprediction)
                        0: next_state <= `STRONGLY_NOT_TAKEN;
                        1: next_state <= `WEAKLY_TAKEN;
                        default: next_state <= next_state;
                    endcase
                `STRONGLY_NOT_TAKEN:
                    case (misprediction)
                        0: next_state <= `STRONGLY_NOT_TAKEN;
                        1: next_state <= `WEAKLY_NOT_TAKEN;
                        default: next_state <= next_state;
                    endcase
                default: next_state <= next_state;
            endcase
        end
    end
    
    // update taken output
    always @ (state) begin
        case (state)
            `STRONGLY_TAKEN      : taken <= 1;
            `WEAKLY_TAKEN        : taken <= 1;
            `WEAKLY_NOT_TAKEN    : taken <= 0;
            `STRONGLY_NOT_TAKEN  : taken <= 0;
        endcase
    end
    
endmodule // two_bit_predictor