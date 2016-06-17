% design2_6.m

sym t;
f=sym('exp(-2*t)*Heaviside(t)');  % 信号的符号表达式
F=fourier(f);  % 得到 Fourier 变换的符号表达式
FF=maple('convert',F,'piecewise');  % 对 Fourier 变换的符号表达式进行转换，使其便于画图
FFF=abs(FF);  % 得到频谱符号表达式
figure
subplot(1,2,1)
ezplot(f,[-4*pi,4*pi])
title('时域波形 f(t)');
subplot(1,2,2)
ezplot(FFF,[-4*pi,4*pi])
title('频域波形 F(jw)');