`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 11:21:29
// Design Name: 
// Module Name: full_adder
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


module full_adder
#(parameter WIDTH = 3)
(
    input start,
    input add,
    input [(WIDTH - 1):0] a,
    input [(WIDTH - 1):0] b,
    output reg [(WIDTH - 1):0] s,
    output reg cout
);
    
    always @ (start or add) begin
        if (add) begin
            {cout, s} <= a + b;
        end
        else if (start) begin
            {cout, s} <= {(WIDTH+1){1'b0}};
        end

    end
endmodule
