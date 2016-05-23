`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 20:46:54
// Design Name: 
// Module Name: mux_2bit_2_to_1_behavioral
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


module mux_2bit_2_to_1_behavioral(input [1:0] x, input [1:0] y, input s, output [1:0] m);
	reg [1:0] m;

	always @(x or y or s) begin
		if (s == 0) begin
			m = x;
		end
		else begin
			m = y;
		end
	end
endmodule
