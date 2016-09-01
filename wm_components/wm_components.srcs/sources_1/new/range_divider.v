`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 09:01:18
// Design Name: 
// Module Name: range_divider
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


module range_divider
#(parameter WIDTH = 32, RANGE = 27'b101111101011110000100000000)
(
    input clk_src,
    output reg clk_dst    
);

    reg[(WIDTH-1):0] count;
    
    initial begin
        count <= 0;
    end

    always@(posedge clk_src) begin
        count = count + 1;
        if (count == RANGE) begin
            count = 0;
            clk_dst = 1;
        end else begin
            clk_dst = 0;
        end
    end

endmodule
