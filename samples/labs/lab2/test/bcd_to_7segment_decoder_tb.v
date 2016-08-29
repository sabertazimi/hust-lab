`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 21:33:38
// Design Name: 
// Module Name: bcd_to_7segment_decoder_tb
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


module bcd_to_7segment_decoder_tb(

    );
    reg [3:0] x;
    wire [3:0] an;
    wire [6:0] seg;
    integer i;

    
    bcd_to_7segment_decoder DUT (.x(x), .an(an), .seg(seg));
    
    initial begin
        x = 0;
        for (i = 0; i < 15; i = i + 1)
            #10 x = i;
        #20;
    end
endmodule
