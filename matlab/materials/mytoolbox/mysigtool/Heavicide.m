function f=Heavicide(tt)
% HEAVIcIDE Unit Step function
% f=Heavicide(t) returns a vector f the same size as
% the input vector, where each elememnt of f is 1 if the 
% corresponding element of t is greater than zero.
N=length(tt);
for i=1:N
   if tt(i)>=0
      a=tt(i-1)
      break
   end
end
f=(t>=a);
