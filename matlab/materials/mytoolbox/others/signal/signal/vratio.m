function v = vratio(u,ineps,mp)
%VRATIO Utility function for use with ELLIP.
%   VRATIO(u,ineps,mp) is a function used to calculate the poles of an
%   elliptic filter.  It finds a u so sn(u)/cn(u) = 1/epsilon ( = ineps), 
%   with parameter mp.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%         $Revision: 1.1 $  $Date: 1998/06/03 14:44:03 $

%   global information - 1/epsilon, the value s/c should attain
%   with parameter mp.

[s,c] = ellipj(u,mp);
v = abs(ineps - s/c);

