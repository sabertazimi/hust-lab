%  design1_2.m
R=10;  % 电阻值
C=4;  % 电容值
U0=2;  % 电容电压初始值
S=[num2str(R), '*', num2str(C), '*Dy+', 'y=heaviside(t-2)'];  % 得到微分方程的字符串表达式
init=['y(0)=',num2str(U0)];  % 得到初始条件的字符串表达式
y=dsolve(S,init,'t');  % 求解微分方程，得到符号解
t=0:0.01:2*pi;
x=ones(1,length(t));  % 得到时间范围 t 内的阶跃信号 u(t) 的离散抽样序列 x
figure
subplot(1,2,1);  % 多子图显示，将图形框分为 1x2 个子图，1号子图显示阶跃信号 x
plot(t,x)
title('激励电压');
subplot(1,2,2);  % 2号子图显示输出响应 ys
ezplot(y,[0,100*pi])
title('输出响应')
