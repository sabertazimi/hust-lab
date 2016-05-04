`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: calc_even_parity_task_tb
//////////////////////////////////////////////////////////////////////////////////

module calc_even_parity_task_tb (
    );
    
    reg [7:0] ain;
    wire parity;
	integer k;
    
    calc_even_parity_task DUT (.ain(ain), .parity(parity));
     
    initial
    begin
      ain = 8'ha8; 
	$display("ain=%h, parity=%b, at time=%t",ain, parity, $time);
	for (k=0; k < 5; k=k+1)
	begin
		#5 ain = ain + k; 
		$display("ain=%h, parity=%b, at time=%t",ain, parity, $time);
	end
	$display("Simulation Done");
    end
    
endmodule
