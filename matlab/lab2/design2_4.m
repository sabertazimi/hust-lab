% design2_4.m

sym t;
f=sym('(1-abs(t))*(Heaviside(t+1)-Heaviside(t-1))');  % 信号的符号表达式
F=fourier(f);  % 得到 Fourier 变换的符号表达式
FF=maple('convert',F,'piecewise');  % 对 Fourier 变换的符号表达式进行转换，使其便于画图
FFF=abs(FF);  % 得到频谱符号表达式
figure
subplot(1,2,1)
ezplot(f,[-pi,pi])
title('时域波形 f(t)');
subplot(1,2,2)
ezplot(FFF,[-8*pi,8*pi])
title('频域波形 F(jw)');