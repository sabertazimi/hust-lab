%================================
function f=mycal(n,T)
%================================
switch n
case 1
   t=0:T:2*pi;
   n2=length(t)-1;
   [f,t1]=impseq(0,0,n2);
case 2
   t=0:T:2*pi;
   n2=length(t)-1;
   [f,t1]=stepseq(0,0,n2);
case 3
   t=0:T:2*pi;
	f=sin(t);
case 4
   t=0:T:2*pi;
   f=exp(-t);
end   
