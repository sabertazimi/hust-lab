`timescale 1ns / 1ps

module time_displayer_tb();

    parameter DELAY = 10;
    parameter TIME = 300;
    parameter WIDTH = 32;
    
    reg clk_src;
    reg [(WIDTH-1):0] sec_data, min_data, hour_data;
    wire [7:0] anodes, cnodes;

    time_displayer DUT (
        .clk_src(clk_src),
        .sec_data(sec_data),
        .min_data(min_data),
        .hour_data(hour_data),
        .anodes(anodes),
        .cnodes(cnodes)
    ); 
    
    initial begin
        clk_src <= 0;
        sec_data <= 0;
        min_data <= 0;
        hour_data <= 0;
        #TIME $finish;
    end
    
    always begin
        #(DELAY) clk_src <= ~clk_src;
    end
    
    always begin
        sec_data = 20; min_data = 20; hour_data = 3;
        #(TIME/2) sec_data = 59; min_data = 59; hour_data = 23;
    end

endmodule
