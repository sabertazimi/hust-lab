`timescale 1ns / 1ps

module weight_ch_mode(
    input power, input weight_ch, input clk,
    output reg weight_ch_light
    );
    
    always @(posedge clk or posedge power)
    begin
        
    end
endmodule
