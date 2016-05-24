`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 16:47:01
// Design Name: 
// Module Name: _32bit_adder_tb
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


module _32bit_adder_tb(

    );
    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    wire cout;
    wire [31:0] s;
    integer i;
    integer j;
    
    _32bit_adder DUT (.a(a), .b(b), .cin(cin), .cout(cout), .s(s));
    
    initial begin
        #10000000 $finish;
    end
    
    initial begin
        a = 0; b = 0; cin = 0;
        for (i = 0 ; i < 500; i = i + 1) begin
            #2 a = i;
            #2
            for (j = 0; j < 500; j = j + 1) begin
                #2 b = j;
                #3;
                if ({cout, s} == (a + b + cin)) $display("Test Passed");
                else $display("Test Failed: %b + %b + %b != %b%b", a, b, cin, cout, s);
            end
        end
        #2 cin = 1;
        #2
        for (i = 0 ; i <500; i = i + 1) begin
            #2 a = i;
            #2
            for (j = 0; j < 500; j = j + 1) begin
                #2 b = j;
                #3;
                if ({cout, s} == (a + b + cin)) $display("Test Passed");
                else $display("Test Failed: %b + %b + %b != %b%b", a, b, cin, cout, s);
            end
        end
        #2 cin = 1;
        #2
        for (i = 200000 ; i <250000; i = i + 1) begin
             #2 a = i;
             #2
                    for (j = 0; j < 500; j = j + 1) begin
                        #2 b = j;
                        #3;
                        if ({cout, s} == (a + b + cin)) $display("Test Passed");
                        else $display("Test Failed: %b + %b + %b != %b%b", a, b, cin, cout, s);
                    end
        end
        #20;
    end
endmodule

