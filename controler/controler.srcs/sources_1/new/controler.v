`timescale 1ns / 1ps


module controler(
    input power, input start_pause, input weight_ch, input mode_ch, input clk_src,
    output start_pause_light,output [2:0]weight_ch_light, output power_light,
    output water_in_light, output reg washing_light, output reg rinsing_light,
    output reg dewatering_light, output water_out_light,// output reg buzzer_lamp,
    output [7:0]anodes, output [7:0]cnodes
    );
    
    reg [2:0]state, nextstate;
    reg [2:0]water_level;
    wire real_clk;
    reg power_control, start_pause_light_one, start_pause_light_two;
    wire true_power;
    wire [7:0]ianodes, icnodes;
    wire [1:0]washing_state, dewatering_state;
    wire [2:0]rinsing_state;
    wire mode_ch_push, weight_ch_push;
    wire water_in_light_wash, water_in_light_rinse;
    wire water_out_light_rinse, water_out_light_dewater;
    wire dewatering_light_rinse, dewatering_light_dewater;
    wire washing_light_wash, rinsing_light_rinse;
    reg washing_light_control, rinsing_light_control, dewatering_light_control;
    reg [2:0]w_r_d_start, w_r_d;
    wire [2:0]w_r_d_end;
    wire [2:0] w_r_d_change;
    wire [31:0]clk;
    reg sound; //washing machine can speak
    reg auto_shut_flag;
    wire [2:0]wash_water_level, rinse_water_level, dewater_water_level;
    wire [31:0]wash_count, rinse_count, dewater_count;
    reg [31:0]mode_count, sum_count;
    parameter mode_ch_state = 0, wash_state = 1, rinse_state = 2, dewater_state = 3, w_r_d_end_state = 4;
    integer count;
    
    // choose weight don't care system run or pause
    selector_mode  #(0,5) MODE_SEL (.clk(clk),
                            .switch_power(true_power),
                            .switch_en(start_pause_light),
                            .sig_change(mode_ch),
                            .push(mode_ch_push),
                            .sel_value(w_r_d_change)
    );
    //devider
    tick_divider TICK_DEVIDER (.clk_src(clk_src),
                               .clk_group(clk)
    );
    
    selector_mode WEIGHT_SEL (.clk(clk),
                            .switch_power(true_power),
                            .switch_en(start_pause_light),
                            .sig_change(weight_ch),
                            .push(weight_ch_push),
                            .sel_value(weight_ch_light)
    );                
    
    wash_mode WASH_MODE (.power(true_power),
                         .start(start_pause_light),
                         .weight(weight_ch_light),
                         .clk(clk),
                         .wash_start(w_r_d_start[2]),
                         .water_in_light(water_in_light_wash),
                         .washing_light(washing_light_wash),
                         .wash_end_sign(w_r_d_end[2]),
                         .water_level(wash_water_level),
                         .wash_count(wash_count),
                         .state(washing_state)
     );
     
    rinse_mode RINSE_MODE (.power(true_power),
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
                           .rinse_count(rinse_count),
                           .state(rinsing_state)
    );
    
    dewater_mode DEWATER_MODE (.power(true_power),
                               .start(start_pause_light),
                               .clk(clk),
                               .weight(weight_ch_light),
                               .dewater_start(w_r_d_start[0]),
                               .dewatering_light(dewatering_light_dewater),
                               .dewater_end_sign(w_r_d_end[0]),
                               .water_out_light(water_out_light_dewater),
                               .water_level(dewater_water_level),
                               .dewater_count(dewater_count),
                               .state(dewatering_state)
    );
    
    //time display
    time_displayer TIME_DISPLAYER (.clk_src(clk[15]),
                               .sec_data({{29{1'b0}}, water_level}),
                               .min_data(mode_count),
                               .hour_data(sum_count),
                               .anodes(ianodes),
                               .cnodes(icnodes)
    );
    initial begin
        state = mode_ch_state;
        nextstate = mode_ch_state;
        start_pause_light_one = 0;  //light is off
        start_pause_light_two = 0;  //light is off
        w_r_d = 7;
        power_control = 1;
        water_level = 0;
        w_r_d_start <= {3{1'b0}}; 
//        buzzer_lamp = 0;
    end
    
    //water_in_light
    assign water_in_light = water_in_light_wash | water_in_light_rinse;
    assign water_out_light = water_out_light_rinse | water_out_light_dewater;
    assign true_power = power & power_control;
    assign anodes = true_power ? ianodes : {8{1'b1}};
    assign cnodes = true_power ? icnodes : {8{1'b1}};
    assign start_pause_light = start_pause_light_one + start_pause_light_two;
    assign power_light = true_power;
    //w_r_d_change
    always @(w_r_d_change) begin
    if(true_power & !start_pause_light)
        if(state == 4) begin w_r_d = 7; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 1; end
        else begin
            if(w_r_d_change == 0) begin w_r_d = 7; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 1;end
            else if(w_r_d_change == 1) begin w_r_d = 4; washing_light_control = 1; rinsing_light_control = 0; dewatering_light_control = 0;end
            else if(w_r_d_change == 2) begin w_r_d = 6; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 0;end
            else if(w_r_d_change == 3) begin w_r_d = 2; washing_light_control = 0; rinsing_light_control = 1; dewatering_light_control = 0;end
            else if(w_r_d_change == 4) begin w_r_d = 5; washing_light_control = 1; rinsing_light_control = 0; dewatering_light_control = 1;end
            else if(w_r_d_change == 5) begin w_r_d = 1; washing_light_control = 0; rinsing_light_control = 0; dewatering_light_control = 1;end
        end
    else begin
        w_r_d = 7; washing_light_control = 1; rinsing_light_control = 1; dewatering_light_control = 1;
    end
    end
    //buzzer_lamp
//    always @(start_pause_light or weight_ch or mode_ch)
//    if(true_power)
//        buzzer_lamp = ~buzzer_lamp;
    
    //water level
    always @(posedge clk[0])
    if(true_power)
    begin
//        water_level = wash_water_level + rinse_water_level + dewater_water_level;
        case(state)
            mode_ch_state: begin
                water_level = 3'b0;
                washing_light = washing_light_control;
                rinsing_light = rinsing_light_control;
                dewatering_light = dewatering_light_control;
                start_pause_light_two = 0;
                sum_count = w_r_d[2] * 4 * {{29{1'b0}},weight_ch_light} + w_r_d[1] * 5 * {{29{1'b0}},weight_ch_light} + w_r_d[0] * 2 * {{29{1'b0}},weight_ch_light};
                mode_count = 0;
            end
            wash_state: begin
                water_level = wash_water_level;
                if(washing_state != 0) washing_light = washing_light_wash;
                sum_count = wash_count + w_r_d[1] * 5 * {{29{1'b0}},weight_ch_light} + w_r_d[0] * 2 * {{29{1'b0}},weight_ch_light};
                mode_count = wash_count;
            end
            rinse_state: begin 
                water_level = rinse_water_level;
                if(rinsing_state == 3 | rinsing_state == 4) dewatering_light = dewatering_light_rinse;
                sum_count = rinse_count + w_r_d[0] * 2 * {{29{1'b0}},weight_ch_light};
                mode_count = rinse_count;
            end
            dewater_state: begin
                water_level = dewater_water_level;
                if(dewatering_state != 0) dewatering_light = dewatering_light_dewater;
                sum_count = dewater_count;
                mode_count = dewater_count;
            end
            w_r_d_end_state: begin
                sum_count = 0;
                mode_count = 0;
                water_level = 0;
                washing_light = washing_light_control;
                rinsing_light = rinsing_light_control;
                dewatering_light = dewatering_light_control;
                start_pause_light_two = 1;
            end
        endcase
    end else begin
        sum_count = 0;
        mode_count = 0;
        water_level = 0;
        washing_light = 0;
        rinsing_light = 0;
        dewatering_light = 0;
        start_pause_light_two = 0;
    end
    // FIXED ME: posedge detective can't be mixed up with level detective.
    always @(posedge clk[0])
    if(true_power) begin
        state = nextstate; //in mode_ch_state
    end
    else begin 
        state = mode_ch_state;
    end
    
    assign real_clk = true_power ? clk[25] : clk[0];
    //count ten seconds
    always @(posedge real_clk)
    begin
    if(true_power) begin
        if(state == 4) count = count + 1;
        else count = 0;
        if(count == 10) power_control = 0;
    end
    else if(power) begin count = 0; power_control = 1; end
    end
    
    //add a block to control  start_pause_light
    always @(posedge start_pause) 
    if(true_power)
    begin
        start_pause_light_one = ~start_pause_light_one;
    end
    else begin
        start_pause_light_one = 0;
    end
    
    always @(state or start_pause_light or true_power)     //moore
    if(true_power & start_pause_light) begin
        case(state)
            mode_ch_state: begin w_r_d_start = 3'b000; end
            wash_state:   begin w_r_d_start = 3'b100; end
            rinse_state:  begin w_r_d_start = 3'b010; end
           dewater_state:  begin w_r_d_start = 3'b001; end
           w_r_d_end_state: begin w_r_d_start = 3'b000;end
        endcase
    end
    else if(true_power & !start_pause_light) begin
        if(mode_ch_push | weight_ch_push) w_r_d_start = 3'b000;
    end
    else if(!true_power) begin
        w_r_d_start = 3'b000;
    end
    
    always @(w_r_d_end or w_r_d or mode_ch_push or weight_ch_push or start_pause_light)
    if(start_pause_light & true_power) begin
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
            w_r_d_end_state: if(mode_ch_push | weight_ch_push) nextstate = mode_ch_state;
        endcase  
    end
    else if(true_power & !start_pause_light) begin
        if(mode_ch_push | weight_ch_push) nextstate = mode_ch_state;
    end
    else if(!true_power) nextstate = mode_ch_state;
endmodule
