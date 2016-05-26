`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 23:26:30
// Design Name: 
// Module Name: D_ff
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


module D_ff(
    input D,
input Clk,
input reset,
output reg Q,
output Qbar
);

assign Qbar = ~Q;

always @(posedge Clk) begin
    if (reset) begin
        Q <= 1'b0;
    end
    else begin
        Q <= D;
    end
end
endmodule
