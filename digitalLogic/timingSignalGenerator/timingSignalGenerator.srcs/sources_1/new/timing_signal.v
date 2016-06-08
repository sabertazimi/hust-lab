`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/08 20:53:23
// Design Name: 
// Module Name: timing_signal
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


module timing_signal
#(parameter LEN = 4)
(
    input clk,
    input clr_n,
    output [(LEN-1):0] Tp
);

    // D_ff
    wire D_Q, D_Qbar;
    
    // rotate register
    wire [(LEN-1):0] Q, Qbar;
    
    // output timing signal
    assign Tp = {Qbar[3], Q[1], Q[2]&Qbar[1], Q[3]&Qbar[2]};

    D_ff #(.LEN(1)) D (
        .clk(~clk),
        .clr_n(clr_n),
        .D(Q[1]),
        .Q(D_Q),
        .Qbar(D_Qbar));
        
    rotate_shift_register #(LEN) ROTATE (
        .clk(~(~clk&D_Qbar)),
        .clr(clk&D_Q),
        .D({1'b1, Q[3], Q[2],1'b0}),
        .Q(Q),
        .Qbar(Qbar));
    
endmodule
