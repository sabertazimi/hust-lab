function [sys,g,T,Ti] = balreal(sys)
%BALREAL  Gramian-based balancing of state-space realizations.
%
%   SYSb = BALREAL(SYS) returns a balanced state-space realization 
%   of the reachable, observable, stable system SYS.
%
%   [SYSb,G,T,Ti] = BALREAL(SYS) also returns a vector G containing
%   the diagonal of the Gramian of the balanced realization.  The
%   matrices T is the state transformation xb = Tx used to convert SYS
%   to SYSb, and Ti is its inverse.  
%
%   If the system is normalized properly, small elements in the balanced
%   Gramian G indicate states that can be removed to reduce the model 
%   to lower order.
%
%   See also MODRED, GRAM, SSBAL, SS.

%	J.N. Little 3-6-86
%	Revised 12-30-88
%       Alan J. Laub 10-30-94
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1998/02/12 19:56:03 $

%       Reference:
%       [1] Laub, A.J., M.T. Heath, C.C. Paige, and R.C. Ward,
%           ``Computation of System Balancing Transformations and Other
%           Applications of Simultaneous Diagonalization Algorithms,''
%           IEEE Trans. Automatic Control, AC-32(1987), 115--122.
%
%       The old balreal used an eigenvalue algorithm described in
%	 1) Moore, B., Principal Component Analysis in Linear Systems:
%	    Controllability, Observability, and Model Reduction, IEEE 
%	    Transactions on Automatic Control, 26-1, Feb. 1981.
%	 2) Laub, A., "Computation of Balancing Transformations", Proc. JACC
%	    Vol.1, paper FA8-E, 1980.


error(nargchk(1,1,nargin));
sizes = size(sys.d);
if ~all(sizes),
   % System w/o state, input or output
   g = [];  T = [];  Ti = [];  return
elseif length(sizes)>2,
   error('Not available for arrays of state-space models.')
end

% Compute reachability and observability Gramians
gr = gram(sys,'c');
go = gram(sys,'o');

% Compute Cholesky factors of Gramians
[Rr,p] = chol(gr);
if p,
   error('System must be reachable.')
end
[Ro,p] = chol(go);
if p,
   error('System must be observable.')
end

% NOTE: The above implementation still involves ``squaring up'' in the gram
% code, and hence can exhibit unsatisfactory numerical behavior for nearly
% unreachable or nearly unobservable systems.  The remedy involves replacing
% the four commands above with the following two:
%      rr = hlyap(a,b);
%      ro = hlyap(a',c');
% where hlyap is Hammarling's algorithm that solves directly for the
% Cholesky factor of a Lyapunov equation solution.  For details, see [1]
% and reference [11] in [1].  

% Compute SVD of the ``product of the Cholesky factors''
[u,s,v] = svd(Ro*Rr');

% NOTE: Numerically, the product SVD algorithm of Heath et al. (reference [12]
% of [1]) is superior to forming the product ro*rr' directly and then
% computing the SVD.  In other words, the following code should be used:
%      [u,g,v] = prodsvd(ro,rr')

g = max(diag(s),eps);
sgi = diag(1./sqrt(g));
Ti = Rr'*v*sgi;
T = sgi*u'*Ro;

% Form balanced realization
% REVISIT: should support descriptor case
[a,b,c] = ssdata(sys);
sys.a = T*a*Ti;
sys.b = T*b;
sys.c = c*Ti;
sys.e = [];
sys.StateName(1:size(a,1)) = {''};

