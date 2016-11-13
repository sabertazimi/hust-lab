`timescale 1ns / 1ps

module dewater_mode_tb();

    reg [31:0]clk;
    wire [31:0]dewater_count;
    wire [1:0]state;
    reg start, power, dewater_start;
    reg [2:0]weight;
    wire dewater_end_sign, water_out_light, dewatering_light;
    wire [2:0]water_level;
    parameter TIME = 1000;
    
    dewater_mode DEWATER_MODE (.power(power),
                               .start(start),
                               .clk(clk),
                               .weight(weight),
                               .dewater_start(dewater_start),
                               .dewatering_light(dewatering_light),
                               .dewater_end_sign(dewater_end_sign),
                               .water_out_light(water_out_light),
                               .water_level(water_level),
                               .dewater_count(dewater_count),
                               .state(state)
    );
    
    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        weight = 5;
        dewater_start = 0;
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
        #20 dewater_start = 1;
//        #100 power = 0;
//        #40 power = 1;
        #950 ;
    end

endmodule
