`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/31 16:39:24
// Design Name: 
// Module Name: weight_selector_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module weight_selector_tb();

    parameter COUNT = 100;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    
    reg switch_power, switch_en, sig_change;
    wire [2:0] weight;
    
    weight_selector DUT (
        .switch_power(switch_power),
        .switch_en(switch_en),
        .sig_change(sig_change),
        .weight(weight)
    );
    
    initial begin
        switch_power <= 0;
        switch_en <= 1;
        sig_change <= 0;
        #TIME $finish;
    end
      
    always begin
        #(5*DELAY) switch_power <= 1;
        #(2*DELAY)
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(DELAY) sig_change <= 1;
        #(DELAY) sig_change <= 0;
        #(5*DELAY) switch_power <= 0;
    end

endmodule
