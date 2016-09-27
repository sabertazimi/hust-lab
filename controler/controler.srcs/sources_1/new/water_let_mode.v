`timescale 1ns / 1ps

module water_let_mode
#(parameter WIDTH = 32, CLK_CH = 25, TIME_SCORE = 2)
(
    input power, input start, input [31:0]clk,
    input water_in_start, input water_out_start, input [2:0]max_water_level,
    output reg water_in_end_sign, output reg water_out_end_sign, output reg [2:0]water_level
);
    reg init_flag;
    wire [(WIDTH-1):0]water_count;
    wire water_sign_mode;
//    wire real_clk;
    initial begin
        init_flag <= 1;
        water_in_end_sign = 1'b0; 
        water_out_end_sign = 1'b0; 
        water_level = {3{1'b0}};
    end
    
    timer #(WIDTH, CLK_CH, TIME_SCORE) WATER_IN_TIMER (.clk_src(clk),
                 .switch_power(power),
                 .switch_en(start),
                 .sum_count({{29{1'b0}}, max_water_level}),
                 .count_start_flag(water_in_start | water_out_start),
                 .count_end_flag(water_sign_mode),
                 .count(water_count)
    );

//    assign real_clk = (power & !init_flag & (water_in_start | water_out_start)) ? clk[25] : clk[0];
    always @(posedge clk[0]) begin
        if (power & (water_in_start | water_out_start)) begin
            if(init_flag) begin
                if(water_in_start) water_level = {3{1'b0}};
                else if(water_out_start) water_level = max_water_level;
                init_flag = 0;
            end
            if(start) begin
                if (water_in_start) begin
//                   water_level = (max_water_level * 60 - count) / 20;
                    water_level = max_water_level - water_count[0] - water_count[1] * 2 - water_count[2] * 4;
                    water_in_end_sign = water_sign_mode;
                end
                else if (water_out_start) begin
//                   water_level = count / 20;
                    water_level = water_count[0] + water_count[1] * 2 + water_count[2] * 4;
                    water_out_end_sign = water_sign_mode;
                end
            end

            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
            // DONE
        end else begin
            init_flag <= 1; water_in_end_sign = 1'b0; water_out_end_sign = 1'b0; water_level = {3{1'b0}};
        end
    end
endmodule
