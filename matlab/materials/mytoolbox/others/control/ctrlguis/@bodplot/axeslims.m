function [Xlims,Ylims] = axeslims(BodRespObj,RespObj);
%AXESLIMS sets the axes limits for Bode Diagram Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/09/11 18:08:45 $
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

if strcmp(AllRespProps.YlimMode,'auto')
   %---Set Uniform Y-axis limits across each row
   for ctax=1:size(DispAx,1),
      Lims = findlims(DispAx(ctax,:),'Ylim');
      set(DispAx(ctax,:),'Ylim',Lims);
   end % for ctax
   
   %---Make sure current axes limits are stored
   Ylims = get(DispAx(:,1),{'Ylim'});
end % if/else strcmp(YlimMode...
%----end Y-axis scaling

if strcmp(AllRespProps.XlimMode,'auto'),
   Xminall=[]; Xmaxall=[];
   
   for ctax=1:size(DispAx,2),
      %---Get common X-limits for each column
      Lims = findlims(DispAx(:,ctax),'Xlim');
      set(DispAx(:,ctax),'Xlim',Lims)
      
      %---Make sure current axes limits are stored
      Xlims = get(DispAx(1,:),{'Xlim'});
      
      %---Make sure X-limits do not exceed range of data
      Lines = findall(DispAx(:,ctax),'Tag','LTIresponseLines');
      Xdata = get(Lines,{'Xdata'});
      if ~isempty(Xdata),
         Xdata = cat(2,Xdata{:});
         Xmin = min(Xdata(:));
         Xmax = max(Xdata(:));
         if (abs((Xmin-Xlims{ctax}(1))/(Xlims{ctax}(1)+eps)) > 0.001) | ...
               (abs((Xmax-Xlims{ctax}(2))/(Xlims{ctax}(2)+eps)) > 0.001),
            Xlims{ctax} = [Xmin, Xmax];
            set(DispAx(:,ctax),'Xlim',Xlims{1});
         end % if abs...
      end % if ~isempty(Xdata)
   end % for ctax
end % if XlimMode=='auto'

%---Make sure Nyquist line spans entire Ylimit range;
NyqLine = findobj(DispAx,'Tag','NyquistLines');
if ~isempty(NyqLine)
  NParent = get(NyqLine,{'Parent'});
  PYlims  = get(cat(1,NParent{:}),{'Ylim'});
  set(NyqLine,{'Ydata'},PYlims)
end

MargLines = findall(DispAx,'Tag','StabilityMarginMarker','LineStyle','-.');
if ~isempty(MargLines),
   Parent = get(MargLines,{'Parent'});
   Marglims = get(cat(1,Parent{:}),{'Xlim'});
   set(MargLines,{'Xdata'},Marglims);
end


