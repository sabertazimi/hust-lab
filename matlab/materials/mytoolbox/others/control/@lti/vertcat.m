function L = vertcat(L1,L2)
%VERTCAT  LTI property management in vertical concatenation.
% 
%   SYS.LTI = VERTCAT(SYS1.LTI,SYS2.LTI,...)  sets the LTI 
%   properties of 
%                 SYS = [SYS1 ; SYS2; ...].

%       Author(s):  P. Gahinet, 5-27-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.5 $  $Date: 1998/04/14 21:11:38 $

L = L1;
if nargin==1,
   % Parser call to HORZCAT with single argument in [SLTI ; SYSJ.LTI]
   return
end

% Notes and UserData
L.Notes = {};
L.UserData = [];

% Sample time managament
% RE: Assumes that the sample time of static gains 
%     has already been adjusted
if (L1.Ts==-1 & L2.Ts>0) | (L2.Ts==-1 & L1.Ts>0),
   % Discrete/discrete with one unspecified sample time
   L.Ts = max(L1.Ts,L2.Ts);
elseif L1.Ts~=L2.Ts,
   error('Sampling time mismatch in concatenation.')
end

% Delay times 
L.OutputDelay = [L1.OutputDelay ; L2.OutputDelay];
[L.InputDelay,L1,L2] = iodmerge('i',L1.InputDelay,L2.InputDelay,L1,L2);
L.ioDelayMatrix = [L1.ioDelayMatrix ; L2.ioDelayMatrix];

% Append output groups:
lind = length(L1.OutputName) + (1:length(L2.OutputName));
L.OutputGroup = groupcat(L1.OutputGroup,L2.OutputGroup,lind);
   
% Append output names
L.OutputName = [L1.OutputName ; L2.OutputName];

% InputName: check compatibility and merge
[L.InputName,InputNameClash] = mrgname(L1.InputName,L2.InputName);
if InputNameClash,
   warning('Name clash. All input name(s) deleted.')
   EmptyStr = {''};
   L.InputName = EmptyStr(ones(length(L.InputName),1),1);
end
   
% InputGroup: check compatibility 
[L.InputGroup,InputGroupClash] = mrggroup(L1.InputGroup,L2.InputGroup);
if InputGroupClash,
   warning('Group clash. All input groups deleted.')
   L.InputGroup = cell(0,2);
end

