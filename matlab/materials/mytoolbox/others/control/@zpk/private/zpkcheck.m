function sys = zpkcheck(sys,zpkflag)
%ZPKCHK   Verifies the consistency of arguments Z,P,K and makes sure
%         Z and P are cellarray of column vectors.
%
%         Returns the empty string if no error is detected.

%      Author: P. Gahinet, 5-1-96
%      Copyright (c) 1986-98 by The MathWorks, Inc.
%      $Revision: 1.6 $  $Date: 1998/07/28 15:56:23 $

if ~zpkflag,
   return
end

% Make sure both Z and P are cell arrays
if isa(sys.z,'double'), 
   % ZPK([1 2],[3 4],1)
   if ndims(sys.z)>2,
      error('Input Z must be a vector (for SISO) or a cell array of vectors.')
   end
   sys.z = {sys.z}; 
end
if isa(sys.p,'double'), 
   if ndims(sys.p)>2,
      error('Input P must be a vector (for SISO) or a cell array of vectors')
   end
   sys.p = {sys.p}; 
end
if ~isa(sys.k,'double'),
   error('Input K must be a 2D or ND array.');
end

% Get sizes
nd = zeros(1,3);
sz = size(sys.z);  nd(1) = length(sz);
sp = size(sys.p);  nd(2) = length(sp);
sk = size(sys.k);  nd(3) = length(sk);

% Check I/O dimension consistency
if ~isequal(sz(1:2),sp(1:2),sk(1:2)),
   errmsg = 'Invalid system: Z,P,K must have matching dimensions.'; 
   if zpkflag<3,  % two or less modified
      errmsg = sprintf('%s\n%s',errmsg, ...
             'Use SET(SYS,''Z'',z,''P'',p,''K'',k) to modify input/output dimensions');
   end
   error(errmsg)    
end

   
% Check compatibility of dimensions > 2
[ndmax,imax] = max(nd);  % highest dimensionality
if ndmax>2,
   % MATSIZES(:,j) = size of dimension j+2 for Z,P,K
   ArraySizes = [sz(3:end) ones(1,ndmax-nd(1)) ; ...
                 sp(3:end) ones(1,ndmax-nd(2)) ; ...
                 sk(3:end) ones(1,ndmax-nd(3))];
   FullSizes = ArraySizes(imax,:);         
   % Which matrices can be resized by REPMAT extension along dims>2      
   Resizable = (nd==2);
   
   % Consistency check
   nrs = length(find(~Resizable));
   if any(ArraySizes(~Resizable,:)~=FullSizes(ones(nrs,1),:),2),
      error('ND inputs Z,P,K must have compatible dimensions.')
   end
   
   % Resize the resizable
   if Resizable(1),  sys.z = repmat(sys.z,[1 1 FullSizes]);  end
   if Resizable(2),  sys.p = repmat(sys.p,[1 1 FullSizes]);  end
   if Resizable(3),  sys.k = repmat(sys.k,[1 1 FullSizes]);  end
end


% Make Z and P cell arrays of column vectors
z = sys.z(:);
p = sys.p(:);
sz = [cellfun('size',z,1) , cellfun('size',z,2)];
sp = [cellfun('size',p,1) , cellfun('size',p,2)];
if ~all(cellfun('isclass',z,'double')) | ...
   ~all(cellfun('isclass',p,'double')),
   error('Content of NUM and DEN must be of class DOUBLE.')
elseif any(cellfun('ndims',z)>2) | any(cellfun('ndims',p)>2) | ...
      any(min(sz,[],2)>1) | any(min(sp,[],2)>1),
   if length(sys.z)==1,
      error('Inputs Z and P must be vectors.')
   else
      error('Inputs Z and P must be cell arrays of vectors')
   end
end

% Make sure all Zs and Ps are column vectors
for k=find(sz(:,2)~=1)',
   sys.z{k} = sys.z{k}(:);
end

for k=find(sp(:,2)~=1)',
   sys.p{k} = sys.p{k}(:);
end

% Make sure all Zs and Ps are complex conjugate
for k=find(max(sz')>1),
   zk = z{k};
   if ~isequal(sort(zk(imag(zk)>0)),sort(conj(zk(imag(zk)<0))))
      error('Complex zeros must come in complex conjugate pairs.')
   end
end

for k=find(max(sp')>1),
   pk = p{k};
   if ~isequal(sort(pk(imag(pk)>0)),sort(conj(pk(imag(pk)<0))))
      error('Complex poles must come in complex conjugate pairs.')
   end
end

