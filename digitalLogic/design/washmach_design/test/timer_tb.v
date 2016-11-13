`timescale 1ns / 1ps

module timer_tb();
   
    reg [31:0]clk, sum_count;
    reg start, power, count_start_flag;
    wire [31:0]count;
    wire count_end_flag;
    
    parameter DELAY = 10;
    parameter TIME = 1000;
    
    timer DUT (
        .clk_src(clk),
        .switch_power(power),
        .switch_en(start),
        .sum_count(sum_count),
        .count_start_flag(count_start_flag),
        .count_end_flag(count_end_flag),
        .count(count)
    );
    
    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        sum_count = 2;
        count_start_flag = 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk[25] = ~clk[25];
    end
    
    always begin
        #(DELAY/DELAY) clk[0] = ~clk[0];
    end
    
    always begin
        #(DELAY/2) start = 1;
        #(DELAY*2) power = 1;
        #(DELAY*2) count_start_flag = 1; start = 1;
        #(DELAY*10) count_start_flag = 0;
        #(DELAY*42);
        #(DELAY/2) count_start_flag = 1; sum_count = 5;
        #(DELAY*50);
    end
    
endmodule
