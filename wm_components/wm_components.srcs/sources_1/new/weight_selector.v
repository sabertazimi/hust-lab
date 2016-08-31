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
    input switch_power,
    input switch_en,
    input sig_change, 
    output reg [2:0] weight
);

    parameter DELAY = 10;

    // for implementing reset feature on electrify
    reg sig_init;

    initial begin
        sig_init <= 0;
        weight <= 0;
    end

    always @(posedge switch_power) begin
        sig_init <= 1;
        #(2*DELAY) sig_init <= 0;
    end

    always @(posedge switch_power or posedge sig_change) begin
        #DELAY
        if (sig_init == 1) begin
            weight = 2;
        end
        if (switch_power && switch_en && sig_change) begin
            weight = (weight + 1) % 6 ? (weight + 1) % 6 : 2;
            
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
        end
    end
    
endmodule
