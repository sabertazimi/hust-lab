`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fulladder_dataflow_tb
//////////////////////////////////////////////////////////////////////////////////

module fulladder_dataflow_tb(
    );
    
    reg a, b, cin;
	wire cout, s;
    
    fulladder_dataflow DUT (.a(a), .b(b), .cin(cin), .cout(cout), .s(s));
    
 
    initial
    begin
      a = 0; b = 0; cin = 0;
	#10 a = 1;
	#10 b = 1; a = 0;
	#10 a = 1;
	#10 cin = 1; a = 0; b = 0;
	#10 a = 1;
	#10 b = 1; a = 0;
	#10 a = 1;
	#10;
    end

endmodule
