function indices = nameref(indstr,L,ioflag)
%NAMEREF  Turn references by name into regular subscripts
%
%   IND = NAMEREF(STRCELL,L,IOFLAG)  takes a cell vector of 
%   strings STRCELL and looks for matching I/O channel or 
%   I/O group names in the LTI object L.  The search is 
%   carried out among the outputs if IOFLAG=1, and among 
%   the inputs if IOFLAG=2.
%   
%   See also SUBSREF, SUSBASGN.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/08/25 19:10:11 $


% Make sure input is a cell array of strings
if isa(indstr,'numeric') | isequal(indstr,':'),
   indices = indstr;   return
elseif ischar(indstr),
   indstr = cellstr(indstr);
elseif ~iscellstr(indstr)
   error(sprintf('Index #%d cannot be processed.',ioflag))
end

if length(indstr) ~= prod(size(indstr))
   error('Use cell vector of strings for channel or group names.');
end
   
% Set name lists for search based on IOFLAG
if ioflag==1
   ChannelNames = L.OutputName;
   Groups = L.OutputGroup;
else
   ChannelNames = L.InputName;
   Groups = L.InputGroup;
end

% Perform a string-by-string matching to respect the
% referencing order
indices = zeros(1,0);
for ix = 1:length(indstr)
   str = indstr{ix};
   if isempty(str),
      error('Ambiguous name reference ''''. Supply more characters.')
   end
   % Match against channel names
   imatch1 = strmatch(lower(str),lower(ChannelNames));
   nhits1 = length(imatch1);
   % Match against group names
   imatch2 = strmatch(lower(str),lower(Groups(:,2)));
   nhits2 = length(imatch2);
   % If multiple match, retry with case-sensitive matching
   if nhits1+nhits2>1,
      imatch1 = strmatch(str,ChannelNames);        
      imatch2 = strmatch(str,Groups(:,2));   
      if length([imatch1;imatch2])==1, % success
         nhits1 = length(imatch1);   nhits2 = length(imatch2);
      end
   end
   % Error checks  
   if nhits1>1,
      error(sprintf('Ambiguous channel name reference ''%s''. Supply more characters.',str))
   elseif nhits2>1,
      error(sprintf('Ambiguous group name reference ''%s''. Supply more characters.',str))
   elseif nhits1+nhits2>1,
      error(sprintf(...
         'Name reference ''%s'' matches both a channel and a group.',str))
   elseif nhits1+nhits2==0,
      error(sprintf('Unmatched name reference ''%s''.',str))
   elseif nhits1,
      indices = [indices , imatch1];
   else
      indices = [indices , Groups{imatch2,1}];
   end
end

      
