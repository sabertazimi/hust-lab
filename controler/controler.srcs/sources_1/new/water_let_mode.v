`timescale 1ns / 1ps

module water_let_mode
#(parameter WIDTH = 32)
(
    input power, input start, input [31:0]clk,
    input water_in_start, input water_out_start, input [2:0]max_water_level,
    output reg water_in_end_sign, output reg water_out_end_sign, output reg [2:0]water_level
);
    reg init_flag;
    wire [(WIDTH-1):0]water_in_count, water_out_count;
    wire water_in_end_sign_mode, water_out_end_sign_mode;
    initial begin
        init_flag <= 1;
    end
    
    timer WATER_IN_TIMER (.clk_src(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count({29'b00000000000000000000000000000, max_water_level}),
                 .count_start_flag(water_in_start),
                 .count_end_flag(water_in_end_sign_mode),
                 .count(water_in_count)
    );
    timer WATER_OUT_TIMER (.clk_src(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count(2),
                 .count_start_flag(water_out_start),
                 .count_end_flag(water_out_end_sign_mode),
                 .count(water_out_count)
    );

    always @(posedge clk[0]) begin
        if (power & (water_in_start | water_out_start)) begin
            if(init_flag) begin
                if(water_in_start) water_level = 0;
                else if(water_out_start) water_level = max_water_level;
                init_flag = 0;// initial off
            end
            if (start) begin
                if (water_in_start) begin
//                   water_level = (max_water_level * 60 - count) / 20;
                    water_level = max_water_level - water_in_count;
                    water_in_end_sign = water_in_end_sign_mode;
                end
                else if (water_out_start) begin
//                   water_level = count / 20;
                    water_level = water_out_count;
                    water_out_end_sign = water_out_end_sign_mode;
                end
            end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
        end else begin
            init_flag <= 1;;
        end
    end
endmodule
