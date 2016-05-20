function text=gettext(x,sig)
%
%
%
if nargin<1
   error('text=gettext(x,sig)');
elseif nargin<2
   sig='x';
end

k=length(x);
text=cell(ceil(k/5),5);
for i=1:k;
   t=[sig,'(',num2str(i),')=',num2str(x(i))];
   m=ceil(i/5);
   n=rem(i,5);
   if n==0
      n=5;
   end
   text{m,n}=t;
end
