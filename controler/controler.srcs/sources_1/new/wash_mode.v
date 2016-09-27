`timescale 1ns / 1ps

module wash_mode
#(parameter WIDTH = 32, CLK_CH = 25, TIME_SCORE = 2)
(
    input wash_start, input start, input power, input [31:0]clk, //input wash_control,
    input [2:0]weight,
    output reg wash_end_sign, 
    //light
    output reg water_in_light, output reg washing_light,
    output [2:0]water_level, output reg [31:0]wash_count
    );
    
    reg [1:0]state, nextstate;
    reg water_in_start, washing_start; // control sbumodules' running
    wire [31:0]washing_count; // mode time
    wire [2:0]water_level_wash; // mode water level 
    wire real_clk; // asynchronous change to synchronization
    wire water_in_end_sign, water_out_end_sign, wash_end_sign_mode; // end sign return to controller
    parameter water_in_state = 0, washing_state = 1, wash_end_state = 2;
    
    initial begin
        state = water_in_state;
        nextstate = water_in_state;
        wash_end_sign = 1'b0;
        water_in_light = 1'b0;
        washing_light = 1'b1; // light on when module start
        wash_count = {32{1'b0}};
        water_in_start = 1'b0;
        washing_start = 1'b0;
        
    end
    
    assign water_level = (state == 3'b000) ? water_level_wash : weight;
    
     // water_let mode run when start sign nd power are both true
     water_let_mode #(WIDTH, CLK_CH, TIME_SCORE) WATER_IN_MODE (.water_in_end_sign(water_in_end_sign),
                                  .water_in_start(water_in_start), // control module start
                                  .water_out_start(1'b0), // module only contains water in
                                  .water_out_end_sign(water_out_end_sign),
                                  .clk(clk),
                                  .power(power),
                                  .max_water_level(weight),
                                  .start(start),
                                  .water_level(water_level_wash)
     );
     
     // count wash time
     timer #(WIDTH, CLK_CH, TIME_SCORE) TIMER_WASH (.clk_src(clk),
                       .switch_power(power),
                       .switch_en(start),
                       .sum_count({{29{1'b0}}, weight} * 3),
                       .count_start_flag(washing_start),
                       .count_end_flag(wash_end_sign_mode),
                       .count(washing_count)
     );
    
    //change state
    always @(posedge clk[0])
    begin
    if(wash_start & power & start) state = nextstate;
    else if(!(wash_start & power)) begin
        state = water_in_state;
    end
    end
    
    // control light
    always @(posedge clk[CLK_CH])
    if(wash_start & power)
    begin
        case(state)
            water_in_state: begin water_in_light = ~water_in_light; washing_light = 1'b1; end
            washing_state: begin water_in_light = 1'b0; washing_light = ~washing_light; end
            wash_end_state: begin washing_light = 1'b0; end
        endcase
    end
    else begin
        water_in_light = 1'b0; washing_light = 1'b1;
    end
    
    //control time and end sign
    always @(posedge clk[0])
    begin
    if(wash_start & power) begin
        case(state)
            water_in_state: begin wash_count = {{29{1'b0}},weight} * 4 - {{29{1'b0}},water_level}; wash_end_sign = 1'b0; end
            washing_state: begin wash_count = washing_count; end
            wash_end_state: begin wash_count = 0; wash_end_sign = 1'b1; end
        endcase
    end
    else begin
        wash_count = 0; wash_end_sign = 1'b0;
    end
    end
    
    //control submodules' start
    always @(state or power or wash_start or start)
    if(wash_start & power & start) begin
        case(state)
            water_in_state: begin water_in_start = 1'b1; washing_start = 1'b0; end
            washing_state: begin water_in_start = 1'b0; washing_start = 1'b1; end
            wash_end_state: begin  washing_start = 1'b0; water_in_start = 1'b0; end
        endcase
    end
    else if(!(wash_start & power)) begin
        water_in_start = 1'b0; washing_start = 1'b0;
    end
    
    // change nextstate when sign come
    always @(water_in_end_sign or wash_end_sign_mode or wash_start or power)
    if(power & wash_start) begin
        case(state)
            water_in_state: begin
                    if(water_in_end_sign)
                        nextstate = washing_state;
                    else nextstate = water_in_state;
                end
            washing_state: begin
                    if(wash_end_sign_mode)
                        nextstate = wash_end_state;
                    else nextstate = washing_state;
                end
            wash_end_state: begin
                    nextstate = wash_end_state;
                end
        endcase
    end else begin
        nextstate = water_in_state;
    end
endmodule
