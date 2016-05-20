function locus = sortrloc(locus)
%SORTRLOC Sorts points along root locus
%       LOCUS = SORTRLOC(R)
%
%       See also ROCUS, RLOCSYN.

%   Author(s): A. Potvin, 12-1-93
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1997/12/01 22:05:10 $

% Assumes that the locus has dimension length(Poles) by length(k) 

% Note: cannot just use esort because we actually want to 
% trace a pole trajectory through the complex plane
% Re: esort orders eigenvalues based on their real parts
% Transpose once

[rr,rc] = size(locus); 
for i=2:(rr>0)*rc, 
   locus(:,i) = matchlsq(locus(:,i-1),locus(:,i)); 
end

% end sortrloc
