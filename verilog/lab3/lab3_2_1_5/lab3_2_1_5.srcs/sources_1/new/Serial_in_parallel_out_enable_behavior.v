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
    input reset,
    input ShiftEn,
    output ShiftOut,
    output  [3:0] ParallelOut
    );
    
    reg [3:0] shift_reg;
    
    always @(posedge Clk) begin
        if (reset) shift_reg <= 4'b0000;
        else if (ShiftEn) shift_reg <= {shift_reg[2:0], ShiftIn};
    end
    
    assign ShiftOut = shift_reg[3];
    assign ParallelOut = shift_reg;
endmodule
