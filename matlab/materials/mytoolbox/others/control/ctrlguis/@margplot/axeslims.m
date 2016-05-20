function [Xlims,Ylims] = axeslims(MargRespObj,RespObj);
%AXESLIMS sets the axes limits for Margin Response Objects

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
   set(DispAx(:),{'Ylim'},Ylims)
end

if strcmp(AllRespProps.XlimMode,'manual')
   set(DispAx(:),'Xlim',Xlims{1})
end

if strcmp(AllRespProps.XlimMode,'auto')
   %---Gve all axes a common X-axis limit
   Lims = findlims(DispAx(:),'Xlim');
   set(DispAx(:),'Xlim',Lims)     
   
   %---Make sure current axes limits are stored
   Xlims = get(DispAx(1),{'Xlim'});
   
end % if/else strcmp(XlimMode...

Ylims = get(DispAx,{'Ylim'});

%---Make sure X-limits do not exceed range of data
Lines = findall(DispAx,'Tag','LTIresponseLines');
Xdata = get(Lines,{'Xdata'});
Xdata = cat(2,Xdata{:});
Xmin = min(Xdata(:));
Xmax = max(Xdata(:));
if (abs((Xmin-Xlims{1}(1))/Xlims{1}(1)) > 0.001) | ...
      (abs((Xmax-Xlims{1}(2))/Xlims{1}(2)) > 0.001),
   Xlims{1} = [Xmin, Xmax];
   set(DispAx,'Xlim',Xlims{1});
end
   


