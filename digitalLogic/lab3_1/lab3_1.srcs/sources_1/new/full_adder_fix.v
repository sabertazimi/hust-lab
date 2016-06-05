`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/05 19:03:48
// Design Name: 
// Module Name: full_adder_fix
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


module full_adder_fix(Ai,Bi,Ci_1,F,Si,Ci);
    input Ai,Bi,Ci_1;
    output F, Si,Ci;
    wire s,t1,t2,t3;
    wire [1:0] m;
    xor #2
        ax1(s,Ai,Bi),
        
        ax2(m[1],s,m[0]);
    and #2
        aa1(t2,m[0],s),
        aa2(t1,Ai,Bi),
        aa3(t3,t1,1),       // empty delay
        aa4(m[0],Ci_1,1);   // empty delay
    or #2
        ao2(Si,m[1],0),     // empty delay
        ao1(Ci,t2,t3);
    xnor #2
        an1(F,Si,Ci);
endmodule
