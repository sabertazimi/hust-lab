% design2_3.m

sym t;
f=sym('Heaviside(t+2)-Heaviside(t-2)');  % 信号的符号表达式
F=fourier(f);  % 得到 Fourier 变换的符号表达式
FF=maple('convert',F,'piecewise');  % 对 Fourier 变换的符号表达式进行转换，使其便于画图
FFF=abs(FF);  % 得到频谱符号表达式
figure
subplot(1,2,1)
ezplot(f,[-2*pi,2*pi])
title('时域波形 f(t)');
subplot(1,2,2)
ezplot(FFF,[-5*pi,5*pi])
title('频域波形 F(jw)');