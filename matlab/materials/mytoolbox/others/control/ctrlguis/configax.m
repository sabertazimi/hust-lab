function varargout = configax(varargin);
%CONFIGAX sets up the selected LTI Viewer response area configuration.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   Karen Gondoly 1-27-98.
%   $Revision: 1.8 $

ni=nargin;
switch ni
case 1,
   action = varargin{1};
case 2,
   action = 'initialize';
   LTIviewerFig=varargin{1};
   ConfigNumber=varargin{2};
end

switch action
case 'initialize',
   
   a = LocalOpenFigure(LTIviewerFig,ConfigNumber);
   
   if nargout,
      varargout{1}=a;
   end
            
case 'radiocallback',   
   val=get(gcbo,'Value');
   ud = get(gcbo,'UserData');
   if val,
      set(ud.Buttons,'Value',0);
      set(ud.Menus(1:ud.Number),'Enable','on')
      set(ud.Menus(ud.Number+1:end),'Enable','off')
   else
      set(gcbo,'Value',1);
   end
   
case 'setbuttons',
   ud = get(gcbf,'UserData');
   val=get(gcbo,'Value');
   set(ud.Handles.Downbutton,'enable','on');
   set(ud.Handles.Upbutton,'enable','on');
   
   if isequal(val,1),
      set(ud.Handles.Upbutton,'enable','off');
   elseif val==size(get(gcbo,'String'),1),
      set(ud.Handles.Downbutton,'enable','off');
   end
case 'help'
   LocalOpenHelp;
case 'changeconfig',
   ud = get(gcbf,'UserData');
   ViewerFig = ud.Parent;
   ViewerObj = get(ViewerFig,'UserData');
   AllViewProps = get(ViewerObj);
   
   OldConfig = AllViewProps.Configuration;
   OldOrder = AllViewProps.PlotTypeOrder;
   
   LayoutVals=get(ud.LayoutButtons,'Value');
   NewConfig = find([LayoutVals{:}]);
   
   AvailTypes = get(ud.PlotTypeMenus(1),'String');
   NewVals = get(ud.PlotTypeMenus(1:NewConfig),{'Value'});
   PlotTypeOrder= OldOrder;
   PlotTypeOrder(1:NewConfig) = AvailTypes([NewVals{:}]);
   
   if isequal(OldConfig,NewConfig) & isequal(OldOrder,PlotTypeOrder),
      return
      
   else
      %---Check if an lsim/initial has been removed
      if ( any(strcmpi(OldOrder(1:OldConfig),'initial')) & ...
            ~any(strcmpi(PlotTypeOrder(1:NewConfig),'initial')) ) | ...
            ( any(strcmpi(OldOrder(1:OldConfig),'lsim')) & ...
            ~any(strcmpi(PlotTypeOrder(1:NewConfig),'lsim')) ),
         
         switch questdlg({'Initial condition responses and linear simulations '; ...
                  'can not be recalculated once removed from the LTI Viewer.'; ...
                  ''; ...
                  'Do you want to continue and remove these plots from the Viewer?'}, ...
               'Viewer Configuration Warning','Yes','No','Yes');
         case 'Yes',
            %---Remove necessary menu entries from the Configurations PopupMenus
            MenuStr = get(ud.PlotTypeMenus(1),'String');
            MenuStr = MenuStr(1:7); % Basic PlotType menu
            %---Put any initial/lsim responses that are still plotted back in list
            if any(strcmpi('initial',PlotTypeOrder(1:NewConfig))),
               MenuStr=[MenuStr;{'initial'}];
            end
            if any(strcmpi('lsim',PlotTypeOrder(1:NewConfig))),
               MenuStr=[MenuStr;{'lsim'}];
            end
            set(ud.PlotTypeMenus,'String',MenuStr)
         case 'No',
            %---Reselect LSIM/INITIAL for the appropriate area
            MenuStr = get(ud.PlotTypeMenus(1),'String');
            ICarea = find(strcmpi('initial',OldOrder(1:OldConfig)));
            if ~isempty(ICarea),
               ICval = find(strcmpi('initial',MenuStr));
               set(ud.PlotTypeMenus(ICarea),'Value',ICval);
            end
            Lsimarea = find(strcmpi('lsim',OldOrder(1:OldConfig)));
            if ~isempty(Lsimarea ),
               Lsimval = find(strcmpi('lsim',MenuStr));
               set(ud.PlotTypeMenus(Lsimarea),'Value',Lsimval );
            end
            return
         end
      end, % if removing Lsim/initial
      
      set(ViewerObj,'PlotTypeOrder',PlotTypeOrder,'Configuration',NewConfig)      
      set(ViewerFig,'UserData',ViewerObj);
   end % if/else isequal(NewConfig,OldConfig
end % switch action

%---------------------------Internal Functions----------------------
%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenFigure %%%
%%%%%%%%%%%%%%%%%%%%%%%
function a = LocalOpenFigure(LTIviewerFig,ConfigNumber);
StdUnit = 'points';
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
LTIViewerUnit = get(LTIviewerFig,'Unit');
set(LTIviewerFig,'Unit','pixel');
LTIViewerPos = get(LTIviewerFig,'Pos');
set(LTIviewerFig,'Unit',LTIViewerUnit);

figurepos=[LTIViewerPos(1) LTIViewerPos(2)+LTIViewerPos(4)-264 494 264];

ParentPos = get(LTIviewerFig,'Position');
FigureColor = get(0,'DefaultFigureColor');
a = figure('Color',FigureColor, ...
   'IntegerHandle','off', ...
   'MenuBar','none', ...
   'Name','Available LTI Viewer Configurations', ...
   'NumberTitle','off', ...
   'Position',figurepos, ...
   'Resize', 'off', ...
   'Tag','ConfigureViewerAxesFig',...
   'visible','off', ...
   'WindowStyle','Modal');

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',FigureColor, ...
   'Position',PointsToPixels*[8 33 346 220], ...
   'Style','frame');

