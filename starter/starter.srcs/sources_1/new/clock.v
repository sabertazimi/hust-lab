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
    input sig_up_sec,
    input sig_up_min,
    input sig_up_hour,
    input sig_reset,
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
  
  range_divider #(.WIDTH(WIDTH), .RANGE(2)) DRANGE_DIVIDER (
    .clk_src(clk_src),
    .clk_dst(clk_dst)
  );
  
  tick_divider TICK_DIVIDER (
    .clk_src(clk_src),
    .clk_group(clk_group)
  );

  timer #(.WIDTH(WIDTH), .RANGE(5)) SEC_TIMER (
    .clk_src(clk_dst),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_sec),
    .sig_reset(sig_reset),
    .count(sec),
    .sig_end(sig_sec)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(5)) MIN_TIMER (
    .clk_src(sig_sec),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_min),
    .sig_reset(sig_reset),
    .count(min),
    .sig_end(sig_min)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(3)) HOUR_TIMER (
    .clk_src(sig_min),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_hour),
    .sig_reset(sig_reset),
    .count(hour),
    .sig_end(sig_hour)
  ); 

  ring RING (
    .sig_ring(sig_min),
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
