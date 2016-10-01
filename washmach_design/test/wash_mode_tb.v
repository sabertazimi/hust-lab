`timescale 1ns / 1ps

module wash_mode_tb();

    reg [31:0]clk;
    wire [31:0]wash_count;
    wire [1:0]state;
    reg start, power, wash_start;
    reg [2:0]weight;
    wire water_in_light, washing_light, wash_end_sign;
    wire [2:0]water_level;
    parameter TIME = 1000;

    wash_mode WASH_MODE (.power(power),
                         .start(start),
                         .weight(weight),
                         .clk(clk),
                         .wash_start(wash_start),
                         .water_in_light(water_in_light),
                         .washing_light(washing_light),
                         .wash_end_sign(wash_end_sign),
                         .water_level(water_level),
                         .wash_count(wash_count),
                         .state(state)
     );

    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        weight = 5;
        wash_start = 0;
        #TIME $finish;
    end
    
    always begin
        #10 clk[25] = ~clk[25];
    end
    
    always begin
        #1 clk[0] = ~clk[0];
    end
    
    always begin
        #10 power = 1;
        #20 start = 1;
        #20 wash_start = 1;
        #950 ;
    end

endmodule
