function L = transpose(L)
%TRANSPOSE  LTI properties management in transpose operations
%
%   SYS.LTI = (SYS.LTI).'

%       Author(s): P. Gahinet, 5-28-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.6 $

% Get I/O dims
nu = length(L.InputName);
ny = length(L.OutputName);

% Delete I/O names and groups
EmptyStr = {''};
L.InputName = EmptyStr(ones(ny,1),1);
L.OutputName = EmptyStr(ones(nu,1),1);
L.InputGroup = cell(0,2);
L.OutputGroup = cell(0,2);

% Transpose delay times
L.ioDelayMatrix = permute(L.ioDelayMatrix,[2 1 3:ndims(L.ioDelayMatrix)]);
Li = L.InputDelay;
L.InputDelay = L.OutputDelay;
L.OutputDelay = Li;
