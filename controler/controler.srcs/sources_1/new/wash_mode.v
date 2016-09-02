`timescale 1ns / 1ps

module wash_mode(
    input wash_start, input pause, input power, input clk, //input wash_control,
    input weight,
    output reg wash_end_sign, 
    //light
    output reg water_in_light, output reg washing_light
    );
    // FIXED ME: there's 3 state, but state and nextState only can hold 1 bit.
    reg [1:0]state, nextstate;
    reg water_in_end_sign;
    parameter water_in_state = 0, washing_state = 1, wash_end_state = 2;
    
    initial begin
        state = water_in_state;
        nextstate = water_in_state;
        water_in_end_sign = 0;
    end
    
     water_in_made WATER_IN_MODE (.water_in_end_sign(water_in_end_sign),
                                  .water_in_start(water_in_light),
                                  .clk(clk),
                                  .power(power),
                                  .weight(weight)
                       );
//     timer TIMER (.(washing_light))
    
    // FIXED ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge power or posedge clk)
    begin
    if(power) state = nextstate; //wash_start means that wash_mode can run
    else begin
        wash_end_sign = 0;
        nextstate = water_in_state;
    end
    end
    
    always @(state or pause)
    if(wash_start & !pause) begin
        case(state)
            water_in_state: water_in_light = 1;   //use light to replace start
            washing_state: begin water_in_light  = 0; washing_light = 1; end
            wash_end_state: begin washing_light = 0; wash_end_sign = 1; end
        endcase
    end
    
    always @(water_in_light or washing_light or water_in_end_sign or wash_end_sign)
    begin
        case(state)
            water_in_state:
                if(water_in_end_sign)
                    nextstate = washing_state;
                else nextstate = water_in_state;
            washing_state:
                if(wash_end_sign)
                    nextstate = wash_end_state;
                else nextstate = washing_state;
            wash_end_state:
                if(!wash_start) nextstate = water_in_state;
                else nextstate = wash_end_state;
        endcase
    end
endmodule
