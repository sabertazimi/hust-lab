`timescale 1ns / 1ps

module dewater_mode(
    input dewater_start, input pause, input power, input clk,
    input water_level_current, 
    output reg dewater_end_sign, 
    //light
    output reg dewatering_light,output reg water_out_light,
    output reg [2:0]water_level
    );
    reg [1:0]state, nextstate;
    reg water_out_end_sign, water_out_start, dewatering_start, dewatering_end_sign;
    parameter water_out_state = 0, dewatering_state = 1, dewater_end_state = 2;
    
    initial begin
        state = water_out_state;
        nextstate = water_out_state;
//        water_in_end_sign = 0;
//        spangle_start = 0;
        water_out_light = 0;
        dewatering_light = 1;
    end
    
     water_out_mode WATER_OUT_MODE (.water_out_end_sign(water_out_end_sign),
                                  .water_out_start(water_out_start),
                                  .clk(clk),
                                  .power(power),
                                  .water_level_current(water_level_current),
                                  .pause(pause),
                                  .water_level(water_level)
                       );
//     timer TIME_WASH (.(washing_light))
//     timer TIME_SPANGLE (.clk(clk),
//                         .start(spangle_start),
//                         .(washing_light));
    
    // FIXED ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge power or posedge clk)
    begin
    if(power) state = nextstate;
    else begin
        dewater_end_sign = 0;
        nextstate = water_out_state;
    end
    end
    
    //spangle light
    always @(posedge clk)
    if(dewater_start & power)
    begin
        case(state)
            water_out_state: water_out_light = ~water_out_light;
            dewatering_state: begin water_out_light = 0; dewatering_light = ~dewatering_light; end
            dewater_end_state: begin dewatering_light = 0; end
        endcase
    end
    
    always @(state or pause)
    if(dewater_start & !pause) begin
        case(state)
            water_out_state: begin dewater_end_sign = 0; water_out_start = 1; end
            dewatering_state: begin water_out_start = 0; dewatering_start = 1; end
            dewater_end_state: begin  dewatering_start = 0; dewater_end_sign = 1; end
        endcase
    end
    
    always @(water_out_end_sign or dewater_end_sign or dewater_start)
    begin
        case(state)
            water_out_state:
                if(water_out_end_sign)
                    nextstate = dewatering_state;
                else nextstate = water_out_state;
            dewatering_state:
                if(dewatering_end_sign)
                    nextstate = dewater_end_state;
                else nextstate = dewatering_state;
            dewater_end_state:
                if(!dewater_start) nextstate = water_out_state;
                else nextstate = dewater_end_state;
        endcase
    end  
endmodule
