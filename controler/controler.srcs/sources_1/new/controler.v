`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 11:14:23
// Design Name: 
// Module Name: controler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controler(
    input power, input start_pause, input weight_ch, input mode_ch, input clk,
    output reg [2:0]state, output reg [2:0]nextstate,
    //light
    output reg [2:0]w_r_d,
    output reg start_pause_light,output reg [2:0]weight_ch_light,
    output reg water_in_light, output reg washing_light, output reg rinsing_light,
    output reg dewatering_light, output reg water_out_light, output reg buzzer_lamp,
    output reg [2:0]water_level
    );
//    reg [1:0]weight_result;
//    reg [2:0]w_r_d;
    reg washing_machine_running, power_control;
    reg [2:0]water_level_current;
    reg [2:0]w_r_d_start, w_r_d_control, w_r_d_end;
    reg sound; //washing machine can speak
    reg auto_shut_flag, washing_machine_running;
//    reg washing_light_controller, rinsing_light_controller, dewatering_light_controller;
//    reg[1:0] state, nextstate;
    parameter mode_ch_state = 0, wash_state = 1, rinse_state = 2, dewatering_state = 3, w_r_d_end_state = 4;
    integer count;
    // choose weight don't care system run or pause
    weight_ch_mode WEIGHT_CH_MODE (.switch_power(power & power_control),
                                  .clk(clk),
                                  .sig_change(weight_ch),
                                  .switch_en(start_pause),
                                  .weight(weight_ch_light)
    );//link start to control running
    
    wash_mode WASH_MODE (.power(power & power_control),
                         .pause(start_pause),
                         .weight(weight_ch_light),
                         .clk(clk),
                         .wash_start(w_r_d_start[2]),
                         .water_in_light(water_in_light),
                         .washing_light(washing_light),
                         .wash_end_sign(w_r_d_end[2]),
                         .water_level(water_level)
     );
     
    rinse_mode RINSE_MODE (.power(power & power_control),
                           .pause(start_pause),
                           .clk(clk),
                           .weight(weight),
                           .rinse_start(w_r_d_start[1]),
                           .rinsing_light(rinsing_light),
                           .rinse_end_sign(w_r_d_end[1]),
                           .water_in_light(water_in_light),
                           .water_out_light(water_out_light),
                           .dewatering_light(dewatering_light),
                           .water_level(water_level)
    );
    
    dewater_mode DEWATER_MODE (.power(power & power_control),
                               .pause(start_pause),
                               .clk(clk),
                               .water_level_current(water_level_current),
                               .dewater_start(w_r_d_start[0]),
                               .dewater_light(dewater_light),
                               .dewater_end_sign(w_r_d_end[0]),
                               .water_out_light(water_out_light),
                               .dewatering_light(dewatering_light),
                               .water_level(water_level)
    );
    
    initial begin
        state = mode_ch_state;
        nextstate = mode_ch_state;
        start_pause_light = 0;  //light is off
        w_r_d = 7;
        power_control = 1;
        washing_machine_running = 1;
        washing_light = 1;
        rinsing_light = 1;
        dewatering_light = 1;
        buzzer_lamp = 0;
    end
    
    //buzzer_lamp
    always @(start_pause or weight_ch or mode_ch)
    if(power & power_control)
        buzzer_lamp = ~buzzer_lamp;
    
    always @(posedge power)
    begin
        if(power)
            power_control = 1;
    end
    
    // FIXED ME: posedge detective can't be mixed up with level detective.
    always @(posedge power or posedge clk)
    if(power & power_control) begin
        if(start_pause_light) begin
            state = nextstate; //in mode_ch_state
        end
    end
    else begin 
        nextstate = mode_ch_state;
        washing_machine_running = 1;
        start_pause_light = 0;  //light is off
        w_r_d = 7;
    end
    
    //add a variable to control machine
    always @(posedge mode_ch)
    if(power & power_control & !start_pause_light)
    begin
        washing_machine_running = 1;
        if(w_r_d == 7) begin w_r_d = 4; washing_light = 1; rinsing_light = 0; dewatering_light = 0; end
        else if(w_r_d == 4) begin w_r_d = 6; washing_light = 1; rinsing_light = 1; dewatering_light = 0; end
        else if(w_r_d == 6) begin w_r_d = 2; washing_light = 0; rinsing_light = 1; dewatering_light = 0; end
        else if(w_r_d == 2) begin w_r_d = 3; washing_light = 0; rinsing_light = 1; dewatering_light = 1; end
        else if(w_r_d == 3) begin w_r_d = 1; washing_light = 0; rinsing_light = 0; dewatering_light = 1; end
        else if(w_r_d == 1) begin w_r_d = 7; washing_light = 1; rinsing_light = 1; dewatering_light = 1; end
    end
    
    //count ten seconds
    always @(posedge clk)
    begin
    if(power & power_control) begin
        if(!washing_machine_running) count = count + 1;
        if(count == 10) power_control = 0;
    end
    end
    
    //add a block to control  start_pause_light
    always @(posedge start_pause) begin
        start_pause_light = ~start_pause_light;
    end
    
    always @(posedge weight_ch)
    if(power & power_control)
    begin
        if(weight_ch_light == 2) weight_ch_light = 3;
        if(weight_ch_light == 3) weight_ch_light = 4;
        if(weight_ch_light == 4) weight_ch_light = 5;
        if(weight_ch_light == 5) weight_ch_light = 2;
    end
    
    
    always @(state or start_pause_light)     //moore
    if(start_pause_light) begin
        case(state)
            mode_ch_state: begin w_r_d_start = 0; w_r_d_end = 0; end
            wash_state:   w_r_d_start = 4;
            rinse_state:  w_r_d_start = 2;
           dewatering_state:  begin w_r_d_start = 1; water_level_current = water_level; end
           w_r_d_end_state: begin w_r_d = 7; washing_machine_running = 0; 
                                  start_pause_light = 0;washing_light = 1;
                                  rinsing_light = 1; dewatering_light = 1;
                                  end
        endcase
    end
    
    always @(w_r_d_end or w_r_d)
        case(state)
            mode_ch_state:
                if(w_r_d[2]) begin    //w_r_d contains wash
                    nextstate = wash_state;
                end
                else if(!w_r_d[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d == 1) begin
                    nextstate = dewatering_state;
                end
                else nextstate = w_r_d_end_state;
            wash_state:
                if(w_r_d_end[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d_end[2] & !w_r_d[1] & w_r_d[0]) begin
                    nextstate = dewatering_state;
                end
                else if(w_r_d_end[2] & (w_r_d == 4)) nextstate = w_r_d_end_state;
                else nextstate = wash_state;
            rinse_state:
                if(w_r_d_end[1] & w_r_d[0]) begin
                    nextstate = dewatering_state;
                end
                else if(w_r_d_end[1] & !w_r_d[0]) nextstate = w_r_d_end_state;
                else nextstate = rinse_state;
            dewatering_state:
                if(w_r_d_end[0]) nextstate = w_r_d_end_state;
                else nextstate = dewatering_state;
            w_r_d_end_state: if(washing_machine_running) nextstate = mode_ch_state;
        endcase     
endmodule
