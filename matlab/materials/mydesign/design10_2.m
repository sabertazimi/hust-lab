% design10_2.m
x=[1 0 -1 0 1 2 4 5 8 6 5 4 2 0 ];
h=[1 2 0 -2  -1 -2 ];
N=max(length(x),length(h));
y=circonvt(x,h,length(x)+length(h)-1);  % 循环卷积函数 circonvt
figure
subplot(3,1,1)
nx=0:length(x)-1;
stem(nx,x)
ylabel('输入激励序列 x');
subplot(3,1,2)
nh=0:length(h)-1;
stem(nh,h)
ylabel('单位冲激响应序列 h');
subplot(3,1,3)
ny=0:length(y)-1;
stem(ny,y)
ylabel('输出响应序列 y');
