`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 10:59:16
// Design Name: 
// Module Name: time_to_segment
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


module time_to_segment
#(parameter WIDTH = 32)
(
    input [(WIDTH-1):0] time_data,
    output [15:0] seg_data
);

    wire [3:0] unit, decade;
    wire [3:0] unit_bcd, decade_bcd;
    
    assign unit = time_data % 10;
    assign decade = time_data / 10;
    
    integer_to_bcd UNIT_BCD (
        .int_data(unit),
        .bcd_data(unit_bcd)
    );
    integer_to_bcd DECADE_BCD (
        .int_data(decade),
        .bcd_data(decade_bcd)
    );
    bcd_to_segment UNIT_SEG (
        .bcd_data(unit_bcd),
        .seg_data(seg_data[7:0])
    );
    bcd_to_segment DECADE_SEG (
        .bcd_data(decade_bcd),
        .seg_data(seg_data[15:8])
    );

endmodule
