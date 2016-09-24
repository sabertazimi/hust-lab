`timescale 1ns / 1ps

module wash_mode_tb();

    reg [31:0]clk;
    reg [1:0]washing_machine_running;
    reg start, power, mode_ch;
    wire push;
    wire [2:0]sel_value;
    parameter TIME = 1000;

    wash_mode WASH_MODE (.power(true_power),
                         .start(start_pause_light),
                         .weight(weight_ch_light),
                         .clk(clk),
                         .wash_start(w_r_d_start[2]),
                         .water_in_light(water_in_light_wash),
                         .washing_light(washing_light_wash),
                         .wash_end_sign(w_r_d_end[2]),
                         .water_level(wash_water_level),
                         .state(washing_state)
     );

    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        mode_ch = 0;
        washing_machine_running = 1;
        #TIME $finish;
    end
    
    always begin
        #10 clk[25] = ~clk[25];
    end
    
    always begin
        #1 clk[0] = ~clk[0];
    end
    
    always begin
        #5 start = 0;
        #20 power = 1;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
        #500 ;
    end

endmodule
