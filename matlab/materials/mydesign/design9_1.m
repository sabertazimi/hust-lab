% design9_1.m
N=30;
n=0:N-1;
xn=exp(-0.1*n);
figure
subplot(3,1,1)
stem(n,xn)
ylabel('原序列x(n)');
Xk=dft(xn,N);
magXk=abs(Xk);
angXk=angle(Xk);
angXk=unwrap(angXk)*180/pi;
subplot(3,1,2)
stem(n,magXk)
ylabel('幅度响应 |X(K)|');
subplot(3,1,3)
stem(n,angXk)
ylabel('相位响应 \theta(K)');
