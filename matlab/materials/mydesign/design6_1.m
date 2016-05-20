% design6_1.m
figure
alpha=[-0.5,0,0.5];
colorn=['b' 'm' 'c']
for n=1:3
   b=[1 0];  % 分子系数向量
   a=[1 alpha(n)];  % 分母系数向量
   printsys(b,a,'z')
   [Hz,w]=freqz(b,a);
   w=w./pi;
   magh=abs(Hz);
   zerosIndx=find(magh==0);
   magh(zerosIndx)=1;
   magh=20*log10(magh);
   magh(zerosIndx)=-inf;
   angh=angle(Hz);
   angh=unwrap(angh)*180/pi;
   subplot(1,2,1)
   plot(w,magh,colorn(n));
   hold on
   subplot(1,2,2)
   plot(w,angh,colorn(n));
   hold on
end
subplot(1,2,1)
xlabel('特征角频率(\times\pi rads/sample)')
title('幅频特性曲线 |H(w)| (dB)');
legend('a=-0.5','a=0','a=0.5')
hold off
subplot(1,2,2)
xlabel('特征角频率 (\times\pi rads/sample)')
title('相频特性曲线 \theta(w) (degrees)');
legend('a=-0.5','a=0','a=0.5')
hold off
   
