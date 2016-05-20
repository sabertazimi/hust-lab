function f=Dirat(t)
% DIRAT Unit Impulse function
% f=DiraT(t) returns a vector f the same size as
% the input vector, where the elememnt of f is 1 if the 
% corresponding element of t is nearly zero.
N=length(t);
for i=1:N
   if t(i)>=0
      a=t(i-1);
      b=t(i);
      break
   end
end
f=(t<=b&t>=a);
