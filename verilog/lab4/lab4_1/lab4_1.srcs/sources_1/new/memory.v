`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 23:29:17
// Design Name: 
// Module Name: memory
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


module memory(
    input [7:0] address,
    output [7:0] data
    );
    
    reg [7:0] MEM [0:255];
    
    assign data = MEM[address];
    
    initial begin
        $readmemb("/home/sabertazimi/gitrepo/hust-lab/verilog/lab4/lab4_1/lab4_1.srcs/sources_1/new/memory.dat", MEM, 0, 255);
    end
endmodule
