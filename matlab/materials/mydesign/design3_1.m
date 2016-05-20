% design3_1.m

b=[1,2,1];  % 分子系数向量
a=[2,3,4,1,2];  % 分母系数向量
printsys(b,a,'s')
[Hz,w]=freqs(b,a);
w=w./pi;
magh=abs(Hz);
zerosIndx=find(magh==0);
magh(zerosIndx)=1;
magh=20*log10(magh);  % 以分贝
magh(zerosIndx)=-inf;
angh=angle(Hz);
angh=unwrap(angh)*180/pi;  % 角度换算
figure
subplot(1,2,1)
plot(w,magh);
grid on
%set(H(2,2),'xlim',[0,1])
xlabel('特征角频率(\times\pi rads/sample)')
title('幅频特性曲线 |H(w)| (dB)');
subplot(1,2,2)
plot(w,angh);
grid on
xlabel('特征角频率 (\times\pi rads/sample)')
title('相频特性曲线 \theta(w) (degrees)');
