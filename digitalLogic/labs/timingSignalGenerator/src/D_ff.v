`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:50:14
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


module D_ff
#(parameter LEN = 1)
(
    input clk,
    input clr_n,
    input [(LEN-1):0] D,
    output reg [(LEN-1):0] Q,
    output [(LEN-1):0] Qbar    
);

    assign Qbar = ~Q;
    
    always @(negedge clr_n or posedge clk) begin
        if (!clr_n) begin
            Q <= {(LEN){1'b1}};
        end
        else begin
            Q <= D;
        end
    end
endmodule
