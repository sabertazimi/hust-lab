`timescale 1ns / 1ps

// @module
// when timing clock match real clock, start these flow leds
// @input
// power: flow leds logical power
// sig_ring: signal for starting running flow leds
// sig_step: flow speed
// @output
// alarm_light: bind to FPGA board
module flow_led
#(parameter LEN = 5, NUM = 5)
(
    input power,
    input sig_ring,
    input sig_step,
    output reg [(NUM-1):0] alarm_light
);

    reg [31:0] count;
    
    // 1: representation for ring on
    // 0: representaion for ring off
    reg alarm;

    initial begin
        alarm <= 0;
        count <= 0;
        alarm_light <= 0;
    end

    always @(posedge sig_step) begin
        if (power) begin
            if (sig_ring) begin
                count = 0;
                alarm = 1;
                alarm_light = 1;
            end else begin
                if (alarm == 1) begin
                    count = count + 1;
                    alarm_light = alarm_light * 2 ? alarm_light * 2 : 1;
                end
                if (count == LEN) begin
                    count = 0;
                    alarm = 0;
                    alarm_light = 0;
                end
            end
        end else begin
            count = 0;
            alarm = 0;
            alarm_light = 0;
        end
    end
    
endmodule
