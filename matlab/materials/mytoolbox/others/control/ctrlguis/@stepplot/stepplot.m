function StepRespObj = stepplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%STEPPLOT Create a Step Response Object for the Control System Toolbox
% $Revision: 1.6 $

%   Karen Gondoly, 2-2-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to STEPPLOT')
end

%---Generate property set
StepRespObj = struct('PeakResponse','off',...
   'PeakResponseValue',[],...
   'RiseTime','off',...
   'RiseTimeLimits',[0.1 0.9],...
   'RiseTimeValue',[],...
   'SettlingTime','off',...
   'SettlingTimeThreshold',0.02,...
   'SettlingTimeValue',[],...
   'SteadyState','off',...
   'SteadyStateValue',[]);

if isequal(1,ni),   
   if isa(RespObj,'stepplot'),
      StepRespObj=RespObj;
   else
      StepRespObj= class(StepRespObj,'stepplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   StepFlag = isa(RespObj,'stepplot');
   
   ResponseHandles = cell(length(X),1);
   SteadyStateVals = struct('System',SystemNames,'Time',cell(size(SystemNames)), ...
      'Amplitude',cell(size(SystemNames)));
   
   %---Assign empty system names. This is how the code knows it needs to
   %----Calculate the Plot Options for this particular system
   PeakRespVals = struct('System',cell(size(SystemNames)),'Time',cell(size(SystemNames)),...
      'Peak',cell(size(SystemNames)));
   RiseTimeVals = struct('System',cell(size(SystemNames)),'RiseTime',cell(size(SystemNames)),...
      'Amplitude',cell(size(SystemNames)));
   SetTimeVals = struct('System',cell(size(SystemNames)),'SettlingTime',cell(size(SystemNames)),...
      'Amplitude',cell(size(SystemNames)));
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   ContextMenu = get(RespObj,'UIContextMenu');
   
   if StepFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   [numout,numin]=size(LTIdisplayAxes);
   
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',[],'Output',[],'Array',[]);
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys+ctR;
      
      [LegendStr,CC,LL,MM] = respcolor(RespObj,PlotStr{ctR},...
         NumSys+ctR,isa(Systems{ctR},'frd'));
      
      Xarray = X{ctR};
      Ytemp = Y{ctR};
      Yarray = Ytemp{1};
      K=Ytemp{2};
      SteadyStateVals(ctR).Amplitude = K;
      TempKtime = zeros(size(K));
      SizeK=size(K);
      for ctTime = 1:max([1, prod(SizeK(3:end))]),
      	TempKtime(:,:,ctTime)= Xarray{ctTime}(end);
      end
      SteadyStateVals(ctR).Time = TempKtime;
      
      %---Determine the number of elements in the data 
      SizeArray=size(Xarray);
      NumArray = prod(SizeArray);
      if NumArray>1,
         ArrayDimsStr = sprintf('%dx',SizeArray);
         LegendStr=[ArrayDimsStr(1:end-1),' array: ',LegendStr];
      end
      
      ContextMenu.Systems.Names(NumSys+ctR) = uimenu(ContextMenu.Systems.Main,...
         'label',[SystemNames{ctR},' (',LegendStr,')'],...
         'ForegroundColor',CC,...
         'Checked','on',...   
         'Callback',['menufcn(''systemtoggle'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
            
      LineHandle = cell(numout,numin);
      for ctin = 1:numin,
         LineUd.Input = ctin;
         for ctout = 1:numout,
            LineUd.Output = ctout;
            RH=cell(SizeArray);
            for ctArray=1:NumArray,
               Xdata = Xarray{ctArray};
               Ydata = Yarray{ctArray};
               LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
               
               %---Set visibility off, then have LTIPLOT turn systems on, as necessary
               RH{ctArray}(1,1)=line(Xdata,Ydata(:,ctout,ctin),...
                  'Color',CC,'Marker',MM,...
                  'LineStyle',LL,'Tag','LTIresponseLines','visible','off', ...
                  'parent',LTIdisplayAxes(ctout,ctin),'UserData',LineUd, ... 
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);', ...
                  'DeleteFcn','delresp(gcbo)');
               
               %---Only add DCgain line for non-array LTI objects
               if isequal(NumArray,1),
                  Xlim=get(LTIdisplayAxes(ctout,ctin),'Xlim');
                  Karray=K(:,:,ctArray);
                  Color = get(LTIdisplayAxes(ctout,ctin),'Ycolor');
                  RH{ctArray}(2,1) = line(Xlim,[Karray(ctout,ctin) Karray(ctout,ctin)],...
                     'Parent',LTIdisplayAxes(ctout,ctin), ...
                     'HandleVisibility','off',...
                     'Color',Color,'LineStyle',':','visible','off','Tag','ExtraTimeLine');
               end % if isequal(NumArray,1)
            end % for ctArray
            LineHandle{ctout,ctin}=RH;
         end % for ctout
      end % for ctin
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   if StepFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles],...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.SteadyStateValue = [RespObj.SteadyStateValue;SteadyStateVals];
      RespObj.PeakResponseValue = [RespObj.PeakResponseValue;PeakRespVals];
      RespObj.RiseTimeValue = [RespObj.RiseTimeValue;RiseTimeVals];
      RespObj.SettlingTimeValue = [RespObj.SettlingTimeValue;SetTimeVals];
      StepRespObj = RespObj;
      
   else
      
      %---Add the Plot Option Menus
      ContextMenu.PlotOptions.PeakResponse = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Peak Response',...
         'Callback',['menufcn(''togglepeak'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      ContextMenu.PlotOptions.SettlingTime = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Settling Time',...
         'Callback',['menufcn(''togglesettling'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
      ContextMenu.PlotOptions.RiseTime = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Rise Time',...
         'Callback',['menufcn(''togglerise'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      ContextMenu.PlotOptions.SteadyState = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Steady State',...
         'Callback',['menufcn(''togglesteady'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      StepRespObj.SteadyStateValue = SteadyStateVals;
      StepRespObj.PeakResponseValue= PeakRespVals;
      StepRespObj.RiseTimeValue= RiseTimeVals;
      StepRespObj.SettlingTimeValue= SetTimeVals;
      StepRespObj= class(StepRespObj,'stepplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   StepRespObj = LocalLabelAxes(StepRespObj,Systems);
   
end %if/else isequal(1,ni)

%------------------------------Internal Functions--------------------------
%%%%%%%%%%%%%%%%%%%%
%%% LocalInd2Sub %%%
%%%%%%%%%%%%%%%%%%%%
function ind = LocalInd2Sub(siz,ndx),
%IND2SUB Multiple subscripts from linear index.
%   IND2SUB is used to determine the equivalent subscript values
%   corresponding to a given single index into an array.
%
%   Modified: 2-12-98, to return entire index in a signal variable

ind=zeros(size(siz));
n = length(siz);
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
for i = n:-1:1,
  ind(i) = floor(ndx/k(i))+1;
  ndx = rem(ndx,k(i));
end

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalLabelAxes %%%
%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalLabelAxes(RespObj,Systems)

%---Set the BackgroundAxes labels
set(get(RespObj,'Xlabel'),'visible','on','string','Time (sec.)');
set(get(RespObj,'ylabel'),'visible','on','string','Amplitude');
set(get(RespObj,'title'),'visible','on','string','Step Response');

%---Set the LTIdisplayAxes labels
[inNames,outNames,clash]=mrgname(Systems); % Get common I/O names

set(RespObj,'InputLabel',inNames,'OutputLabel',outNames);