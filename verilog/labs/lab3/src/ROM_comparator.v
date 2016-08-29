`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/05/25 11:03:33
// Design Name:
// Module Name: ROM_comparator
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

module ROM_comparator(
    input [1:0] a,
    input [1:0] b,
    output lt,
    output gt,
    output eq
    );

    reg [2:0] ROM [0:15];

    assign {lt, gt, eq} = ROM[{a, b}];

    initial begin
        $readmemb ("/home/sabertazimi/gitrepo/hust-lab/verilog/lab3/lab3_3_1/lab3_3_1.srcs/sources_1/new/ROM_comparator.dat", ROM, 0, 15);
    end
endmodule
