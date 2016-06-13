`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 22:39:02
// Design Name: 
// Module Name: control_unit
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


module control_unit
#(parameter LEN = 4)
(
    input on,
    input off,
    input clr_n,
    input [(LEN-1):0] Tp,
    output [(LEN-1):0] T
);

    // D_ff
    wire Q;
    
    // R_S latch
    wire on_and, off_and;
    
    assign on_and = ~(on & off_and);
    assign off_and = ~(on_and & off & clr_n);
    
    assign T = Tp & {(LEN){Q}};
    
    D_ff #(.LEN(1)) D (.clk(~Tp[3]), .clr_n(clr_n), .D(on_and), .Q(Q), .Qbar());
    
endmodule
