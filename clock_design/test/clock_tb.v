`timescale 1ns / 1ps

module clock_tb();

    parameter DELAY = 10;
    parameter TIME = 1000;
    
    reg clk_src, power, enable, reset;
    reg [2:0] add_time, sub_time;
    reg timing_clock_switch;
    wire alarm, timing_clock_alarm;
    wire [7:0] anodes, cnodes;

    clock #(32, 0, 5, 4, 3, 5, 5) DUT (
        .clk_src(clk_src),
        .power(power),
        .enable(enable),
        .reset(reset),
        .add_time(add_time),
        .sub_time(sub_time),
        .timing_clock_switch(timing_clock_switch),
        .alarm(alarm),
        .timing_clock_alarm(timing_clock_alarm),
        .anodes(anodes),
        .cnodes(cnodes)
    );
    
    initial begin
        clk_src <= 0;
        power <= 0;
        enable <= 0;
        reset <= 0;
        add_time <= 3'b000;
        sub_time <= 3'b000;
        timing_clock_switch <= 0;
        #TIME $finish;
    end
    
    always begin
        #DELAY clk_src <= ~clk_src;
    end
    
    always begin
        // power = 0, enable = 0
        // all buttons don't work
        #(DELAY) add_time = 3'b111;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 3'b111;
        #(DELAY) sub_time = 0;
    
        // power = 0, enable = 1
        // all buttons don't work
        #(DELAY) add_time = 3'b111;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 3'b111;
        #(DELAY) sub_time = 0;

        // power = 1, enable = 1
        // reset works, add_time/sub_time doesn't work
        // feat: reset && count
        #(DELAY) power = 1;
        #(DELAY) enable = 1;
        #(DELAY/2);
        #(DELAY) add_time = 3'b111;
        #(DELAY) add_time = 0;
        #(DELAY) sub_time = 3'b111;
        #(DELAY) sub_time = 0;
        #(5*DELAY) reset = 1;
        #(DELAY) reset = 0;
    
        // power = 1, enable = 0
        // reset works, add_time/sub_time works
        // feat: add time && sub time
        #(10*DELAY) enable = 0;
        #(10*DELAY); // pause
        #(DELAY) add_time = 3'b111;
        #(2*DELAY) add_time = 0;
        #(DELAY) sub_time = 3'b111;
        #(DELAY) sub_time = 0;
    
        // power = 0
        // when power off, automatically reset all clock
        #(DELAY) power = 0;
        
        // test timing clock feature
        #(DELAY) power = 1;
        #(DELAY) timing_clock_switch = 1;
        #(DELAY) add_time[0] = 1;
        #(5*DELAY) add_time[1] = 0;
        #(DELAY) timing_clock_switch = 0;
        #(DELAY) enable = 1;
    end
endmodule
