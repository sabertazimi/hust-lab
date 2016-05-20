function [d,flag]=poly2routh(a)
%
%
%
%
%

row=size(a,2);
col=round(row/2);
dd=roots(a);
nd=length(dd);
roo=[' '*ones(nd,8),num2str(dd)];
fac=[' '*ones(1,8),poly2str(a,'s')];
% check a
chk=[sign(a(1)),sign(a)];
n=0;
gg=0;
if ~all(chk)
   n=1;
end
if chk(end)==0&all(chk(1:end-1))
   flag={''
      ''
      ' 特征方程系数a(n)~a(0)不满足系统稳定的必要条件'
      ' 因为只有a0=0，而其他系数不为零，所以系统属于临界稳定'
      ''
      ' 系统特征方程为'
      fac
      ''
      ' 特征方程根为'
      roo
   	''};
   d=[];
   return
end
for m=2:row+1
   if chk(m)~=chk(m-1)
      n=n+1;
   end
end
if n~=0
   flag={''
      ''
      ' 特征方程系数a(n)~a(0)不满足系统稳定的必要条件：'
      ' 特征方程所有系数同号且不为零' 
      ' 所以系统不稳定'
      ''
      ' 系统特征方程为'
      fac
      ''
      ' 特征方程根为'
      roo
   	''};
   d=[];
   return
end

%s=e;
%for m=2:col
%   s(1,m)=0;
%end
%b=zeros(row-1,col);
%b=[s;b];

format rat
b=zeros(row,col);
for m=1:col
   b(1,m)=a(2*m-1);
   if 2*m<=row
      b(2,m)=a(2*m);
   else
      b(2,m)=0;
   end
end

for i=3:row
   for j=1:col-1
      a1=b(i-2,1);
      a2=b(i-2,j+1);
      a3=b(i-1,1);
      a4=b(i-1,j+1);
      if a3==0&all([a1,a2,a4])
         f1=poly2sym(a,'s');
         f2=poly2sym([1,1],'s');
         f=f1*f2;
         a=sym2poly(f);
         [d,flag]=poly2routh(a);
         text={''
            ''
            ' 系统特征方程为'
            fac
            ' 特征方程根为'
            roo
            ''
            ' 由于在计算阵列的过程中出现某行首项为零的情况'
            ' 在此将方程乘以因式 (s+1) 再重新排出阵列进行判断'
            ' 此方法相当于增加极点 s=-1 '
            ' 因其位于左半平面，对判断系统稳定性不产生影响'
            ''};
         flag=[text;flag];
         flag2=1;
         return
      else
      	b(i,j)=(a3*a2-a1*a4)/a3;
      end
   end
   h=b(i,:);
   if ~any(h)
      mi=row-i+2;
      for t=1:col
         f(2*t-1)=b(i-1,t);
         f(2*t)=0;
      end
      f=f(1:mi);
      p=poly2sym(f,'s');
      ff=roots(f);
      mr=length(ff);
      if (mi-1)==mr
         gg=1;
      else gg=2;
      end
      
      dp=diff(p,'s',1);
      df=sym2poly(dp);
      df(end+1:2*col-1)=0;
      for t=1:col
         b(i,t)=df(2*t-1);
      end
   end
end
h=sign(b(:,1));
n=0;
for m=2:row
   if h(m)~=h(m-1)
      n=n+1;
   end
end
if n==0
   switch gg
   case 0
      flag={''
         ''
         ' 系统特征方程为'
         fac
         ''
         ' 该系统稳定'
         ''
         ' 特征方程根为'
         roo
         ''};
   case 1
      flag={''
         ''
         ' 系统特征方程为'
         fac
         ''
         ' 该系统临界稳定，在虚轴上有单极点' 
         ''
         ' 特征方程根为'
         roo
         ''};
   case 2
      flag={''
         ''
         ' 系统特征方程为'
         fac
         ''
         ' 该系统不稳定，在虚轴上具有重极点' 
         ''
         ' 特征方程根为'
         roo
         ''};
   end
               
else
   switch gg
   case 2
      flag={''
         ''
         ' 系统特征方程为'
         fac
         ''
         ' 该系统不稳定，在虚轴上具有重极点'
         ''
         ' 特征方程根为'
         roo
         ''};
   case 1
      flag={''
         ''
         ' 系统特征方程为'
         fac
         ''
         ' 该系统不稳定，在虚轴上有单极点' 
         ''
         ' 特征方程根为'
         roo
         ''};
   case 0
      flag={''
         ''
         '系统特征方程为'
         fac
         ''
         [' 该系统不稳定，有',num2str(n),'个根位于右半平面']
         ''
         ' 特征方程根为'
         roo
         ''};
   end
end

%d=subs(b,'NaN',0);
d=b;
