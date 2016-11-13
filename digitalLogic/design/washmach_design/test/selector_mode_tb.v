`timescale 1ns / 1ps

module selector_mode_tb();

    reg [31:0]clk;
    reg start, power, mode_ch;
    reg [1:0]washing_machine_running;
    wire push;
    wire [2:0]sel_value;
    parameter TIME = 1000;

    selector_mode  #(0,5) MODE_SEL (.clk(clk),
                            .switch_power(power),
                            .switch_en(start),
                            .sig_change(mode_ch),
                            .push(push),
                            .washing_machine_running(washing_machine_running),
                            .sel_value(sel_value)
);

    initial begin
        power = 0;
        clk[25] = 0;
        clk[0] = 0;
        start = 0;
        mode_ch = 0;
        washing_machine_running = 0;
        #TIME $finish;
    end
    
    always begin
        #10 clk[25] = ~clk[25];
    end
    
    always begin
        #1 clk[0] = ~clk[0];
    end
    
    always begin
//        #5 start = 0;
        #20 power = 1;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
        #10 mode_ch = 0;
        #10 mode_ch = 1;
//        #100 start = 1; washing_machine_running = 1;
        #100 start = 0; washing_machine_running = 2;
    end
  

endmodule
