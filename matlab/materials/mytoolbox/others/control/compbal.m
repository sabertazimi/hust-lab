function [a,b,c,t] = compbal(a,b,c)
%COMPBAL  Balancing for SIMO state-space realizations in 
%    companion form.
%
%    [A1,B1,C1,T] = COMPBAL(A,B,C)  returns the balanced 
%    realization:
%            -1                   -1
%      A1 = T  * A * T  ,   B1 = T  * B  ,   C1 = C * T 
%         
%    where T is a diagonal matrix.

%    Authors: P. Gahinet, C. Moler, and A. Laub, 4-5-96
%    Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%    $Revision: 1.5 $  $Date: 1999/01/05 15:20:34 $

n = size(a,1);
ny = size(c,1);
if n==0,
   return
end

% Replace C by the norms of its columns in the SIMO case
if ny>1, 
   cnorms = max(abs(c),[],1);
else
   cnorms = c;
end

% Balance [a b;cnorms 0]
[t,abcd] = balance([a b;cnorms 0]);
s = t(n+1,n+1);
t = t(1:n,1:n);

% Extract transformed matrices
a = abcd(1:n,1:n);
b = abcd(1:n,n+1);
if ny>1,
   % Perform s\c*t in o(n^2) flops
   dt = diag(t);
   c = (c.*repmat(dt',size(c,1),1))/s;
else
   c = abcd(n+1,1:n);
end


% end compbal


