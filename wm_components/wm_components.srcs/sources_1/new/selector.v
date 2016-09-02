`timescale 1ns / 1ps

// @input
// clk_src: input event detective
// switch_power: power on/off state switch
// switch_en: start/pause state switch
// sig_change: plus signal for sel_value
// @output
// sel_value
module selector
#(parameter LO = 2, HI = 5)
(
    input clk_src,
    input switch_power,
    input switch_en,
    input sig_change,
    output reg [2:0] sel_value
);

    reg init_flag;

    initial begin
        init_flag <= 1;
        sel_value <= LO;
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
                    sel_value <= LO;
                    init_flag <= 0;
                end else if (sig_change) begin
                    sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO;
                end
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
            end
        end else begin
            init_flag <= 1;
            sel_value <= 0;
        end
    end
    
endmodule
