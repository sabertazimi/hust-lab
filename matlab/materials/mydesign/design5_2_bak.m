% design5_2.m
% y(k)-y(k-1)+0.35y(k-2)=2x(k)-x(k-1)

N=2;  % 差分方程阶数
a=[1 -1 0.35];  % 差分方程系数向量 a(0)~a(N)
b=[2 -1];  % 差分方程系数向量 b(0)~b(N)
k=20;  % 输出样点数目
zi=[2 1];  % 初始状态 N 个
yzi=[0*ones(1,k+N+1)];
h=yzi;
yzs=yzi;
for n=1:N
   yzi(n)=zi(N-n+1);
end
y=yzi;
n=[-N:k];
x=impseq(0,-N,k);
zic=filtic(b,a,zi);
h(N+1:end)=filter(b,a,x(N+1:end)); % 或由命令 dimpulse 实现
x=stepseq(0,-N,k);
yzs(N+1:end)=filter(b,a,x(N+1:end));
yzi(N+1:end)=filter([0 0],a,x(N+1:end),zic);
y(N+1:end)=filter(b,a,x(N+1:end),zic);
figure
subplot(3,1,1)
stem(n,x)
title('激励 x(n)');
subplot(3,1,2)
stem(n,h)
title('冲激响应 h(n)');
subplot(3,1,3)
hold on
stem(n,yzs,'g')
stem(n,yzi,'r')
stem(n,y)
hold off
legend('yzs','yzs','yzi','yzi','y','y')
title('输出响应 y(n)');
text={...
   ''
   '  单位冲激响应 h='
   ''
   [' '*ones(1,12),num2str(h)]
   ''
   '  零状态响应 yzs='
   ''
   [' '*ones(1,12),num2str(yzs)]
   ''
   '  零输入响应 yzi='
   ''
   [' '*ones(1,12),num2str(yzi)]
   ''
   '  全响应 y='
   ''
   [' '*ones(1,12),num2str(y)]
   ''};
textwin('差分方程数值解',text)
