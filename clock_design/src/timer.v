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
// clk_src: normal clock source
// up_src: manually changing time clock source
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
    input change_src,
    input power,
    input switch_en,
    input switch_up_time,
    input switch_reset,
    output reg [(WIDTH-1):0] count,
    output reg sig_end
);

    wire true_clk;

    initial begin
        count <= 0;
        sig_end <= 0;
    end
    
    // change async clk to sync clk
    assign true_clk = (!power || switch_reset || !switch_en && switch_up_time) ? change_src : clk_src;
    
    always @(posedge true_clk) begin
        if (power) begin
            if (switch_reset) begin
                count <= 0;
            end else if (switch_en) begin
                count = (count + 1) % RANGE;
                
                if (count == 0) begin
                    sig_end = 1;
                end else begin
                    sig_end = 0;
                end
            end else if (switch_up_time) begin
                count = (count + 1) % RANGE;
            end
        end else begin
            count <= 0;
        end
    end
endmodule
