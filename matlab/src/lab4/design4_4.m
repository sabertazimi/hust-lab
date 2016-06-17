% design4_4.m
%     1 - s
% --------------
%    s (s + 1)

syms s;
fs=sym((1-s)/(s^2+s))  %系统传递函数符号表达式
ft=ilaplace(fs);
ft=maple('convert',ft,'radical');
figure
ezplot(ft,[0,4*pi])
title('时域原函数f(t)');
