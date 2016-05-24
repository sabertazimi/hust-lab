`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 11:27:47
// Design Name: 
// Module Name: fulladder_dataflow_tb
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
