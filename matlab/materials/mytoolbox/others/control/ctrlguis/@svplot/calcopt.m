function Value = calcopt(varargin);
%CALCOPT calculates Plot Options for Singular Value Response Plots
%   Value = CALCOPT(Property,RespObj) calculates the values of the
%   Plot Options specified by Property for all systems in the Response
%   Object, RespObj. The values are returned as the cell array, Value, 
%   where each cell represents the results for each system in RespObj.
%
%   Value = CALCOPT(Property,RespObj,Index) calculates the values for
%   only the systems in RespObj for the indices in Index.
% $Revision: 1.2 $

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
   Value = struct('System',cell(length(Ind),1),'Frequency ',cell(length(Ind),1),...
      'Peak',cell(length(Ind),1));
   
end % switch lower(Property)

for ctInd = 1:length(Ind);
   AllHandles = ResponseHandles{Ind(ctInd)}; % Handles for a particular system
   Value(ctInd).System = SysNames{Ind(ctInd)};
   Xvals = ones([size(AllHandles,1),size(AllHandles,2),size(AllHandles{1})]);
   Yvals = Xvals;
   Handles = AllHandles{1,1};
   %---Go through each model in the array
   for ctModel = 1:prod(size(Handles)),
      ResponseLine = findobj(Handles{ctModel},'Tag','LTIresponseLines');
      X = get(ResponseLine,{'Xdata'});
      Y = get(ResponseLine,{'Ydata'});
      
      switch lower(Property),
         
      case 'peakresponsevalue',
         X=[X{:}]; Y=[Y{:}]; 
         [garb,indMax]=max(Y);
         Ymax(ctModel,1) = Y(indMax);
         Xmax(ctModel,1) = X(indMax);
      end % switch Property
   end % for ctModel
   Xmax=reshape(Xmax,1,1,length(Xmax));
   Ymax=reshape(Ymax,1,1,length(Ymax));
   
   %---Store the calculated values into the structured array
   switch lower(Property),
   case 'peakresponsevalue',
      Value(ctInd).Frequency = Xmax;
      Value(ctInd).Peak = Ymax;
      
   end % switch lower(Property)
   
end % for ctInd

% end ../@svresp/calcopt.m