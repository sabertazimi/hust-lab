`timescale 1ns / 1ps

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
    input [31:0]sum_count,
    input count_start_flag,
    output reg count_end_flag,
    output reg [(WIDTH-1):0] count
);
    reg power_control;
    initial begin
        count_end_flag <= 0;
        count <= sum_count;
        power_control = 1;
    end
    //information: count has a second delay
    always @(posedge clk_src[25]) begin
        if (switch_power & count_start_flag & power_control) begin
            if (switch_en) begin
                if (count > 0) begin
                    count <= count - 1;
                end else if (count == 0) begin
                    count_end_flag <= 1;
                end
            end
        end else begin
            count_end_flag <= 0;
            count <= sum_count;
            power_control = 1;
        end
    end
    
    always @(negedge switch_power or negedge count_start_flag) begin
        power_control = 0;
    end
endmodule