function Lims = findlims(DispAx,Type);

%   Author(s): K. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4.1.2 $  $Date: 1999/01/05 15:20:47 $

allLims = get(DispAx,{Type});
allLims = cat(1,allLims{:});
Lmin = min(allLims(:,1));
Lmax = max(allLims(:,2));

if isempty(Lmin), % Lmin is empty if all systems are invisible
   Lmin = 0;
   Lmax = 1;
elseif isequal(Lmin,Lmax)
   Lmin = Lmin-(0.05*abs(Lmin));
   Lmax = Lmax+(0.05*abs(Lmax));
end

Lims = [Lmin Lmax];
