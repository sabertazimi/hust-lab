function v2 = matchlsq(v1,v2)
%MATCHLSQ Matches two vectors.  Used in RLOCUS subroutines.
%
%   V2S = MATCHLSQ(V1,V2) matches two complex vectors 
%   V1 and V2, returning V2S with consists of the elements 
%   of V2 sorted so that they correspond to the elements 
%   in V1 in a least squares sense.
%
%   V2 can also be a matrix, in which case the match is
%   performed wrt first column of V2 and all rows of V2
%   are reordered consistently with V1.

%   Author(s): A. Potvin, 9-1-95
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1997/12/01 22:05:08 $

p = length(v1);
vones = ones(p,1);
vv = v2;
v21 = v2(:,1).';

% Form gap matrix
Mdiff = abs(v21(vones,:) - v1(:,vones));
Mdiff(isnan(Mdiff)) = Inf;
v1ind = 1:p;
v2ind = 1:p;

while length(v1ind)>1,
   [m,i] = min(Mdiff(v1ind,v2ind));
   if all(filter([1 -1],1,sort(i))),  % fast diff
      % Quick exit condition
      v2(v1ind(i),:) = vv(v2ind,:);
      return
   end
   [trash,j] = min(m);
   i = i(j);
   v2(v1ind(i),:) = vv(v2ind(j),:);
   % indices = [indices; v1ind(i) v2ind(j)];
   v1ind(i) = [];
   v2ind(j) = [];
end
% Here's the last point.
v2(v1ind,:) = vv(v2ind,:);

% end matchlsq
