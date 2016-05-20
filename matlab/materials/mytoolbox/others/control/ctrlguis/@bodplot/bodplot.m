function BodeRespObj = bodplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%BODPLOT Create a Bode Response Object for the Control System Toolbox
% $Revision: 1.7 $

%   Karen Gondoly, 2-13-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to BODPLOT')
end

ContextMenu = get(RespObj,'UIContextMenu');

%---Generate property set
BodeRespObj = struct('MagnitudeUnits','decibels',...
   'PeakResponse','off',...
   'PeakResponseValue',[],...
   'PhaseUnits','degrees',...
   'StabilityMargin','off',...
   'StabilityMarginValue',[],...
   'FrequencyUnits','RadiansPerSecond');

if isequal(1,ni),   
   if isa(RespObj,'bodplot'),
      BodeRespObj=RespObj;
   else
      BodeRespObj= class(BodeRespObj,'bodplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   BodeFlag = isa(RespObj,'bodplot');
   if BodeFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   ResponseHandles = cell(length(X),1);
   
   %---Assign empty system names. This is how the code knows it needs to
   %----Calculate the Plot Options for this particular system
   PeakRespVals = struct('System',cell(size(SystemNames)),'Frequency',cell(size(SystemNames)),...
      'Peak',cell(size(SystemNames)));
   MarginVals = struct('System',cell(size(SystemNames)),...
      'GainMargin',cell(size(SystemNames)),...
      'GMFrequency',cell(size(SystemNames)),...
      'PhaseMargin',cell(size(SystemNames)),...
      'PMFrequency',cell(size(SystemNames)));
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   set(LTIdisplayAxes(:),'Xscale','log');
   [numout,numin]=size(LTIdisplayAxes);
   
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',[],'Output',[],'Array',[]);
   
   MagData = Y{1};
   PhData = Y{2};   
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys + ctR;
      [LegendStr,CC,LL,MM] = respcolor(RespObj,PlotStr{ctR},NumSys+ctR,isa(Systems{ctR},'frd'));
      
      Xarray= X{ctR};
      AllMagdata = MagData{ctR};
      AllPhdata = PhData{ctR};
      
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
      
      
      %---Determine if system is discrete
      dflag=abs(Systems{ctR}.Ts);
      
      LindHandle = cell(numout,numin);
      for ctin=1:numin,
         LineUd.Input=ctin;
         for ctout=1:2:numout,
            LineUd.Output=ceil(ctout/2);
            RH=cell(SizeArray);
            RH2=cell(SizeArray);
            for ctArray=1:NumArray,
               Xdata = Xarray{ctArray};
               Magdata= AllMagdata{ctArray};
               Phdata= AllPhdata{ctArray};
               LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
               
               %---Magnitude
               RH{ctArray}(1,1)=line(Xdata,squeeze(Magdata(ceil(ctout/2),ctin,:)),...
                  'Color',CC,'Tag','LTIresponseLines','DeleteFcn','delresp(gcbo)', ...
                  'Marker',MM,'LineStyle',LL,'UserData',LineUd,...
                  'visible','off','parent',LTIdisplayAxes(ctout,ctin),...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
               
               %---Phase
               RH2{ctArray}(1,1)=line(Xdata,squeeze(Phdata(ceil(ctout/2),ctin,:)),...
                  'Color',CC,'UserData',LineUd,'DeleteFcn','delresp(gcbo)',...                  
                  'Tag','LTIresponseLines','visible','off', ...
                  'Marker',MM,'LineStyle',LL,'parent',LTIdisplayAxes(ctout+1,ctin),...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
               
               
               if dflag>0,  
                  %Only draw Nyquist line when it is at the end of the data
                  NyqFreq=pi/dflag; % Nyquist frequency
                  if abs(Xdata(end)-NyqFreq)<(1e-2*NyqFreq) | ...
                        Xdata(end)-NyqFreq > 1e-2,
                     Ylim=get(LTIdisplayAxes(ctout,ctin),'Ylim');
                     RH{ctArray}(2,1)=line([NyqFreq;NyqFreq],Ylim,'Color','k','Linestyle','-', ...
                        'Parent',LTIdisplayAxes(ctout,ctin),...
                        'visible','off','Tag','NyquistLines');
                     Ylim=get(LTIdisplayAxes(ctout+1,ctin),'Ylim');
                     RH2{ctArray}(2,1)=line([NyqFreq;NyqFreq],Ylim,'Color','k','Linestyle','-', ...
                        'Parent',LTIdisplayAxes(ctout+1,ctin),'visible','off',...
                        'Tag','NyquistLines');
                  end % if NyqFreq at end of data  
               end % if dflag
            end % for ctArray
            LineHandle{ctout,ctin}=RH;
            LineHandle{ctout+1,ctin}=RH2;
            
         end % for ctout
      end % for ctin
      
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   if BodeFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.PeakResponseValue = [get(RespObj,'PeakResponseValue');PeakRespVals];
      RespObj.StabilityMarginValue = [get(RespObj,'StabilityMarginValue');MarginVals];
      BodeRespObj = RespObj;
   else
      %---No Grouping or I/O selection for SISO bode diagrams
      if isequal(numin,1) & isequal(numout,2),
         set([ContextMenu.ChannelMenu,ContextMenu.GroupMenu.Main],'visible','off');
      end
      
      %---Add the Plot Option Menus
      ContextMenu.PlotOptions.PeakResponse = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Peak Response',...
         'Callback',['menufcn(''togglepeak'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      BodeRespObj.PeakResponseValue= PeakRespVals;
      BodeRespObj.StabilityMarginValue= MarginVals;
      BodeRespObj= class(BodeRespObj,'bodplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   BodeRespObj = LocalLabelAxes(BodeRespObj,Systems);
   
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
set(get(RespObj,'Xlabel'),'visible','on','string','Frequency (rad/sec)');
set(get(RespObj,'ylabel'),'visible','on','string','Phase (deg); Magnitude (dB)');
set(get(RespObj,'title'),'visible','on','string','Bode Diagrams');

%---Set the LTIdisplayAxes labels
[inNames,outNames,clash]=mrgname(Systems); % Get common I/O names

set(RespObj,'InputLabel',inNames,'OutputLabel',outNames);

