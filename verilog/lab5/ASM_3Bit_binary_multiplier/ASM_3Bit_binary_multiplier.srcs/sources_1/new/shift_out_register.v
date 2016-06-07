`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 12:57:48
// Design Name: 
// Module Name: shift_out_register
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


module shift_out_register
#(parameter WIDTH = 3)
(
    input clk,
    input load,
    input shift,
    input [(WIDTH-1):0] D,
    input shift_in,
    output [(WIDTH-1):0] Q,
    output shift_out
);

    reg [(WIDTH-1):0] shift_reg; 

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= D;
        end
        else if (shift) begin
            if (WIDTH == 1) begin
                shift_reg <= shift_in;
            end
            else begin
                shift_reg <= {shift_in, shift_reg[(WIDTH-1):1]};
            end
        end
    end
    
    assign shift_out = shift_reg[0];
    assign Q = shift_reg; 
endmodule
