`timescale 1ns / 1ps

// @module
// timing clock alarm
// @input
// clk_dst/clk_group: multiple clock source
// timing_clock_switch: switch for enabling to change timing time
// timing_clock_disable: shutdown timing_clock manully
// power: electric power
// enable: enable switch only for real clock
// reset: reset switch
// add_time/sub_time: chaning time switch
// sec/min/hour: time data of real clock
// timing_anodes/timing_cnodes: port for displaying time
// timing_clock_alarm: clock alarm when timing clock arrive
module timing_clock
#(parameter WIDTH = 32, CLK_CH = 25, SEC_RANGE = 60, MIN_RANGE = 60, HOUR_RANGE = 24, LEN = 30, NUM = 5)
(
    input clk_dst,
    input [(WIDTH-1):0] clk_group,
    input timing_clock_switch,
    input timing_clock_disable,
    input power,
    input enable,
    input reset,
    input [2:0] add_time,
    input [2:0] sub_time,
    input [(WIDTH-1):0] sec,
    input [(WIDTH-1):0] min,
    input [(WIDTH-1):0] hour,
    output [7:0] timing_anodes,
    output [7:0] timing_cnodes,
    output [(NUM-1):0] timing_clock_alarm
);

    // for timer invoking in this module
    wire [(WIDTH-1):0] timing_sec, timing_min, timing_hour;
    wire timing_sig_sec, timing_sig_min, timing_sig_hour;

    // for ring module invoking in this module
    reg [(WIDTH-1):0] timing_count;
    reg timing_clock_alarm_sig;

    initial begin
        timing_count <= 0;
        timing_clock_alarm_sig <= 0;
    end

    /* start of cloning a clock that can't run */
    
    timer #(.WIDTH(WIDTH), .RANGE(SEC_RANGE)) TIMING_SEC_TIMER (
        // && !timing_clock_switch : when changing real clock, lock timing clock
        .clk_normal(clk_dst  && timing_clock_switch),
        .clk_change_time(clk_group[CLK_CH]  && timing_clock_switch),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[0]),
        .sub_time(sub_time[0]),
        .count(timing_sec),
        .sig_end(timing_sig_sec)
    );

    timer #(.WIDTH(WIDTH), .RANGE(MIN_RANGE)) TIMING_MIN_TIMER (
        .clk_normal(timing_sig_sec  && timing_clock_switch),
        .clk_change_time(clk_group[CLK_CH]  && timing_clock_switch),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[1]),
        .sub_time(sub_time[1]),
        .count(timing_min),
        .sig_end(timing_sig_min)
    );

    timer #(.WIDTH(WIDTH), .RANGE(HOUR_RANGE)) TIMING_HOUR_TIMER (
        .clk_normal(timing_sig_min  && timing_clock_switch),
        .clk_change_time(clk_group[CLK_CH]  && timing_clock_switch),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[2]),
        .sub_time(sub_time[2]),
        .count(timing_hour),
        .sig_end(timing_sig_hour)
    );

    time_displayer TIMING_SEG_SEVEN (
        .clk_src(clk_group[15]),
        .sec_data(timing_sec),
        .min_data(timing_min),
        .hour_data(timing_hour),
        // when power off, light off
        .anodes(timing_anodes),
        .cnodes(timing_cnodes)
    );
    
    /* end of cloning a clock that can't run */
    
    // judge whether tming clock arrive or not
    always @(posedge clk_group[CLK_CH]) begin
        // shutdown timing clock manually
        if (timing_clock_disable) begin
            timing_clock_alarm_sig = 0;
        end
        // arrive target time
        else if (sec == timing_sec
            && min == timing_min
            && hour == timing_hour
            && enable && !timing_clock_switch) begin
            timing_clock_alarm_sig = 1;
        end else begin
            timing_clock_alarm_sig = 0;
        end
    end

    // timing clock alarm
    flow_led #(LEN, NUM) TIMING_RING (
        .power(power && !timing_clock_disable),
        .sig_ring(timing_clock_alarm_sig),
        .sig_step(clk_dst),
        .alarm_light(timing_clock_alarm)
    );

endmodule
