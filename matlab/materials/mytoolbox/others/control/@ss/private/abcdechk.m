function sys = abcdechk(sys,abcdex)
%ABCDECHK  Checks that the state-space matrices of SYS define
%          a valid system and returns the empty string if no 
%          error is detected.

%   Author(s): P. Gahinet, 5-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.10 $  $Date: 1998/10/01 20:12:32 $

if ~any(abcdex),
   return
end

% Get data dimensions 
nd = zeros(5,1);
sa = size(sys.a);   nd(1) = length(sa);
sb = size(sys.b);   nd(2) = length(sb);
sc = size(sys.c);   nd(3) = length(sc);
sd = size(sys.d);   nd(4) = length(sd);
se = size(sys.e);   nd(5) = length(se);
Nx = sa(1);   
Ne = se(1);
Nu = max(sb(2),sd(2));
Ny = max(sc(1),sd(1));

% Check and reset SYS.NX
if abcdex(6), 
   % Property NX was redefined (not by user)
   sys.Nx = nxcheck(sys.Nx);
end

if any(abcdex(1:3)),
   % A,B,C redefined
   % REVISIT: E not covered...
   if all(abcdex(1:3)),
      % All three are redefined: update SYS.NX
      sys.Nx = Nx;
   elseif length(sys.Nx)>1,
      % Reassignment creates inconsistency when state order was non uniform
      error(sprintf('Cannot modify A,B,C directly when models have different numbers of states.\n%s',...
         'Proceed model by model using assignments of the form sys(:,:,k).a=Anew.'))
   end
end

% Check matrix data
% Check all matrices are double
if ~isa(sys.a,'double') | ~isa(sys.e,'double') | ...
      ~isa(sys.b,'double') | ~isa(sys.c,'double') | ~isa(sys.d,'double') | ...
      ~isreal(sys.a) | ~isreal(sys.b) | ~isreal(sys.c) | ...
      ~isreal(sys.d) | ~isreal(sys.e),
   error('Invalid system: A,B,C,D must be arrays of real numbers.');
end

% Handle shorthand syntax
if Nx==0,  
   sa(1:2) = 0;  sys.a = zeros(sa);  
end
if Ne==0,  
   se(1:2) = 0;  sys.e = zeros(se);  
end
if Nx==0 | Nu==0,  
   sb(1:2) = [Nx Nu];  sys.b = zeros(sb);  
end
if Nx==0 | Ny==0,  
   sc(1:2) = [Ny Nx];  sys.c = zeros(sc);  
end
if Nu==0 | Ny==0 | isequal(sys.d,0), 
   sd(1:2) = [Ny Nu];  sys.d = zeros(sd);  
end

% Check compatibility of I/O and state dimensions
if sa(1)~=sa(2) | se(1)~=se(2),
   error('The A and E matrices must be square.')
elseif Ne>0 & ~isequal(sa(1:2),se(1:2)),
   error('The A and E matrices must have the same dimensions.')
elseif Nx~=sb(1),
   error('The A and B matrices must have the same number of rows.')
elseif Nx~=sc(2),
   error('The A and C matrices must have the same number of columns.')
elseif sb(2)~=sd(2),
   errmsg = 'The B and D matrices must have the same number of columns.';
   if any(abcdex(2:4)~=1),
      errmsg = sprintf('%s\n%s',errmsg,...
         'Use SET(SYS,''b'',B,''d'',D) to modify number of inputs');
   end
   error(errmsg)
elseif sc(1)~=sd(1),
   errmsg = 'The C and D matrices must have the same number of rows.';
   if any(abcdex(2:4)~=1),
      errmsg = sprintf('%s\n%s',errmsg, ...
         'Use SET(SYS,''c'',C,''d'',D) to modify number of outputs');
   end
   error(errmsg)    
end


% Check all E matrices are nonsingular
if Ne>0,
   for k=1:prod(se(3:end)),
      if rcond(sys.e(:,:,k)) < eps,
         error('All E matrices must be non singular.')
      end
   end
end

% Check compatibility of dimensions > 2
[ndmax,imax] = max(nd);  % highest dimensionality
if ndmax>2,
   % ARRAYSIZES(:,j) = length of dimension j+2 for A,B,C,D,E
   ArraySizes = [sa(3:end) ones(1,ndmax-nd(1));...
         sb(3:end) ones(1,ndmax-nd(2));...
         sc(3:end) ones(1,ndmax-nd(3));...
         sd(3:end) ones(1,ndmax-nd(4));...
         se(3:end) ones(1,ndmax-nd(5))];
   FullSizes = ArraySizes(imax,:);         
   FixedDims = (nd>2);  % Arrays with 3D or more
   
   % Consistency check
   nfd = length(find(FixedDims));
   if any(ArraySizes(FixedDims,:)~=FullSizes(ones(nfd,1),:),2),
      error('ND arrays A,B,C,D,E must have compatible dimensions.')
   elseif nfd<5,
      % Replicate 2D matrices
      sys.a = repmat(sys.a,[1 1 FullSizes(nd(1)-1:end)]);
      sys.b = repmat(sys.b,[1 1 FullSizes(nd(2)-1:end)]);
      sys.c = repmat(sys.c,[1 1 FullSizes(nd(3)-1:end)]);
      sys.d = repmat(sys.d,[1 1 FullSizes(nd(4)-1:end)]);
      sys.e = repmat(sys.e,[1 1 FullSizes(nd(5)-1:end)]);
   end
end






