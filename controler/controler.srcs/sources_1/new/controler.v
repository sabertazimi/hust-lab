`timescale 1ns / 1ps


module controler(
    input power, input start_pause, input weight_ch, input mode_ch, input clk_src,
//    output reg [2:0]state, output reg [2:0]nextstate,
    //light
//    output reg [2:0]w_r_d,
    output reg start_pause_light,output [2:0]weight_ch_light,
    output water_in_light, output washing_light, output rinsing_light,
    output reg dewatering_light, output water_out_light, output reg buzzer_lamp,
    output [7:0]anodes, output [7:0]cnodes
    );
    
    reg [2:0]state, nextstate;
    reg [2:0]water_level;
    reg washing_machine_running, power_control;
    wire [1:0]washing_state, dewatering_state;
    wire [2:0]rinsing_state;
    wire water_in_light_wash, water_in_light_rinse;
    wire water_out_light_rinse, water_out_light_dewater;
    wire dewatering_light_rinse, dewatering_light_dewater;
    wire washing_light_wash, rinsing_light_rinse;
    reg washing_light_control, rinsing_light_control, dewatering_light_control;
//    reg [2:0]weight_ch_light_selector, weight_ch_light_wash;
    reg [2:0]w_r_d_start, w_r_d;
    wire [2:0]w_r_d_end;
    wire [2:0] w_r_d_change;
//    wire [2:0] w_r_d;
    wire [31:0]clk;
    reg sound; //washing machine can speak
    reg auto_shut_flag, washing_machine_running;
    wire [2:0]wash_water_level, rinse_water_level, dewater_water_level;
    reg [31:0]wash_count, rinse_count, dewater_count;
    reg [31:0]mode_count, sum_count;
//    wire [31:0]anodes_mode, cnodes_mode;
//    reg[1:0] state, nextstate;
    parameter mode_ch_state = 0, wash_state = 1, rinse_state = 2, dewater_state = 3, w_r_d_end_state = 4;
    integer count;
    
    // choose weight don't care system run or pause
    selector_mode  #(0,5) MODE_SEL (
                            .switch_power(power & power_control & washing_machine_running),
                            .switch_en(start_pause_light),
                            .sig_change(mode_ch),
//                            .washing_machine_running(washing_machine_running),
                            .sel_value(w_r_d_change)
    );
    //devider
    tick_divider TICK_DEVIDER (.clk_src(clk_src),
                               .clk_group(clk)
    );
    
    selector_mode WEIGHT_SEL (
                            .switch_power(power & power_control),
                            .switch_en(start_pause_light),
                            .sig_change(weight_ch),
//                            .washing_machine_running(washing_machine_running),
                            .sel_value(weight_ch_light)
    );                
    
    wash_mode WASH_MODE (.power(power & power_control),
                         .start(start_pause_light),
                         .weight(weight_ch_light),
                         .clk(clk),
                         .wash_start(w_r_d_start[2]),
                         .water_in_light(water_in_light_wash),
                         .washing_light(washing_light_wash),
                         .wash_end_sign(w_r_d_end[2]),
                         .water_level(wash_water_level),
                         .washing_light_control(washing_light_control),
                         .state(washing_state)
     );
     
    rinse_mode RINSE_MODE (.power(power & power_control),
                           .start(start_pause_light),
                           .clk(clk),
                           .weight(weight_ch_light),
                           .rinse_start(w_r_d_start[1]),
                           .rinsing_light(rinsing_light_rinse),
                           .rinse_end_sign(w_r_d_end[1]),
                           .water_in_light(water_in_light_rinse),
                           .water_out_light(water_out_light_rinse),
                           .dewatering_light(dewatering_light_rinse),
                           .water_level(rinse_water_level),
                           .rinsing_light_control(rinsing_light_control),
                           .state(rinsing_state)
    );
    
    dewater_mode DEWATER_MODE (.power(power & power_control),
                               .start(start_pause_light),
                               .clk(clk),
                               .weight(weight_ch_light),
                               .dewater_start(w_r_d_start[0]),
                               .dewatering_light(dewatering_light_dewater),
                               .dewater_end_sign(w_r_d_end[0]),
                               .water_out_light(water_out_light_dewater),
                               .water_level(dewater_water_level),
                               .dewatering_light_control(dewatering_light_control),
                               .state(dewatering_state)
    );
    
    //time display
    time_displayer TIME_DISPLAYER (.clk_src(clk[25]),
                               .sec_data(sum_count),
                               .min_data(mode_count),
                               .hour_data({{29{1'b0}}, water_level}),
                               .anodes(anodes),
                               .cnodes(cnodes)
    );
    initial begin
        state = mode_ch_state;
        nextstate = mode_ch_state;
        start_pause_light = 0;  //light is off
        w_r_d = 7;
        power_control = 1;
        washing_machine_running = 1;
        water_level = 0;
        buzzer_lamp = 0;
    end
    
    //water_in_light
    assign water_in_light = water_in_light_wash | water_in_light_rinse;
    assign water_out_light = water_out_light_rinse | water_out_light_dewater;
    //w_r_d_change
    always @(w_r_d_change) begin
    if(power & power_control & !start_pause_light)
        if(w_r_d_change == 0) begin w_r_d = 7; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 1;end
        else if(w_r_d_change == 1) begin w_r_d = 4; washing_light_control = 1; rinsing_light_control = 0; dewatering_light_control = 0;end
        else if(w_r_d_change == 2) begin w_r_d = 6; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 0;end
        else if(w_r_d_change == 3) begin w_r_d = 2; washing_light_control = 0; rinsing_light_control = 1; dewatering_light_control = 0;end
        else if(w_r_d_change == 4) begin w_r_d = 5; washing_light_control = 1; rinsing_light_control = 0; dewatering_light_control = 1;end
        else if(w_r_d_change == 5) begin w_r_d = 1; washing_light_control = 0; rinsing_light_control = 0; dewatering_light_control = 1;end
        else begin w_r_d = 7; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 1;end
    end
    //buzzer_lamp
    always @(start_pause_light or weight_ch or mode_ch)
    if(power & power_control)
        buzzer_lamp = ~buzzer_lamp;
    
    always @(posedge power)
    begin
        if(power)
            power_control = 1;
    end
    //water level
    always @(posedge clk[0])
    if(power & power_control)
    begin
        water_level = wash_water_level + rinse_water_level + dewater_water_level;
//        anodes = anodes_mode;
//        cnodes = cnodes_mode;
        case(state)
            mode_ch_state: begin
                sum_count = w_r_d[2] * 4 * weight_ch_light + w_r_d[1] * 5 * weight_ch_light + w_r_d[0] * 2 * weight_ch_light;
                mode_count = 0;
            end
            wash_state: begin
                sum_count = wash_count + w_r_d[1] * 5 * weight_ch_light + w_r_d[0] * 2 * weight_ch_light;
                mode_count = wash_count;
            end
            rinse_state: begin 
                sum_count = rinse_count + w_r_d[0] * 2 * weight_ch_light;
                mode_count = rinse_count;
            end
            dewater_state: begin
                sum_count = dewater_count;
                mode_count = dewater_count;
            end
            w_r_d_end_state: begin
                sum_count = 0;
                mode_count = 0;
            end
        endcase
    end
    // FIXED ME: posedge detective can't be mixed up with level detective.
    always @(posedge power or posedge clk[0])
    if(power & power_control) begin
        if(start_pause_light) begin
            state = nextstate; //in mode_ch_state
        end
    end
    else begin 
        nextstate = mode_ch_state;
        washing_machine_running = 1;
        start_pause_light = 0;  //light is off
//        w_r_d = 7;
    end
    
    //count ten seconds
    always @(posedge clk[25])
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
    
    always @(state or start_pause_light)     //moore
    if(start_pause_light) begin
        case(state)
            mode_ch_state: begin w_r_d_start = 0; end
            wash_state:   begin w_r_d_start = 4; end
            rinse_state:  begin w_r_d_start = 2; if(rinsing_state == 3) dewatering_light = dewatering_light_rinse; end
           dewater_state:  begin w_r_d_start = 1; dewatering_light = dewatering_light_dewater; end
           w_r_d_end_state: begin w_r_d = 7; washing_machine_running = 0; 
                                  start_pause_light = 0;
                                  end
        endcase
    end
    
    always @(w_r_d_end or w_r_d)
    if(start_pause_light)
        case(state)
            mode_ch_state:
                if(w_r_d[2]) begin    //w_r_d contains wash
                    nextstate = wash_state;
                end
                else if(!w_r_d[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d == 1) begin
                    nextstate = dewater_state;
                end
                else nextstate = w_r_d_end_state;
            wash_state:
                if(w_r_d_end[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d_end[2] & !w_r_d[1] & w_r_d[0]) begin
                    nextstate = dewater_state;
                end
                else if(w_r_d_end[2] & (w_r_d == 4)) nextstate = w_r_d_end_state;
                else nextstate = wash_state;
            rinse_state:
                if(w_r_d_end[1] & w_r_d[0]) begin
                    nextstate = dewater_state;
                end
                else if(w_r_d_end[1] & !w_r_d[0]) nextstate = w_r_d_end_state;
                else nextstate = rinse_state;
            dewater_state:
                if(w_r_d_end[0]) nextstate = w_r_d_end_state;
                else nextstate = dewater_state;
            w_r_d_end_state: if(washing_machine_running) nextstate = mode_ch_state;
        endcase     
endmodule
