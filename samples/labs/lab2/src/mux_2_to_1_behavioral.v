`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 20:37:21
// Design Name: 
// Module Name: mux_2_to_1_behavioral
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


module mux_2_to_1_behavioral(input x, input y, input s, output m);
	reg m;

	always @(x or y or s) begin
		if (s == 0) begin
			m = x;
		end
		else begin
			m = y;
		end
	end
endmodule

