`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/02 10:05:14
// Design Name: 
// Module Name: HUD
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

// input
// clk_src: input event detective
// switch_power: power on/off state switch
// switch_en: start/pause state switch
// max_water_level: water line standard
// inwater_flag: flag for water in enable
// outwater_flag: flag for water out enable
// output
// water_level: current water level
module HUD
(
    input clk_src,
    input switch_power,
    input switch_en,
    input max_water_level,
    input inwater_flag,
    input outwater_flag,
    output reg [2:0] water_level
);

    reg init_flag;

    initial begin
        init_flag <= 1;
        water_level <= 0;
    end
    
    wire [31:0] clk;
    
    tick_divider DIVIDER (
        .clk_src(clk_src),
        .clk_group(clk)
    );

    always @(posedge clk[25]) begin
        if (switch_power) begin
            if (switch_en) begin
                if (init_flag) begin
                    water_level <= 0;
                    init_flag <= 0;
                end else if (inwater_flag) begin
                    if (water_level < max_water_level) begin
                        water_level = water_level + 1;
                    end
                end else if (outwater_flag) begin
                    if (water_level > 0) begin
                        water_level = water_level - 1;
                    end
                end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
            end
        end else begin
            init_flag <= 1;
            water_level <= 0;
        end
    end
    
endmodule
