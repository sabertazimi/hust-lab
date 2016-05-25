`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 11:53:03
// Design Name: 
// Module Name: ROM_multiplier
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


module ROM_multiplier(
    input [1:0] a,
    input [1:0] b,
    output [3:0] product
    );
    
    reg [3:0] ROM[15:0];
    
    assign product = ROM[{a, b}];
    
    initial begin
        $readmemb ("/home/sabertazimi/gitrepo/hust-lab/verilog/lab3/lab3_3_2/lab3_3_2.srcs/sources_1/new/ROM_multiplier.dat", ROM, 0, 15);
    end
endmodule
