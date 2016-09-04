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
#(parameter WIDTH = 32)
(   input [31:0]clk_src,
    input switch_power,
    input switch_en,
    input sum_count,
    input count_start_flag,
    output reg count_end_flag,
    output reg [(WIDTH-1):0] count
);

    initial begin
        count_end_flag <= 0;
        count <= sum_count;
    end
    
    always @(posedge clk_src[25]) begin
        if (switch_power) begin
            if (count_start_flag) begin
                if (switch_en) begin
                    if (count >= 0) begin
                        count <= count - 1;
                    end else if (count == 0) begin
                        count_end_flag <= 0;
                    end
                end
            end else begin
                count_end_flag <= 0;
                count <= sum_count;
            end
        end else begin
            count_end_flag <= 0;
            count <= sum_count;
        end
    end
endmodule