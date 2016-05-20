function [k,s,e] = dlqr(a,b,q,r,nn)
%DLQR  Linear-quadratic regulator design for discrete-time systems.
%
%   [K,S,E] = DLQR(A,B,Q,R,N)  calculates the optimal gain matrix K 
%   such that the state-feedback law  u[n] = -Kx[n]  minimizes the 
%   cost function
%
%         J = Sum {x'Qx + u'Ru + 2*x'Nu}
%
%   subject to the state dynamics   x[n+1] = Ax[n] + Bu[n].  
%
%   The matrix N is set to zero when omitted.  Also returned are the
%   Riccati equation solution S and the closed-loop eigenvalues E:                            
%                               -1
%    A'SA - S - (A'SB+N)(R+B'SB) (B'SA+N') + Q = 0,   E = EIG(A-B*K).
%
%
%   See also  DLQRY, LQRD, LQGREG, and DARE.

%   Author(s): J.N. Little 4-21-85
%   Revised    P. Gahinet  7-24-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.7 $  $Date: 1999/01/05 15:21:15 $

ni = nargin;
error(nargchk(4,5,ni));
if ni==4,
   nn = zeros(size(b));
end

% Check dimensions and symmetry
Nx = size(a,1);
Nu = size(b,2);
if Nx~=size(b,1),
   error('The A and B matrices must have the same number of rows.')
elseif any(size(q)~=Nx),
   error('The A and Q matrices must be the same size.')
elseif any(size(r)~=Nu),
   error('The R matrix must be square with as many columns as B.')
elseif ~isequal(size(nn),[Nx Nu]),
   error('The B and N matrices must be the same size.')
elseif norm(q'-q,1) > 100*eps*norm(q,1),
   warning('Q is not symmetric and has been replaced by (Q+Q'')/2).')
elseif norm(r'-r,1) > 100*eps*norm(r,1),
   warning('R is not symmetric and has been replaced by (R+R'')/2).')
end


% Enforce symmetry and check positivity
q = (q+q')/2;
r = (r+r')/2;
vr = real(eig(r));
vqnr = real(eig([q nn;nn' r]));
if min(vr)<=0,
   error('The R matrix must be positive definite.')
elseif min(vqnr)<-1e2*eps*max(0,max(vqnr)),
   warning('The matrix [Q N;N'' R] should be positive semi-definite.')
end


% Call DARE
[s,e,k,report] = dare(a,b,q,r,nn,'report');

% Handle failure
if report==-1,
   error('(A,B) or (Q-N/R*N'',A-B/R*N'') has non minimal modes near unit circle.')
elseif report==-2,
   error('(A,B) is unstabilizable.')
end

% end dlqr
