`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 14:25:50
// Design Name: 
// Module Name: decoder_74138_dataflow
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


module decoder_74138_dataflow(
    input [0:2] x,
    input g1, 
    input g2a_n,
    input g2b_n,
    output reg [7:0] y
    );
    
    wire [7:0] tmp;
    
    decoder_3to8_dataflow DECODE (.x(x), .y(tmp));
    
    always @(g1 or g2a_n or g2b_n or x) begin
        if ({g1, g2a_n, g2b_n} == 3'b100) begin
            y = ~tmp;
        end
        else begin
            y = 8'b1111_1111;
        end
    end
endmodule
