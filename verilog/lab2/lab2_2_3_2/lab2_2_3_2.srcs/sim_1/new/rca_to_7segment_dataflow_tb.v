`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 12:15:15
// Design Name: 
// Module Name: rca_to_7segment_dataflow_tb
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


module rca_to_7segment_dataflow_tb(

    );
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire z;
    wire [6:0] seg;
    integer i;
    integer j;
    
    rca_to_7segment_dataflow DUT (.a(a), .b(b), .cin(cin), .z(z), .seg(seg));
    
    initial begin
        a = 0; b = 0; cin = 0;
        for (i = 0 ; i < 16; i = i + 1) begin
            #10 a = i;
            for (j = 0; j < 16; j = j + 1) begin
                #10 b = j;
            end
        end
        #10 cin = 1;
        for (i = 0 ; i < 16; i = i + 1) begin
            #10 a = i;
            for (j = 0; j < 16; j = j + 1) begin
                #10 b = j;
            end
        end
        #20;
    end
endmodule
