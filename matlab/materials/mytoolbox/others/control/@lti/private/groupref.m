function Group = groupref(Group,indices)
%GROUPREF  Manage I/O groups in subscripted references
%
%   SUBGROUP = GROUPREF(GROUP,INDICES)
%
%   See also SUBSREF.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/02/12 19:55:36 $

if ~isempty(Group) & ~isequal(indices,':'),
   idel = [];
   % Get rid of logical indices
   if islogical(indices), 
      indices = find(indices); 
   end
   
   % For each group, delete channels that don't belong to INDICES
   for i=1:size(Group,1),
      iselect = find(ismember(indices,Group{i,1}));
      if isempty(iselect),
         idel = [idel i];
      else
         Group{i,1} = sort(iselect);
      end
   end
   Group(idel,:) = [];
end

