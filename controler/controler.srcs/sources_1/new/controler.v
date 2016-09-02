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
    output reg [1:0]state, output reg [1:0]nextstate,
    //light
    output reg start_pause_light,output [1:0]weight_ch_light,
    output reg water_in_light, output reg washing_light, output reg rinse_light,
    output reg dewatering_light, output reg water_out_light
    );
//    reg [1:0]weight_result;
    reg [2:0]w_r_d;
    reg [2:0]w_r_d_start, w_r_d_control, w_r_d_end;
    reg sound; //washing machine can speak
    reg auto_shut_flag, power_control;
//    reg[1:0] state, nextstate;
    parameter weight_ch_state = 0, wash_state = 1, rinse_state = 2, dewatering_state = 3;
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
                       //.wash_control(w_r_d_control[2]),
                         .wash_end_sign(w_r_d_end[2])
     );
     
    rinse_mode RINSE_MODE (.power(power & power_control),
                           .pause(start_pause),
                           .clk(clk),
                           .rinse_start(w_r_d_start[1]),
                           .rinse_light(rinse_light),
                           .wash_end_sign(w_r_d_end[2]),
                           .water_in_light(rinse_light),
                           .water_out_light(rinse_light),
                           .dewatering_light(rinse_light)
    );
//    dewatering DEWATERING ();
    
    initial begin
        state = weight_ch_state;
        nextstate = weight_ch_state;
        start_pause_light = 0;  //light is off
        auto_shut_flag = 0;
        w_r_d = 7;
        power_control = 1;
    end
    
    // FIXED ME: posedge detective can't be mixed up with level detective.
    always @(posedge power or posedge clk)
    if(power & power_control) begin
        if(!start_pause_light) begin
            state = nextstate; //in weight_ch_state
        end
    end
    else if(!power) begin 
        nextstate = weight_ch_state;
        power_control = 0;
    end
    
    //add a block to control start_pause
    always @(posedge start_pause)
    if(power & power_control)
    begin
        start_pause_light = ~ start_pause_light;
    end
    
    always @(weight_ch_light)
    if(power & power_control)
    begin
        if(weight_ch_light == 0) ;
    end
    
    //light spangle
    always @(water_in_light or )
    begin
        
    end
    
    always @(state or start_pause_light)     //moore
    if(start_pause_light) begin
        case(state)
            weight_ch_state: begin w_r_d_start = 0; w_r_d_end = 0; end
            wash_state:   w_r_d_start = 4;
            rinse_state:  w_r_d_start = 2;
           dewatering_state:  w_r_d_start = 1;
        endcase
    end
    
    always @(w_r_d_end or w_r_d)
    if(start_pause_light) begin
        case(state)
//            mode_end:   
//                if(power) nextstate = weight_ch_state;
            weight_ch_state:
                if(w_r_d[2]) begin    //w_r_d contains wash
                    nextstate = wash_state;
                end
                else if(!w_r_d[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d == 1) begin
                    nextstate = dewatering_state;
                end
                else if(!auto_shut_flag) nextstate = weight_ch_state;
                else if(auto_shut_flag) begin
                    nextstate = weight_ch_state;
                    power_control = 0;
                end
            wash_state:
                if(w_r_d_end[2] & w_r_d[1]) begin
                    nextstate = rinse_state;
                end
                else if(w_r_d_end[2] & !w_r_d[1] & w_r_d[0]) begin
                    nextstate = dewatering_state;
                end
                else nextstate = weight_ch_state;
            rinse_state:
                if(w_r_d_end[1] & w_r_d[0]) begin
                    nextstate = dewatering_state;
                end
                else nextstate = weight_ch_state;
            dewatering_state:
                if(w_r_d_end[0]) nextstate = weight_ch_state;
        endcase            
     end     
     else begin
        if(w_r_d[2]) nextstate = wash_state;
        else if(!w_r_d[2] & w_r_d[1]) nextstate = rinse_state;
        else if(w_r_d == 1) nextstate = dewatering_state;
        else nextstate = weight_ch_state;
     end
endmodule
