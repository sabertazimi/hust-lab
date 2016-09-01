`timescale 1ns / 1ps

module wash_mode(
    input wash_start, input pause, input power, input clk, //input wash_control,
    input weight_ch,
    output reg wash_end_sign, 
    //light
    output reg water_in_light, output reg washing_light
    );
    // FIX ME: there's 3 state, but state and nextState only can hold 1 bit.
    reg state, nextstate;
    reg water_in_end;
    parameter water_in = 0, washing = 1, wash_end = 2;
    
    initial begin
        state = water_in;
        nextstate = water_in;
    end
    
    // water_in WATER_IN (.water_in_end(water_in_end),
    //                    .water_in_start(water_in_light),
    //                   )
    // timer TIMER (.(washing_light))
    
    // FIX ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge wash_start or posedge power or posedge clk)
    begin
    if(power)
        if(wash_start) state = nextstate; //wash_start means that wash_mode can run
        else wash_end_sign = 0;
    else begin
        wash_end_sign = 0;
        nextstate = water_in;
    end
    end
    
    always @(state or pause)
    if(wash_start & ) begin
        case(state)
            water_in: water_in_light = 1;   //use light to replace start
            washing: begin water_in_light  = 0; washing_light = 1; end
            wash_end: begin washing_light = 0; wash_end_sign = 1; end
        endcase
    end
    
    always @()
endmodule
