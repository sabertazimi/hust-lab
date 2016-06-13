`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 19:17:16
// Design Name: 
// Module Name: timing_signal_generator
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

/*
 * top module
 * @parameter clr_n
 */
module timing_signal_generator
#(parameter CYCLE = 5, LEN = 4)
(
    input clr_n,
    input on,
    input off,
    input [3:0] power,
    output [(LEN-1):0] T
);

    // power[1]: Hz select
    // power[0]: on/off
    
    wire [(LEN-1):0] clk_group, Tp;
    
    clock_generator #(.CYCLE(CYCLE), .LEN(LEN)) CLK (
        .clk(clk_group));
        
    timing_signal #(.LEN(LEN)) SIG (
        .clk(clk_group[power[3:1]]&power[0]),
        .clr_n(clr_n),
        .Tp(Tp));
        
    control_unit #(.LEN(LEN)) UNIT (
        .on(on),
        .off(off),
        .clr_n(clr_n),
        .Tp(Tp),
        .T(T));
endmodule
