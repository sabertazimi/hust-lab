function sys = ss2ss(sys,T)
%SS2SS  Change of state coordinates for state-space models.
%
%   SYS = SS2SS(SYS,T) performs the similarity transformation 
%   z = Tx on the state vector x of the state-space model SYS.  
%   The resulting state-space model is described by:
%
%               .       -1        
%               z = [TAT  ] z + [TB] u
%                       -1
%               y = [CT   ] z + D u
%
%   or, in the descriptor case,
%
%           -1  .       -1        
%       [TET  ] z = [TAT  ] z + [TB] u
%                       -1
%               y = [CT   ] z + D u  .
%
%   SS2SS is applicable to both continuous- and discrete-time 
%   models.  For LTI arrays SYS, the transformation T is 
%   performed on each individual model in the array.
%
%   See also CANON, SSBAL, BALREAL.

%	 Clay M. Thompson  7-3-90,  P. Gahinet 5-9-96
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.10 $  $Date: 1998/05/18 22:33:16 $

error(nargchk(2,2,nargin))

% Check dimensions
asizes = size(sys.a);  Nx = asizes(1);
tsizes = size(T);
if length(tsizes)>2 | tsizes(1)~=tsizes(2),
   error('T must be a square 2D matrix.')
elseif Nx~=tsizes(1),
   error('SYS must have as many states as rows in T.')
elseif length(sys.Nx)>1
   error('Not well defined for SS arrays with varying model orders.')
end

% LU decomposition of T
[l,u,p] = lu(T);
if rcond(u)<eps,
   error('State similarity matrix T is singular.')
end

% Perform coordinate transformation
for i=1:prod(asizes(3:end)),
   sys.a(:,:,i) = T*((sys.a(:,:,i)/u)/l)*p;
   sys.b(:,:,i) = T*sys.b(:,:,i);
   sys.c(:,:,i) = ((sys.c(:,:,i)/u)/l)*p;
end

if ~isempty(sys.e),
   for i=1:prod(asizes(3:end)),
      sys.e(:,:,i) = T*((e(:,:,i)/u)/l)*p;
   end
end

sys.StateName(1:Nx) = {''};



