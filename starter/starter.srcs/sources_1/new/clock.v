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
    output [15:0] seg_sec,
    output [15:0] seg_min,
    output [15:0] seg_hour
);

  // record current time
  wire [(WIDTH-1):0] sec, min, hour;
  
  // record whole point signal
  wire sig_sec, sig_min, sig_hour;
  
  // divided clock source
  wire clk_dst;
  
  range_divider DIVIDER (
    .clk_src(clk_src),
    .clk_dst(clk_dst)
  );
  
  
  timer #(.WIDTH(WIDTH), .RANGE(60)) SEC_TIMER (
    .clk_src(clk_dst),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_sec),
    .sig_reset(sig_reset),
    .count(sec),
    .sig_start(),
    .sig_end(sig_sec)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(60)) MIN_TIMER (
    .clk_src(sig_sec),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_min),
    .sig_reset(sig_reset),
    .count(min),
    .sig_start(),
    .sig_end(sig_min)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(24)) HOUR_TIMER (
    .clk_src(sig_min),
    .power(power),
    .switch_en(switch_en),
    .sig_up_time(sig_up_hour),
    .sig_reset(sig_reset),
    .count(hour),
    .sig_start(),
    .sig_end(sig_hour)
  ); 

  ring RING (
    .sig_ring(sig_min),
    .sig_step(clk_dst),
    .bell(bell)
  );
  
  time_to_segment SEC_SEG (
     .time_data(sec),
     .seg_data(seg_sec)
  );
  
  time_to_segment MIN_SEG (
     .time_data(min),
     .seg_data(seg_min)
  );
  
  time_to_segment HOUR_SEG (
     .time_data(hour),
     .seg_data(seg_hour)
  );
endmodule
