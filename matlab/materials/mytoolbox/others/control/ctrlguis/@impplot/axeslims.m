function [Xlims,Ylims] = axeslims(ImpRespObj,RespObj);
%AXESLIMS sets the axes limits for Impulse Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/21 19:38:05 $
%   Karen Gondoly 5-14-98.

AllRespProps = get(RespObj);
DispAx = AllRespProps.PlotAxes;  
Xlims = AllRespProps.Xlims;
Ylims = AllRespProps.Ylims;

if strcmp(AllRespProps.YlimMode,'auto')
   set(DispAx,'YlimMode','auto');
end

if strcmp(AllRespProps.XlimMode,'auto')
   set(DispAx,'XlimMode','auto','XtickMode','auto');
end

if strcmp(AllRespProps.YlimMode,'manual')
   for ctAx = 1:size(DispAx,1),
      set(DispAx(ctAx,:),'Ylim',Ylims{ctAx})
   end
end

if strcmp(AllRespProps.XlimMode,'manual')
   for ctAx = 1:size(DispAx,2),
      set(DispAx(:,ctAx),'Xlim',Xlims{ctAx},'XtickMode','auto')
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

if strcmp(AllRespProps.XlimMode,'auto')
   %---Set Uniform X-axis limits across all plots
   Lines = findall(DispAx(:),'Tag','LTIresponseLines');
   Xdata = get(Lines,{'Xdata'});
   Xdata = cat(2,Xdata{:});
   Xmin = min(Xdata(:));
   Xmax = max(Xdata(:));
   
   Lims = findlims(DispAx(:),'Xlim');
   onSys = strcmpi('on',AllRespProps.SystemVisibility);

   if strcmpi(get(AllRespProps.Parent,'Tag'),'ResponseGUI') & ~isempty(onSys),
      Xmax = LocalGetSettlingTime(ImpRespObj,Xmax,onSys);
      Lims(2)=Xmax;
   end
   
   if ~isequal(Xmin,Lims(1)) | ~isequal(Xmax,Lims(2)),
      %---Use limits that give nice tickmarks
      Xmax=tchop(Xmax);
      Lims = [Xmin,Xmax];
      [xtick,pow10]=txticks(Xmax-Xmin,size(DispAx,2));
      xticknew=(xtick+Xmin)*10^pow10;
      set(DispAx(:),'Xtick',xticknew)
   end
   
   set(DispAx(:),'Xlim',Lims)
   
   %---Make sure current axes limits are stored
   Xlims = get(DispAx(1,:),{'Xlim'});
   
end % if/else strcmp(XlimMode...

%---Rescale the ExtraTime Lines
TimeLine=findall(DispAx,'tag','ExtraTimeLine');
if ~isempty(TimeLine),
   P = get(TimeLine,{'Parent'}); P = cat(1,P{:});
   X = get(P,{'Xlim'});
   set(TimeLine,{'Xdata'},X);
end

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

SetLines = findall(DispAx,'Tag','SettlingTimeMarker','Marker','none');
for ctL=1:length(SetLines),
   X = get(SetLines(ctL),'Xdata');
   Y = get(SetLines(ctL),'Ydata');
   if ~isequal(Y(1),Y(2)),
      Ylim = get(get(SetLines(ctL),'Parent'),'Ylim');
      set(SetLines(ctL),'Ydata',[Ylim(1),Y(2)]);
   elseif ~isequal(X(1),X(2)),
      Xlim = get(get(SetLines(ctL),'Parent'),'Xlim');
      set(SetLines(ctL),'Xdata',Xlim);
   end
end % for ctL

%-------------------------Internal Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGetSettlingTime %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Xmax = LocalGetSettlingTime(ImpRespObj,Xmax,onSys);

ST = get(ImpRespObj,'SettlingTimeValue');
OnTime=ST(onSys);
Xtemp = zeros(length(OnTime),1);
for ct=1:length(OnTime),
   SetTime = OnTime(ct).SettlingTime(:);
   Xtemp(ct)=max(SetTime);
end

XmaxTemp = max(Xtemp);
if ~isinf(XmaxTemp) & ~isnan(XmaxTemp) & XmaxTemp;
   %---Don't allow Infs, Nans, or zeros!
   Xmax = XmaxTemp + (0.01*XmaxTemp); % Go out 1% past settling time
end