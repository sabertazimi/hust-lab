`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:33:35
// Design Name: 
// Module Name: rotate_shift_register
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


module rotate_shift_register
#(parameter LEN = 4)
(
    input clk,
    input clr,
    input [(LEN-1):0] D,
    output reg [(LEN-1):0] Q,
    output [(LEN-1):0] Qbar    
);

    assign Qbar = ~Q;
    
    initial begin
        Q <= {(LEN){1'b1}};
    end
    
    always @(posedge clr or posedge clk) begin
        if (clr) begin
            Q <= {(LEN){1'b0}};
        end
        else begin
            Q <= D;
        end
    end
endmodule
