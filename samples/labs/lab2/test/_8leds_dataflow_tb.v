`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 20:17:02
// Design Name: 
// Module Name: _8leds_dataflow_tb
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


module _8leds_dataflow_tb(

    );
    reg [7:0] x;
    integer i;
    wire [7:0] y;
    
    _8leds_dataflow DUT (.x_in(x), .y_out(y));
    
    initial begin
        x =0;
        for (i = 0;i < 255; i = i + 1)
            #10 x = i;
        #20;
    end
endmodule
