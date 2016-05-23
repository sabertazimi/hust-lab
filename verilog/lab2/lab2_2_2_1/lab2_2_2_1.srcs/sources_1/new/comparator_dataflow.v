`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 23:19:33
// Design Name: 
// Module Name: comparator_dataflow
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


module comparator_dataflow(
    input [3:0] in,
    output flag
    );
    
    wire [4:0] in_with_carry;
    wire [4:0] sub_result;
    
    assign in_with_carry = {1'b1, in};
    assign sub_result = in_with_carry - 5'b01010;
    assign flag = sub_result[4];
endmodule
