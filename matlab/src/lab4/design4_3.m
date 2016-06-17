% design4_3.m
%      s + 1
% --------------
%  s^2 + s + 1

syms s;
fs=sym((s+1)/(s^2+s+1))  %系统传递函数符号表达式
ft=ilaplace(fs);
ft=maple('convert',ft,'radical');
figure
ezplot(ft,[0,4*pi])
title('时域原函数f(t)');
