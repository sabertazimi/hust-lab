function A = response(NumRows,NumColumns,AxHandle)
%RESPONSE Create a Response Object for the Control System Toolbox
% $Revision: 1.7.1.2 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly 12-31-97.

ni=nargin;
error(nargchk(0,3,ni));
if isequal(ni,1),
   error('Wrong number of input arguments for RESPONSE.');
end

%---Generate property set
AllProps = {'ArraySelector';
   'AxesGrouping';
   'BackgroundAxes';
   'ChannelSelector';
   'ColorOrder';
   'Grid';
   'InputLabel';
   'LinestyleOrder';
   'MarkerOrder';
   'NextPlot'; 
   'OutputLabel';
   'Parent'; 
   'PlotAxes';
   'ResponseType';
   'SelectedChannels';
   'SelectedModels';
   'SystemNames';
   'SystemVisibility';
   'Title';
   'Xlabel';
   'XlimMode';
   'Xlims';
   'Ylabel';
   'YlimMode';
   'Ylims';
   'Zoom';
   'ResponseHandles';
   'UIContextMenu';
	'InitializeResponse'};

NumProps = length(AllProps);
A = cell2struct(cell(NumProps,1),AllProps,1);
A.AxesGrouping = 'none';
A.NextPlot = 'replace';
A.ColorOrder = get(get(AxHandle,'Parent'),'defaultaxescolororder');
A.LinestyleOrder = get(get(AxHandle,'Parent'),'defaultaxeslinestyleorder');
%---Make sure LinestyleOrder is a cell array
if ~iscell(A.LinestyleOrder),
   A.LinestyleOrder = cellstr(A.LinestyleOrder);
end
A.MarkerOrder = {'none';'x';'o';'+';'*';'s';'d';'p';'h'};
A.ChannelSelector = 'off';
A.Zoom = 'off';
A.XlimMode = 'auto';
A.YlimMode = 'auto';
A.Xlims = cell(NumColumns,1);
A.Ylims = cell(NumRows,1);
A.Xlims(:)={[0 1]}; A.Ylims(:) = {[0 1]};

%---Check the GridState
kids=get(AxHandle,'children');
L = findobj(kids,'Tag','CSTgridLines');
if ~isempty(L) | strcmp('on',get(AxHandle,'Xgrid')) | ...
      strcmp('on',get(AxHandle,'Ygrid')),
	A.Grid = 'on';   
else
   A.Grid = 'off';
end

%---Turn the Figure's Double Buffer Property on
set(get(AxHandle,'Parent'),'DoubleBuffer','on')

if nargin==0
   A = class(A,'response');
else
   if isequal(ni,2),
      AxHandle = newplot; % Get the correct axes to plot to
   end	
   
   %---Check for invalid axis handle
   if ~ishandle(AxHandle) | ~strcmp('axes',get(AxHandle,'type')),
      error('An invalid axes handle was passed to RESPONSE.');
   end
      
   %---Get any axis children...if it is not a Response object, data is already
   %---plotted and the Hold is on, copy the children to the DisplayAxes. This is 
   %---ONLY valid for SISO plots. For MIMO plots, data must be plotted first.
   kids=get(AxHandle,'children');
   L = findobj(kids,'Tag','BackgroundResponseObjectLine');
   Axhold = get(AxHandle,'NextPlot');
   
   if isempty(L)
      L=line(0,0,'parent',AxHandle,'visible','off',...
         'tag','BackgroundResponseObjectLine', ...
         'DeleteFcn','delresp(gcbo)');
   else
      kids(find(kids==L))=[];
   end
   
   %---Check if Hold is valid
   if ~isempty(kids) & strcmp(Axhold,'add') & (~isequal(NumRows,1) | ~isequal(NumColumns,1)),
      error('Only SISO response plots can be placed on Held axes')
   end
   
   set(AxHandle,'Visible','off')
   [LTIdisplayAxes,ContextMenu] = LocalManyAxes(NumRows,NumColumns,AxHandle,Axhold,L);
   set(ContextMenu.GridMenu,'Checked',A.Grid)
   
   %---Store the ContextMenu Handle in the BacgroundResponesObjectLine
   %    Useful when using GCR and passing in the BackgroundAxes
   set(L,'UserData',ContextMenu.Main);

   %---Delete BackgroundAxes kids and copy to LTIdisplayAxes, if necessary
   if ~isempty(kids) & strcmp(Axhold,'add') & isequal(NumRows,1) & isequal(NumColumns,1),
      newkids=copyobj(kids,LTIdisplayAxes);   
   end
   delete(kids)
   
   A.NextPlot = Axhold;
   A.BackgroundAxes = AxHandle;
   A.Parent = get(AxHandle,'Parent');
   A.PlotAxes = LTIdisplayAxes;
   A.Xlabel = get(AxHandle,'Xlabel');
   A.Ylabel = get(AxHandle,'Ylabel');
   A.Title = get(AxHandle,'Title');
   A.UIContextMenu = ContextMenu;
   A = class(A,'response');
   
   %---Store the Response Object in the ContextMenus UserData
   set(ContextMenu.Main,'UserData',A)
   
