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

    wire clock;
    wire [3:0] flags;
    
    assign clock = sig_reset || sig_up_time || clk_src;
    assign flags = {switch_en, clk_src, sig_reset, sig_up_time};

    initial begin
        count <= 0;
        // sig_start <= 0;
        sig_end <= 0;
    end
    
    always @(posedge clock) begin
        if (power) begin
//            if (clk_src && switch_en) begin
//                count = (count + 1) % RANGE;
            
//                if (count == 0) begin
//                    sig_end = 1;
//                end else begin
//                    sig_end = 0;
//                end
//            end else if (sig_reset && !switch_en) begin
//                count = 0;
//            end else if (sig_up_time && !switch_en) begin
//                count = (count + 1) % RANGE;
//            end
            case (flags)
                4'b1000,
                4'b1100: begin
                    count = (count + 1) % RANGE;
                    if (count == 0) begin
                        sig_end = 1;
                    end else begin
                        sig_end = 0;
                    end
                end
                4'b0010,
                4'b0110,
                4'b0011,
                4'b0111: begin
                    count = 0;
                end
                4'b0001,
                4'b0101: begin
                    count = (count + 1) % RANGE;
                end
                default : begin
                end
            endcase
        end
    end
endmodule
