`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/05 19:30:53
// Design Name: 
// Module Name: _1bit_binary_comparator_tb
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


module _1bit_binary_comparator_tb(

    );
    parameter COUNT = 4;
    parameter DELAY = 10;
    reg A, B;
    wire [2:0] F;
    integer i;
    
    _1bit_binary_comparator DUT (.A(A), .B(B), .F(F));
    
    initial begin
        #(COUNT * DELAY) $finish;
    end
    
    initial begin
        {A, B} = 2'b00;
        for (i = 1; i < COUNT; i = i + 1) begin
            #DELAY {A, B} = i;
        end
    end
endmodule

