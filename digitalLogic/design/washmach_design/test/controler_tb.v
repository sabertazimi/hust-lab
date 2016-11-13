`timescale 1ns / 1ps

module controler_tb();

    reg power, start_pause, weight_ch, mode_ch, clk_src;
    wire power_light;
    wire start_pause_light, water_in_light, washing_light, rinsing_light, dewatering_light, water_out_light;
    wire [7:0]anodes, cnodes;
    wire [2:0]weight_ch_light; 
    wire [2:0]state;
    wire alarm;
    parameter TIME = 1000, DELAY = 10;

    controler #(32,0) CONTROLER (.power(power),
                         .start_pause(start_pause),
                         .weight_ch(weight_ch),
                         .mode_ch(mode_ch),
                         .clk_src(clk_src),
                         .start_pause_light(start_pause_light),
                         .weight_ch_light(weight_ch_light),
                         .water_in_light(water_in_light),
                         .washing_light(washing_light),
                         .rinsing_light(rinsing_light),
                         .dewatering_light(dewatering_light),
                         .water_out_light(water_out_light),
                         .power_light(power_light),
                         .state(state),
                         .alarm(alarm),
                         .anodes(anodes),
                         .cnodes(cnodes)
    );

    initial begin
        power = 0;
        clk_src = 0;
        start_pause = 0;
        weight_ch = 0;
        mode_ch = 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY/10) clk_src = ~clk_src;
    end
    
    always begin
        #(2*DELAY) mode_ch = 1;
        #(2*DELAY) weight_ch = 1; mode_ch = 0; // cann't change when machine isn't turn on
        #(2*DELAY) power = 1; weight_ch = 0;
        #(2*DELAY) mode_ch = 1; weight_ch = 1;
        #(DELAY/10) mode_ch = 0; weight_ch = 0;
        #(2*DELAY) start_pause = 1;
        #(2*DELAY) mode_ch = 1; weight_ch = 1; // cann't change when machine is start
        #((2*DELAY)/10) mode_ch = 0; weight_ch = 0;
        #(2*DELAY) start_pause = 0;
        #(2*DELAY) mode_ch = 1; weight_ch = 1; // change when machine is pause
        #(DELAY/10) mode_ch = 0; weight_ch = 0;
        #(2*DELAY) start_pause = 1; // start in new mode
        #(2*DELAY) start_pause = 0;
        #(5*DELAY) start_pause = 1; // test start_pause
        #(73*DELAY) ;
    end

endmodule
