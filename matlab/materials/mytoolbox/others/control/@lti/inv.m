function Li = inv(L)
%INV  Manages LTI properties in model inversion
%
%   ISYS.LTI = INV(SYS.LTI)  sets the LTI properties of 
%   the inverse model
%        ISYS = INV(SYS)
%
%   See also TF/INV.

%       Author(s): P. Gahinet, 5-28-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.5 $  $Date: 1998/04/14 21:12:44 $

Li = L;

% Delete Notes and UserData
Li.Notes = {};
Li.UserData = [];

% Swap I/O names
Li.InputName = L.OutputName;
Li.OutputName = L.InputName;

% Swap I/O groups
Li.InputGroup = L.OutputGroup;
Li.OutputGroup = L.InputGroup;

% Zero time delays
nio = size(L.ioDelayMatrix,1);
L.ioDelayMatrix = zeros(nio);
L.InputDelay = zeros(nio,1);
L.OutputDelay = zeros(nio,1);
