% design4_1.m
%   2 s^2 + 6 s + 5
%   ---------------
%       s^2 +  s

z=[-1.5+0.5i,-1.5-0.5i];  % 零点向量                           
p=[-1,0];  % 极点向量
k=2;  % 增益系数
[num,den]=zp2tf(z',p',k);
printsys(num,den,'s')
a1=poly2sym(num);
a2=poly2sym(den);
a=a1/a2;
ft=ilaplace(a);
figure
subplot(1,2,1)
rlocus(num,den)
title('像函数 F(s) 极、零图');
subplot(1,2,2)
ft=maple('convert',ft,'radical');
ezplot(ft,[0,4*pi])
title('时域原函数f(t)');
