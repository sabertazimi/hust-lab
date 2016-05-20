% design4_2.m
%       5
% -------------
%   5 s^2 + s

syms s;
fs=sym(5/(5*s^2+s))  %系统传递函数符号表达式
ft=ilaplace(fs);
ft=maple('convert',ft,'radical');
figure
ezplot(ft,[0,4*pi])
title('时域原函数f(t)');
