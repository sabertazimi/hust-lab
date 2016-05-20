function [x,n]=stepseq(n0,n1,n2)
% Generates [y,n]=u(n-n0);n1<=n,n0<=n2
% ----------------------------------
% [x,n]=stepseq(n0,n1,n2)
%
if ((n0<n1)|(n0>n2)|(n1>n2))
   error('arguments must satisfy n1<=n0<=n2')
end
n=[n1:n2];
x=[(n-n0)>=0];
