%  design1_2.m
tx = -4:0.01:4; % 时间周期起始点为 0,取样间隔 0.1,取样周期 2*pi
th = -4:0.01:4;
ty = -8:0.01:8;
x=(1-abs(tx)/4).*(Heaviside(tx+4)-Heaviside(tx-4));
h=Heaviside(th);
y=conv(x,h)*0.01;  % 卷积结果
figure
subplot(3,1,1);  % 多子图显示，将图形框分为 3x1 个子图，1号子图显示 x
plot(tx,x)
ylabel('输入激励');
subplot(3,1,2);  % 2号子图显示 h
plot(th,h)
ylabel('单位冲激响应');
subplot(3,1,3);  % 3号子图显示 y
plot(ty,y);
ylabel('输出响应');
