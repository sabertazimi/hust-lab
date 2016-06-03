`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 11:34:51
// Design Name: 
// Module Name: full_adder
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


module full_adder (Ai,Bi,Ci_1,F,Si,Ci);
    input Ai,Bi,Ci_1;
    output F, Si,Ci;
    wire s1,s2,t3,t4,s5,s6;
    wire [2:0] q;
    wire [1:0] m;
    not #2
        at1(q[0],Ai),
        at2(q[1],Bi),
        at3(q[2],Ci_1);
    xor #2
        ax1(s1,Ai,Bi),
        
        ax2(m[1],s1,m[0]);
    and #2
        aa1(t2,m[0],s1),
        aa2(t1,Ai,Bi),
        aa3(t3,t1,1),       // empty delay
        aa4(m[0],Ci_1,1);   // empty delay
    or #2
        ao2(Si,m[1],0),     // empty delay
        ao1(Ci,t2,t3);
    xnor #2
        an1(F,Si,Ci);
endmodule