%---Response Order controls
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',FigureColor, ...
   'Position',PointsToPixels*[360 33 127 220], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[0.8 0.8 0.8], ...
   'Position',PointsToPixels*[374 226 100 17], ...
   'String','Response type', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[0.8 0.8 0.8], ...
   'Position',PointsToPixels*[70 236 250 15], ...
   'String','Choose a response arrangement.', ...
   'Style','text');

WhiteFramePos=[{[312 49 24 34]};
   {[286 49 24 34]};
   {[260 49 24 34]};
   {[312 85 24 34]};
   {[286 85 24 34]};
   {[260 85 24 34]};
   {[202 49 24 34]};
   {[175 49 24 34]};
   {[149 49 24 34]};
   {[189 85 37 34]};
   {[149 85 37 34]};
   {[40 85 37 34]};
   {[80 85 37 34]};
   {[40 49 37 34]};
   {[80 49 37 34]};
   {[262 192 74 23]};
   {[262 167 74 23]};
   {[262 142 74 23]};
   {[150 181 76 35]};
   {[150 143 76 35]};
   {[42 144 71 69]}];

TextPos = [{[315 55 18 18]};
   {[289 55 18 18]};
   {[263 55 18 18]};
   {[315 93 18 18]};
   {[289 93 18 18]};
   {[263 93 18 18]};
   {[204 55 18 18]};
   {[177 55 18 18]};
   {[150 55 18 18]};
   {[195 93 18 18]};
   {[157 93 18 18]};
   {[48 93 18 18]};
   {[88 93 18 18]};
   {[48 55 18 18]};
   {[88 55 18 18]};
   {[265 194 18 18]};
   {[265 170 18 18]};
   {[265 144 18 18]};
   {[153 188 18 18]};
   {[153 150 18 18]};
   {[45 186 18 18]}];
TextStr = {'6';'5';'4';'3';'2';'1';'5';'4';'3';'2';'1';'1';'2';'3';'4'; ...
      '1';'2';'3';'1';'2';'1'};
GreyFramePos=[{[36 140 84 80]};
   {[146 140 84 80]};
   {[256 140 84 80]};
   {[36 45 84 80]};
   {[146 45 84 80]};
   {[256 45 84 80]}];

RadioPos = [{[16 203 20 20]};
   {[126 203 20 20]};
   {[236 203 20 20]};
   {[16 108 20 20]};
   {[126 108 20 20]};
   {[236 108 20 20]}];

MenuPos = [{[386 192 94 25]};
   {[386 162 94 25]};
   {[386 131 94 25]};
   {[386 101 94 25]};
   {[386 70 94 25]};
   {[386 39 94 25]}];

MenuLabPos = [{[366 193 18 23]};
   {[366 162 18 23]};
   {[366 131 18 23]};
   {[366 100 18 23]};
   {[366 69 18 23]};
   {[366 38 18 23]}];

ViewerObj = get(LTIviewerFig,'UserData');
RespOrder = get(ViewerObj,'PlotTypeOrder');
allResp = {'step';'impulse';'bode';'nyquist';'nichols';'sigma';'pzmap'};
%---Append initial and lsim commands only if they are already plotted
%     These commands cannot currently be initialized from the Viewer
if any(strcmpi('initial',RespOrder(1:ConfigNumber))), 
   allResp = [allResp;{'initial'}];
end
if any(strcmpi('lsim',RespOrder(1:ConfigNumber))), 
   allResp = [allResp;{'lsim'}];
end

