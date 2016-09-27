`timescale 1ns / 1ps

// @input
// clk_src: clock source group
// ALARM_STEP: HZ of alarm sparkle
// power: power of washing machine
// weight_ch: signal for changing weight
// mode_ch: signal for changing mode
// w_r_d_end: signal expliciting which phase has finished
// @output
// alarm: alarm led
module ring
#(parameter WIDTH = 32, ALARM_STEP = 24)
(
    input [(WIDTH-1):0] clk_src,
    input power,
    input weight_ch,
    input mode_ch,
    input [2:0] w_r_d_end,
    output reg alarm
);

    reg [(WIDTH-1):0] count;
    
    // state of alarm
    reg [1:0] state, next_state;
    // NO_ALARM: no sparkle, BTN_ALARM: sparkle 1 time, PHASE_ALARM: sparkle 3 times
    parameter NO_ALARM = 0, BTN_ALARM = 1, PHASE_ALARM = 2;
    
    initial begin
        alarm <= 0;
        count <= 0;
        state <= NO_ALARM;
        next_state <= NO_ALARM;
    end
    
    // state update
    always @(clk_src[0]) begin
        if (power) begin
            state = next_state;
        end else if (!power) begin
            state = NO_ALARM;
        end
    end
    
    // state transfer
    always @(mode_ch or weight_ch or w_r_d_end or count) begin
        if (power) begin
            case(state)
                NO_ALARM: begin
                    // when btn pushed, transfer to BTN_ALARM
                    // start to alarm 1 time
                    if (mode_ch || weight_ch) begin
                        next_state = BTN_ALARM;
                    // when a phase finished, transfer to PHASE_ALARM
                    // start to alarm 3 time 
                    end else if (w_r_d_end) begin
                        next_state = PHASE_ALARM;
                    end else begin
                        next_state = NO_ALARM;
                    end
                end
                BTN_ALARM: begin
                    // there is a new phase finished, start to a new alarm 3 time
                    if (w_r_d_end) begin
                        next_state = PHASE_ALARM;
                    // alarm 1 time finished, transfer to NO_ALARM
                    // stop alarm
                    end else if (count >= 2) begin
                        next_state = NO_ALARM;
                    // continue alarm
                    end else begin
                        next_state = BTN_ALARM;
                    end
                end
                PHASE_ALARM: begin
                    /// there is a new btn pushed, start to a new alarm 1 time
                    if (mode_ch || weight_ch) begin
                        next_state = BTN_ALARM;
                    end
                    // alarm 3 time finished, transfer to NO_ALARM
                    // stop alarm
                    else if (count >= 6) begin
                        next_state = NO_ALARM;
                    end else begin
                    // continue alarm
                        next_state = PHASE_ALARM;
                    end
                end
            endcase
        end else begin
            next_state = NO_ALARM;
        end
    end
    
    // output
    always @(posedge clk_src[ALARM_STEP]) begin
        case(state)
            NO_ALARM: begin
                count = 0;
                alarm = 0;
            end
            BTN_ALARM: begin
                count = count + 1;
                alarm = ~alarm;
            end
            PHASE_ALARM: begin
                count = count + 1;
                alarm = ~alarm;
            end
       endcase
   end
    
endmodule
