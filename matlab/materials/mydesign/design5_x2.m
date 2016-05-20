% design5_x2
% y(k)-y(k-1)+0.35y(k-2)=2f(k)-f(k-1)
clear
a1=1;
a2=2;
a3=a2-0.35*a1+2%0;  % y(0)
a4=a3-0.35*a2+1%2;  % y(1)
a5=a4-0.35*a3+1%2*2-1;  % y(2)
y=[1:22];
%y=[1:20]';
%y(1)=a4;
%y(2)=a5;
y(1)=a1;
y(2)=a2;
y(3)=a3;
y(4)=a4;
y(5)=a5;
%for m=1:20
for m=6:22
   y(m)=y(m-1)-0.35*y(m-2)+1;
   %y(m+2)=y(m+1)-0.35*y(m)+2*(m+2)-(m+1);
end
x=[0 0 1*ones(1,20)]
y
%x=[1:22];
figure
subplot(2,1,1)
stem(x)
ylabel('ÊäÈë¼¤Àø')
subplot(2,1,2)
stem(y')
ylabel('Êä³öÏìÓ¦')
