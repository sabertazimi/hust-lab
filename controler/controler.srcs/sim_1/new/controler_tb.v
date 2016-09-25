`timescale 1ns / 1ps

module controler_tb();

    reg power, start_pause, weight_ch, mode_ch, clk_src;
    wire power_light;
    wire start_pause_light, water_in_light, washing_light, rinsing_light, dewatering_light, water_out_light;
    wire [7:0]anodes, cnodes;
    wire [2:0]weight_ch_light; 
    parameter TIME = 1000;

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
        #1 clk_src = ~clk_src;
    end
    
    always begin
//        #10 mode_ch = 1;
//        #10 weight_ch = 1; mode_ch = 0;
//        #10 power = 1; weight_ch = 0;
//        #10 mode_ch = 1; weight_ch = 1;
        #10 power = 1;
        #30 start_pause = 1;
//        #100 power = 0;
//        #40 power = 1;
        #980 ;
    end

endmodule