for ctB=1:6,
   LayoutButton(ctB) = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',[0.8 0.8 0.8], ...
      'callback','configax(''radiocallback'');', ...
      'Position',PointsToPixels*RadioPos{ctB}, ...
      'Style','radiobutton', ...
      'Tag',['Layout',num2str(ctB),'Button']);
   b = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*GreyFramePos{ctB}, ...
      'Style','frame');
   b = uicontrol('Parent',a, ...
      'BackgroundColor',FigureColor, ...
      'String',[num2str(ctB),':'],...
      'Units',StdUnit, ...
      'Position',PointsToPixels*MenuLabPos{ctB}, ...
      'Style','text');
   myVal = find(strcmpi(RespOrder{ctB},allResp));
   if isempty(myVal),
      myVal=ctB; % In case this entry is lsim or initial
   end
   PlotTypeMenu(ctB) = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'Enable','off',...
      'Position',PointsToPixels*MenuPos{ctB}, ...
      'Style','popupmenu', ...
      'String',allResp,...
      'Value',myVal,...
      'Tag',['Area',num2str(ctB),'Menu']);
end
set(PlotTypeMenu(1:ConfigNumber),'Enable','on')
set(LayoutButton(ConfigNumber),'Value',1);

set(LayoutButton(1),'UserData',...
   struct('Number',1,'Buttons',LayoutButton(2:6),'Menus',PlotTypeMenu))
set(LayoutButton(2),'UserData',...
   struct('Number',2,'Buttons',LayoutButton([1,3:6]),'Menus',PlotTypeMenu))
set(LayoutButton(3),'UserData',...
   struct('Number',3,'Buttons',LayoutButton([1:2,4:6]),'Menus',PlotTypeMenu))
set(LayoutButton(4),'UserData',...
   struct('Number',4,'Buttons',LayoutButton([1:3,5:6]),'Menus',PlotTypeMenu))
set(LayoutButton(5),'UserData',...
   struct('Number',5,'Buttons',LayoutButton([1:4,6]),'Menus',PlotTypeMenu))
set(LayoutButton(6),'UserData',...
   struct('Number',6,'Buttons',LayoutButton(1:5),'Menus',PlotTypeMenu))

for ct=1:length(WhiteFramePos),
   b = uicontrol('Parent',a, ...
      'BackgroundColor',[1 1 1], ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*WhiteFramePos{ct}, ...
      'Style','frame');
   b = uicontrol('Parent',a, ...
      'BackgroundColor',[1 1 1], ...
      'String',TextStr{ct},...
      'Units',StdUnit, ...
      'Position',PointsToPixels*TextPos{ct}, ...
      'Style','text');
end


Handles.OKButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'Callback','configax(''changeconfig'');close(gcbf);', ...
   'Position',PointsToPixels*[105 6 55 23], ...
   'String','OK');
Handles.CloseButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'Position',PointsToPixels*[170 6 55 23], ...
   'Callback','close(gcbf);', ...
   'String','Cancel');
Handles.HelpButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'Position',PointsToPixels*[235 6 55 23], ...
   'String','Help', ...
   'Callback', 'configax(''help'')');
Handles.ApplyButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'Callback','configax(''changeconfig'');', ...
   'Position',PointsToPixels*[300 6 55 23], ...
   'String','Apply');

set(a,'UserData',struct('Parent',LTIviewerFig,...
   'LayoutButtons',LayoutButton,...
   'PlotTypeMenus',PlotTypeMenu,...
   'Handles',Handles),...
   'visible','on');


%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenHelp %%%
%%%%%%%%%%%%%%%%%%%%%
function LocalOpenHelp;

   helptext={'Viewer Configuration', ...
         {'The Viewer Configuration window allows you to set the number';
         'and type of response plots contained in the LTI Viewer.';
         '';
         'The Viewer can be broken into anywhere from one to six response';
         'areas. Each area can show a different response type.';
         '';
         'To change the Viewer configuration:';
         '  1) Use the radio buttons to select a response arrangement. ';
         '     Choosing a arrangement sets the number of response areas';
         '     as well as their layout on the Viewer.';
         '  2) Use the pull down menus to select the response type shown ';
         '     in each area. You can select the same response type more';
         '     then once, or show different response types in each area.';
         '  3) Press the OK or Apply Button';
         '';
         'Press Cancel to close the window without reconfiguring the Viewer.';
         '';
         '';
         'There are six possible response arrangements for the LTI Viewer.';
         '';
         'Each arrangement consists of:';
         '   1) The number of response areas.';
         '   2) The layout of the response areas on the Viewer.';
         '';
         'Each area is numbered. The response type to show in any';
         'area is selected in the corresponding pull down menu on the';
         'right side of the Viewer Configuration window.';
         '';
         'All the available response types are contained in the pull down';
         'menus. If the Viewer was opened with an initial condition response';
         'or linear simulation, these options appear in the menus.'}};
   
   helpwin(helptext);
