function Value = calcopt(varargin);
%CALCOPT calculates Plot Options for Step Response Plots
%   Value = CALCOPT(Property,RespObj) calculates the values of the
%   Plot Options specified by Property for all systems in the Response
%   Object, RespObj. The values are returned as the cell array, Value, 
%   where each cell represents the results for each system in RespObj.
%
%   Value = CALCOPT(Property,RespObj,Index) calculates the values for
%   only the systems in RespObj for the indices in Index.
% $Revision: 1.6 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly 1-28-97.

ni=nargin;
error(nargchk(2,3,ni));

Property = varargin{1};
RespObj = varargin{2};
ResponseHandles = get(RespObj,'ResponseHandles');
SteadyStateVal = RespObj.SteadyStateValue;
SysNames = get(RespObj,'SystemNames');

if ni>2,
   Ind = varargin{3};
else
   Ind = [1:length(ResponseHandles)];   
end

switch lower(Property),
case 'peakresponsevalue',
   Value = struct('System',cell(length(Ind),1),'Time',cell(length(Ind),1),...
      'Peak',cell(length(Ind),1));
   
case 'risetimevalue',
   Value = struct('System',cell(length(Ind),1),...
      'StartTime',cell(length(Ind),1),...
      'RiseTime',cell(length(Ind),1),...
      'Amplitude',cell(length(Ind),1));
   RiseTimeLims = RespObj.RiseTimeLimits;
   
case 'settlingtimevalue',
   Value = struct('System',cell(length(Ind),1),'SettlingTime',cell(length(Ind),1),...
      'Amplitude',cell(length(Ind),1));
   SetTimeLims = RespObj.SettlingTimeThreshold;
   
end

for ctInd = 1:length(Ind);
   AllHandles = ResponseHandles{Ind(ctInd)}; % Handles for a particular system
   K=SteadyStateVal(Ind(ctInd)).Amplitude;
   Value(ctInd).System = SysNames{Ind(ctInd)};
   Xvals = ones([size(AllHandles),size(AllHandles{1})]);
   Yvals = Xvals;
   for ctrow = 1:size(AllHandles,1),
      for ctcol = 1:size(AllHandles,2),
         Handles = AllHandles{ctrow,ctcol};
         %---Go through each model
         for ctModel = 1:prod(size(Handles)),
            Karray=K(:,:,ctModel);
            ResponseLine = findobj(Handles{ctModel},'Tag','LTIresponseLines');
            X = get(ResponseLine,'Xdata');
            Y = get(ResponseLine,'Ydata');
            absY=abs(Y);
            
            switch lower(Property),
               
            case 'peakresponsevalue',
               [garb,indMax]=max(absY);
               Ymax=Y(indMax);
               Xmax=X(indMax);
               Yvals(ctrow,ctcol,ctModel) = Ymax;
               Xvals(ctrow,ctcol,ctModel)= Xmax;
               
            case 'risetimevalue',
               absK=abs(Karray(ctrow,ctcol));
               IndStart = find(absY>=RiseTimeLims(1)*absK);
               IndEnd = find(absY>=RiseTimeLims(2)*absK);
               
               if ~isempty(IndStart) & ~isempty(IndEnd) & ...
                     ~isequal(length(IndStart),length(IndEnd)),
                  Tr=X(IndEnd(1))-X(IndStart(1));
                  Rr=Y(IndEnd(1));
               elseif isinf(Karray(ctrow,ctcol)) | isequal(length(IndStart),length(IndEnd)),
                  Tr=Inf;
                  Rr=Inf;
               else
                  Tr=NaN;
                  Rr=NaN;
               end % if/else ~isempty(IndStart...
               Yvals(ctrow,ctcol,ctModel) = Rr;
               Xvals(ctrow,ctcol,ctModel) = Tr;
               Startvals(ctrow,ctcol,ctModel) = X(IndStart(1));
               
            case 'settlingtimevalue',
               if isinf(Karray(ctrow,ctcol)),
                  IndTs=Inf;
               else
                  SetTimeAmp = SetTimeLims*max(abs(Y(1)-Karray(ctrow,ctcol)),...
                     (.5*max(abs(Y-Karray(ctrow,ctcol)))));
                  indTs = find(abs(Y-Karray(ctrow,ctcol))>SetTimeAmp);
               end
               
               if ~isempty(indTs),
                  Ts=X(indTs(end));
                  Rs=Y(indTs(end));
               elseif isinf(indTs),
                  Ts=Inf;
                  Rs=Inf;
               else
                  Ts=0;
                  Rs=Y(1);
               end % if/else isempty(indTr)
               Yvals(ctrow,ctcol,ctModel) = Rs;
               Xvals(ctrow,ctcol,ctModel) = Ts;
               
            end % switch Property
         end % for ctModel
      end % for ctcol,
   end % for ctrow
   
   %---Store the calculated values into the structured array
   switch lower(Property),
   case 'peakresponsevalue',
      Value(ctInd).Time = Xvals;
      Value(ctInd).Peak = Yvals;
      
   case 'risetimevalue',
      Value(ctInd).StartTime = Startvals;
      Value(ctInd).RiseTime = Xvals;
      Value(ctInd).Amplitude = Yvals;
      
   case 'settlingtimevalue',
      Value(ctInd).SettlingTime = Xvals;
      Value(ctInd).Amplitude = Yvals;
      
   end
   
end % for ctInd

% end ../@stepresp/calcopt.m
