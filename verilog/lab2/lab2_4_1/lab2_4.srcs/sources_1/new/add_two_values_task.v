`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 15:18:47
// Design Name: 
// Module Name: add_two_values_task
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


module add_two_values_task(
    input [3:0] ain,
    input [3:0] bin,
    output reg cout,
    output reg [3:0] sum
    );
    
    task add_two_values;
        input [3:0] ain;
        input [3:0] bin;
        output cout;
        output [3:0] sum;
        {cout, sum} = ain + bin;
    endtask
    
    always @(ain or bin) begin
        add_two_values(ain, bin, cout, sum);
    end
endmodule
