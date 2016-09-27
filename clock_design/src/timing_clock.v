`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/27 08:11:19
// Design Name: 
// Module Name: timing_clock
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
// clk_dst/clk_group: multiple clock source
// timing_clock_switch: switch for enabling to change timing time
// power: electric power
// enable: enable switch only for real clock
// reset: reset switch
// add_time/sub_time: chaning time switch
// sec/min/hour: time data of real clock
// timing_anodes/timing_cnodes: port for displaying time
// timing_clock_alarm: clock alarm when timing clock arrive
module timing_clock
#(parameter WIDTH = 32)
(
    input clk_dst,
    input [(WIDTH-1):0] clk_group,
    input timing_clock_switch,
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
    output timing_clock_alarm
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
    
    timer #(.WIDTH(WIDTH), .RANGE(60)) TIMING_SEC_TIMER (
        // && !timing_clock_switch : for timing clock
        .clk_normal(clk_dst  && timing_clock_switch ),
        .clk_change_time(clk_group[25]  && timing_clock_switch),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[0]),
        .sub_time(sub_time[0]),
        .count(timing_sec),
        .sig_end(timing_sig_sec)
    );

    timer #(.WIDTH(WIDTH), .RANGE(60)) TIMING_MIN_TIMER (
        .clk_normal(timing_sig_sec  && timing_clock_switch),
        .clk_change_time(clk_group[25]  && timing_clock_switch),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[1]),
        .sub_time(sub_time[1]),
        .count(timing_min),
        .sig_end(timing_sig_min)
    );

    timer #(.WIDTH(WIDTH), .RANGE(24)) TIMING_HOUR_TIMER (
        .clk_normal(timing_sig_min  && timing_clock_switch),
        .clk_change_time(clk_group[25]  && timing_clock_switch),
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
    always @(posedge clk_group[25]) begin
        if (sec == timing_sec - 1
            && min == timing_min
            && hour == timing_hour
            && enable && !timing_clock_switch) begin
            timing_clock_alarm_sig = 1;
        end else begin
            timing_clock_alarm_sig = 0;
        end
    end

    // timing clock alarm
    ring TIMING_RING (
        .power(power),
        .sig_ring(timing_clock_alarm_sig),
        .sig_step(clk_dst),
        .alarm(timing_clock_alarm)
    );

endmodule
