`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 21:46:06
// Design Name: 
// Module Name: starter
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
// clk_src: bind to E3(100Hz)
// power: electric power
// enable: enable switch(pause switch)
// reset: reset switch
// add_time/sub_time: add/sub time manually
// timing_clock_switch: switch for enabling to change timing clock
// @output
// alarm: round time alarm
// timing_clock_alarm: timing clock arrive
// anodes/cnodes: displaye time
module clock
#(parameter WIDTH = 32, CLK_CH = 25, SEC_RANGE = 60, MIN_RANGE = 60, HOUR_RANGE = 24)
(
    input clk_src,
    input power,
    input enable,
    input reset,
    input [2:0] add_time,
    input [2:0] sub_time,
    input timing_clock_switch,
    output alarm,
    output timing_clock_alarm,
    output [7:0] anodes,
    output [7:0] cnodes
);

    // record current time
    wire [(WIDTH-1):0] sec, min, hour;
  
    // record whole point signal
    wire sig_sec, sig_min, sig_hour;
  
    // divided clock source
    wire clk_dst;
    wire [(WIDTH-1):0] clk_group;
  
    // segment light when power on
    wire [7:0] inner_anodes, inner_cnodes;
    
    // segment light of timing clock
    wire [7:0] timing_anodes, timing_cnodes;
  
    range_divider DRANGE_DIVIDER (
        .clk_src(clk_src),
        .clk_dst(clk_dst)
    );
    
    // for debug only
    // assign clk_dst = clk_group[0];
  
    tick_divider TICK_DIVIDER (
        .clk_src(clk_src),
        .clk_group(clk_group)
    );

    timer #(.WIDTH(WIDTH), .RANGE(SEC_RANGE)) SEC_TIMER (
        // && !timing_clock_switch : for timing clock
        .clk_normal(clk_dst  && !timing_clock_switch ),
        .clk_change_time(clk_group[CLK_CH]  && !timing_clock_switch),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[0]),
        .sub_time(sub_time[0]),
        .count(sec),
        .sig_end(sig_sec)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(MIN_RANGE)) MIN_TIMER (
        .clk_normal(sig_sec  && !timing_clock_switch),
        .clk_change_time(clk_group[CLK_CH]  && !timing_clock_switch),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[1]),
        .sub_time(sub_time[1]),
        .count(min),
        .sig_end(sig_min)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(HOUR_RANGE)) HOUR_TIMER (
        .clk_normal(sig_min  && !timing_clock_switch),
        .clk_change_time(clk_group[CLK_CH]  && !timing_clock_switch),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[2]),
        .sub_time(sub_time[2]),
        .count(hour),
        .sig_end(sig_hour)
    );
  
    time_displayer SEG_SEVEN (
        .clk_src(clk_group[15]),
        .sec_data(sec),
        .min_data(min),
        .hour_data(hour),
        // when power off, light off
        .anodes(inner_anodes),
        .cnodes(inner_cnodes)
    );
 
    ring RING (
        .power(power),
        .sig_ring(sec == (SEC_RANGE-1) && min == (MIN_RANGE-1) && enable),
        .sig_step(clk_dst),
        .alarm(alarm)
    );
    
    timing_clock #(WIDTH, CLK_CH, SEC_RANGE, MIN_RANGE, HOUR_RANGE) TIMING_CLOCK (
        .clk_dst(clk_dst),
        .clk_group(clk_group),
        .timing_clock_switch(timing_clock_switch),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time),
        .sub_time(sub_time),
        .sec(sec),
        .min(min),
        .hour(hour),
        .timing_anodes(timing_anodes),
        .timing_cnodes(timing_cnodes),
        .timing_clock_alarm(timing_clock_alarm)
    );
 
    assign anodes = !power ? 8'b11111111
                : timing_clock_switch ? timing_anodes
                : inner_anodes;
    assign cnodes = !power ? 8'b11111111 
                : timing_clock_switch ? timing_cnodes
                : inner_cnodes;
  
endmodule
