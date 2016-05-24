`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 22:02:27
// Design Name: 
// Module Name: Register_with_synch_reset_load_behavior
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


module Register_with_synch_reset_load_behavior(
    input [3:0] D,
    input Clk,
    input reset,
    input load,
    output reg [3:0] Q
    );
    
    always @(posedge Clk) begin
        if (reset) Q <= 4'b0;
        else if (load) Q <= D;
    end
endmodule
