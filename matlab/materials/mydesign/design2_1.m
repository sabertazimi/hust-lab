% 修正原design2_1.m（现在的design2_1_bak.m），改变不能运行的函数以及谐波的个数改少
clear
TT=10;  % 周期信号周期
N=10;  % 希望看到的谐波次数
syms t T k;  % 定义时间 t、周期 Ta、下标 k 三个符号
y=subs(sym('Heaviside(t+T/10)-Heaviside(t-T/10)'),'T',TT);  % 锯齿脉冲基础波形，tao/T=1/5
A0=int(y,t,-TT/2,TT/2)/TT;  % 直流分量 A0
% 利用符号法得到各频率分量的复数 Fourier 系数 Ak 的符号表达式
Ak=int(y*exp(-2*i*pi*k*t/TT),t,-TT/2,TT/2)/TT;  
% 利用 symmul 命令得到 Ak*exp(2*j*k*pi*t/T) 的符号表达式
%fk=symmul(Ak,sym(exp(2*i*k*pi*t/TT))); 
%fk=symmul(Ak,exp(2*i*k*pi*t/TT));
fk=sym(Ak)*sym(exp(2*i*k*pi*t/TT));
% 计算 k 在区间 [-N,N] 内的 Fourier 系数，存入向量 a（长度为 2*N+1）
for m=-N:-1
%   a(m+N+1)=numeric(subs(Ak,k,m));
    a(m+N+1)=double(subs(Ak,k,m));
end
%a(N+1)=numeric(A0);
a(N+1)=double(sym(A0));
for m=1:N
   a(m+N+1)=double(subs(Ak,k,m));
end  % for
% 利用 symmul 命令进行符号求和，得到综合信号 f
f=symsum(fk,k,-N,-1)+A0+symsum(fk,k,1,N);

% 图形显示结果
figure
n=-N:N;
as=abs(a)*2;  % 由 Fourier 系数得到频谱幅度
subplot(3,1,1)
ezplot(y,[-TT,TT])
ylabel('原函数');
subplot(3,1,2)
ezplot(f,[-TT,TT])
ylabel('合成函数');
subplot(3,1,3)
stem(n,as)
ylabel('幅度频谱图');

