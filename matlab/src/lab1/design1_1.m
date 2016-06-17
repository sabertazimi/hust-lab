%  design1_1.m
t = 0:0.01:4; % 时间周期起始点为 0,取样间隔 0.1,取样周期 2*pi
ty = 0:0.01:8;
x=exp(-1*t).*(Heaviside(t)-Heaviside(t-2));
h=2*(Heaviside(t)-Heaviside(t-2));
y=conv(x,h)*dt;  % 卷积结果
figure
subplot(3,1,1);  % 多子图显示，将图形框分为 3x1 个子图，1号子图显示 x
plot(t,x)
ylabel('输入激励');
subplot(3,1,2);  % 2号子图显示 h
plot(t,h)
ylabel('单位冲激响应');
subplot(3,1,3);  % 3号子图显示 y
plot(ty,y);
ylabel('输出响应');
