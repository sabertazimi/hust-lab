function SVRespObj = svplot(RespObj,Systems,SystemNames,X,Y,PlotStr);      
%SVPLOT Create a Singular Value Response Object for the Control System Toolbox
% $Revision: 1.6 $

%   Karen Gondoly, 2-13-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to SVPLOT')
end

ContextMenu = get(RespObj,'UIContextMenu');

%---Generate property set
SVRespObj = struct('MagnitudeUnits','decibels',...
   'PeakResponse','off',...
   'PeakResponseValue',[],...
   'FrequencyUnits','RadiansPerSecond');

if isequal(1,ni),   
   if isa(RespObj,'svplot'),
      SVRespObj=RespObj;
   else
      SVRespObj= class(SVRespObj,'svplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   SVFlag = isa(RespObj,'svplot');
   if SVFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   ResponseHandles = cell(length(X),1);
   
   %---Assign empty system names. This is how the code knows it needs to
   %----Calculate the Plot Options for this particular system
   PeakRespVals = struct('System',cell(size(SystemNames)),'Frequency',cell(size(SystemNames)),...
      'Peak',cell(size(SystemNames)));
   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   set(LTIdisplayAxes(:),'Xscale','log');
   
   [numout,numin]=size(LTIdisplayAxes);
   
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',[],'Output',[],'Array',[]);
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys + ctR;
      
      [LegendStr,CC,LL,MM] = respcolor(RespObj,PlotStr{ctR},...
         NumSys+ctR,isa(Systems{ctR},'frd'));
      
      Xarray = X{ctR};
      Yarray = Y{ctR};
      
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
      LineUd.Input=1;
      LineUd.Output=1;
      RH=cell(SizeArray);
      RH2=cell(SizeArray);
      for ctArray=1:NumArray,
         Xdata = Xarray{ctArray};
         Ydata = Yarray{ctArray};
         LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
         for ctlines=1:size(Ydata,1),
            
            RH{ctArray}(ctlines,1)=line(Xdata,20*log10(Ydata(ctlines,:)),'Color',CC,...
               'Marker',MM,'LineStyle',LL,'UserData',LineUd, ...
               'Tag','LTIresponseLines','DeleteFcn','delresp(gcbo)',...
               'visible','off','parent',LTIdisplayAxes(1,1),...
               'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
         end % for ctlines
            
         if dflag>0,  
            %Only draw Nyquist line when it is at the end of the data
            NyqFreq=pi/dflag; % Nyquist frequency
            if abs(Xdata(end)-NyqFreq)<(1e-2*NyqFreq), 
               Ylim=get(LTIdisplayAxes(1,1),'Ylim');
               RH{ctArray}(ctlines+1,1)=line([NyqFreq;NyqFreq],Ylim,'Color','k','Linestyle','-', ...
                  'Parent',LTIdisplayAxes(1,1),'visible','off','Tag','NyquistLines');
            end 
         end % if dflag
         
      end % for ctArray
      LineHandle{1,1}=RH;      
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   if SVFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      RespObj.PeakResponseValue=[get(RespObj,'PeakResponseValue');PeakRespVals];
      SVRespObj = RespObj;
   else
      
      %---Add the Plot Option Menus
      ContextMenu.PlotOptions.PeakResponse = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Peak Response',...
         'Callback',['menufcn(''togglepeak'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      SVRespObj.PeakResponseValue= PeakRespVals;
      SVRespObj= class(SVRespObj,'svplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the BackgroundAxes labels
   set(get(SVRespObj,'Xlabel'),'visible','on','string','Frequency (rad/sec)');
   set(get(SVRespObj,'ylabel'),'visible','on','string','Singular Values (dB)');
   set(get(SVRespObj,'title'),'visible','on','string','Singular Values');
   
   %---Store Response Object in Context Menu UserData
   set(ContextMenu.Main,'UserData',SVRespObj);
   
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


