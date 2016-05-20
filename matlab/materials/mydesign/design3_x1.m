% design3_1.m

figure
subplot(1,2,1)
grid on
hold on
subplot(1,2,2)
grid on
hold on
for ah=0.1:0.22:0.76
   b=[ah];  % 分子系数向量
   a=[(ah-ah.^2)*500*15*1e-12 1];  % 分母系数向量
   printsys(b,a,'s')
   [Hz,w]=freqs(b,a);
   w=w./pi;
   magh=abs(Hz);
   angh=angle(Hz);
   angh=unwrap(angh)*180/pi;  % 角度换算
   subplot(1,2,1)
   plot(w,magh);
   subplot(1,2,2)
   semilogx(w,angh);
end
subplot(1,2,1)
title('幅频特性曲线 |H(w)|');
hold off
subplot(1,2,2)
title('相频特性曲线 \theta(w) (degrees)');
hold off