`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 11:27:22
// Design Name: 
// Module Name: ROM_comparator_tb
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


module ROM_comparator_tb(

    );
    reg [1:0] a, b;
    wire lt, gt, eq;
    integer i, j;
    
    ROM_comparator DUT (.a(a), .b(b), .lt(lt), .gt(gt), .eq(eq));
    
    initial begin
        #220 $finish;
    end
    
    initial begin
    a = 0; b = 0;
    for (i = 0; i < 4; i = i+1) begin
        #10 a = i;
        for (j = 0; j < 4; j = j+1) begin
            #10 b = j;
        end
    end
    end
endmodule
