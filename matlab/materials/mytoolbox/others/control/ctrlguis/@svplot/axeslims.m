function [Xlims,Ylims] = axeslims(SVRespObj,RespObj);
%AXESLIMS sets the axes limits for Singular Value Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/27 17:28:38 $
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
end

if strcmp(AllRespProps.YlimMode,'manual')
   set(DispAx,'Ylim',Ylims{1})
end

if strcmp(AllRespProps.XlimMode,'manual')
   set(DispAx,'Xlim',Xlims{1})
end

Ylims = get(DispAx,{'Ylim'});
Xlims = get(DispAx,{'Xlim'});

%---Make sure X-limits do not exceed range of data
%     Only if all limits are being chosen automatically,
%     Otherwise, let the zoom routine take care of the limits
if strcmp(AllRespProps.XlimMode,'auto') & ...
      strcmp(AllRespProps.YlimMode,'auto')
   Lines = findall(DispAx,'Tag','LTIresponseLines');
   Xdata = get(Lines,{'Xdata'});
   Xdata = cat(2,Xdata{:});
   Xmin = min(Xdata(:));
   Xmax = max(Xdata(:));
   if (abs((Xmin-Xlims{1}(1))/(Xlims{1}(1)+eps)) > 0.001) | ...
         (abs((Xmax-Xlims{1}(2))/(Xlims{1}(2)+eps)) > 0.001),
      Xlims{1} = [Xmin, Xmax];
      set(DispAx,'Xlim',Xlims{1});
   end
end % if XlimMode=='auto'
   
%---Make sure Nyquist line spans entire Ylimit range;
NyqLine = findobj(DispAx,'Tag','NyquistLines');
set(NyqLine,'Ydata',Ylims{1})

%---Make sure Peak Response lines span the X and Y limits;
PRLines = [findall(DispAx,'Tag','PeakResponseMarker','Marker','none')];
for ctL=1:length(PRLines),
   X = get(PRLines(ctL),'Xdata');
   Y = get(PRLines(ctL),'Ydata');
   if ~isequal(Y(1),Y(2)),
      Ylim = get(get(PRLines(ctL),'Parent'),'Ylim');
      set(PRLines(ctL),'Ydata',[Ylims{1}(1),Y(2)]);
   elseif ~isequal(X(1),X(2)),
      Xlim = get(get(PRLines(ctL),'Parent'),'Xlim');
      set(PRLines(ctL),'Xdata',[Xlims{1}(1),X(2)]);
   end
end % for ctL
