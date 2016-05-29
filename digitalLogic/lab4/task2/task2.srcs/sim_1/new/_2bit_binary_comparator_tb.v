`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 21:32:40
// Design Name: 
// Module Name: _2bit_binary_comparator_tb
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


module _2bit_binary_comparator_tb(
    );
    reg [1:0] A, B;
    wire [2:0] F;
    integer i;
    
    _2bit_binary_comparator DUT (.A(A), .B(B), .F(F));
    
    initial begin
        #200 $finish;
    end
    
    initial begin
        {A, B} = 4'b0000;
        for (i = 0; i < 16; i = i + 1) begin
            #10 {A, B} = i;
        end
    end
endmodule
