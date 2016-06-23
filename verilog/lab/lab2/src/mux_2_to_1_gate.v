`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 19:59:51
// Design Name: 
// Module Name: mux_2_to_1_gate
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


module mux_2_to_1_gate(input x, input y, input s, output m);
	wire neg_s, x_s, y_s;

	not (neg_s, s);
	and (x_s, x, neg_s);
	and (y_s, y, s);
	or  (m, x_s, y_s);
endmodule
