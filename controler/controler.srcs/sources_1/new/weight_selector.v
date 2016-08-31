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
    input reset_power,
    input switch_en,
    input clk_src,
    input sig_change, 
    output reg [2:0] weight
);

    always @(posedge sig_change) 
    begin
    if(power)
        if(wash_control)
            if(reset) wash_end = 0;
            else state = nextstate;
        else wash_end = 0;
    else begin
        wash_end = 0;
        nextstate = wait_state;
    end
    end
    
endmodule
