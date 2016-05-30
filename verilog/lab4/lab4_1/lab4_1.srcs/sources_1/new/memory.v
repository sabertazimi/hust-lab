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


module memory
#(parameter DATA_WIDTH = 8)
    (
    input [(DATA_WIDTH - 1):0] address,
    output [(DATA_WIDTH - 1):0] data
    );
    
    reg [(DATA_WIDTH - 1):0] MEM [0:(2**(DATA_WIDTH) - 1)];
    
    assign data = MEM[address];
    
    initial begin
        $readmemb("/home/sabertazimi/gitrepo/hust-lab/verilog/lab4/lab4_1/lab4_1.srcs/sources_1/new/memory.dat", MEM, 0, 255);
    end
endmodule
