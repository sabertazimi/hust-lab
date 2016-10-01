`timescale 1ns / 1ps

module water_let_mode_tb();

    reg [31:0]clk;
    reg water_in_start, water_out_start, power, start;
    reg [2:0]weight;
    wire [2:0]water_level;
    wire water_in_end_sign, water_out_end_sign;
    
    parameter DELAY = 10;
    parameter TIME = 1000;

    water_let_mode DUT (
        .water_in_end_sign(water_in_end_sign),
        .water_in_start(water_in_start),
        .water_out_start(water_out_start),
        .water_out_end_sign(water_out_end_sign),
        .clk(clk),
        .power(power),
        .max_water_level(weight),
        .start(start),
        .water_level(water_level)
    );
     
    initial begin
         power = 0;
         clk[25] = 0;
         clk[0] = 0;
         start = 0;
         weight = 5;
         water_in_start = 0;
         water_out_start = 0;
         #TIME $finish;
     end
     
     always begin
         #DELAY clk[25] = ~clk[25];
     end
     
     always begin
         #(DELAY/DELAY) clk[0] = ~clk[0];
     end
     
     always begin
        #DELAY water_in_start = 1;
        #DELAY start = 1;
        #DELAY power = 1;
        #DELAY start = 1;
        #(DELAY*5) water_in_start = 0;
        #DELAY water_in_start = 1;
        #(DELAY*50) water_in_start = 0;
        #(DELAY) water_out_start = 1;
        #(DELAY*46);
     end
endmodule
