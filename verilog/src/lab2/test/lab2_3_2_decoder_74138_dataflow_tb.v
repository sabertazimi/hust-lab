`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: decoder_74138_dataflow_tb
//////////////////////////////////////////////////////////////////////////////////

module decoder_74138_dataflow_tb(
    );
    
    reg [2:0] x;
	reg g1, g2a_n, g2b_n;
	wire [7:0] y;
	integer k;
    
    decoder_74138_dataflow DUT (.g1(g1), .g2a_n(g2a_n), .g2b_n(g2b_n), .x(x), .y(y));   
 
    initial
    begin
      x = 0; g1 = 0; g2a_n = 1; g2b_n = 1;
	for (k=0; k < 8; k=k+1)
		#5 x=k;
	#10;
      x = 0; g1 = 1; g2a_n = 0; g2b_n = 1;
	for (k=0; k < 8; k=k+1)
		#5 x=k;
	#10;
      x = 0; g1 = 0; g2a_n = 1; g2b_n = 0;
	for (k=0; k < 8; k=k+1)
		#5 x=k;
	#10;
      x = 0; g1 = 1; g2a_n = 0; g2b_n = 0;
	for (k=0; k < 8; k=k+1)
		#5 x=k;
	#10;
    end

endmodule
