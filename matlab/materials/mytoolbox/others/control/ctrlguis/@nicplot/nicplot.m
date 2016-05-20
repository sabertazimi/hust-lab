function NicRespObj = nicplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%NICPLOT Create a Nichols Chart Response Object for the Control System Toolbox

%   Karen Gondoly, 2-18-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to NICPLOT')
end

%---Generate property set
NicRespObj = struct('MagnitudeUnits','decibels',...
   'Frequency',[],...
   'FrequencyUnits','RadiansPerSecond',...
   'GridLines',[],...
   'PhaseUnits','degrees',...
   'StabilityMargin','off',...
   'StabilityMarginValue',[0.1 0.9]);

if isequal(1,ni),   
   if isa(RespObj,'nicplot'),
      NicRespObj=RespObj;
   else
      NicRespObj= class(NicRespObj,'nicplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   NicFlag = isa(RespObj,'nicplot');
   
   ResponseHandles = cell(length(X),1);
   
   %---Assign empty system names. This is how the code knows it needs to
   %----Calculate the Plot Options for this particular system
   MarginVals = struct('System',cell(size(SystemNames)),...
      'GainMargin',cell(size(SystemNames)),...
      'GMFrequency',cell(size(SystemNames)),...
      'PhaseMargin',cell(size(SystemNames)),...
      'PMFrequency',cell(size(SystemNames)));
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   ContextMenu = get(RespObj,'UIContextMenu');
   
   %---Look for any grid lines already on a SISO Nichols chart
   if strcmp('on',get(RespObj,'Grid')) & isequal([1 1],size(LTIdisplayAxes)),
      kids = get(LTIdisplayAxes(1,1),'Children');
      GridLines = findobj(kids,'Tag','CSTgridLines');
      if ~isempty(GridLines),
         % There is a valid Ngrid on the axes
         NicRespObj.GridLines = findobj(kids,'Tag','CSTgridLines');
      else
         %---Turn of the square grid
         set(RespObj,'Grid','off')
         set(LTIdisplayAxes(1,1),'Xgrid','off','Ygrid','off');
      end
   end
   
   if NicFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   [numout,numin]=size(LTIdisplayAxes);
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',[],'Output',[],'Array',[]);
   
   MagData = Y{1};
   PhData = Y{2};   
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys + ctR;
      
      [LegendStr,CC,LL,MM] = respcolor(RespObj,PlotStr{ctR},...
         NumSys+ctR,isa(Systems{ctR},'frd'));
      
      AllMagdata = MagData{ctR};
      AllPhdata = PhData{ctR};
      
      %---Determine the number of elements in the data 
      SizeArray=size(AllMagdata);
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
      for ctin=1:numin,
         LineUd.Input = ctin;
         for ctout=1:numout,
            LineUd.Output = ctout;
            RH=cell(SizeArray);
            for ctArray=1:NumArray,
               LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
               Magdata = AllMagdata{ctArray};
               Phdata = AllPhdata{ctArray};
               
               RH{ctArray}(1,1)=line(squeeze(Phdata(ctout,ctin,:)),squeeze(Magdata(ctout,ctin,:)),...
                  'Color',CC,'DeleteFcn','delresp(gcbo)', ...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);', ...
                  'Tag','LTIresponseLines','Marker',MM,'LineStyle',LL,...
                  'parent',LTIdisplayAxes(ctout,ctin), ...
                  'visible','off','UserData',LineUd);
               
            end % for ctArray
            LineHandle{ctout,ctin}=RH;
         end % for ctout
      end % for ctin
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   if NicFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.Frequency = [get(RespObj,'Frequency'),X];
      RespObj.StabilityMarginValue = [get(RespObj,'StabilityMarginValue');MarginVals];
      NicRespObj = RespObj;
   else
      
      %---No Plot Option Menus for Nyquist responses opened at the command line
      set(ContextMenu.PlotOptions.Main,'visible','off');
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      NicRespObj.Frequency = X;
      NicRespObj.StabilityMarginValue= MarginVals;
      NicRespObj= class(NicRespObj,'nicplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   NicRespObj = LocalLabelAxes(NicRespObj,Systems);
   
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
set(get(RespObj,'Xlabel'),'visible','on','string','Open-Loop Phase (deg)');
set(get(RespObj,'ylabel'),'visible','on','string','Open-Loop Gain (dB)');
set(get(RespObj,'title'),'visible','on','string','Nichols Charts');

%---Set the LTIdisplayAxes labels
[inNames,outNames,clash]=mrgname(Systems); % Get common I/O names

set(RespObj,'InputLabel',inNames,'OutputLabel',outNames);

