function L = augstate(L,statenames)
%AUGSTATE   LTI property management for AUGSTATE.
%
%   SYS.LTI = AUGSTATE(SYS.LTI,STATENAMES)  sets the 
%   LTI properties of SYS = AUGSTATE(SYS)
%
%   See also SS/AUGSTATE

%	P. Gahinet 5-21-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1998/08/26 16:42:29 $

if ~strcmp(class(L),'lti')
   error('AUGSTATE is applicable only to state-space models.');
end

ns = length(statenames);

% Append "state" group to output groups
StateGroup = {1:ns , 'states'};
L.OutputGroup = groupcat(L.OutputGroup,StateGroup,...
                              length(L.OutputName)+(1:ns));

% Append state names to output names
L.OutputName = [L.OutputName ; statenames];

% Delete notes and userdata
L.Notes = {};
L.UserData = [];

% Delay time
L.ioDelayMatrix = [L.ioDelayMatrix ; zeros(ns,size(L.ioDelayMatrix,2))];
L.OutputDelay = [L.OutputDelay ; zeros(ns,1)];
