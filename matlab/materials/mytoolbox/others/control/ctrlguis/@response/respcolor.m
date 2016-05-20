function varargout = respcolor(varargin);
%RESPCOLOR creates a color/linestyle/marker string for Response Object menus
%    LEGENDSTR = RESPCOLOR(RespObj,PlotStr) returns a suitable legend string
%    for the color, linestyle, and marker contained in the string PlotStr. 
%    If PlotStr is empty, RESPCOLOR uses a default plot string.

%    LEGENDSTR = RESPCOLOR(RespObj,PlotStr,NumSys,FRDflag) is useful when PlotStr
%    is empty, to override the default plot string.  NumSys indicates the Systems 
%    index on the plot. RESPCOLOR chooses a color based on NumSys.
%    FRDflag indicates if the system is an FRD (1), or not (0).
%    If the system is an FRD, the plots do not use a linestyle and cycle through
%    the marker styles, as well as the colors. All other LTI Objects cycle through
%    only the color, using a solid line and no marker.
%
%    [LEGENDSTR,CC,LL,MM] = RESPCOLOR(RespObj,PlotStr,NumSys,FRDflag) also returns 
%    a color, linestyle, and marker to use when plotting the response

%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.3 $
%   Karen Gondoly 4-13-98.

ni = nargin;
no = nargout;
%---At least a color has to be entered
error(nargchk(2,4,ni));

ScreenDepth = get(0,'ScreenDepth');

RespObj = varargin{1};
PlotStr = varargin{2};

Cvals = RespObj.ColorOrder; 
numC=size(Cvals,1);
Lvals = RespObj.LinestyleOrder;
numL = size(Lvals,1);
Mvals = RespObj.MarkerOrder;

%---Prepare markers for FRDs
MMsys = Mvals{1};
%Mvals(find(strcmpi('none',Mvals)))=[];
numM = size(Mvals,1);

if ni>2,
   NumSys=varargin{3};
else
   NumSys=1;
end

if ni>3,
   FRDflag=varargin{4};
else
   FRDflag=0;
end

AllColors = {'blue';'green';'red';'cyan';'magenta';'yellow';'black';'white'};
AllLines = {'solid';'dashed';'dash-dot';'dotted'};
Lstr='';
Mstr='';

if ~isempty(PlotStr)
   [LL,CC,MM,msg]=colstyle(PlotStr);
   if isempty(CC),
      CC=Cvals(NumSys-(numC*floor((NumSys-1)/numC)),:);
   end
   if isempty(MM);
      MM='none';
   elseif isempty(LL),
      LL='none';
   end
   if isempty(LL);
      LL='-';
   end
else
   %---Do some optimizing based on LTI-type and ScreenDepth
   CC = Cvals(NumSys-(numC*floor((NumSys-1)/numC)),:);
   if FRDflag
      LL='-';
      MM = Mvals{NumSys-(numM*floor((NumSys-1)/numM))};
   else
      if isequal(ScreenDepth,1); % Monochrome screen
         LL=Lvals{NumSys-(numL*floor((NumSys-1)/numL))};
      else
         LL=Lvals{1};
      end
      MM = MMsys;
   end
   
end % if/else ~isempty(PlotStr)

if ischar(CC), % Working with a string
   NiceRGBs = {[0 0 1];[0 0.5 0];[1 0 0];[0 .75 .75];[.75 0 .75];[.75 .75 0];[.25 .25 .25];[1 1 1]};
   if iscell(CC) | ~isequal(length(CC),1),
      error('The color must be a single character.')
   end
   
   colorind = strmatch(CC,AllColors);
   if isempty(colorind) & strcmp(CC,'k'),
      Cstr = 'black';
      CC = [.25 .25 .25];
   elseif length(colorind)>1,
      Cstr = 'blue';
      CC=[0 0 1];
   elseif ~isempty(colorind),
      Cstr = AllColors{colorind};
      CC = NiceRGBs{colorind};
   else
      error('Invalid color specification')
   end % if/else isempty(colorind...
else
   %---Have to figure out the RGB combination
   %---As a first cut, round the triplet and look at which indices contain ones
   roundCC = round(CC);   
   AllRGBs = {[0 0 1];[0 1 0];[1 0 0];[0 1 1];[1 0 1];[1 1 0];[0 0 0];[1 1 1]};
   for ct=1:length(AllRGBs),
      if isequal(roundCC,AllRGBs{ct}),
         colorind = ct;
      end
   end
   if ~isempty(colorind),
      Cstr = AllColors{colorind};
   else
      error('Invalid RGB triplet')
   end
end % if/else ischar
LegendStr = Cstr;

Lind = find(strcmpi(LL,{'-';'--';'-.';':'}));
if isempty(Lind) & strcmp(LL,'none'),
   Lstr='';
elseif isempty(Lind)
   error(sprintf('Invalid linestyle specification: %s',varargin{2}))
else
   Lstr = AllLines{Lind};
end      

Mstr = MM;
if strcmp(Mstr,'none'), % Don't bother showing empty markerstyles
   Mstr='';
end

if ~isempty(Lstr)
   LegendStr = [LegendStr,',',Lstr];
end

if ~isempty(Mstr),
   LegendStr = [LegendStr,',',Mstr];
end

if no>=1,
   varargout{1}=LegendStr;
end
varargout{2}=CC;
varargout{3}=LL;
varargout{4}=MM;
