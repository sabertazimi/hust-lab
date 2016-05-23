`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/23 20:47:06
// Design Name: 
// Module Name: mux_2bit_2_to_1_behavioral_tb
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


module mux_2bit_2_to_1_behavioral_tb(
    );
    
    reg[1:0]  x, y;
	reg s;
    wire[1:0]  m;
    
    mux_2bit_2_to_1_behavioral DUT (.x(x), .y(y), .s(s), .m(m));
    
    initial begin
    x = 0; y = 0; s = 1;
    #10 y = 0;
    #10 y = 1;
    #10 y = 2;
    #10 y = 3;
    #10 y = 0;
    #10 y = 1;
    #10 y = 2;
    #10 y = 3;
    #10 s = 0;
    #10 x = 0;
    #10 x = 1;
    #10 x = 2;
    #10 x = 3;
    #10 x = 0;
    #10 x = 1;
    #10 x = 2;
    #10 x = 3;
	#20;
    end

endmodule
