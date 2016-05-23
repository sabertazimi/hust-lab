`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: calc_ones_function_tb
//////////////////////////////////////////////////////////////////////////////////

module calc_ones_function_tb (
    );
    
    reg [7:0] ain;
	wire [2:0] number_of_ones;
	integer k;
    
    calc_ones_function DUT (.ain(ain), .number_of_ones(number_of_ones));
     
    initial
    begin
      ain = 8'h4a; 
      #5;
	#2 $display("ain=%h, number_of_ones=%d at time=%t",ain, number_of_ones, $time);
	for (k=0; k < 5; k=k+1)
	begin
		#5 ain = ain + k; 
		#2 $display("ain=%h, number_of_ones=%d at time=%t",ain,  number_of_ones, $time);
	end
	$display("Simulation Done");
    end
    
endmodule
