function [k,s,e] = lqry(sys,q,r,nn)
%LQRY  Linear-quadratic regulator design with output weighting.
%
%   [K,S,E] = LQRY(SYS,Q,R,N) calculates the optimal gain matrix K 
%   such that: 
%
%     * if SYS is a continuous-time system, the state-feedback law  
%       u = -Kx  minimizes the cost function
%
%             J = Integral {y'Qy + u'Ru + 2*y'Nu} dt
%                                       .
%       subject to the system dynamics  x = Ax + Bu,  y = Cx + Du
%
%     * if SYS is a discrete-time system, u[n] = -Kx[n] minimizes 
%
%             J = Sum {y'Qy + u'Ru + 2*y'Nu}
%
%       subject to  x[n+1] = Ax[n] + Bu[n],   y[n] = Cx[n] + Du[n].
%                
%   The matrix N is set to zero when omitted.  Also returned are the
%   the solution S of the associated algebraic Riccati equation and 
%   the closed-loop eigenvalues E = EIG(A-B*K).
%
%   See also  LQR, DLQR, LQGREG, CARE, DARE.

%   J.N. Little 7-11-88
%   Revised: 7-18-90 Clay M. Thompson, P. Gahinet 7-24-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/05/05 14:09:14 $

ni = nargin;
error(nargchk(3,4,ni))
if ~isa(sys,'ss'),
   error('SYS must be a state-space LTI model.')
elseif hasdelay(sys),
   if sys.Ts,
      % Map delay times to poles at z=0 in discrete-time case
      sys = delay2z(sys);
   else
      error('Not supported for continuous-time delay systems.')
   end
elseif ni==3 | isempty(nn) | isequal(nn,0),
   nn = zeros(size(q,1),size(r,1));
end
   
% Extract system data 
[a,b,c,d,ee] = dssdata(sys);
Ts = sys.Ts;
Nx = size(a,1);
[Ny,Nu] = size(d);

% Check dimensions and symmetry
if any(size(q)~=Ny),
   error('Q must be symmetric with as many rows as C.')
elseif any(size(r)~=Nu),
   error('The R matrix must be square with as many columns as B.')
elseif ~isequal(size(nn),[Ny Nu]),
   error('The D and N matrices must be the same size.')
elseif norm(q'-q,1) > 100*eps*norm(q,1),
   warning('Q is not symmetric and has been replaced by (Q+Q'')/2).')
elseif norm(r'-r,1) > 100*eps*norm(r,1),
   warning('R is not symmetric and has been replaced by (R+R'')/2).')
end

% Derive parameters of equivalent LQR problem
nd = nn' * d;
qq = c'*q*c;
rr = r + d'*q*d + nd + nd';
nn = c'*(q*d + nn);

% Enforce symmetry and check positivity
qq = (qq+qq')/2;
rr = (rr+rr')/2;
vr = real(eig(rr));
vqnr = real(eig([qq nn;nn' rr]));
if min(vr)<=0,
   error('The matrix R+D''*Q*D+N''*D+D''*N must be positive definite.')
elseif min(vqnr)<-1e2*eps*max(0,max(vqnr)),
   warning('[C D;0 I]''*[Q N;N'' R]*[C D;0 I] should be positive semi-definite.')
end


% Perform synthesis
if Ts==0,
   % Continuous time: call CARE
   [s,e,k,report] = care(a,b,qq,rr,nn,ee,'report');

   % Handle failure
   if report==-1,
      error(...
        '(A,B) or (C''*Q*C,A) has non minimal modes near the imaginary axis (assuming N=0).')
   elseif report==-2,
      error('(A,B) is unstabilizable.')
   end
else
   % Discrete time: call DARE
   [s,e,k,report] = dare(a,b,qq,rr,nn,ee,'report');

   % Handle failure
   if report==-1,
      error('(A,B) or (C''*Q*C,A) has non minimal modes near unit circle (assuming N=0).')
   elseif report==-2,
      error('(A,B) is unstabilizable or (C''*Q*C,A) is undetectable (assuming N=0).')
   end
end

if ~isequal(ee,eye(size(a))),
   s = ee'*s*ee;  
   s = (s+s')/2;
end

% end lqry
