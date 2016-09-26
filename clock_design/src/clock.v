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


module clock
#(parameter WIDTH = 32)
(
    input clk_src,
    input power,
    input enable,
    input reset,
    
    input timing_clock,
    
    input [2:0] add_time,
    input [2:0] sub_time,
    output alarm,
    output [7:0] anodes,
    output [7:0] cnodes,
    
    output timing_clock_alarm
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
  
    range_divider DRANGE_DIVIDER (
        .clk_src(clk_src),
        .clk_dst(clk_dst)
    );
  
    tick_divider TICK_DIVIDER (
        .clk_src(clk_src),
        .clk_group(clk_group)
    );

    timer #(.WIDTH(WIDTH), .RANGE(60)) SEC_TIMER (
        // && !timing_clock : for timing clock
        .clk_normal(clk_dst  && !timing_clock ),
        .clk_change_time(clk_group[25]  && !timing_clock),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[0]),
        .sub_time(sub_time[0]),
        .count(sec),
        .sig_end(sig_sec)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(60)) MIN_TIMER (
        .clk_normal(sig_sec  && !timing_clock),
        .clk_change_time(clk_group[25]  && !timing_clock),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[1]),
        .sub_time(sub_time[1]),
        .count(min),
        .sig_end(sig_min)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(24)) HOUR_TIMER (
        .clk_normal(sig_min  && !timing_clock),
        .clk_change_time(clk_group[25]  && !timing_clock),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time[2]),
        .sub_time(sub_time[2]),
        .count(hour),
        .sig_end(sig_hour)
    );

    ring RING (
        .sig_ring(sec == 59 && min == 59 && enable),
        .sig_step(clk_dst),
        .alarm(alarm)
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
 
    wire [(WIDTH-1):0] timing_sec, timing_min, timing_hour;
    wire timing_sig_sec, timing_sig_min, timing_sig_hour;
    wire [7:0] timing_anodes, timing_cnodes;

    timer #(.WIDTH(WIDTH), .RANGE(60)) TIMING_SEC_TIMER (
        // && !timing_clock : for timing clock
        .clk_normal(clk_dst  && timing_clock ),
        .clk_change_time(clk_group[25]  && timing_clock),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[0]),
        .sub_time(sub_time[0]),
        .count(timing_sec),
        .sig_end(timing_sig_sec)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(60)) TIMING_MIN_TIMER (
        .clk_normal(timing_sig_sec  && timing_clock),
        .clk_change_time(clk_group[25]  && timing_clock),
        .power(power),
        .enable(0),
        .reset(reset),
        .add_time(add_time[1]),
        .sub_time(sub_time[1]),
        .count(timing_min),
        .sig_end(timing_sig_min)
    );
  
    timer #(.WIDTH(WIDTH), .RANGE(24)) TIMING_HOUR_TIMER (
        .clk_normal(timing_sig_min  && timing_clock),
        .clk_change_time(clk_group[25]  && timing_clock),
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
  
    assign anodes = !power ? 8'b11111111
                : timing_clock ? timing_anodes
                : inner_anodes;
    assign cnodes = !power ? 8'b11111111 
                : timing_clock ? timing_cnodes
                : inner_cnodes;
                
    reg [(WIDTH-1):0] timing_count;
    reg timing_clock_alarm_sig;
    
    initial begin
        timing_count <= 0;
        timing_clock_alarm_sig <= 0;
    end
                
    always @(posedge clk_group[25]) begin
        if (sec == timing_sec
            && min == timing_min
            && hour == timing_hour
            && enable && !timing_clock) begin
            timing_clock_alarm_sig <= 1;
        end else begin
            timing_clock_alarm_sig <= 0;
        end
    end
    
    ring TIMING_RING (
        .sig_ring(timing_clock_alarm_sig),
        .sig_step(clk_dst),
        .alarm(timing_clock_alarm)
    );
    
endmodule
