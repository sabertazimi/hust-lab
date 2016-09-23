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
    input [2:0] add_time,
    input [2:0] sub_time,
    output alarm,
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
  
  range_divider DRANGE_DIVIDER (
    .clk_src(clk_src),
    .clk_dst(clk_dst)
  );
  
  tick_divider TICK_DIVIDER (
    .clk_src(clk_src),
    .clk_group(clk_group)
  );

  timer #(.WIDTH(WIDTH), .RANGE(60)) SEC_TIMER (
    .clk_normal(clk_dst),
    .clk_change_time(clk_group[25]),
    .power(power),
    .enable(enable),
    .reset(reset),
    .add_time(add_time[0]),
    .sub_time(sub_time[0]),
    .count(sec),
    .sig_end(sig_sec)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(60)) MIN_TIMER (
    .clk_normal(sig_sec),
    .clk_change_time(clk_group[25]),
    .power(power),
    .enable(enable),
    .reset(reset),
    .add_time(add_time[1]),
    .sub_time(sub_time[1]),
    .count(min),
    .sig_end(sig_min)
  );
  
  timer #(.WIDTH(WIDTH), .RANGE(24)) HOUR_TIMER (
    .clk_normal(sig_min),
    .clk_change_time(clk_group[25]),
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
  
  assign anodes = power ? inner_anodes : 8'b11111111;
  assign cnodes = power ? inner_cnodes : 8'b11111111;
  
endmodule
