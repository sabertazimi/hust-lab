function [indices,freqIndices] = getfreqindex(sys, indices)
% GETFREQINDEX looks through indices for frequency access indices,
%              returns frequency indices and remaining indices

% since last 2 elements must be  keyword,freqIndices,
% look at last two indices only

%   Author: S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/09/18 20:45:58 $

nind = length(indices);
freqIndices = indices{nind};	% dereference this now

keyword = indices{max(1,nind-1)}; % keyword 'frequency' in end-1 position
if nind < 2 | ...
   ~ischar(keyword) | ...
   ~strncmpi(keyword,'frequencypoints',length(keyword))
   freqIndices = ':';
   return
end

if nind <= 3  % keyword in position 1,2 could be channel/group name
   lasterr('');
   try
      nameref(keyword,sys.lti,nind-1);  % try to match I/O name
   end
   % Give priority to Channel/Group name over 'frequency' keyword
   % If the call to nameref above succeeds or does not return an error
   % which includes the string below, then assume group/channel name match
   % was found.  
   if isempty(findstr(lasterr,'Unmatched name reference'))
      warning(['Interpreting ''', keyword, ...
               ''' as channel/group name, not ''', ...
               keyword(1), 'requency'' keyword.']);
      freqIndices = ':';
      return
   end
   % if indices are now empty, use all I/O dimensions at given frequencies
   indices = [repmat({':'},[1 2*(nind==2)]) indices(1:end-2)];
else
   indices = indices(1:end-2);
end
