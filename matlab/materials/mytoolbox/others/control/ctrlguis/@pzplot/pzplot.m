function PZRespObj = pzplot(RespObj,Systems,SystemNames,P,Z,PlotStr);      
%PZPLOT Create a Pole-Zero Object for the Control System Toolbox
% $Revision: 1.6.1.2 $

%   Karen Gondoly, 2-2-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

ni=nargin;
error(nargchk(1,6,ni));

if ~isa(RespObj,'response')
   error('Invalid Response Object passed to PZPLOT')
end

%---Generate property set
PZRespObj = struct('GridLines',[],...
   'GridType','sgrid', ...
   'Poles',[],...
   'Zeros',[]);

if isequal(1,ni),   
   if isa(RespObj,'pzplot'),
      PZRespObj=RespObj;
   else
      PZRespObj= class(PZRespObj,'pzplot',RespObj);
   end, % if/else isa(RespObj...
   
else
   
   PZFlag = isa(RespObj,'pzplot');
   
   ResponseHandles = cell(size(P));   
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   ContextMenu = get(RespObj,'UIContextMenu');
   
   %---Look for any grid lines already on the plot
   if strcmp('on',get(RespObj,'Grid')),
      kids = get(LTIdisplayAxes(1,1),'Children');
      GridLines = findobj(kids,'Tag','CSTgridLines');
      if ~isempty(GridLines),
         % There is a valid pole-zero on the axes
         PZRespObj.GridLines = findobj(kids,'Tag','CSTgridLines');
      else
         %---Turn of the square grid
         set(RespObj,'Grid','off')
         set(LTIdisplayAxes(1,1),'Xgrid','off','Ygrid','off');
      end
   end
   
   if PZFlag;
      NumSys=length(ContextMenu.Systems.Names);
   else
      NumSys=0;
   end
   
   %---Get Default plot styles
   Cvals = get(RespObj,'ColorOrder'); numC=size(Cvals,1);
   Lvals = get(RespObj,'LinestyleOrder'); numL = size(Lvals,1);
   Mvals = get(RespObj,'MarkerOrder'); numM = size(Mvals,1);
   
   [numout,numin]=size(LTIdisplayAxes);
   %---Initialize Line Userdata
   LineUd = struct('System',[],'Input',1,'Output',1,'Array',[]);
   
   for ctR=1:length(ResponseHandles); % each system
      LineUd.System = NumSys + ctR;
      
      if ~isempty(PlotStr{ctR})
         [LL,CCpole,MM,msg]=colstyle(PlotStr{ctR});
         if isempty(CCpole),
            CCpole = Cvals((NumSys+ctR)-(numC*floor(((NumSys+ctR)-1)/numC)),:);
            CCzero = CCpole;
         else
            CCzero = CCpole;
         end
         LegendStr = legdstr(CCpole);
         ColStr = ': ';
      else
         CCpole = 'r';
         CCzero = 'b';
         LegendStr = '';
         ColStr = '';
      end % if/else ~isempty(PlotStr)
      
      Parray = P{ctR};
      Zarray = Z{ctR};
      
      %---Determine the number of elements in the data 
      SizeArray=size(Systems{ctR});
      if length(SizeArray)>2,
        % LegendStr=[LegendStr,ComStr,mat2str(SizeArray(3:end)),' array'];
         SizeArray=SizeArray(3:end);
         ArrayDimsStr = sprintf('%dx',SizeArray);
         LegendStr=[ArrayDimsStr(1:end-1),' array',ColStr,LegendStr];
      else
         SizeArray = 1;
      end
      NumArray = prod(SizeArray);      
      if ~isempty(LegendStr)
         LegendStr = [' (',LegendStr,')'];
      end
      
      ContextMenu.Systems.Names(NumSys+ctR) = uimenu(ContextMenu.Systems.Main,...
         'label',[SystemNames{ctR},LegendStr],...
         'ForegroundColor',CCpole,...
         'Checked','on',...   
         'Callback',['menufcn(''systemtoggle'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
            
      LineHandle = cell(1,1);
      RH=cell(SizeArray);
      for ctArray=1:NumArray,
         LineUd.Array = LocalInd2Sub(SizeArray,ctArray);
         udstr = ['System: ',SystemNames{ctR}];
         if NumArray>1,
            udstr = [udstr,' ',mat2str(LineUd.Array)];
         end
         for ctpoles=1:size(Parray,1),
            RH{ctArray}(ctpoles,1)=line(real(Parray(ctpoles,1,ctArray)),...
               imag(Parray(ctpoles,1,ctArray)),...
               'color',CCpole,'LineStyle','none','Marker','x',...
               'DeleteFcn','delresp(gcbo)',...
               'parent',LTIdisplayAxes(1,1),'Tag','LTIresponseLines','visible','off', ...
               'UserData',{udstr;['Pole: ',num2str(Parray(ctpoles,1,ctArray),'%5.2g')]}, ...
               'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);');
         end % for ctpoles
         
         for ctZ=1:size(Zarray,1),
            RH{ctArray}(ctpoles+ctZ,1)=line(real(Zarray(ctZ,1,ctArray)),...
               imag(Zarray(ctZ,1,ctArray)),...
               'color',CCzero,'LineStyle','none',...
               'DeleteFcn','delresp(gcbo)',...
               'Marker','o','parent',LTIdisplayAxes(1,1),...
               'Tag','LTIresponseLines', ...
               'UserData',{udstr;['Zero: ',num2str(Zarray(ctZ,1,ctArray),'%5.2g')]}, ...
               'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);',...
               'visible','off');
         end % for ctZ
         
      end % for ctArray
      LineHandle{1,1}=RH;
      ResponseHandles{ctR}=LineHandle;
   end % for ctR
   
   %---Add the Real/Imag axes lines, if they are not already there
   allKids = allchild(LTIdisplayAxes(1,1));
   if isempty(findobj(allKids,'Tag','PZxaxisLine')),
      ylim = get(LTIdisplayAxes(1,1),'YLim');
      ymax = max(abs(ylim));
      ylim = [-ymax ymax];
      Color = get(LTIdisplayAxes(1,1),'XColor');
      line([0 0],ylim,'LineStyle',':','Color',Color,'HitTest','off',...
         'HandleVis','off','parent',LTIdisplayAxes(1,1),'Tag','PZyaxisLine')
      Color = get(LTIdisplayAxes(1,1),'YColor');
      line(get(LTIdisplayAxes(1,1),'XLim'),[0 0],'LineStyle',':',...
         'parent',LTIdisplayAxes(1,1),...
         'HandleVis','off','Tag','PZxaxisLine','Color',Color,'HitTest','off')
   end
   
   if PZFlag, % Append Data
      set(RespObj,'UIContextMenu',ContextMenu, ...
         'ResponseHandles',[get(RespObj,'ResponseHandles');ResponseHandles], ...
         'SystemNames',[get(RespObj,'SystemNames');SystemNames]);
      PZRespObj = RespObj;
   else
      
      %---Hide the Plot Option Menus
      set(ContextMenu.PlotOptions.Main,'visible','off')
      set(RespObj,'ResponseHandles',ResponseHandles, ...
         'UIcontextMenu',ContextMenu,'SystemNames',SystemNames)
      PZRespObj = class(PZRespObj,'pzplot',RespObj);
   end, % if/else isa(RespObj...
   
   %---Set the Labels
   PZRespObj = LocalLabelAxes(PZRespObj,Systems);
   
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

dflag = zeros(size(Systems));
for ctS=1:length(Systems),
   dflag(ctS)=Systems{ctS}.Ts;
end

if ~isempty(dflag) & all(dflag==0),
   RespObj.GridType = 'sgrid';
   %set(RespObj,'GridType','sgrid');
elseif ~any(~dflag),
   RespObj.GridType = 'zgrid';
   %set(RespObj,'GridType','zgrid');
else
   RespObj.GridType = 'square';
end

%---Set the BackgroundAxes labels
set(get(RespObj,'Xlabel'),'visible','on','string','Real Axis');
set(get(RespObj,'ylabel'),'visible','on','string','Imag Axis');
set(get(RespObj,'title'),'visible','on','string','Pole-zero map');

%---Set the LTIdisplayAxes labels
set(RespObj,'InputLabel',{'U'},'OutputLabel',{'Y'});

