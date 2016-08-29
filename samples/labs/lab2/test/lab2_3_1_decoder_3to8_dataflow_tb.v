`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: decoder_3to8_dataflow_tb
//////////////////////////////////////////////////////////////////////////////////

module decoder_3to8_dataflow_tb(
    );
    
    reg [2:0] x;
	wire [7:0] y;
	integer k;
    
    decoder_3to8_dataflow DUT (.x(x), .y(y));   
 
    initial
    begin
      x = 0; 
	for (k=0; k < 8; k=k+1)
		#5 x=k;
	#10;
    end

endmodule
