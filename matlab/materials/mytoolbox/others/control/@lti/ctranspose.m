function L = ctranspose(L)
%CTRANSPOSE   Manages LTI properties in pertransposition.
%
%   SYS.LTI = (SYS.LTI)'

%       Author(s): P. Gahinet, 5-28-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.5 $

if hasdelay(L),
   error('Time delays makes pertransposed model non causal.')
end

% Get I/O dims
nu = length(L.InputName);
ny = length(L.OutputName);

% Delete I/O names and groups
EmptyStr = {''};
L.InputName = EmptyStr(ones(ny,1),1);
L.OutputName = EmptyStr(ones(nu,1),1);
L.InputGroup = cell(0,2);
L.OutputGroup = cell(0,2);

% Set delay times to zero
L.ioDelayMatrix = zeros(nu,ny);
L.InputDelay = zeros(ny,1);
L.OutputDelay = zeros(nu,1);
