function MargRespObj = margplot(RespObj,Systems,SystemNames,X,Y,MarginVals);      
%MARGPLOT Create a Stability Margin Response Object for the Control System Toolbox
% $Revision: 1.5 $

%   Karen Gondoly, 2-13-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to MARGPLOT')
end

ContextMenu = get(RespObj,'UIContextMenu');

%---Generate property set
MargRespObj = struct('FrequencyUnits','RadiansPerSecond', ...
   'MagnitudeUnits','decibels',...
   'PhaseUnits','degrees',...
   'StabilityMarginValue',MarginVals);

if isequal(1,ni),   
   if isa(RespObj,'margplot'),
      MargRespObj=RespObj;
   else
      MargRespObj= class(MargRespObj,'margplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   MargFlag = isa(RespObj,'margplot');
   if MargFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   ResponseHandles = cell(length(X),1);
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   set(LTIdisplayAxes(:),'Xscale','log');
   
   Cvals = get(RespObj,'ColorOrder'); numC=size(Cvals,1);
   Lvals = get(RespObj,'LinestyleOrder'); numL = size(Lvals,1);
   Mvals = get(RespObj,'MarkerOrder'); numM = size(Mvals,1);
   
   [numout,numin]=size(LTIdisplayAxes);
   
   %---Initialize Line Userdata
   LineUd = struct('System',NumSys+1,'Input',1,'Output',1,'Array',1);
   
   CC = Cvals((NumSys+1)-(numC*floor(NumSys/numC)),:);
   LL=Lvals{1};
   MM = Mvals{1};
   LegendStr = legdstr(CC,LL,MM);
   
   ContextMenu.Systems.Names(NumSys+1) = uimenu(ContextMenu.Systems.Main,...
      'label',[SystemNames{1},' (',LegendStr,')'],...
      'ForegroundColor',CC,...
      'Checked','on',...   
      'Callback',['menufcn(''systemtoggle'',',...
         'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
   
   Xarray = X{1};
   Magdata = Y{1}{1};
   Phdata = Y{1}{2};      
   
   %---Determine if system is discrete
   if ~isempty(Systems{1}),
      dflag=abs(Systems{1}.Ts);
   else
      dflag = 0;
   end
   
   %---Initializations
   LindHandle = cell(2,1);
   RH=cell(1);
   RH2=cell(1);
   MagLine=1;
   PhLine=1;
   
   %---Magnitude
   if ndims(Magdata)>2,
      Magdata = squeeze(Magdata(1,1,:));
   end
   %---Convert Magnitude data to dB
   RH{1}(1,1)=line(Xarray,20*log10(Magdata),...
      'Color',CC,'Tag','LTIresponseLines','DeleteFcn','delresp(gcbo)', ...
      'Marker',MM,'LineStyle',LL,'UserData',LineUd,...
      'visible','on','parent',LTIdisplayAxes(1,1),...
      'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
   
   %---Phase
   if ndims(Phdata)>2,
      Phdata= squeeze(Phdata(1,1,:));
   end
   RH2{1}(1,1)=line(Xarray,Phdata,...
      'Color',CC,'UserData',LineUd,'DeleteFcn','delresp(gcbo)',...                  
      'Tag','LTIresponseLines', ...
      'Marker',MM,'LineStyle',LL,'parent',LTIdisplayAxes(2,1),...
      'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
            
   if dflag>0,  
      %---This is currently never called since the system is not passed to margin
      %Only draw Nyquist line when data extends, at least, up to NyqFreq
      NyqFreq=pi/dflag; % Nyquist frequency (Magnitude plot)
      if abs(Xdata(end)-NyqFreq)<(1e-2*NyqFreq) | ...
            Xdata(end)-NyqFreq > 1e-2,
         Ylim=get(LTIdisplayAxes(1,1),'Ylim');
         RH{1}(2,1)=line([NyqFreq;NyqFreq],Ylim,'Color','k','Linestyle','-', ...
            'Parent',LTIdisplayAxes(1,1),'HandleVis','off','Tag','NyquistLines');
         MagLine=MagLine+1;   
         Ylim=get(LTIdisplayAxes(2,1),'Ylim');
         RH2{1}(PhLine+1,1)=line([NyqFreq;NyqFreq],Ylim,'Color','k','Linestyle','-', ...
            'Parent',LTIdisplayAxes(2,1),'HandleVis','off',...
            'Tag','NyquistLines');
         PhLine=PhLine+1;
      end
   end % if dflag
      
   Xlim=get(LTIdisplayAxes(1,1),'Xlim');
   Ylim1=get(LTIdisplayAxes(1,1),'Ylim');
   if MarginVals.PhaseMargin >= 0,
      Pmline=-180;
   else
      Pmline=180;
   end
   
   % Gm lines
	PhLine=1;
   if min(Xlim)<=MarginVals.GMFrequency & max(Xlim)>=MarginVals.GMFrequency & MarginVals.GainMargin,
      Ylim2=get(LTIdisplayAxes(2,1),'Ylim');
      RH{1}(MagLine+1,1)=line([MarginVals.GMFrequency;MarginVals.GMFrequency],[-1*MarginVals.GainMargin;zeros(1,length(MarginVals.GainMargin))],...
         'parent',LTIdisplayAxes(1,1), ...
         'color','k','linestyle','-');
      RH{1}(MagLine+2,1)=line(Xlim,[0;0],'parent',LTIdisplayAxes(1,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH{1}(MagLine+3,1)=line([MarginVals.GMFrequency;MarginVals.GMFrequency],get(LTIdisplayAxes(1,1),'Ylim'),...
         'parent',LTIdisplayAxes(1,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH2{1}(PhLine+1,1)=line([MarginVals.GMFrequency;MarginVals.GMFrequency],[Pmline Ylim2(2)],...
         'parent',LTIdisplayAxes(2,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH2{1}(PhLine+2,1)=line([Xlim(1),MarginVals.GMFrequency],[Pmline Pmline],...
         'parent',LTIdisplayAxes(2,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      %---Set up the title string
      MagLine=MagLine+3;
      PhLine=PhLine+2;
   end
   
   unstableflag=0;
   if ~MarginVals.GainMargin
      tStr=['Gm = 0 dB,'];
   elseif isinf(MarginVals.GainMargin),
      tStr=['Gm = Inf,'];
   else
      tStr=['Gm=',num2str(MarginVals.GainMargin,'%0.5g'), ...
            ' dB (at ',num2str(MarginVals.GMFrequency,'%0.5g'),' rad/sec),'];
   end
   
   % Pm lines   
   Xlim=get(LTIdisplayAxes(2,1),'Xlim');
   Ylim2=get(LTIdisplayAxes(2,1),'Ylim');
   if min(Xlim)<=MarginVals.PMFrequency & max(Xlim)>=MarginVals.PMFrequency & MarginVals.PhaseMargin,
      RH2{1}(PhLine+1,1)=line([MarginVals.PMFrequency;MarginVals.PMFrequency],[MarginVals.PhaseMargin+Pmline;Pmline],...
         'HandleVisibility','off',...
         'parent',LTIdisplayAxes(2,1), ...
         'color','k','linestyle','-');
      RH2{1}(PhLine+2,1)=line(Xlim,[Pmline Pmline],'parent',LTIdisplayAxes(2,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH2{1}(PhLine+3,1)=line([MarginVals.PMFrequency;MarginVals.PMFrequency],get(LTIdisplayAxes(2,1),'Ylim'),...
         'parent',LTIdisplayAxes(2,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH{1}(MagLine+1,1)=line([MarginVals.PMFrequency;MarginVals.PMFrequency],[Ylim1(1);0],...
         'parent',LTIdisplayAxes(1,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
      RH{1}(MagLine+2,1)=line([Xlim(1),MarginVals.PMFrequency],[0;0],'parent',LTIdisplayAxes(1,1), ...
         'HandleVisibility','off',...
         'color','k','linestyle',':');
   end
   
   LineHandle{1,1}=RH;
   LineHandle{2,1}=RH2;
   ResponseHandles{1}=LineHandle;

   if ~MarginVals.PhaseMargin,
      tStr=[tStr,' Pm = 0'];
      unstableflag=1;
   elseif isinf(MarginVals.PhaseMargin),
      tStr=[tStr,' Pm = Inf'];
   else
      tStr=[tStr,...
            ' Pm=',num2str(MarginVals.PhaseMargin,'%0.5g'),' deg. (at '];
      if ~MarginVals.PMFrequency,
         tStr=[tStr,'0 rad/sec)'];            
      else
         tStr=[tStr,num2str(MarginVals.PMFrequency,'%0.5g'),' rad/sec)'];
      end
   end
   if unstableflag
      tStr=[tStr,' (unstable closed loop)'];
   end
   Thand=get(LTIdisplayAxes(1,1),'title');
   set(Thand,'string',tStr);
   
   if MargFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      MargRespObj = RespObj;
   else
      %---No Plot Option Menus for Nyquist responses opened at the command line
      set([ContextMenu.PlotOptions.Main,ContextMenu.ChannelMenu, ...
            ContextMenu.GroupMenu.Main],'visible','off');
      
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      MargRespObj= class(MargRespObj,'margplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   MargRespObj = LocalLabelAxes(MargRespObj,Systems);
   
   %---For Margin, only...need to save Response Object in ContextMenu
   %    (For all other plots, this is done in the LocalLabelAxes code)
   set(ContextMenu.Main,'UserData',MargRespObj);
   
end %if/else isequal(1,ni)

%------------------------------Internal Functions--------------------------

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalLabelAxes %%%
%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalLabelAxes(RespObj,Systems)

%---Set the BackgroundAxes labels
set(get(RespObj,'Xlabel'),'visible','on','string','Frequency (rad/sec)');
set(get(RespObj,'ylabel'),'visible','on','string','Phase (deg); Magnitude (dB)');
set(get(RespObj,'title'),'visible','on','string','Bode Diagrams');


