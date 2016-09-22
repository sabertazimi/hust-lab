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
//    input clk,
    input switch_power,
    input switch_en,
    input sig_change,
//    output reg washing_machine_running,
    output reg [2:0] sel_value
);

    reg init_flag;

    initial begin
        init_flag <= 1;
        sel_value <= LO;
    end

    always @(posedge sig_change) begin
        if (switch_power) begin
            if (!switch_en) begin
                if (init_flag) begin
                    sel_value <= LO;
                    init_flag <= 0;
                end
                sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO;
            // TODO: button-down signal led
            // btn_sig_led(bool sig_flicker, output btn_l   ed)
            end
        end else begin
            init_flag <= 1;
            sel_value <= LO;
        end
    end
    
endmodule