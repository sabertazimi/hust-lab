`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 12:23:49
// Design Name: 
// Module Name: carry_look_ahead_adder_tb
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


module carry_look_ahead_adder_tb(

    );
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire cout;
    wire [3:0] s;
        wire [3:0] p;
    wire [3:0] g;
    wire [3:0] c;
    integer i;
    integer j;
    
    carry_look_ahead_adder DUT (.a(a), .b(b), .cin(cin), .cout(cout), .s(s), .p(p), .g(g), .c(c));
    
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
