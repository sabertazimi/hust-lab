% design6_3.m
%         1 - z^-1
% -----------------------
%         1 + 0.81z^-2
figure
colorn=['b' 'm' 'c']
for n=1:1
   b=[1 -1 0];  % 分子系数向量
   a=[1 0 0.81];  % 分母系数向量
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
hold off
subplot(1,2,2)
xlabel('特征角频率 (\times\pi rads/sample)')
title('相频特性曲线 \theta(w) (degrees)');
hold off
   
