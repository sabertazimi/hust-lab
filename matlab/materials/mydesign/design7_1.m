% design 7_1.m
dt=0.15;
i=[2 1];
a=[1 0;0 1];
b=[1 0 0 0;0 -1 0 1];
c=[0.5 0;0 1.5];
d=[0 1 0 0;0 0 0 0];
u1=mycal(1,dt);
u2=mycal(2,dt);
u3=mycal(3,dt);
u4=mycal(4,dt);
u=[u1;u2;u3;u4];
t=0:dt:2*pi;
SYS=SS(a,b,c,d);
[ys,ts,xs]=lsim(SYS,u,t,i);
figure
subplot(2,1,1)
hold on
plot(t,xs(:,1),'b')
plot(t,xs(:,2),'m')
legend('x1(t)','x2(t)')
hold off
title('状态变量 x1(t) x2(t)')
subplot(2,1,2)
hold on
plot(t,ys(:,1),'b')
plot(t,ys(:,2),'m')
legend('y1(t)','y2(t)')
hold off
title('输出响应 y1(t) y2(t)')
