`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 15:27:29
// Design Name: 
// Module Name: add_two_values_function
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


module add_two_values_function(
    input [3:0] ain, 
    input [3:0] bin,
    output reg [4:0] sum
    );
    
    function [4:0] add_two_values;
        input [3:0] ain;
        input [3:0] bin;
        
        begin
            add_two_values[4] = 0;
            add_two_values = ain + bin;
        end
    endfunction
    
    always @(ain or bin) begin
        sum = add_two_values(ain, bin);
    end
endmodule
