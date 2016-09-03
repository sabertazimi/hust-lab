`timescale 1ns / 1ps

module dewater_mode(
    input rinse_start, input pause, input power, input clk,
    input weight,
    output reg rinse_end_sign, 
    //light
    output reg water_in_light, output reg rinsing_light,output reg water_out_light,
    output reg [2:0]water_level, output reg dewatering_light
    );
endmodule
