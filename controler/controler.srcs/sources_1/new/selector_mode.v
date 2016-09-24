`timescale 1ns / 1ps

// @input
// clk_src: input event detective
// switch_power: power on/off state switch
// switch_en: start/pause state switch
// sig_change: plus signal for sel_value
// @output
// sel_value
module selector_mode
#(parameter LO = 2, HI = 5)
(
    input [31:0]clk,
    input switch_power,
    input switch_en,
    input sig_change,
    output reg push,
    output reg [2:0] sel_value
);

    reg init_flag;
    wire real_clk;

    initial begin
        init_flag <= 1;
        sel_value <= 0;
        push <= 0;
    end

    assign real_clk = (switch_power & !init_flag) ? sig_change : clk[0];
    always @(posedge real_clk) begin
        if (switch_power) begin
            if(init_flag) begin sel_value <= LO; push <= 0; end
            if (!switch_en) begin
                if (init_flag) begin
                    init_flag <= 0;
                end
                else begin
                    sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO;
                    push = 1;
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