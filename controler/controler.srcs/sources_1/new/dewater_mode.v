`timescale 1ns / 1ps

module dewater_mode
#(parameter WIDTH = 32, CLK_CH = 25)
(
    input dewater_start, input start, input power, input [31:0]clk,
    input [2:0]weight,
    output reg dewater_end_sign, 
    //light
    output reg dewatering_light,output reg water_out_light,
    output [2:0]water_level, output reg [31:0]dewater_count,
    output reg [1:0]state
    );
    reg [1:0]nextstate;
    wire [31:0]dewatering_count;
    wire real_clk;
    wire water_out_end_sign, water_in_end_sign, dewatering_end_sign;
    reg  water_out_start, dewatering_start;
    parameter water_out_state = 0, dewatering_state = 1, dewater_end_state = 2;
    
    initial begin
        state = water_out_state;
        nextstate = water_out_state;
        water_out_light = 1'b0;
        dewatering_light = 1'b1;
        water_out_start = 1'b0;
        dewatering_start = 1'b0;
        dewater_count = {32{1'b0}};
        dewater_end_sign = 1'b0;
    end
    
     water_let_mode #(WIDTH, CLK_CH) WATER_OUT_MODE (.water_out_end_sign(water_out_end_sign),
                                    .water_in_end_sign(water_in_end_sign),
                                    .water_out_start(water_out_start),
                                    .water_in_start(1'b0),
                                    .clk(clk),
                                    .power(power),
                                    .max_water_level(weight),
                                    .start(start),
                                    .water_level(water_level)
     );
     timer #(WIDTH, CLK_CH) TIMER_WASH (.clk_src(clk),
                       .switch_power(power),
                       .switch_en(start),
                       .sum_count({{29{1'b0}},weight}),
                       .count_start_flag(dewatering_start),
                       .count_end_flag(dewatering_end_sign),
                       .count(dewatering_count)
     );
    // FIXED ME: edge detective(posedge) can't be mix up with level detective(power).
    always @(posedge clk[0])
    begin
    if(power & dewater_start & start) state <= nextstate;
    else if(!(power & dewater_start)) begin
        state <= water_out_state;
    end
    end
    
    //spangle light
//    assign real_clk = (dewater_start & power) ? clk[CLK_CH] : clk[0];
    always @(posedge clk[CLK_CH])
    if(dewater_start & power)
    begin
        case(state)
            water_out_state: begin water_out_light = ~water_out_light; dewatering_light = 1'b1; end
            dewatering_state: begin water_out_light = 1'b0; dewatering_light = ~dewatering_light; end
            dewater_end_state: begin dewatering_light = 1'b0; end
        endcase
    end
    else begin
        water_out_light = 1'b0; dewatering_light = 1'b1;
    end
    
    //count time
    always @(posedge clk[0])
    begin
    if(dewater_start & power) begin
        case(state)
            water_out_state: begin dewater_count = {{29{1'b0}},weight} + {{29{1'b0}},water_level}; dewater_end_sign = 1'b0; end
            dewatering_state: dewater_count = dewatering_count;
            dewater_end_state: begin dewater_count = 0; dewater_end_sign = 1'b1; end
        endcase
    end else begin
        dewater_count = 0; dewater_end_sign = 1'b0;
    end
    end
    
    always @(state or power or dewater_start or start)
    if(dewater_start & power & start) begin
        case(state)
            water_out_state: begin water_out_start = 1'b1; dewatering_start = 1'b0; end
            dewatering_state: begin water_out_start = 1'b0; dewatering_start = 1'b1; end
            dewater_end_state: begin  dewatering_start = 1'b0; water_out_start = 1'b0; end
        endcase
    end
    else if(!(dewater_start & power)) begin
        water_out_start = 1'b0; dewatering_start = 1'b0; 
    end
    
    always @(water_out_end_sign or dewatering_end_sign or dewater_start or power)
    if(power & dewater_start)
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
                nextstate = dewater_end_state;
        endcase
    end else begin
        nextstate = water_out_state;
    end
endmodule
