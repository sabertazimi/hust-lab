`timescale 1ns / 1ps

module timer_tb();
   
    reg [31:0]clk, sum_count;
    reg start, power, count_start_flag;
    wire [31:0]count;
    wire count_end_flag;
    parameter TIME = 1000;
    
    timer TIMER_TEST (.clk_src(clk),
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
        start = 0;
        sum_count = 20;
        count_start_flag = 0;
        #TIME $finish;
    end
    
    always begin
        #10 clk[25] = ~clk[25];
    end
    
    always begin
        #1 clk[0] = ~clk[0];
    end
    
    always begin
        #5 start = 1;
        #20 power = 1;
        #20 count_start_flag = 1;
        #420 count_start_flag = 0;
        #5 count_start_flag = 1; sum_count = 5;
        #500 ;
    end
    
endmodule
