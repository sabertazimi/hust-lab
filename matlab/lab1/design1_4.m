a=[1,0.5];b=1; % 微分方程系数
t=[0:0.1:5]; tf=t(end);dt=tf/(length(t)-1);
u=cos(t); % 输入激励
%用留数法求冲激响应
[r,p]=residue(b,a);
h=r(1)+exp(p(1)*t);
%画出冲激响应
subplot(2,1,1);
plot(t,h);
grid;
%求u和h的卷积，得输出y(t)
y=conv(u,h)*dt;
%画出y(t)
subplot(2,1,2);
plot(t,y(1:length(t)));
grid;