function r = genrloc(sys,z,p,k)
%GENRLOC Generates points along root locus
%
%   R = GENRLOC(SYS,Z,P,K)  computes the poles R of the 
%   negative feedback loop
%   
%        ---->o---->| SYS |---+--->
%             |               |
%             +<-----| G |----+
%
%   for the values of the gain G specified in the vector K.
%   The vectors Z and P contain the zeros and poles of SYS
%   and the matrix R is N-by-length(K) where N is the number 
%   of closed-loop poles.
%
%   See also  ROCUS and RLOCFIND.

%   Author(s): P. Gahinet 7-9-97
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1997/12/01 22:05:37 $

% Extract state-space data
[a,b,c,d] = ssdata(sys);
n = size(a,1);

% Pre-allocate space for R
lk = length(k);
r = zeros(n,lk);
r(:) = Inf;

% For all k, determine the roots of den+k*num
for i=1:(n>0)*lk,
   ki = k(i);
   if ~isfinite(ki),
      clr = z;
   elseif ki==0,
      clr = p;
   else
      ff = 1+d*ki;
      if abs(ff)>sqrt(eps),
         clr = eig(a-b*(c*ki/ff));
      else
         % Near-zero feedthrough 1+D*K: compute the closed-loop poles 
         % as the zeros of (A,B,C*K,1+D*K)
         clr = tzero(a,b,c*ki,ff);
      end
   end
   nclr = length(clr);
   r(n-nclr+1:n,i) = clr;
end

% end genrloc
