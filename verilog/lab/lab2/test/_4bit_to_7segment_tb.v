`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 22:49:12
// Design Name: 
// Module Name: _4bit_to_7segment_tb
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


module _4bit_to_7segment_tb(

    );
        reg [3:0] x;
        wire [6:0] seg;
        integer i;
    
        
        _4bit_to_7segment DUT (.x(x),  .seg(seg));
        
        initial begin
            x = 0;
            for (i = 0; i < 10; i = i + 1)
                #10 x = i;
            #20;
        end
endmodule
