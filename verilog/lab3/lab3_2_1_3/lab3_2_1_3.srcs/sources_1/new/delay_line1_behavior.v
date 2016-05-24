`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 22:59:44
// Design Name: 
// Module Name: delay_line1_behavior
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


module delay_line1_behavior(
    input Clk,
    input ShiftIn,
    output ShiftOut
    );
    
    reg shift_reg;
    
    always @(posedge Clk) begin
         shift_reg = ShiftIn;
    end
    
    assign ShiftOut = shift_reg;
endmodule
