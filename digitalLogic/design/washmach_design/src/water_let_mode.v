`timescale 1ns / 1ps

// @module
// control water in/out
// @input
// power: electric power
// start: pause switch
// clk: clock srouce group
// water_in_start: signal for starting watering in
// water_out_start: signal for starting watering out
// max_water_level: maxinum of water level(CONSTANT)
// @output
// water_in_end_sign: mark for watering in finished
// water_out_end_sign: mark for watering out finished
// water_level: display current water level
module water_let_mode
#(parameter WIDTH = 32, CLK_CH = 25, TIME_SCORE = 2)
(
    input power,
    input start,
    input [31:0]clk,
    input water_in_start,
    input water_out_start,
    input [2:0]max_water_level,
    output reg water_in_end_sign,
    output reg water_out_end_sign,
    output reg [2:0]water_level
);

    reg init_flag;
    wire [(WIDTH-1):0]water_count;
    wire water_sign_mode;
    
    initial begin
        init_flag <= 1;
        water_in_end_sign = 1'b0; 
        water_out_end_sign = 1'b0; 
        water_level = {3{1'b0}};
    end
    
    // water in/out timer
    timer #(WIDTH, CLK_CH, TIME_SCORE) WATER_IN_TIMER (
        .clk_src(clk),
        .switch_power(power),
        .switch_en(start),
        .sum_count({{29{1'b0}}, max_water_level}),
        .count_start_flag(water_in_start | water_out_start),
        .count_end_flag(water_sign_mode),
        .count(water_count)
    );

    always @(posedge clk[0]) begin
        if (power & (water_in_start | water_out_start)) begin
            // when first enter this module , start ot initiate
            if(init_flag) begin
                if (water_in_start) begin
                    water_level = {3{1'b0}};
                end else if (water_out_start) begin
                    water_level = max_water_level;
                    init_flag = 0;
                end
            end
            
            if (start) begin
                if (water_in_start) begin
                    water_level = max_water_level - water_count[0] - water_count[1] * 2 - water_count[2] * 4;
                    // bind end flag of this module to end flag of timer
                    water_in_end_sign = water_sign_mode;
                end else if (water_out_start) begin
                    water_level = water_count[0] + water_count[1] * 2 + water_count[2] * 4;
                    // bind end flag of this module to end flag of timer
                    water_out_end_sign = water_sign_mode;
                end
            end
        end else begin
            // when leave this module, reset init_flag to 1
            // making next time enter this module, all var of this module can be initiate
            init_flag <= 1;
            water_in_end_sign = 1'b0;
            water_out_end_sign = 1'b0;
            water_level = {3{1'b0}};
        end
    end
endmodule
