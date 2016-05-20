function [sys,t] = ssbal(sys,condt)
%SSBAL  Balancing of state-space model using diagonal similarity.
%
%   [SYS,T] = SSBAL(SYS) uses BALANCE to compute a diagonal similarity 
%   transformation T such that [T*A/T , T*B ; C/T 0] has approximately 
%   equal row and column norms.  
%
%   [SYS,T] = SSBAL(SYS,CONDT) specifies an upper bound CONDT on the 
%   condition number of T.  Since balancing with ill-conditioned T 
%   can inadvertly magnify round-off errors, CONDT gives control over
%   the worst-case round-off amplification.  The default value is 
%   CONDT = 1/eps.
%
%   For arrays of state-space models, SSBAL computes a single 
%   transformation T that equalizes the maximum row and column norms 
%   across the entire array.
%
%   See also BALREAL, COMPBAL, SS.

%   Authors: P. Gahinet and C. Moler, 4-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.10 $  $Date: 1998/02/12 19:56:01 $

ni = nargin;
error(nargchk(1,2,ni))
if ni==1, 
   condt = 1/eps;
end

% Quick exit when no state
sizes = size(sys.d);
stail = sizes(3:end);  % sizes of dimensions > 2
ntail = prod(stail);
nx = size(sys.a,1);  
if nx==0 | any(stail==0)
   t = eye(nx);   return
end

% Extract SS data
a = sys.a(:,:,:);  
b = sys.b(:,:,:);
c = sys.c(:,:,:);  
e = sys.e(:,:,:);
ne = size(e,1);
ny = sizes(1);
nu = sizes(2);

% Compute |A|+|E| and replace B and C by their row-wise and 
% column-wise norms
mae = max(abs(a),[],3);
if ne,
   mae = mae + max(abs(e),[],3);
end
mb = max([max(abs(b),[],3) , zeros(nx,1)],[],2);
mc = max([max(abs(c),[],3) ; zeros(1,nx)],[],1);

% To activate balancing when A is triangular and B and C are nonzero,
% set zero entries of B to |B|/CONDT and zero entries of C to |C|/CONDT.
bmax = max(mb); 
cmax = max(mc);
mb(mb==0) = bmax/condt;
mc(mc==0) = cmax/condt;

% When C=0 and A(:,j)-A(j,j) is zero (i.e., x(j) is unobservable),
% set C(j)=|B| to reduce the weight of x(j) in (A,B)
offdiag = mae-diag(diag(mae));
if bmax==0 & cmax, 
   mb(all([offdiag,mb]==0,2)) = cmax;
end
if cmax==0 & bmax,
   mc(all([offdiag;mc]==0,1)) = bmax;
end

% Balance [|A|+|E| B;C 0]
% RE: BALANCE may permute the rows/cols of A. To undo this permutation,
%     set T = DIAG(MAX(T,[],2))
[t,Mb] = balance([mae mb;mc 0]);
dt = max(t(1:nx,:),[],2);     % balances the states
s = max(t(nx+1,:));           % equalizes |B| and |C|

% If cond(T) exceeds CONDT, rescale diag(T) to match the bound on CONDT 
if max(dt)>10*condt*min(dt),
   dt = log2(dt);
   scalf = log2(condt)/(max(dt)-min(dt));
   dt = pow2(round(scalf*dt));
end

% Update state-space data using .* product to evaluate X*T and T\X in o(n^2) 
dti = 1./dt;
T = repmat(dt.',[max(nx,ny) 1 ntail]);
Ti = repmat(dti,[1 max(nx,nu) ntail]);
sys.a = reshape( (Ti(:,1:nx,:) .* a) .* T(1:nx,:,:) , [nx nx stail]);
if ne,
   sys.e = reshape((Ti(:,1:nx,:) .* e) .* T(1:nx,:,:) , [nx nx stail]); 
end
sys.b = reshape((Ti(:,1:nu,:) .* b)*s , [nx nu stail]);
sys.c = reshape((c .* T(1:ny,:,:))/s , [ny nx stail]);
sys.StateName(1:nx) = {''};

% Return inv(T) to be consistent with SS2SS
t = s * diag(dti);

