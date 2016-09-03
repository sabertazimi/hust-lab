`timescale 1ns / 1ps

module water_let_mode
#(parameter WIDTH = 32)
(
    input power, input start, input clk,
    input water_in_start, input water_out_start, input max_water_level,
    output reg water_in_end_sign, output reg water_out_end_sign, output reg [2:0]water_level,
    output reg [(WIDTH-1):0]water_count
);
    reg init_flag;
    reg [(WIDTH-1):0]water_in_count, water_out_count;
//    initial begin
//        init_flag <= 1;
//        water_in_end_sign <= 0;
//        water_out_end_sign <= 0;
//    end
    
    timer #(32) WATER_IN_TIMER (.clk(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count(max_water_level),
                 .count_start_flag(water_in_start),
                 .count_end_flag(water_in_end_sign),
                 .count(water_in_count)
    );
    timer #(32) WATER_OUT_TIMER (.clk(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count(max_water_level),
                 .count_start_flag(water_out_start),
                 .count_end_flag(water_out_end_sign),
                 .count(water_out_count)
    );
    
//    wire [31:0] clk;
    
//    tick_divider DIVIDER (
//        .clk_src(clk_src),
//        .clk_group(clk)
//    );

    always @(posedge clk) begin
        if (power) begin
//            if(init_flag) begin
//                if(water_in_start) water_level = 0;
//                else if(water_out_start) water_level = max_water_level * 3;
//                init_flag = 0;// initial off
//            end
            
            count = water_in_count + water_out_count;
            if (start) begin
                if (water_in_start) begin
//                   water_level = (max_water_level * 60 - count) / 20;
                    water_level = max_water_level - water_in_count;
                end
                else if (water_out_start) begin
//                   water_level = count / 20;
                    water_level = water_out_count;                                               
                end
            end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
        end //else begin
//            init_flag <= 1;
//            water_in_end_sign <= 0;
//            water_out_end_sign <= 0;
//        end
    end
endmodule
