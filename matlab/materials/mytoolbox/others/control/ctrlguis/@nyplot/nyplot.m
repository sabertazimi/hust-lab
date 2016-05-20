function NyqRespObj = nyplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%NYPLOT Create a Nyquist Response Object for the Control System Toolbox
% $Revision: 1.6 $

%   Karen Gondoly, 2-17-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to NYPLOT')
end

%---Generate property set
NyqRespObj = struct('MagnitudeUnits','decibels',...
   'Frequency',[],...
   'FrequencyUnits','RadiansPerSecond',...
   'PhaseUnits','degrees',...
   'StabilityMargin','off',...
   'StabilityMarginValue',[0.1 0.9]);

if isequal(1,ni),   
   if isa(RespObj,'nyplot'),
      NyqRespObj=RespObj;
   else
      NyqRespObj= class(NyqRespObj,'nyplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   NyqFlag = isa(RespObj,'nyplot');
   
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
   
   if NyqFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   [numout,numin]=size(LTIdisplayAxes);
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',[],'Output',[],'Array',[]);
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys + ctR;
      
      [LegendStr,CC,LL,MM] = respcolor(RespObj,PlotStr{ctR},...
         NumSys+ctR,isa(Systems{ctR},'frd'));
      
      Yarray = Y{ctR};
      
      %---Determine the number of elements in the data 
      SizeArray=size(Yarray);
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
               Re = real(Yarray{ctArray});
               Im=imag(Yarray{ctArray});
               LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
               
               RH{ctArray}(1,1) = line(squeeze(Re(ctout,ctin,:)),squeeze(Im(ctout,ctin,:)),...
                  'Color',CC,'Tag','LTIresponseLines','DeleteFcn','delresp(gcbo)', ...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);', ...
                  'Marker',MM,'LineStyle',LL,'parent',LTIdisplayAxes(ctout,ctin), ...
                  'visible','off','UserData',LineUd);
               RH{ctArray}(2,1)=line(squeeze(Re(ctout,ctin,:)),-1*squeeze(Im(ctout,ctin,:)),...
                  'Color',CC, ...
                  'ButtonDownFcn','rguifcn(''showbox'',gcbf);', ...
                  'Marker',MM,'LineStyle',LL,'parent',LTIdisplayAxes(ctout,ctin), ...
                  'Tag','LTIresponseLines','visible','off','UserData',LineUd);
               RH{ctArray}(3,1)=line(-1,0,'Color','k','Parent',LTIdisplayAxes(ctout,ctin),'Marker','+', ...
                  'visible','off','Tag','ExtraNyquist');
               
               dY=get(LTIdisplayAxes(ctout,ctin),'Ylim');
               yrange=dY(2)-dY(1);
               [yrange,ArrowInd] = max(abs(Im(ctout,ctin,:)));
               xrange = max(Re(ctout,ctin,:))-min(Re(ctout,ctin,:));
               % Make any arrows
               % Horizontal arrows
               ind = ArrowInd;
               % Positive Dir means top arrow to right
               if ind==size(Re,3),
                  Dir = Re(ctout,ctin,end-1) -Re(ctout,ctin,end);
               else
                  Dir = Re(ctout,ctin,ind+1) -Re(ctout,ctin,ind);
               end
               Dir = sign(Dir);
               if Dir~=0,
                  yarrow = [yrange 0 -yrange]/36;
                  xarrow = -[xrange 0 xrange]/36;
                  Ar = Re(ctout,ctin,ind);
                  Ai = Im(ctout,ctin,ind);
                  RH{ctArray}(4,1) = line(Ar+[Dir*xarrow NaN -Dir*xarrow],[Ai+yarrow NaN -Ai+yarrow], ...
                     'parent',LTIdisplayAxes(ctout,ctin),'color',CC,'visible','off',...
                     'Tag','NyquistArrow');
               end % if Dir~=0
            end % for ctArray
            LineHandle{ctout,ctin}=RH;
         end % for ctout
      end % for ctin
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
         
   if NyqFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.Frequency = [get(RespObj,'Frequency'),X];
      RespObj.StabilityMarginValue = [get(RespObj,'StabilityMarginValue');MarginVals];
      NyqRespObj = RespObj;
   else
      
      %---No Plot Option Menus for Nyquist responses opened at the command line
      set(ContextMenu.PlotOptions.Main,'visible','off');
      
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      NyqRespObj.Frequency = X;
      NyqRespObj.StabilityMarginValue= MarginVals;
      NyqRespObj= class(NyqRespObj,'nyplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   NyqRespObj = LocalLabelAxes(NyqRespObj,Systems);
   
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
set(get(RespObj,'Xlabel'),'visible','on','string','Real Axis');
set(get(RespObj,'ylabel'),'visible','on','string','Imaginary Axis');
set(get(RespObj,'title'),'visible','on','string','Nyquist Diagrams');

%---Set the LTIdisplayAxes labels
[inNames,outNames,clash]=mrgname(Systems); % Get common I/O names

set(RespObj,'InputLabel',inNames,'OutputLabel',outNames);

