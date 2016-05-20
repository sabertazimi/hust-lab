% design10_1.m
figure
ct='2*sin(4*pi*t)+5*cos(8*pi*t)';
NUM1=45;
NUM2=65;
number=0:NUM1-1;
number1=number*2*pi/NUM1;
t=0.01*number;
x=eval(ct);
X1=fft(x,NUM1);
xw=x+randn(1,NUM1);
Y1=fft(xw,NUM1);
number=0:NUM2-1; 
t=0.01*number;
number2=number*2*pi/NUM2;
x=eval(ct);
X2=fft(x,NUM2);
xw=x+randn(1,NUM2);
Y2=fft(xw,NUM2);
subplot(2,2,1)
plot(number1,abs(X1))
title('FFT N=45');
subplot(2,2,2)
plot(number2,abs(X2))
title('FFT N=65');
subplot(2,2,3)
plot(number1,abs(Y1))
title('FFT N=45(ÕıÌ¬ÔëÉù£©');
subplot(2,2,4)
plot(number2,abs(Y2))
title('FFT N=65(ÕıÌ¬ÔëÉù£©');
