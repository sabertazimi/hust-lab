`timescale 1ns / 1ps

// @input
// clk_src: input event detective
// switch_power: power on/off state switch
// switch_en: start/pause state switch
// sig_change: plus signal for sel_value
// @output
// sel_value
module selector_mode
#(parameter LO = 2, HI = 5, CLK_CH = 25)
(
    input [31:0]clk,
    input switch_power,
    input switch_en,
    input sig_change,
    input [1:0]washing_machine_running,
    output reg push,
    output reg [2:0] sel_value
);

    reg init_flag;
    wire real_clk;

    initial begin
        init_flag <= 1;
        sel_value <= LO;
        push <= 1'b0;
    end

    // change signal change to level change(with clk[CLK_CH] Hz)
    always @(posedge clk[CLK_CH]) begin
        if (switch_power) begin
            // pause
            if (!switch_en) begin   
                // washing finished
                if(washing_machine_running[1]) begin
                    push = 1'b1;
                    sel_value = LO;
                // true pause
                end else begin
                    if(init_flag) begin
                        sel_value = LO;
                        init_flag = 0;
                        push = 1'b0;
                    end
                    // start to change value
                    if (sig_change) begin
                        sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO;
                        push = 1'b1;
                    // otherwise, keep current state
                    end else begin
                        sel_value = sel_value;
                        push = push;
                    end
                end
            // washing running
            end else begin
                push = 1'b0;
                sel_value = sel_value;
            end
        // power off
        end else begin
            init_flag = 1;
            sel_value = LO;
            push = 1'b0;
        end
    end
    
endmodule