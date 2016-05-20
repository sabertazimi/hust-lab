function [X,L,G,RR] = care(A,B,Q,varargin)
%CARE  Solve continuous-time algebraic Riccati equations.
%
%   [X,L,G,RR] = CARE(A,B,Q,R,S,E)  computes the unique symmetric 
%   stabilizing solution X of the continuous-time algebraic Riccati 
%   equation
%                               -1
%      A'XE + E'XA - (E'XB + S)R  (B'XE + S') + Q = 0
%
%   or, equivalently,
%                         -1             -1                     -1
%      F'XE + E'XF - E'XBR  B'XE + Q - SR  S' = 0  with  F:=A-BR  S'.
%
%   When omitted, R,S and E are set to the default values R=I, S=0, 
%   and E=I.  Additional optional outputs include the gain matrix
%               -1
%          G = R  (B'XE + S') ,
%
%   the vector L of closed-loop eigenvalues (i.e., EIG(A-B*G,E)), 
%   and the Frobenius norm RR of the relative residual matrix.  
%
%   [X,L,G,REPORT] = CARE(A,B,Q,...,'report')  turns off error 
%   messages and returns a success/failure diagnosis REPORT instead.
%   The value of REPORT is 
%     * -1 if Hamiltonian matrix has eigenvalues too close to jw axis
%     * -2 if X=X2/X1 with X1 singular
%     * the relative residual RR when CARE succeeds.
%
%   [X1,X2,L,REPORT] = CARE(A,B,Q,...,'implicit')  also turns off 
%   error messages, but now returns matrices X1,X2 such that X=X2/X1. 
%   REPORT=0 indicates success.
%
%   See also  DARE.

%   Author(s): Alan J. Laub (1993)  (laub@ece.ucsb.edu)
%              with key contributions by Pascal Gahinet, Cleve Moler,
%              and Andy Potvin
%   Revised: 94-10-29, 95-07-20, 96-01-09, 8-21-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.15 $

%   Assumptions: E is nonsingular, Q=Q', R=R' with R nonsingular, and
%                the associated Hamiltonian pencil has no eigenvalues
%                on the imaginary axis.
%   Sufficient conditions to guarantee the above are stabilizability,
%   detectability, and [Q S;S' R] >= 0, with R > 0.
%
%   Reference: W.F. Arnold, III and A.J. Laub, ``Generalized Eigenproblem
%	       Algorithms and Software for Algebraic Riccati Equations,''
%	       Proc. IEEE, 72(1984), 1746--1754.


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
end
Desc = ~isequal(E,eye(n));
if Desc & rcond(E)<eps,
   error('E must be nonsingular.')
end

% NoError=1 turns off error messages
NoError = ~strcmp(flag(1),'E');


% Assess whether R can be safely inverted
if Desc | isequal(R,diag(diag(R))),
   U = 1;   D = diag(R);   InvertR = ~Desc;
else
   % E=I and R is not diagonal
   [U,D] = schur(R);
   D = diag(D);
   Da = abs(D);
   if min(Da) <= eps*max(Da),
      error('R matrix must be nonsingular in continuous-time case.')
   else
      InvertR = (min(Da) > sqrt(eps)*max(Da));
   end
end


% Work with Hamiltonian matrix if E=I and R well conditioned 
% wrt inversion, otherwise use extended Hamiltonian pencil
if InvertR,
   % Form Hamitonian matrix
   %    H = [A-B/R*S'  -B/R*B' ; -Q+S/R*S'  -A'+S/R*B']
   BU = B * U;
   SU = S * U;
   DINV = diag(1./D);
   AS = A - BU * DINV * SU';
   H12 = -BU*DINV*BU';
   H21 = -Q+SU*DINV*SU';

   % Balance norms of H12 and H21
   % RE: watch for the permutation in BALANCE when H12=0
   [tb,trash] = balance([0 norm(H12,1);norm(H21,1) 0]);
   ScaleFact = max(tb(2,:))/max(tb(1,:));

   H = [AS ScaleFact*H12; H21/ScaleFact -AS'];

   % Compute complex Schur form
   [z,t] = schur(H);
   [z,t] = rsf2csf(z,t);
   L = diag(t);

   % Prepare vector index such that index(i) = sign(real(t(i,i)))
   index = sign(real(L));
   istab = find(index<0);

   % Exit if spectrum cannot be split equally
   if length(istab)~=n,
      if NoError,
         X = []; L = []; G = []; RR = -1;  return
      else
         error('Cannot order eigenvalues; spectrum too near imaginary axis.')
      end
   else
      L = L(istab);
   end

   % Order spectrum
   [z,t] = schord(z,t,index);

else
   % Set up extended Hamiltonian pencil
   a = [A zeros(n) B;-Q -A' -S;S' B' R];
   b = [E zeros(n);zeros(n) E'];
   ScaleFact = 1;
 
   % Compression step in case R is ill-conditioned w.r.t. inversion
   [q,r] = qr(a(:,n2+1:n2+m));
   a = q(:,n2+m:-1:m+1)'*a(:,1:n2);
   b = q(1:n2,n2+m:-1:m+1)'*b;

   % Use QZ algorithm to deflate pencil
   [aa,bb,q,z] = qz(a,b);
   L = diag(aa)./diag(bb);

   % Find all pencil eigenvalues in right-half plane
   [ignore,p] = sort(real(L)>0);

   % Exit if spectrum cannot be split equally
   if sum(ignore) ~= n
      if NoError,
         X = []; L = []; G = []; RR = -1;  return
      else
         error('Cannot order eigenvalues; spectrum too near imaginary axis.')
      end
   else
      L = L(p(1:n));
   end

   % Order pencil eigenvalues so that left-half plane eigenvalues are in the
   % leading n positions
   [aa,bb,z] = qzexch(aa,bb,z,p);

   % Account for non-identity E matrix and orthonormalize basis
   if Desc,
      x1 = E*z(1:n,1:n);
      [q,r] = qr([x1;z(n+1:n2,1:n)]);
      z = q(:,1:n);
   end

end


% Check for symmetry of solution
X1 = z(1:n,1:n);
X2 = z(n+1:n2,1:n);
X12 = X1'*X2;
Asym = X12-X12';
Asym = max(abs(Asym(:))) - sqrt(eps);
if Asym > 0.1*max(abs(X12(:))),
   % Spurious separation of Hamiltonian spectrum
   if NoError,
      X = []; L = []; G = []; RR = -1;  return
   else 
      error('Cannot order eigenvalues: spectrum too near unit circle.')
   end
elseif Asym > sqrt(eps),
   warning(...
    'Solution may be inaccurate due to poor scaling or eigenvalues too near imag. axis.')
end

% Force exact complex conjugate pairs in L
L = qzeig(L);


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
   if no>2
      G = R\(B'*X*E+S');
   end

   % Compute Frobenius norm of relative residual
   if no>3
      Res = A'*X*E + E'*X*A - (E'*X*B + S)*G + Q;
      RR = norm(Res,'fro')/max(1,norm(X,'fro'));
   end

end

% *** last line of care.m ***


