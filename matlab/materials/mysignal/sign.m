function f=sign(x)
%
%
% SIGN  Signum function.
% f=sign(x)
% For each element of X, SIGN(X) returns 1 if the element
% is greater than zero, 0 if it equals zero and -1 if it is
% less than zero.  For complex X, SIGN(X) = X ./ ABS(X). %
if isreal(x)
   if x<0
      f=-1;
   elseif x==0
      f=0;
   else
      f=1;
   end
else
   f=x./abs(x);
end

      