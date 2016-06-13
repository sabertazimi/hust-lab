`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 15:42:48
// Design Name: 
// Module Name: calc_ones_function
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


module calc_ones_function(
    input [7:0] ain,
    output reg [2:0] number_of_ones
    );
    
    function [2:0] calc_ones;
        input [7:0] ain;
        integer i;
        
        begin
            calc_ones = 0;
            for (i = 0; i < 8 && ain > 0; i = i + 1) begin
                ain = ain & (ain - 1);
                calc_ones = calc_ones + 1;
            end
        end
    endfunction
    
    always @(ain) begin
        number_of_ones = calc_ones(ain);
    end
endmodule
