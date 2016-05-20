function [Xlims,Ylims] = axeslims(NyqRespObj,RespObj);
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
   for ctAx = 1:size(DispAx,2),
      set(DispAx(:,ctAx),'Xlim',Xlims{ctAx})
   end
end

if strcmp(AllRespProps.XlimMode,'auto')
   %---Set Uniform X-axis limits across each column
   Lims = findlims(DispAx,'Xlim');
   set(DispAx,'Xlim',Lims)
   
   %---Make sure current axes limits are stored
   Xlims = get(DispAx(1),{'Xlim'});
   
end % if/else strcmp(XlimMode...
Ylims = get(DispAx(:,1),{'Ylim'});

   


