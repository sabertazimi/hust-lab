`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 20:51:51
// Design Name: 
// Module Name: timer
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
// clk_src: clock source
// power: electronic power
// switch_en: pause switch
// sig_up_time: add value of time
// sig_reset: reset pulse
// @output
// count: current count time
// sig_start: signal implicits arriving at 0
// sig_end: signal implicits arriving at RANGE
module timer
#(parameter WIDTH = 32, RANGE = 60)
(
    input clk_src,
    input power,
    input switch_en,
    input sig_up_time,
    input sig_reset,
    output reg [(WIDTH-1):0] count,
    output reg sig_end   
);

    initial begin
        count <= 0;
        // sig_start <= 0;
        sig_end <= 0;
    end
    
    always @(posedge clk_src or posedge sig_up_time or posedge sig_reset) begin
        if (power) begin
            if (switch_en) begin
                count = (count + 1) % RANGE;
                
                if (count == 0) begin
                    sig_end = 1;
                end else begin
                    sig_end = 0;
                end
//                if (count == RANGE) begin
//                    sig_end = 1;
//                end else begin
//                    sig_end = 0;
//                end
            end else if (sig_reset) begin
                sig_end = 0;
                count = 0;
            end else if (sig_up_time) begin
                sig_end = 0;
                count = (count + 1) % RANGE;
            end
        end
    end
endmodule
