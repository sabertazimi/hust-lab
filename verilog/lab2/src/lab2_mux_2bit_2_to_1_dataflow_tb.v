`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: mux_2bit_2_to_1_dataflow_tb
//////////////////////////////////////////////////////////////////////////////////

module lab2_1_mux_2bit_2_to_1_dataflow_tb(
    );
      reg[1:0]  x, y;
	reg s;
    wire[1:0]  m;

    lab2_1_mux_2bit_2_to_1_dataflow DUT (.x(x), .y(y), .s(s), .m(m));


    initial
    begin
      x = 0; y = 0; s = 0;
      #10 s = 1;
      #10 s = 0; y = 1;
      #10 s = 1;
      #10 x = 1; y = 0; s = 0;
      #10 s = 1;
      #10 y = 1;s = 0;
      #10 s = 1;
      #10 x = 1; y = 1; s = 0;
            #10 s = 1;
            #10 s = 0; y = 3;
            #10 s = 1;
            #10 x = 3; y = 1; s = 0;
            #10 s = 1;
            #10 y = 3;s = 0;
            #10 s = 1;
	#20;
    end

endmodule
