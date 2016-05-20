function [Xlims,Ylims] = axeslims(PZRespObj,RespObj);
%AXESLIMS sets the axes limits for Pole-zero Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/21 19:38:07 $
%   Karen Gondoly 1-30-98.

AllRespProps = get(RespObj);
DispAx = AllRespProps.PlotAxes;  
Xlims = AllRespProps.Xlims;
Ylims = AllRespProps.Ylims;

if strcmp(AllRespProps.YlimMode,'auto')
   set(DispAx,'YlimMode','auto');
end

if strcmp(AllRespProps.XlimMode,'auto')
   set(DispAx,'XlimMode','auto');
   %---Make sure imaginary axis is shown
   Xlims = get(DispAx,'Xlim');
   if Xlims(1)>0 
      Xlims(1)=0;
   elseif Xlims(2)<0,
      Xlims(2)=0;
   end
end

if strcmp(AllRespProps.YlimMode,'manual')
   set(DispAx,'Ylim',Ylims{1})
end

if strcmp(AllRespProps.XlimMode,'manual')
   set(DispAx,'Xlim',Xlims{1})
end

Ylims = get(DispAx,{'Ylim'});
Xlims = get(DispAx,{'Xlim'});

set(findall(DispAx,'Tag','PZyaxisLine'),'Ydata',Ylims{1});
set(findall(DispAx,'Tag','PZxaxisLine'),'Xdata',Xlims{1});

