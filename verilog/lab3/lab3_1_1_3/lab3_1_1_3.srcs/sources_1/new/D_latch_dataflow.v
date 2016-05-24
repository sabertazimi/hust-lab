`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 19:45:37
// Design Name: 
// Module Name: D_latch_dataflow
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


module D_latch_dataflow(
    input D,
    input Enable,
    output Q,
    output Qbar
    );
    
    wire D_i;
    
    assign #2 D_i = ~D;
    assign #2 Q = ~(Enable & D_i |Qbar);
    assign #2 Qbar = ~(Enable & D |Q);
endmodule
