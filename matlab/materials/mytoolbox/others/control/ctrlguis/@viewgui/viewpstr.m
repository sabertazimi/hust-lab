function varargout = viewpstr(varargin);
%VIEWPSTR creates a cell array of Plot Strings for the LTI Viewer
%    PLOTSTR = VIEWPSTR(ViewerObj) returns a suitable cell array of
%    plot strings for all the systems contained in the LTI Viewer
%    object ViewerObj.
%
%    PLOTSTR = VIEWPSTR(ViewerObj,N) creates an appropriate plot
%    string for the N'th system in the Viewer.
%
%    PLOTSTR = VIEWPSTR(ViewerObj,N,FRDflag) creates an appropriate plot
%    string for the N'th system in the Viewer. FRDflag is set to 1 to
%    force the plot string to be appropriate for an FRD, or 0 to force
%    the plot string to be appropriate for a non-FRD system. If FRDflag
%    is empty, the plot string is returned as a value appropriate for
%    the Nth system currently stored in the Viewer.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.4 $
%   Karen Gondoly 4-13-98.

ni = nargin;
no = nargout;
%---At least a color has to be entered
error(nargchk(1,3,ni));

ScreenDepth = get(0,'ScreenDepth');

AllCnames = {'blue';'green';'red';'cyan';'magenta';'yellow';'black';'white'};
AllColors = {'b';'g';'r';'c';'m';'y';'k';'w'};

ViewObj = varargin{1};
PlotStrs = ViewObj.PlotStrings;

if ni>1,
   NumSys = varargin{2};
   %---Make sure NumSys is a row vector
   NumSys = NumSys(:)';
else
   NumSys = 1:length(PlotStrs);
end

if ni>2,
   FRDflag=varargin{3};
else
   FRDflag = zeros(length(PlotStrs),1);
   for ctS=1:length(PlotStrs),
      FRDflag(ctS) = isa(ViewObj.Systems{ctS},'frd');
   end;
end

Cvals = ViewObj.ColorOrder; 
numC=size(Cvals,1);
Lvals = ViewObj.LineStyleOrder;
numL = size(Lvals,1);
Mvals = ViewObj.MarkerOrder;

%---Prepare markers for FRDs
%MMsys = Mvals{1};
%Mvals(find(strcmpi('none',Mvals)))=[];
numM = size(Mvals,1);

Systems = ViewObj.Systems;
ctSys=0;
for ctR=NumSys;
   ctSys=ctSys+1;
   CC=Cvals{ctR-(numC*floor((ctR-1)/numC))};
   indC = find(strcmpi(CC,AllCnames));
   PlotStrs{ctR} = AllColors{indC};
   if FRDflag(ctSys),
      PlotStrs{ctR} = [PlotStrs{ctR},Mvals{ctR-(numM*floor((ctR-1)/numM))},'-'];
    % PlotStrs{ctR} = [PlotStrs{ctR},'-'];
   end
end % for ctR

if no
   varargout{1}=PlotStrs(NumSys);
end
