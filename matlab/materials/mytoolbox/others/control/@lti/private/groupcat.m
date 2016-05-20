function Group = groupcat(Group,NewGroup,inew)
%GROUPCAT  Concatenates two I/O groups.  
%
%   GROUP = GROUPCAT(GROUP,NEWGROUP,INEW) inserts the new 
%   groups NEWGROUP into an existing group list GROUP as 
%   part of one of the operations:  
%      *  SYS = [SYS , NEWSYS] 
%      *  SYS = [SYS ; NEWSYS]
%      *  SYS(indices) = NEWSYS
%   INEW is the index vector such that SYS(INEW) = NEWSYS
%   in the resulting SYS.

%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.1 $  $Date: 1998/02/12 19:55:36 $


% Perform index dereferencing in NEWGROUP (resulting indices are
% relative to resulting model SYS
for i=1:size(NewGroup,1),
   NewGroup{i,1} = sort(inew(NewGroup{i,1}));
end

% Look for shared group names and merge corresponding index sets
% RE: Sorting IS2 in decreasing order to ensure that deletions 
%     in NewGroup don't mess up indexing.
[is1,is2] = NameIntersect(char(Group(:,2)),char(NewGroup(:,2)));
[junk,is] = sort(-is2);
is1 = is1(is);  
is2 = is2(is); 
for i=1:length(is2),
   % RE: sort needed for use in lti/subsasgn (groupasgn)
   Group{is1(i),1} = sort([Group{is1(i),1} , NewGroup{is2(i),1}]);
   NewGroup(is2(i),:) = [];
end
      
% Append groups      
Group = [Group ; NewGroup];


% Subfunction NameIntersect
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ia,ib] = NameIntersect(a,b)
%NAMEINTERSECT  Looks for matching strings in CHAR arrays A and B
%
%  Output:  A(IA)=B(IB) are the shared names

if isempty(a) | isempty(b),
   ia = []; ib = [];  return
end

% Adjust number of columns in A and B
space = ' ';
[ra,ca] = size(a);
[rb,cb] = size(b);
a = [a , space(ones(1,ra),ones(1,cb-ca))];
b = [b , space(ones(1,rb),ones(1,ca-cb))];

% Find matching entries (discarding '' names)
[c,ndx] = sortrows([a;b]);
d = find(all(c(1:end-1,:)==c(2:end,:),2) & any(c(1:end-1,:)~=' ',2));

% Derive indices
ndx = ndx([d;d+1]);
boo = (ndx<=ra);
ia = ndx(boo);
ib = ndx(~boo)-ra;

