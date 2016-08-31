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
    input [2:0]w_r_d,// input [2:0]w_r_d_end,
    output reg [1:0]state, output reg [1:0]nextstate,
    //light
    output reg start_pause_light
    );
    reg [1:0]weight_result;
    //reg [2:0]w_r_d;
    reg [2:0]w_r_d_start, w_r_d_control, w_r_d_end;
    reg sound; //washing machine can speak
    //reg[1:0] state, nextstate;
    parameter mode_weight_choose = 0, wash = 1, rinse = 2, dewatering = 3;
    
//    weight_water WEIGHT ();//link start to control running
//    mode MODE ();
    wash_mode WASH (.power(power),
                    .pause(start_pause),
                    .weight(weight),
                    .clk(clk),
                    .wash_start(w_r_d_start[2]),
                    //.wash_control(w_r_d_control[2]),
                    .wash_end(w_r_d_end[2])
     );
//    rinse RINSE ();
//    dewatering DEWATERING ();
    
    initial begin
        state = mode_weight_choose;
        nextstate = mode_weight_choose;
        start_pause_light = 0;  //light is off
    end
    
    // FIXED ME: posedge detective can't be mixed up with level detective.
    always @(posedge power or posedge clk or posedge start_pause)
    if(power) state = nextstate; //in mode_weight_choose
    else nextstate = mode_weight_choose;
    
    always @(state or start_pause)     //moore
    if(start_pause) begin
        case(state)
            mode_weight_choose: begin w_r_d_start = 0; w_r_d_end = 0; end
            wash:   w_r_d_start = 4;
            rinse:  w_r_d_start = 2;
           dewatering:  w_r_d_start = 1;
        endcase
    end
    
    always @(w_r_d_end or w_r_d)
    if(start) begin
        case(state)
//            mode_end:   
//                if(power) nextstate = mode_weight_choose;
            mode_weight_choose:
                if(w_r_d[2]) begin    //w_r_d contains wash
                    //wash_start = 1;
                    nextstate = wash;
                end
                else if(!w_r_d[2] & w_r_d[1]) begin
                    //rinse_start = 1;
                    nextstate = rinse;
                end
                else if(w_r_d == 1) begin
                    //dewatering_start = 1;
                    nextstate = dewatering;
                end
                else nextstate = mode_weight_choose;
            wash:
                if(w_r_d_end[2] & w_r_d[1]) begin
                    //rinse_start = 1;
                    nextstate = rinse;
                end
                else if(w_r_d_end[2] & !w_r_d[1] & w_r_d[0]) begin
                    //dewatering_start = 1;
                    nextstate = dewatering;
                end
                else nextstate = mode_weight_choose;
            rinse:
                if(w_r_d_end[1] & w_r_d[0]) begin
                    //dewatering_start = 1;
                    nextstate = dewatering;
                end
                else nextstate = mode_weight_choose;
            dewatering:
                if(w_r_d_end[0]) nextstate = mode_weight_choose;
        endcase            
     end     
     else begin
        if(w_r_d[2]) nextstate = wash;
        else if(!w_r_d[2] & w_r_d[1]) nextstate = rinse;
        else if(w_r_d == 1) nextstate = dewatering;
        else nextstate = mode_weight_choose;
     end
endmodule
