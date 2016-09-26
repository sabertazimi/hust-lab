`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/26 10:10:57
// Design Name: 
// Module Name: ring
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

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
    
    always @(clk_src[0]) begin
        if (power) begin
            state = next_state;
        end else if (!power) begin
            state = NO_ALARM;
        end
    end
    
    always @(mode_ch or weight_ch or w_r_d_end or count) begin
        if (power) begin
            case(state)
                NO_ALARM: begin
                    if (mode_ch || weight_ch) begin
                        next_state = BTN_ALARM;
                    end else if (w_r_d_end) begin
                        next_state = PHASE_ALARM;
                    end else begin
                        next_state = NO_ALARM;
                    end
                end
                BTN_ALARM: begin
                    if (w_r_d_end) begin
                        next_state = PHASE_ALARM;
                    end else if (count >= 2) begin
                        next_state = NO_ALARM;
                    end else begin
                        next_state = BTN_ALARM;
                    end
                end
                PHASE_ALARM: begin
                    if (mode_ch || weight_ch) begin
                        next_state = BTN_ALARM;
                    end
                    else if (count >= 6) begin
                        next_state = NO_ALARM;
                    end else begin
                        next_state = PHASE_ALARM;
                    end
                end
            endcase
        end else begin
            next_state = NO_ALARM;
        end
    end
    
    always @(posedge clk_src[ALARM_STEP]) begin
        case(state)
            NO_ALARM: begin
                count = 0;
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
