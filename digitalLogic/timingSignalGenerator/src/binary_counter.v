`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:03:36
// Design Name: 
// Module Name: binary_counter
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


module binary_counter
#(parameter LEN = 4)
(
    input clk,
    output reg [(LEN-1): 0] Q
);

    initial begin
        Q <= {(LEN){1'b0}};
    end
    
    always @(posedge clk) begin
        Q <= Q + 1;
    end
endmodule
