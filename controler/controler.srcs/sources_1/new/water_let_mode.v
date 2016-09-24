`timescale 1ns / 1ps

module water_let_mode
#(parameter WIDTH = 32)
(
    input power, input start, input [31:0]clk,
    input water_in_start, input water_out_start, input [2:0]max_water_level,
    output reg water_in_end_sign, output reg water_out_end_sign, output reg [2:0]water_level
);
    reg init_flag;
    wire [(WIDTH-1):0]water_count;
    wire water_sign_mode;
    wire real_clk;
    initial begin
        init_flag <= 1;
    end
    
    timer WATER_IN_TIMER (.clk_src(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count({{29'b0}, max_water_level}),
                 .count_start_flag(water_in_start | water_out_start),
                 .count_end_flag(water_sign_mode),
                 .count(water_count)
    );

    assign real_clk = (power & !init_flag & (water_in_start | water_out_start)) ? clk[25] : clk[0];
    always @(posedge real_clk) begin
        if (power & (water_in_start | water_out_start)) begin
            if (start & !init_flag) begin
            if (water_in_start) begin
//                   water_level = (max_water_level * 60 - count) / 20;
                water_level = max_water_level - water_count;
                water_in_end_sign = water_sign_mode;
            end
            else if (water_out_start) begin
//                   water_level = count / 20;
                water_level = water_count;
                water_out_end_sign = water_sign_mode;
            end
        end
            if(init_flag) begin
                if(water_in_start) water_level = 0;
                else if(water_out_start) water_level = max_water_level;
                init_flag = 0;// initial off
            end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
        end else begin
            init_flag <= 1;;
        end
    end
endmodule