end

%----------------------------Internal Functions------------------------------
%%%%%%%%%%%%%%%%%%%%%
%%% LocalManyAxes %%%
%%%%%%%%%%%%%%%%%%%%%
function [subax,ContextMenu] = LocalManyAxes(NumRows,NumColumns,AxHandle,Axhold,L);

% Get BackGround axes position
FigHandle = get(AxHandle,'Parent');
AxesUnit=get(AxHandle,'Unit');
set(AxHandle,'units','pixel');
position=get(AxHandle,'Position');
holdstr=get(AxHandle,'nextplot');
set(AxHandle,'unit',AxesUnit);

%---Check the PlotBoxAspectRatio and DataAspectRatio of BackgroundAxes
% Make the children mimic this behavior...needed if the BackgroundAxes
% was made square or equal
DARmode = get(AxHandle,'DataAspectRatioMode');
PBARmode = get(AxHandle,'PlotBoxAspectRatioMode');

%---Get the current Grid Mode
XgridVal = get(AxHandle,'Xgrid');
YgridVal = get(AxHandle,'Ygrid');

position(1)=position(1)+25;
position(3)=position(3)-25;
position(2)=position(2)+5;
position(4)=position(4)-17;

% Create sub axes 
subax = zeros(NumRows,NumColumns);
SWH = position(3:4)./[NumColumns NumRows];
offset=[0.01, 0.05];
if NumRows==1,
   offset(2)=0;
end
if NumColumns ==1,
   offset(1)=0;
end
inset=offset.*SWH;
AWH = (1-3*offset).*SWH;

%---Configure the Context Menu
ContextMenu.Main = uicontextmenu('Parent',FigHandle,...
   'Tag','ResponseObjectContextMenu'); 

%---Systems Menu
ContextMenu.Systems.Main = uimenu(ContextMenu.Main,'label','Systems');
ContextMenu.Systems.Names=[];

%---Plot Options Menu
ContextMenu.PlotOptions.Main = uimenu(ContextMenu.Main,'label','Characteristics');

