function [X,L,G,RR] = dare(A,B,Q,varargin)
%DARE  Solve discrete-time algebraic Riccati equations.
%
%   [X,L,G,RR] = DARE(A,B,Q,R,S,E)  computes the unique symmetric 
%   stabilizing solution X of the discrete-time algebraic Riccati 
%   equation
%                                      -1 
%    E'XE = A'XA - (A'XB + S)(B'XB + R)  (A'XB + S)' + Q
%
%   or, equivalently (if R is nonsingular)
%                                -1             -1                 -1
%    E'XE = F'XF - F'XB(B'XB + R)  B'XF + Q - SR  S'  with  F:=A-BR  S'.
%
%   When omitted, R,S and E are set to the default values R=I, S=0, 
%   and E=I.  Additional optional outputs include the gain matrix
%                        -1
%          G = (B'XB + R)  (B'XA + S'),
%
%   the vector L of closed-loop eigenvalues (i.e., EIG(A-B*G,E)), 
%   and the Frobenius norm RR of the relative residual matrix.  
%
%   [X,L,G,REPORT] = DARE(A,B,Q,...,'report')  turns off error 
%   messages and returns a success/failure diagnosis REPORT instead.
%   The value of REPORT is 
%     * -1 if symplectic pencil has eigenvalues too close to unit circle,
%     * -2 if X=X2/X1 with X1 singular
%     * the relative residual RR when DARE succeeds.
%
%   [X1,X2,L,REPORT] = DARE(A,B,Q,...,'implicit')  also turns off 
%   error messages, but now returns matrices X1,X2 such that X=X2/X1. 
%   REPORT=0 indicates success.
%
%   See also  CARE.

%      Author(s): Alan J. Laub (1993)  (laub@ece.ucsb.edu)
%	           with key contributions by Pascal Gahinet, Cleve Moler,
%                  and Andy Potvin
%	Revised: 94-10-29, 95-07-20, 95-07-24, 96-01-09
%       Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%       $Revision: 1.14 $

%       Assumptions: E is nonsingular, Q=Q', R=R', and the associated
%                    symplectic pencil has no eigenvalues on the unit circle.
%       Sufficient conditions to guarantee the above are stabilizability,
%       detectability, and [Q S;S' R] >= 0.

%	Reference: W.F. Arnold, III and A.J. Laub, ``Generalized Eigenproblem
%	           Algorithms and Software for Algebraic Riccati Equations,''
%	           Proc. IEEE, 72(1984), 1746--1754.


ni = nargin;
no = nargout;
error(nargchk(3,7,ni))
error(abcdchk(A,B));
if ~length(A) | ~length(B)
   error('A and B matrices cannot be empty.')
end
[n,m] = size(B);
n2 = 2*n;

% Parse input list
flag = 'E';  % standard
switch ni
case 3
   R = eye(m);
   S = zeros(n,m);
   E = eye(n);
case 4
   R = varargin{1};
   S = zeros(n,m);
   E = eye(n);
case 5
   R = varargin{1};
   S = varargin{2};
   E = eye(n);
case 6
   R = varargin{1};
   S = varargin{2};
   E = varargin{3};
case 7
   R = varargin{1};
   S = varargin{2};
   E = varargin{3};
   flag = varargin{4};
end

% Check that Q and R are the correct size and symmetric
if any(size(Q) ~= n),
   error('A and Q must be the same size.')
elseif norm(Q-Q',1) > 100*eps*norm(Q,1),
   error('Q must be symmetric.')
else
   Q = (Q+Q')/2;
end

% Define or check sizes of R
if isstr(R)
   % 'report' or 'implicit'
   flag = R;
   R = eye(m);
elseif any(size(R) ~= m),
   error('Order of R matrix must = number of columns of B matrix.')
elseif norm(R-R',1) > 100*eps*norm(R,1),
   error('R must be symmetric.')
else
   R = (R+R')/2;
end

% Define or check sizes of S
if isstr(S),
   % 'report' or 'implicit'
   flag = S;
   S = zeros(n,m);
elseif any(size(S) ~= [n m]),
   error('S and B must be the same size.')
end

% Define or check sizes of E
if isstr(E),
   flag = E;
   E = eye(n);
elseif any(size(E)~=n),
   error('E and A must be the same size.')
elseif ~isequal(E,eye(n)) & rcond(E)<eps,
   error('E must be nonsingular.')
end

% NoError=1 turns off error messages
NoError = ~strcmp(flag(1),'E');

% Scale Q,R,S so that norm(Q,1)+norm(R,1)+norm(S,1) = 1
ScaleFact = norm(Q,1)+norm(R,1)+norm(S,1);
Qn = Q/ScaleFact;   Rn = R/ScaleFact;   Sn = S/ScaleFact;

% Set up extended pencil
a = [E zeros(n,n+m);zeros(n) A' zeros(n,m);zeros(m,n) -B' zeros(m)];
b = [A zeros(n) B;-Qn  E' -Sn;Sn' zeros(m,n) Rn];

% Compression step in case R is singular
[q,r] = qr(b(:,n2+1:n2+m));
a = q(:,n2+m:-1:m+1)'*a(:,1:n2);
b = q(:,n2+m:-1:m+1)'*b(:,1:n2);

% Do initial QZ algorithm; eigenvalues of this pencil have a tendency
% to deflate out in the ``desired'' order
[aa,bb,q,z] = qz(a,b);

% Find all pencil eigenvalues outside the unit circle
daa = abs(diag(aa));
dbb = abs(diag(bb));
[ignore,p] = sort(daa <= dbb);
if sum(ignore) ~= n
   if NoError,
      X = []; L = []; G = []; RR = -1;  return
   else 
      error('Cannot order eigenvalues: spectrum too near unit circle.')
   end
end

% Order pencil eigenvalues so that those outside the unit circle are in the
% leading n positions
[aa,bb,z] = qzexch(aa,bb,z,p);

% Account for non-identity E matrix and orthonormalize basis
if ni > 5
   x1 = E*z(1:n,1:n);
   a = [x1;z(n+1:n2,1:n)];
   [q,r] = qr(a);
   z = q(:,1:n);
end

% Check for symmetry of solution
X1 = z(1:n,1:n);
X2 = z(n+1:n2,1:n);
X12 = X1'*X2;
Asym = X12-X12';
Asym = max(abs(Asym(:))) - sqrt(eps);
if Asym > 0.1*max(abs(X12(:))),
   % Spurious separation of pencil spectrum (cf. dare(1,1,1,-1))
   if NoError,
      X = []; L = []; G = []; RR = -1;  return
   else 
      error('Cannot order eigenvalues: spectrum too near unit circle.')
   end
elseif Asym > sqrt(eps)
   warning(...
    'Solution may be inaccurate due to poor scaling or eigenvalues too near unit circle.')
end

% Compute L = vector of n closed-loop eigenvalues; use the
% last n elements of diag(aa)./diag(bb) to avoid dealing with
% infinite eigenvalues in the first n components
if no>1,
   va = diag(aa);   vb = diag(bb);
   va = va(n+1:n2);  vb = vb(n+1:n2);
   L = va./vb;

   % Force exact complex conjugate pairs
   L = qzeig(L);
end


% Set output arguments
if strcmp(lower(flag(1)),'i'),
   % X given in implicit form
   G = L;
   X = X1;
   L = ScaleFact*X2;
   RR = 0;

else
   % Solve X * X1 = X2
   [l,u,p] = lu(X1);
   CondX1 = rcond(u);

   if CondX1>eps,
      % Solve for X based on LU decomposition
      X = real(((X2/u)/l)*p);
   elseif NoError,
      % X1 is singular
      X = []; L = []; G = []; RR = -2;  return
   else
      % X1 is singular
      error('X = X2/X1 with X1 singular; solution is not finite.')
   end
   X = (ScaleFact/2) * (X+X');

   % Compute gain matrix G
   if no > 2
      G = (B'*X*B+R)\(B'*X*A+S');
   end

   % Compute Frobenius norm of relative residual
   if no > 3
      Res = A'*X*A - E'*X*E - (A'*X*B + S)*G + Q;
      RR = norm(Res,'fro')/max(1,norm(X,'fro'));
   end

end

% *** last line of dare.m ***
