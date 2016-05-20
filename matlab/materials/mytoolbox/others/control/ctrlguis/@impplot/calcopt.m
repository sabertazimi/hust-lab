function Value = calcopt(varargin);
%CALCOPT calculates Plot Options for Impulse Response Plots
%   Value = CALCOPT(Property,RespObj) calculates the values of the
%   Plot Options specified by Property for all systems in the Response
%   Object, RespObj. The values are returned as the cell array, Value, 
%   where each cell represents the results for each system in RespObj.
%
%   Value = CALCOPT(Property,RespObj,Index) calculates the values for
%   only the systems in RespObj for the indices in Index.
% $Revision: 1.4 $

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
   Value = struct('System',cell(length(Ind),1),'Time',cell(length(Ind),1),...
      'Peak',cell(length(Ind),1));
   
case 'settlingtimevalue',
   Value = struct('System',cell(length(Ind),1),'SettlingTime',cell(length(Ind),1),...
      'Amplitude',cell(length(Ind),1));
   SetTimeLims = get(RespObj,'SettlingTimeThreshold');
   
end

for ctInd = 1:length(Ind);
   AllHandles = ResponseHandles{Ind(ctInd)}; % Handles for a particular system
   Value(ctInd).System = SysNames{Ind(ctInd)};
   Xvals = ones([size(AllHandles),size(AllHandles{1})]);
   Yvals = Xvals;
   for ctrow = 1:size(AllHandles,1),
      for ctcol = 1:size(AllHandles,2),
         Handles = AllHandles{ctrow,ctcol};
         %---Go through each model
         for ctModel = 1:prod(size(Handles)),
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
               
            case 'settlingtimevalue',
               SetTimeAmp = SetTimeLims*max(abs(Y(1)),(.5*max(abs(Y))));
               indTs = find(abs(Y)>SetTimeAmp);
               
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
      end % for ctcol
   end % for ctrow
   
   %---Store the calculated values into the structured array
   switch lower(Property),
   case 'peakresponsevalue',
      Value(ctInd).Time = Xvals;
      Value(ctInd).Peak = Yvals;
      
   case 'settlingtimevalue',
      Value(ctInd).SettlingTime = Xvals;
      Value(ctInd).Amplitude = Yvals;
      
   end
   
end % for ctInd

% end ../@impresp/calcopt.m
