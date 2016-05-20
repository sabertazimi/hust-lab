function L = append(L1,L2,sflags)
%APPEND  Manages LTI properties in APPEND operation.
%
%   SYS.LTI = APPEND(SYS1.LTI,SYS2.LTI,SFLAGS) sets 
%   the LTI properties of 
%      SYS = APPEND(SYS1,SYS2)
%
%   The two-entry vector SFLAGS flags static gains:
%      * SFLAGS(1) = 1 --> SYS1 is a static gain
%      * SFLAGS(2) = 1 --> SYS2 is a static gain

%   Author(s): P. Gahinet, 5-28-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/04/14 21:11:37 $

% Adjust sample time of static gains to avoid unwarranted clashes
if nargin>2 & any(sflags),
   [L1,L2] = sgcheck(L1,L2,sflags);
end
L = L1;

% Delete Notes and UserData
L.Notes = {};
L.UserData = [];

% Sample time managament
if (L1.Ts==-1 & L2.Ts>0) | (L2.Ts==-1 & L1.Ts>0),
   % Discrete/discrete with one unspecified sample time
   L.Ts = max(L1.Ts,L2.Ts);
elseif L1.Ts~=L2.Ts,
   error('In APPEND, systems must have identical sampling times.')
end

% I/O delays
std1 = size(L1.ioDelayMatrix);
std2 = size(L2.ioDelayMatrix);
L.ioDelayMatrix = [L1.ioDelayMatrix , zeros(std1(1),std2(2)) ; ...
      zeros(std2(1),std1(2)) , L2.ioDelayMatrix];

% Append input and output delays
L.InputDelay = [L1.InputDelay ; L2.InputDelay];
L.OutputDelay = [L1.OutputDelay ; L2.OutputDelay];


% Append I/O groups
L.InputGroup = groupcat(L1.InputGroup,L2.InputGroup,...
                        length(L1.InputName)+(1:length(L2.InputName)));
L.OutputGroup = groupcat(L1.OutputGroup,L2.OutputGroup,...
                        length(L1.OutputName)+(1:length(L2.OutputName)));

% Append I/O names
L.InputName = [L1.InputName ; L2.InputName];
L.OutputName = [L1.OutputName ; L2.OutputName];

