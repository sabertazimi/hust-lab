function Nx = nxcheck(Nx)
%NXCHECK  Reduces NX to a scalar when all models have the
%         same number of states.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/05 14:07:41 $

if ~any(diff(Nx(:))),
   Nx = Nx(1);
end
