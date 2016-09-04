`timescale 1ns / 1ps

module dewater_mode(
    input dewater_start, input start, input power, input [31:0]clk,
    input weight, 
    output reg dewater_end_sign, 
    //light
    output reg dewatering_light,output reg water_out_light,
    output reg [2:0]water_level, output reg [31:0]dewater_count
    );
    reg [1:0]state, nextstate;
    reg [31:0]dewatering_count;
    reg water_out_end_sign, water_in_end_sign, water_out_start, dewatering_start, dewatering_end_sign;
    parameter water_out_state = 0, dewatering_state = 1, dewater_end_state = 2;
    
    initial begin
        state = water_out_state;
        nextstate = water_out_state;
//        water_in_end_sign = 0;
//        spangle_start = 0;
        water_out_light = 0;
        dewatering_light = 1;
    end
    
     water_let_mode WATER_OUT_MODE (.water_out_end_sign(water_out_end_sign),
                                    .water_in_end_sign(water_in_end_sign),
                                    .water_out_start(water_out_start),
                                    .water_in_start(0),
                                    .clk(clk),
                                    .power(power),
                                    .max_water_level(weight),
                                    .start(start),
                                    .water_level(water_level)
     );
     timer TIMER_WASH (.clk_src(clk),
                       .switch_power(power),
                       .switch_en(start),
                       .sum_count(weight),
                       .count_start_flag(dewatering_start),
                       .count_end_flag(dewatering_end_sign),
                       .count(dewatering_count)
     );
    // FIXED ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge power or posedge clk[0])
    begin
    if(power) state = nextstate;
    else begin
        dewater_end_sign = 0;
        nextstate = water_out_state;
    end
    end
    
    //spangle light
    always @(posedge clk[25])
    if(dewater_start & power)
    begin
        case(state)
            water_out_state: water_out_light = ~water_out_light;
            dewatering_state: begin water_out_light = 0; dewatering_light = ~dewatering_light; end
            dewater_end_state: begin dewatering_light = 0; end
        endcase
    end
    
    //count time
    always @(posedge clk[0])
    begin
    if(dewater_start & power) begin
        case(state)
            water_out_state: dewater_count = weight + water_level;
            dewatering_state: dewater_count = dewatering_count;
            dewater_end_state: dewater_count = 0;
        endcase
    end
    end
    
    always @(state or start)
    if(dewater_start & start) begin
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
