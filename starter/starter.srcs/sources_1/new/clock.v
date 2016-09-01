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
    input switch_en,
    input switch_upen_sec,
    input switch_upen_min,
    input switch_upen_hour,
    input switch_up_sec,
    input switch_up_min,
    input switch_up_hour,
    input switch_reset,
    output bell,
    output [7:0] seg_control,
    output [7:0] seg_time
);

  // record current time
  wire [(WIDTH-1):0] sec, min, hour;
  
  // record whole point signal
  wire sig_sec, sig_min, sig_hour;
  
  // divided clock source
  wire clk_dst;
  wire [(WIDTH-1):0] clk_group;
  
  range_divider DRANGE_DIVIDER (
    .clk_src(clk_src),
    .clk_dst(clk_dst)
  );
  
  tick_divider TICK_DIVIDER (
    .clk_src(clk_src),
    .clk_group(clk_group)
  );

  // open switch for time change, change clock source
  timer #(.WIDTH(WIDTH), .RANGE(60)) SEC_TIMER (
    .clk_src(switch_upen_sec ? clk_group[25] : clk_dst),
    .power(power),
    .switch_en(switch_en),
    .switch_up_time(switch_up_sec),
    .switch_reset(switch_reset),
    .count(sec),
    .sig_end(sig_sec)
  );
  
  // open switch for time change, change clock source
  timer #(.WIDTH(WIDTH), .RANGE(60)) MIN_TIMER (
    .clk_src(switch_upen_min ? clk_group[25] : sig_sec),
    .power(power),
    .switch_en(switch_en),
    .switch_up_time(switch_up_min),
    .switch_reset(switch_reset),
    .count(min),
    .sig_end(sig_min)
  );
  
  // open switch for time change, change clock source
  timer #(.WIDTH(WIDTH), .RANGE(24)) HOUR_TIMER (
    .clk_src(switch_upen_hour ? clk_group[25] : sig_min),
    .power(power),
    .switch_en(switch_en),
    .switch_up_time(switch_up_hour),
    .switch_reset(switch_reset),
    .count(hour),
    .sig_end(sig_hour)
  );

  ring RING (
    .sig_ring(sec == 0 && min == 0),
    .sig_step(clk_dst),
    .bell(bell)
  );
  
  time_displayer SEG_SEVEN (
     .clk_src(clk_group[15]),
     .sec_data(sec),
     .min_data(min),
     .hour_data(hour),
     .anodes(seg_control),
     .cnodes(seg_time)
  );
  
endmodule
