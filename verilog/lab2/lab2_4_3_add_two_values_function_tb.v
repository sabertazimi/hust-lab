`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: add_two_values_function_tb
//////////////////////////////////////////////////////////////////////////////////

module add_two_values_function_tb (
    );
    
    reg [3:0] ain, bin;
	wire [4:0] sum;
	integer k;
    
    add_two_values_function DUT (.ain(ain), .bin(bin), .sum(sum));
     
    initial
    begin
      ain = 4'h6; bin = 4'ha;
	#2 $display("ain=%b, bin=%b, sum=%b at time=%t",ain, bin, sum, $time);
	for (k=0; k < 5; k=k+1)
	begin
		#5 ain = ain + k; bin = bin + k;
		#2 $display("ain=%b, bin=%b, sum=%b at time=%t",ain, bin, sum, $time);
	end
	$display("Simulation Done");
    end
    
endmodule
