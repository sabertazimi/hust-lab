`timescale 1ns / 1ps

module wash_mode
//#(parameter WIDTH = 32)
(
    input wash_start, input pause, input power, input [31:0]clk, //input wash_control,
    input weight,
    output reg wash_end_sign, 
    //light
    output reg water_in_light, output reg washing_light,
    output reg [2:0]water_level, output reg [31:0]wash_count
    );
    // FIXED ME: there's 3 state, but state and nextState only can hold 1 bit.
    reg [1:0]state, nextstate;
    reg [31:0]washing_count;
    reg water_in_end_sign, water_in_start, washing_start, water_out_end_sign;
    parameter water_in_state = 0, washing_state = 1, wash_end_state = 2;
    
    initial begin
        state = water_in_state;
        nextstate = water_in_state;
//        water_in_end_sign = 0;
//        spangle_start = 0;
        water_in_light = 0;
        washing_light = 1;
        wash_count = 0;
    end
    
     water_let_mode WATER_IN_MODE (.water_in_end_sign(water_in_end_sign),
                                  .water_in_start(water_in_start),
                                  .water_out_start(0),
                                  .water_out_end_sign(water_out_end_sign),
                                  .clk(clk),
                                  .power(power),
                                  .max_water_level(weight),
                                  .pause(pause),
                                  .water_level(water_level)
     );
     
     timer TIMER_WASH (.clk_src(clk),
                       .switch_power(power),
                       .switch_en(pause),
                       .sum_count(weight * 3),
                       .count_start_flag(washing_start),
                       .count_end_flag(wash_end_sign),
                       .count(washing_count)
     );
    
    // FIXED ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge power or posedge clk[0])
    begin
    if(power & wash_start) state = nextstate;
    else begin
        wash_end_sign = 0;
        nextstate = water_in_state;
        wash_count = 0;
    end
    end
    
    //spangle light
    always @(posedge clk[24])
    if(wash_start & power)
    begin
        case(state)
            water_in_state: water_in_light = ~water_in_light;
            washing_state: begin water_in_light = 0; washing_light = ~washing_light; end
            wash_end_state: begin washing_light = 0; end
        endcase
    end
    
    //count time
    always @(posedge clk[0])
    begin
    if(wash_start & power) begin
        case(state)
            water_in_state: wash_count = weight * 4 - water_level;
            washing_state: wash_count = washing_count;
            wash_end_state: wash_count = 0;
        endcase
    end
    end
    
    always @(state or pause)
    if(wash_start & !pause) begin
        case(state)
            water_in_state: begin wash_end_sign = 0; water_in_start = 1; end
            washing_state: begin water_in_start = 0; washing_start = 1; end
            wash_end_state: begin  washing_start = 0; wash_end_sign = 1; end
        endcase
    end
    
    always @(water_in_end_sign or wash_end_sign or wash_start)
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
