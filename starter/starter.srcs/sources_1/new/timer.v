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
// time_in: user-defined time(controled by sig_set)
// power: electronic power
// switch_en: pause switch
// sig_set: set pulse
// sig_reset: reset pulse
// @output
// sig_start: signal implicits arriving at 0
// sig_end: signal implicits arriving at RANGE
module timer
#(parameter WIDTH = 8, RANGE = 10)
(
    input clk_src,
    input time_in,
    input power,
    input switch_en,
    input sig_set,
    input sig_reset,
    output reg sig_start,
    output reg sig_end   
);

    reg [(WIDTH-1):0] count;
    
    initial begin
        count <= 0;
        sig_start <= 0;
        sig_end <= 0;
    end
    
    always @(posedge clk_src or posedge sig_set or posedge sig_reset) begin
        if (power) begin
            if (sig_reset) begin
                count <= 0;
            end
            
            if (switch_en) begin
                if (count == 0) begin
                    sig_start = 1;
                end else begin
                    sig_start = 0;
                end
                if (count == RANGE) begin
                    sig_end = 1;
                    count = 0;
                end else begin
                    sig_end = 0;
                end
                count = count + 1;
            end else begin
                if (sig_set) begin
                    count = time_in; 
                end        
            end
        end
    end
endmodule
