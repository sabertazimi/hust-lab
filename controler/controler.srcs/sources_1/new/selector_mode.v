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

    assign real_clk = (switch_power & !switch_en & !washing_machine_running[1]) ? sig_change : clk[0];
    always @(posedge real_clk) begin
        if (switch_power && !switch_en) begin
            if(washing_machine_running[0]) begin push = 1'b1;sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO; end
            else if(washing_machine_running[1]) begin push = 1'b1; sel_value = LO; end
            else begin 
                if(init_flag) begin sel_value = LO; init_flag = 0; push = 1'b0; end
                sel_value = (sel_value + 1) % (HI+1) ? (sel_value + 1) % (HI+1) : LO; push = 1'b0;
            end
        end else if(switch_power && switch_en) begin
            push = 1'b0; sel_value = sel_value;
        end else if(!switch_power) begin
            init_flag = 1;
            sel_value = LO;
            push = 1'b0;
        end
    end
    
endmodule