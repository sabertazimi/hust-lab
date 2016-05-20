function ImpRespObj = impplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%IMPPLOT Create a Impulse Response Object for the Control System Toolbox
% $Revision: 1.6 $

%   Karen Gondoly, 2-2-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to IMPPLOT')
end

%---Generate property set
ImpRespObj = struct('PeakResponse','off',...
   'PeakResponseValue',[],...
   'SettlingTime','off',...
   'SettlingTimeThreshold',0.02,...
   'SettlingTimeValue',[]);

if isequal(1,ni),   
   if isa(RespObj,'impplot'),
      ImpRespObj =RespObj;
   else
      ImpRespObj = class(ImpRespObj,'impplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   ImpFlag = isa(RespObj,'impplot');
   ResponseHandles = cell(length(X),1);
   
   %---Assign empty system names. This is how the code knows it needs to
   %----Calculate the Plot Options for this particular system
   PeakRespVals = struct('System',cell(size(SystemNames)),'Time',cell(size(SystemNames)),...
      'Peak',cell(size(SystemNames)));
   SetTimeVals = struct('System',cell(size(SystemNames)),'SettlingTime',cell(size(SystemNames)),...
      'Amplitude',cell(size(SystemNames)));
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   ContextMenu = get(RespObj,'UIContextMenu');
   
   if ImpFlag;
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
      
      Xarray= X{ctR};
      Yarray= Y{ctR};
      
      %---Determine the number of elements in the data 
      SizeArray=size(Xarray);
      NumArray = prod(SizeArray);
      if NumArray>1,
         ArrayDimsStr = sprintf('%dx',SizeArray);
         LegendStr=[ArrayDimsStr(1:end-1),' array: ',LegendStr];
      end

      ContextMenu.Systems.Names(NumSys+ctR) = uimenu(ContextMenu.Systems.Main,...
         'label',[SystemNames{ctR},' (',LegendStr,')'],...
         'Checked','on',...   
         'Callback',['menufcn(''systemtoggle'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
      LindHandle = cell(numout,numin);
      for ctin = 1:numin,
         LineUd.Input=ctin;
         for ctout = 1:numout,
            LineUd.Output=ctout;
            RH=cell(SizeArray);
            for ctArray=1:NumArray,
               Xdata = Xarray{ctArray};
               Ydata = Yarray{ctArray};
               LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
               
               %---Set visibility off, then have LTIPLOT turn systems on, as necessary
               RH{ctArray}(1,1)=line(Xdata,Ydata(:,ctout,ctin),'Color',CC,'Marker',MM,...
                  'LineStyle',LL,'Tag','LTIresponseLines','visible','off', ...
                  'parent',LTIdisplayAxes(ctout,ctin),'UserData',LineUd,...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);',...
                  'DeleteFcn','delresp(gcbo)');
              
               Xlim=get(LTIdisplayAxes(ctout,ctin),'Xlim');
               Color = get(LTIdisplayAxes(ctout,ctin),'Ycolor');
               RH{ctArray}(2,1)=line(Xlim,[0 0],'Parent',LTIdisplayAxes(ctout,ctin), ...
                  'HandleVisibility','on','visible','off',...
                  'Color',Color,'LineStyle',':','Tag','ExtraTimeLine');
            end % for ctArray
            LineHandle{ctout,ctin}=RH;
         end % for ctout
      end % for ctin
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   if ImpFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.PeakResponseValue=[get(RespObj,'PeakResponseValue');PeakRespVals];
      RespObj.SettlingTimeValue=[get(RespObj,'SettlingTimeValue');SetTimeVals];
      ImpRespObj = RespObj;
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

      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      ImpRespObj.PeakResponseValue= PeakRespVals;
      ImpRespObj.SettlingTimeValue= SetTimeVals;
      ImpRespObj= class(ImpRespObj,'impplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   ImpRespObj = LocalLabelAxes(ImpRespObj,Systems);

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
set(get(RespObj,'title'),'visible','on','string','Impulse Response');

%---Set the LTIdisplayAxes labels
[inNames,outNames,clash]=mrgname(Systems); % Get common I/O names

set(RespObj,'InputLabel',inNames,'OutputLabel',outNames);
   