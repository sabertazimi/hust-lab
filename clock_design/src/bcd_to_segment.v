`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 10:58:59
// Design Name: 
// Module Name: bcd_to_segment
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

// seg_data[7:0]a: dp-G-F-E-D-C-B-A
module bcd_to_segment
(
    input [3:0] bcd_data,
    output reg [7:0] seg_data
);

    always @(bcd_data) begin
        case (bcd_data)
             4'b0000:    seg_data <= 8'b11000000;    // 0
             4'b0001:    seg_data <= 8'b11111001;    // 1
             4'b0010:    seg_data <= 8'b10100100;    // 2
             4'b0011:    seg_data <= 8'b10110000;    // 3
             4'b0100:    seg_data <= 8'b10011001;    // 4
             4'b0101:    seg_data <= 8'b10010010;    // 5
             4'b0110:    seg_data <= 8'b10000011;    // 6
             4'b0111:    seg_data <= 8'b11111000;    // 7
             4'b1000:    seg_data <= 8'b10000000;    // 8
             4'b1001:    seg_data <= 8'b10010000;    // 9
             4'b1010:    seg_data <= 8'b01111111;    // dp
             default:    seg_data <= 8'b11111111;    // off
        endcase    
    end
    
endmodule
