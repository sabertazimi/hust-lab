function dispprop(L,StaticFlag)
%DISPPROP  Creates display for LTI properties

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1998/07/16 20:07:54 $

% Display input Groups
disp(FormatGroup(L.InputGroup,L.OutputGroup));

% Display sample time (for discrete-time models only)
if ~StaticFlag,
   if L.Ts<0,
      disp('Sampling time: unspecified')
   elseif L.Ts>0,
      disp(sprintf('Sampling time: %0.5g',L.Ts))
   end
end


% Subfunction FORMATGROUP
%%%%%%%%%%%%%%%%%%%%%%%%%
function Display = FormatGroup(Igroup,Ogroup);

nig = size(Igroup,1);
nog = size(Ogroup,1);
ng = nig+nog;
if ng==0,
   Display = '';  return
end

% Concatenate groups
Group = [Igroup ; Ogroup];
Blank = ' ';  I = 'I';  O = 'O';

% Name display
Names = Group(:,2);
inamed = find(strcmp(Names,''));
for i=inamed',
   Names{i} = ['#' num2str(i)];
end
Names = strjust(strvcat('Group name',char(Names)),'center');

% Channel display
Channels = cell(ng,1);
for i=1:ng,
   str = sprintf('%d,',Group{i,1});
   Channels{i} = str(1:end-1);
end
Channels = strjust(strvcat('Channel(s)',char(Channels)),'center');

% I/O Selector
Types = strjust(strvcat('I/O',I(ones(nig,1)),O(ones(nog,1))),'center');

% Final display string
Display = strvcat('I/O groups:',...
                  [Blank(ones(ng+1,4)) , Names , ...
                   Blank(ones(ng+1,4)) , Types , ...
                   Blank(ones(ng+1,4)) , Channels],' ');


   