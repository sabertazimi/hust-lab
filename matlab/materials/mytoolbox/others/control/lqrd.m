function [k,s,e] = lqrd(a,b,q,r,nn,Ts)
%LQRD  Discrete linear-quadratic regulator design from continuous 
%      cost function.
%
%   [K,S,E] = LQRD(A,B,Q,R,Ts)  calculates the optimal gain matrix K 
%   such that the discrete state-feedback law  u[n] = -K x[n] 
%   minimizes a discrete cost function equivalent to the continuous 
%   cost function
%
%       J = Integral {x'Qx + u'Ru} dt
%                                             
%   subject to the discretized state dynamics x[n+1] = Ad x[n] + Bd u[n]
%   where [Ad,Bd] = C2D(A,B,Ts).  Also returned are the discrete Riccati 
%   equation solution S and the closed-loop eigenvalues E = EIG(Ad-Bd*K).
%
%   [K,S,E] = LQRD(A,B,Q,R,N,Ts)  handles the more general cost function
%   J = Integral {x'Qx + u'Ru + 2*x'Nu} dt . 
%
%   Algorithm:  the continuous plant (A,B,C,D) and continuous weighting 
%   matrices (Q,R,N) are discretized using the sample time Ts and 
%   zero-order hold approximation.  The gain matrix K is then calculated 
%   using DLQR.
%
%   See also  DLQR, LQR, C2D, and KALMD.

%   Clay M. Thompson 7-16-90
%   Revised: P. Gahinet  7-25-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.8 $  $Date: 1999/01/05 15:21:30 $

% Reference: This routine is based on the routine JDEQUIV.M by Franklin, 
% Powell and Workman and is described on pp. 439-441 of "Digital Control
% of Dynamic Systems".

ni = nargin;
error(nargchk(5,6,nargin));
[msg,a,b] = abcdchk(a,b); error(msg);
Nx = size(a,1); 
Nu = size(b,2);

% Set Ts and NN properly
if ni==5,
   Ts = nn;
   nn = zeros(Nx,Nu);
end

% Check dimensions and symmetry
if any(size(q)~=Nx),
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

% Determine discrete equivalent of continuous cost function 
% along with Ad,Bd matrices of discretized system
n = Nx+Nu;
Za = zeros(Nx); Zb = zeros(Nx,Nu); Zu = zeros(Nu);
M = [ -a' Zb   q  nn
      -b' Zu  nn'  r
      Za  Zb   a   b
      Zb' Zu  Zb' Zu];
phi = expm(M*Ts);
phi12 = phi(1:n,n+1:2*n);
phi22 = phi(n+1:2*n,n+1:2*n);
QQ = phi22'*phi12;
QQ = (QQ+QQ')/2;        % Make sure QQ is symmetric
Qd = QQ(1:Nx,1:Nx);
Rd = QQ(Nx+1:n,Nx+1:n);
Nd = QQ(1:Nx,Nx+1:n);
ad = phi22(1:Nx,1:Nx);
bd = phi22(1:Nx,Nx+1:n);


% Design the gain matrix using the discrete plant and discrete cost function
[s,e,k,report] = dare(ad,bd,Qd,Rd,Nd,'report');

% Handle failure
if report==-1,
   error('(Ad,Bd) or (Qd-Nd/Rd*Nd'',Ad-Bd/Rd*Nd'') has non minimal modes near unit circle.')
elseif report==-2,
   error('Discretized pair (Ad,Bd) is unstabilizable.')
end

% end lqrd