%---Grouping Menu   
ContextMenu.GroupMenu.Main = uimenu(ContextMenu.Main,'label','Axes Grouping','Separator','on');
ContextMenu.GroupMenu.None = uimenu(ContextMenu.GroupMenu.Main,...
   'label','None',...
   'Checked','on',...
   'callback',['menufcn(''groupcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.GroupMenu.All = uimenu(ContextMenu.GroupMenu.Main,...
   'label','All',...
   'Callback',['menufcn(''groupcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.GroupMenu.In = uimenu(ContextMenu.GroupMenu.Main,...
   'label','Inputs',...
   'Callback',['menufcn(''groupcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.GroupMenu.Out = uimenu(ContextMenu.GroupMenu.Main,...
   'label','Outputs',...
   'Callback',['menufcn(''groupcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);

set(ContextMenu.GroupMenu.None,'UserData',[ContextMenu.GroupMenu.All; ...
   ContextMenu.GroupMenu.In;ContextMenu.GroupMenu.Out]);         
set(ContextMenu.GroupMenu.All,'UserData',[ContextMenu.GroupMenu.None; ...
   ContextMenu.GroupMenu.In;ContextMenu.GroupMenu.Out]);
set(ContextMenu.GroupMenu.In,'UserData',[ContextMenu.GroupMenu.All; ...
      ContextMenu.GroupMenu.None;ContextMenu.GroupMenu.Out]);
set(ContextMenu.GroupMenu.Out,'UserData',[ContextMenu.GroupMenu.All; ...
   ContextMenu.GroupMenu.In;ContextMenu.GroupMenu.None]);

ContextMenu.ChannelMenu = uimenu(ContextMenu.Main,...
   'label','Select I/Os...',...
   'callback',['menufcn(''selectios'',',...
      'get(get(gcbo,''Parent''),''UserData''));']);

if isequal(NumRows,1) & isequal(NumColumns,1),
   set([ContextMenu.ChannelMenu;ContextMenu.GroupMenu.Main],'visible','off');
end

ContextMenu.ArrayMenu = uimenu(ContextMenu.Main,...
   'visible','off', ...
   'label','Select from LTI Array...',...
   'callback',['menufcn(''selectmodels'',',...
      'get(get(gcbo,''Parent''),''UserData''));']);

ContextMenu.ZoomMenu.Main = uimenu(ContextMenu.Main,'label','Zoom','Separator','on');
ContextMenu.ZoomMenu.ZoomX = uimenu(ContextMenu.ZoomMenu.Main,...
   'Label','In-X',...
   'Callback',['menufcn(''zoomcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.ZoomMenu.ZoomY = uimenu(ContextMenu.ZoomMenu.Main,...
   'label','In-Y',...
   'Callback',['menufcn(''zoomcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.ZoomMenu.ZoomXY = uimenu(ContextMenu.ZoomMenu.Main,...
   'label','X-Y',...
   'Callback',['menufcn(''zoomcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
ContextMenu.ZoomMenu.ZoomOut = uimenu(ContextMenu.ZoomMenu.Main,...
   'label','Out',...
   'Callback',['menufcn(''zoomcallback'',',...
      'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);

set(ContextMenu.ZoomMenu.ZoomX,'UserData',[ContextMenu.ZoomMenu.ZoomY; ...
   ContextMenu.ZoomMenu.ZoomXY;ContextMenu.ZoomMenu.ZoomOut]);         
set(ContextMenu.ZoomMenu.ZoomY,'UserData',[ContextMenu.ZoomMenu.ZoomX; ...
   ContextMenu.ZoomMenu.ZoomXY;ContextMenu.ZoomMenu.ZoomOut]);
set(ContextMenu.ZoomMenu.ZoomXY,'UserData',[ContextMenu.ZoomMenu.ZoomX; ...
   ContextMenu.ZoomMenu.ZoomY;ContextMenu.ZoomMenu.ZoomOut]);
set(ContextMenu.ZoomMenu.ZoomOut,'UserData',[ContextMenu.ZoomMenu.ZoomX; ...
   ContextMenu.ZoomMenu.ZoomY;ContextMenu.ZoomMenu.ZoomXY]);

ContextMenu.GridMenu = uimenu(ContextMenu.Main,...
   'label','Grid',...
   'Callback',['menufcn(''gridcallback'',',...
      'get(get(gcbo,''Parent''),''UserData''));']);

%---LTIdisplayAxes UserData structure
udDisp=struct('Position',[], ...
   'Placement',[], ...
   'Parent',AxHandle, ...
   'Siblings',[]);

for i=1:NumRows,
   for j=1:NumColumns,
      % Define AxesPos as function of i and j and position
      AxesLL = position(1:2) +[j-1 NumRows-i].*SWH +inset;
      AxesPos = [AxesLL AWH];
      
      % Create axes
      subax(i,j) = axes('Unit','pixel','Position',AxesPos, ...
         'Box','on', ...
         'Color',[1 1 1], ...
         'DataAspectRatioMode',DARmode,...
         'NextPlot',Axhold,...
         'Parent',FigHandle, ...
         'PlotBoxAspectRatioMode',PBARmode,...
         'UserData',udDisp, ...
         'Xcolor',[.5 .5 .5],'Ycolor',[.5 .5 .5],...
         'Xgrid',XgridVal,'Ygrid',YgridVal,...
         'Tag','LTIdisplayAxes', ...
         'XTickLabelMode','manual','YTickLabelMode','manual');
      T=get(subax(i,j),'Title');
      set(T,'color',[.5 .5 .5],'String',' ','Interpreter','none');
      set(get(subax(i,j),'Xlabel'),'Interpreter','none');
      set(get(subax(i,j),'Ylabel'),'Interpreter','none');
      set(subax(i,j),'UiContextMenu',ContextMenu.Main);
   end % for j
end % for i

set(subax,'unit','norm');

for ct=1:NumRows
   for ct2=1:NumColumns,
      ud=get(subax(ct,ct2),'UserData'); 
      ud.Siblings=subax;
      set(subax(ct,ct2),'UserData',ud)
   end
end

if strcmp(PBARmode,'manual');
   set(subax(:),'PlotBoxAspectRatio',get(AxHandle,'PlotBoxAspectRatio'));
end
if strcmp(DARmode,'manual');
   set(subax(:),'DataAspectRatio',get(AxHandle,'DataAspectRatio'));
end

set(subax(:,1),'YtickLabelMode','auto','FontSize',8)
set(subax(end,:),'XtickLabelMode','auto','FontSize',8)

%---Store the Handle of the associated Context Menu in the backgroundline
set(L,'UserData',ContextMenu.Main)