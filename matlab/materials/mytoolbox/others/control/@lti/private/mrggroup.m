function [Group,clash] = mrggroup(Group1,Group2)
%MRGGROUP  I/O group management.  
%
%   [GROUP,CLASH] = MRGGROUP(GROUP1,GROUP2)  merges the
%   two I/O groups GROUP1 and GROUP2.  If either one is 
%   empty, GROUP is set to the nonempty group.  If both
%   GROUP1 and GROUP2 are nonempty, CLASH is set to 1 if 
%   the two groups don't match.

%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.1 $  $Date: 1998/02/12 19:55:36 $


% Set output
if isempty(Group1),
   Group = Group2;
else
   Group = Group1;
end

% Determine if there is a clash
if isempty(Group1) | isempty(Group2) | isequal(Group1,Group2),
   clash = 0;
else
   % Groups are nonempty and nonequal. Sort by group name
   % to make sure there is a true clash
   [jk,is1] = sort(Group1(:,2));
   [jk,is2] = sort(Group2(:,2));
   clash = ~isequal(Group1(is1,:),Group2(is2,:));
end
   
