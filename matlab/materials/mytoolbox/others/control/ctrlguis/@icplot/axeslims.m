function [Xlims,Ylims] = axeslims(IcRespObj,RespObj);
%AXESLIMS sets the axes limits for Initial Condition Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/21 19:38:08 $
%   Karen Gondoly 5-14-98.

AllRespProps = get(RespObj);
DispAx = AllRespProps.PlotAxes;  
Xlims = AllRespProps.Xlims;
Ylims = AllRespProps.Ylims;

if strcmp(AllRespProps.YlimMode,'auto')
   set(DispAx,'YlimMode','auto');
end

if strcmp(AllRespProps.XlimMode,'auto')
   set(DispAx,'XlimMode','auto');
end

if strcmp(AllRespProps.YlimMode,'manual')
   for ctAx = 1:size(DispAx,1),
      set(DispAx(ctAx,:),'Ylim',Ylims{ctAx})
   end
end

if strcmp(AllRespProps.XlimMode,'manual')
   set(DispAx,'Xlim',Xlims{1})
end

if strcmp(AllRespProps.XlimMode,'auto')
   %---Set Uniform X-axis limits across each column
   Lims = findlims(DispAx,'Xlim');
   set(DispAx,'Xlim',Lims)
   
   %---Make sure current axes limits are stored
   Xlims = get(DispAx(1),{'Xlim'});
   
end % if/else strcmp(XlimMode...
Ylims = get(DispAx(:,1),{'Ylim'});

%---Rescale the ExtraTime Lines
TimeLine=findall(DispAx,'tag','ExtraTimeLine');
P = get(TimeLine,{'Parent'}); P = cat(1,P{:});
X = get(P,{'Xlim'});
set(TimeLine,{'Xdata'},X);

%---Rescale the Peak Response Lines
PRLines = findall(DispAx,'Tag','PeakResponseMarker','Marker','none');
for ctL=1:length(PRLines),
   X = get(PRLines(ctL),'Xdata');
   Y = get(PRLines(ctL),'Ydata');
   if ~isequal(Y(1),Y(2)),
      Ylim = get(get(PRLines(ctL),'Parent'),'Ylim');
      set(PRLines(ctL),'Ydata',[Ylim(1),Y(2)]);
   elseif ~isequal(X(1),X(2)),
      Xlim = get(get(PRLines(ctL),'Parent'),'Xlim');
      set(PRLines(ctL),'Xdata',[Xlim(1),X(2)]);
   end
end % for ctL


