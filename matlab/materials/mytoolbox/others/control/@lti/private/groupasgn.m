function Group = groupasgn(Group,indices,Grhs)
%GROUPASGN  Reassignment of an I/O group portion
%
%   GROUP = GROUPASGN(GROUP,INDICES,GRHS) propagates I/O group
%   information in the assignments  SYS(:,INDICES) = RHS  and
%   SYS(INDICES,:) = RHS.  If RHS has I/O groups, this grouping
%   information is inherited by the reassigned channels of GROUP
%   and replaces any pre-existing group membership for these 
%   channels.
%
%   Used by LTI/SUBSASGN.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/02/12 22:19:34 $

% Keep existing groups if RHS group is empty
if isempty(Grhs),
   return
end

% Delete channels in INDICES from original GROUP
ng = size(Group,1);
ikeep = logical(zeros(1,ng));
for i=1:ng,
   % For each group, delete channels that belong to INDICES
   Group{i,1}(ismember(Group{i,1},indices)) = [];
   ikeep(i) = ~isempty(Group{i,1});
end

% Insert Grhs
Group = groupcat(Group(ikeep,:),Grhs,indices);
