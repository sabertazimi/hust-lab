function Value = calcopt(varargin);
%CALCOPT calculates Plot Options for Bode Response Plots
%   Value = CALCOPT(Property,RespObj) calculates the values of the
%   Plot Options specified by Property for all systems in the Response
%   Object, RespObj. The values are returned as the cell array, Value, 
%   where each cell represents the results for each system in RespObj.
%
%   Value = CALCOPT(Property,RespObj,Index) calculates the values for
%   only the systems in RespObj for the indices in Index.
% $Revision: 1.5 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly 1-28-97.

ni=nargin;
error(nargchk(2,3,ni));

Property = varargin{1};
RespObj = varargin{2};
ResponseHandles = get(RespObj,'ResponseHandles');
SysNames = get(RespObj,'SystemNames');

if ni>2,
   Ind = varargin{3};
else
   Ind = [1:length(ResponseHandles)];   
end

switch lower(Property),
case 'peakresponsevalue',
   Value = struct('System',cell(length(Ind),1),'Frequency',cell(length(Ind),1),...
      'Peak',cell(length(Ind),1));
   
case 'stabilitymarginvalue',
   Value = struct('System',cell(length(Ind),1),...
      'GainMargin',cell(length(Ind),1),...
      'GMFrequency',cell(length(Ind),1),...
      'PhaseMargin',cell(length(Ind),1),...
      'PMFrequency',cell(length(Ind),1));
   %---Will need to get Systems from the LTI Viewer
   LTIviewerFig = get(RespObj,'Parent');
   if strcmp(get(LTIviewerFig,'Tag'),'ResponseGUI'),
      ViewerObj = get(LTIviewerFig,'UserData');
      Systems = get(ViewerObj,'Systems');
      FRDind = get(ViewerObj,'FrequencyData');
   else
      Systems=[];
   end
end % switch

%---Turn warnings off, temporarily, to avoid MARGIN warnings
WarnStr = warning;
warning off;

for ctInd = 1:length(Ind);
   AllHandles = ResponseHandles{Ind(ctInd)}; % Handles for a particular system
   Value(ctInd).System = SysNames{Ind(ctInd)};
   Xvals = ones([size(AllHandles,1)/2,size(AllHandles,2),size(AllHandles{1})]);
   Yvals = Xvals;
   switch lower(Property),
      
   case 'peakresponsevalue',
      for ctrow = 1:2:size(AllHandles,1),
         for ctcol = 1:size(AllHandles,2),
            Handles = AllHandles{ctrow,ctcol};
            %---Go through each model
            for ctModel = 1:prod(size(Handles)),
               ResponseLine = findobj(Handles{ctModel},'Tag','LTIresponseLines');
               X = get(ResponseLine,'Xdata');
               Y = get(ResponseLine,'Ydata');
               
               %---Only look at Magnitudes
               [garb,indMax]=max(Y);
               Ymax=Y(indMax);
               Xmax=X(indMax);
               Yvals(ceil(ctrow/2),ctcol,ctModel) = Ymax;
               Xvals(ceil(ctrow/2),ctcol,ctModel)= Xmax;
            end % for ctModel
         end % for ctcol,
      end % for ctrow
      Value(ctInd).Frequency = Xvals;
      Value(ctInd).Peak = Yvals;
      
   case 'stabilitymarginvalue',
      if ~isempty(Systems) & (isempty(FRDind) | ~any(ctInd==FRDind)),
         [Gm,Pm,Wcg,Wcp]=margin(Systems{Ind(ctInd)});
      else
         Gm=[];Pm=[];Wcg=[];Wcp=[];
      end
      if strcmpi(RespObj.MagnitudeUnits,'decibels'),
         Gm = 20*log10(Gm);
      end
      if strcmpi(RespObj.PhaseUnits,'radians'),
         Pm = (pi/180)*Pm;
      end
      if strncmpi(RespObj.FrequencyUnits,'h',1),
         Wcg = Wcg*1/(2*pi);
         Wcp = Wcp*1/(2*pi);
      end
      Value(ctInd).GainMargin = Gm;
      Value(ctInd).PhaseMargin = Pm;
      Value(ctInd).GMFrequency = Wcg;
      Value(ctInd).PMFrequency = Wcp;
   end % switch Property
   
end % for ctInd

warning WarnStr;

% end ../@bodplot/calcopt.m