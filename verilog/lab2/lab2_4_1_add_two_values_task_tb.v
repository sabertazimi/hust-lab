`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: add_two_values_task_tb
//////////////////////////////////////////////////////////////////////////////////

module add_two_values_task_tb (
    );
    
    reg [3:0] ain, bin;
    wire cout;
	wire [3:0] sum;
	integer k;
    
    add_two_values_task DUT (.ain(ain), .bin(bin), .cout(cout), .sum(sum));
     
    initial
    begin
      ain = 4'h6; bin = 4'ha;
	$display("ain=%b, bin=%b, cout=%b, sum=%b at time=%t",ain, bin, cout, sum, $time);
	for (k=0; k < 5; k=k+1)
	begin
		#5 ain = ain + k; bin = bin + k;
		$display("ain=%b, bin=%b, cout=%b, sum=%b at time=%t",ain, bin, cout, sum, $time);
	end
	$display("Simulation Done");
    end
    
endmodule
