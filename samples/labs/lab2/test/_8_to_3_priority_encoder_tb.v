`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 14:50:35
// Design Name: 
// Module Name: _8_to_3_priority_encoder_tb
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


module _8_to_3_priority_encoder_tb(

    );
    reg [7:0] v;
    reg in;
    wire [2:0] y;
    wire out;
    wire gs;
    
    _8_to_3_priority_encoder DUT (.v(v), .en_in_n(in), .y(y), .en_out(out), .gs(gs));
    
    initial begin
        {in, v} = 9'b1_xxxx_xxxx;
        #10 {in, v} = 9'b1_xxxx_xxxx;
        #10 {in, v} = 9'b0_1111_1111;
        #10 {in, v} = 9'b0_xxxx_xxx0;
        #10 {in, v} = 9'b0_xxxx_xx01;
        #10 {in, v} =9'b0_xxxx_x011 ;
        #10 {in, v} =9'b0_xxxx_0111 ;
        #10 {in, v} = 9'b0_xxx0_1111;
        #10 {in, v} = 9'b0_xx01_1111;
        #10 {in, v} = 9'b0_x011_1111;
        #10 {in, v} = 9'b0_0111_1111;
        #20;
    end
endmodule
