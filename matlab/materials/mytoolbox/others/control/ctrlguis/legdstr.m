function LegendStr = legdstr(varargin);
%LEGDSTR creates a color/linestyle/marker string for Response Object menus
%    LEGENDSTR = LEGDSTR(COLOR) takes the color indicated by COLOR and
%    makes it into a string that can be displayed in the Systems list
%    of the Response Object menu. COLOR can be either a single letter string
%    that is valid as a color specifier for the PLOT command, or an RGB
%    triplet. In the case of RGB triplets, LEDGSTR will determine the color
%    closest to the triplet and use that in the legend.
%
%    LEGENDSTR = LEGDSTR(COLOR,LINESTYLE,MARKER) appends the Linestyle and
%    Marker type indicated in the strings LINESTYLE and MARKER to the color.
% $Revision: 1.5 $

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   Karen Gondoly 1-27-98.

ni = nargin;
%---At least a color has to be entered
error(nargchk(1,3,ni));

CC = varargin{1};
AllColors = {'blue';'green';'red';'cyan';'magenta';'yellow';'black';'white'};
AllLines = {'solid';'dashed';'dash-dot';'dotted'};
Lstr='';
Mstr='';

if ni>=2
   if ~iscell(varargin{2}) & ischar(varargin{2}),
      Lind = find(strcmpi(varargin{2},{'-';'--';'-.';':'}));
      if isempty(Lind) & strcmp(varargin{2},'none'),
         Lstr='';
      elseif isempty(Lind)
         error(sprintf('Invalid linestyle specification: %s',varargin{2}))
      else
         Lstr = AllLines{Lind};
      end      
   else
      error('The linestyle must be entered as a character array')
   end % if/else ~iscell
end % if ni>=2

if ni==3
   if ~iscell(varargin{3}) & ischar(varargin{3}),
      Mstr = varargin{3};
      if strcmp(Mstr,'none'), % Don't bother showing empty markerstyles
         Mstr='';
      end
   else
      error('The marker must be entered as a character array')
   end % if/else ~iscell...
end % if ni==3
      
if ~isempty(CC)
   if ischar(CC), % Working with a string
      if iscell(CC) | ~isequal(length(CC),1),
         error('The color must be a single character.')
      end
      
      colorind = strmatch(CC,AllColors);
      if isempty(colorind) & strcmp(CC,'k'),
         Cstr = 'black';
      elseif length(colorind)>1,
         Cstr = 'blue';
      elseif ~isempty(colorind),
         Cstr = AllColors{colorind};
      else
         error('Invalid color specification')
      end % if/else isempty(colorind...
   else
      %---Have to figure out the RGB combination
      %---As a first cut, round the triplet and look at which indices contain ones
      CC = round(CC);   
      AllRGBs = {[0 0 1];[0 1 0];[1 0 0];[0 1 1];[1 0 1];[1 1 0];[0 0 0];[1 1 1]};
      for ct=1:length(AllRGBs),
         if isequal(CC,AllRGBs{ct}),
            colorind = ct;
         end
      end
      if ~isempty(colorind),
         Cstr = AllColors{colorind};
      else
         error('Invalid RGB triplet')
      end
   end % if/else ischar
else
   Cstr = [];
end % if/else ~isempty(CC)
LegendStr = [Cstr];

if ~isempty(Lstr)
   LegendStr = [LegendStr,',',Lstr];
end

if ~isempty(Mstr),
   LegendStr = [LegendStr,',',Mstr];
end