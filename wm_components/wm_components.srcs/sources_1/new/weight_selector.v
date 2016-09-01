`timescale 1ns / 1ps

// input
// reset_power: power
// switch_en: start/pause
// clk_src: clock source
// sig_ch: button for selecting weight
// output
// weight: weight of clothes
module weight_selector
(
    input clk_src,
    input switch_power,
    input switch_en,
    input sig_change,
    output reg [2:0] weight
);

    reg init_flag;

    initial begin
        init_flag <= 1;
        weight <= 2;
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
                    weight <= 2;
                    init_flag <= 0;
                end else if (sig_change) begin
                    weight = (weight + 1) % 6 ? (weight + 1) % 6 : 2;
                end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
            end
        end else begin
            init_flag <= 1;
            weight <= 0;
        end
    end
    
endmodule
