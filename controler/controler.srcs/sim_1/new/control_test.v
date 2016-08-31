`timescale 1ns / 1ps

module control_test();
    reg power, start, weight_ch, mode_ch, clk, reset;
    reg [2:0]w_r_d, w_r_d_end;
    wire [1:0]state, nextstate;
    parameter TIME = 1000, DELAY = 10;
    
    controler CONTROLER (
        .reset(reset),
        .power(power),
        .start(start),
        .weight_ch(weight_ch),
        .mode_ch(mode_ch),
        .clk(clk),
        .w_r_d(w_r_d),
        .w_r_d_end(w_r_d_end),
        .state(state),
        .nextstate(nextstate)
    );
    
    initial begin
        clk = 0; w_r_d_end = 0;
        #TIME $finish;
    end
    
    always begin
        power = 1; w_r_d = 1; reset = 0;  start = 0;
        #50 w_r_d = 2;
        #50 w_r_d = 3;
        #50 w_r_d = 4;
        #50 w_r_d = 6;
        #3 start = 1;
//        #50 w_r_d = 7;
        #100 w_r_d_end[2] = 1;
        #100 w_r_d_end[1] = 1;
//        #100 w_r_d_end[0] = 1;
        #100  w_r_d_end = 0;
    end
    
    always begin
        #DELAY clk = ~clk;
    end
endmodule
