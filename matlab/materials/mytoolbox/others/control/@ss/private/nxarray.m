function Nx = nxarray(sys)
%NXARRAY   Returns array of state dimensions for SS arrays.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/05 14:07:41 $

Nx = sys.Nx;
sizes = size(sys.a);

if length(sizes)>2 & length(Nx)==1,
   Nx = repmat(Nx,[sizes(3:end) 1]);
end

