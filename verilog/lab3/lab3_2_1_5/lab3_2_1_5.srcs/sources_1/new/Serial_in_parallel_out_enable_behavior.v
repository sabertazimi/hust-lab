`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 08:26:01
// Design Name: 
// Module Name: Serial_in_parallel_out_enable_behavior
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


module Serial_in_parallel_out_enable_behavior(
    input Clk,
    input ShiftIn,
    input ShiftEn,
    output ShiftOut,
    output [3:0] ParallelOut
    );
    
    reg [3:0] shift_reg;
    
    always @(posedge Clk) begin
        if (ShiftEn) shift_reg <= 
    end
endmodule
