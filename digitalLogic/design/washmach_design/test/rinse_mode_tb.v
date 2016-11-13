`timescale 1ns / 1ps

module rinse_mode_tb();

    reg [31:0]clk;
    wire [31:0]rinse_count;
    wire [2:0]state;
    reg start, power, rinse_start;
    reg [2:0]weight;
    wire water_in_light, rinsing_light, rinse_end_sign, water_out_light, dewatering_light;
    wire [2:0]water_level;
    parameter TIME = 1000;

    rinse_mode RINSE_MODE (.power(power),
                           .start(start),
                           .clk(clk),
                           .weight(weight),
                           .rinse_start(rinse_start),
                           .rinsing_light(rinsing_light),
                           .rinse_end_sign(rinse_end_sign),
                           .water_in_light(water_in_light),
                           .water_out_light(water_out_light),
                           .dewatering_light(dewatering_light),
                           .water_level(water_level),
                           .rinse_count(rinse_count),
                           .state(state)
    );

    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        weight = 5;
        rinse_start = 0;
        #TIME $finish;
    end
    
    always begin
        #10 clk[25] = ~clk[25];
    end
    
    always begin
        #1 clk[0] = ~clk[0];
    end
    
    always begin
        #10 start = 1;
        #20 power = 1;
        #20 rinse_start = 1;
//        #100 power = 0;
//        #40 power = 1;
        #950 ;
    end

endmodule
