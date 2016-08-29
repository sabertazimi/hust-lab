`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/05/25 10:33:11
// Design Name:
// Module Name: _2bit_up_counter_with_synch_load_enable_clear
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

// mod 4 adder

module _2bit_up_counter_with_synch_load_enable_clear(
    input Clock,
	input Clear,
	input Enable,
	input Load,
	output [1:0] Q
);

reg [1:0] count;

assign Q = count;

always @(posedge Clock) begin
    if (Clear) count <= 2'b00;
    else if (Enable)
        if (Load && count == 2'b11) count <= 2'b00;
        else count <= count + 1;
end
endmodule
