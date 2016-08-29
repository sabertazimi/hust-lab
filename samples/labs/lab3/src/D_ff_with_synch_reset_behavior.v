`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 09:42:19
// Design Name: 
// Module Name: D_ff_with_synch_reset_behavior
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


module D_ff_with_synch_reset_behavior(
    input Clk,
    input D,
    input reset,
    output reg Q
    );
    
    always @(posedge Clk) begin
        if (reset) Q <= 1'b0;
        else Q  <= D;
    end
endmodule
