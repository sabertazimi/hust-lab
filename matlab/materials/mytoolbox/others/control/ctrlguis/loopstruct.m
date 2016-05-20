function varargout = loopstruct(varargin);
%LOOPSTRUCT opens and manages the Feedback Structure for LTI Design Models window
%   NewStructNum = LOOPSTRUCT('initialize',ParentFig,OldStructNum) opens a
%   Feedback Structure window for the GUI with handle ParentFig, and initialized
%   to the Feedback Structure number OldStructNum. 
%
%   NewStructNum = LOOPSTRUCT('initialize',ParentFig,OldStructNum,SISOflag) opens a
%   Feedback Structure window for the GUI with handle ParentFig, and initialized
%   with the Feedback Structure number OldStructNum. If SISOflag is one, only the
%   first two SISO feedback structures are shown. If OldStructNum is 3 or 4 when
%   SISOflag is one, the Feedback Structure window does not open. Instead a warning
%   indicating that no other feedback structures are compatible with the current 
%   design model configuration is issued.
%
%   When LOOPSTRUCT is called from a GUI callback, the callback is suspended 
%   until the Feedback Structure window is closed. NewStructNum then returns the 
%   selected Feedback Structure number. The Feedback Structure window is Modal. No 
%   other windows can be accessed until the window is closed. 
%
%   Handles = LOOPSTRUCT('drawconfig',AxisHandle,NewStructNum) draws the loop 
%   structure with number NewStructNum in the axis with handle AxisHandle. The
%   axis limits will be set from 0-1 along both axes to ensure the loop 
%   structure scales appropriately. Any children on the axis are deleted before 
%   the new feedback structure is drawn. The handles to the new children on the
%   axis are returned in Handles, if an output argument is requested.

%   To add more feedback structures, change the following:


%   Karen D. Gondoly
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Initialize variables
MaxNumStruct = 4; % Change this if entering more feedback structures

%---Check if number of input arguments is in the correct range
ni = nargin;
no=nargout;

error(nargchk(2,4,ni));

%---The first input argument should always be a string action
action = varargin{1};
if ~ischar(action)
   error('The first input argument must be a valid string action.');
end

%---Read the remaining input arguments based on the action
switch action
case 'initialize',
   ParentFig = varargin{2};
   OldStructNum = varargin{3};
   if ni>3,
      SISOflag=varargin{4};
   else
      SISOflag = 0;
   end	
   if OldStructNum>MaxNumStruct,
      error(['Only ',num2str(MaxNumStruct),' feedback structures are currently supported.']);
   end
   
   if SISOflag & any(OldStructNum==[3 4]),
      warndlg(['The feedback structure of the current model configuration cannot',...
            ' be changed.'],'Feedback  Structure Warning');
      if no,
         varargout{1} = OldStructNum;
      end
      return
   end
   
case 'drawconfig',
   AxisHandle = varargin{2};
   NewStructNum = varargin{3};
   
otherwise
   LoopFig = varargin{2};
   if ni>2,
      LoopUd = varargin{3};
   else
      LoopUd = get(LoopFig,'UserData');
   end
end % switch action

%---Process the action
switch action
case 'initialize', % Open a Feedback Structure window
   LoopFig = LocalOpenStruct(ParentFig,OldStructNum,SISOflag);
   
   %---Wait until the figure is closed and return the new Structure number
   uiwait(LoopFig);
   
   if ishandle(LoopFig),
      LoopUd=get(LoopFig,'UserData');
      close(LoopFig)
      NewStructNum = LoopUd.StructNum;
   else
      NewStructNum = OldStructNum;
   end
   if no,
      varargout{1}=NewStructNum;
   end
   
case 'drawconfig',
   Handles = LocalDrawStruct(AxisHandle,NewStructNum);
   if no,
      varargout{1} = Handles;
   end
   
case 'apply', % Send the new feedback structure to the Parent's Userdata
   ConfigVals=get(LoopUd.ConfigButtons,'Value');
   OnButton = find([ConfigVals{:}]);
   LoopUd.StructNum=OnButton;
   set(LoopFig,'UserData',LoopUd);
   uiresume(LoopFig)
   
case 'close', % Close the Feedback Structure window without saving any changes
   uiresume(LoopFig),
   
case 'help',
   helptext = {'Closed-loop Configurations', ...
         {'The Closed-loop Configurations window shows all the available closed-loop ';
         'configurations.';
         '';
         '   1) Use the radio buttons to select the desired configuration';
         '   2) Press OK button to accept change to the selected configuration';
         '   3) Press Close to ignore any changes in configuration selection'}};
   
   helpwin(helptext);
   
end % switch action

%---Set varargout when the window is closed


%---------------------Internal Functions-----------------------
%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalDrawStruct %%% %---Draws the current feedback structure
%%%%%%%%%%%%%%%%%%%%%%%
function Handles = LocalDrawStruct(AxisHandle,ConfigNumber)   

set(AxisHandle,'Ylim',[0 1],'Xlim',[0 .9],'XlimMode','manual','YlimMode','manual');

Handles = struct('OpenLine',[],'ClosedLine',[],'SumPoint',[],...
   'FilterPatch',[],'FilterText',[],'CompPatch',[],'CompText',[],...
   'SensorPatch',[],'SensorText',[],'PlantPatch',[],'PlantText',[]);

%---Add new cases to add new feedback structures
switch ConfigNumber
case 1,
   
   Handles.OpenLine = line([0.05 .8 .76 NaN .8 .76 NaN .11 .15 .11], ...
      [.65 .65 .68 NaN .65 .62 NaN .62 .65 .68],'Color','k','Parent',AxisHandle);
   Handles.ClosedLine = line([.3 .3 .7 .7 NaN .59 .55 .59],...
      [.65 .2 .2 .65 NaN .17 .2 .23],...
      'Color','k','Parent',AxisHandle,'Tag','ClosedLine');
   Handles.SumPoint = line(.3,.65,'Marker','o','MarkerEdgeColor','k',...
      'MarkerFaceColor','k','MarkerSize',5,'Parent',AxisHandle);
   Handles.FilterPatch=patch([.15 .25 .25 .15 .15],[.5 .5 .8 .8 .5],'y',...
      'Parent',AxisHandle,'Tag','FilterPatch');
   Handles.FilterText=text(.175,.65,'F','Parent',AxisHandle,'Tag','FilterText','FontSize',7);
   Handles.CompPatch=patch([.35 .45 .45 .35 .35],[.5 .5 .8 .8 .5],'c',...
      'Parent',AxisHandle,'Tag','CompPatch');
   Handles.CompText=text(.375,.65,'K','Parent',AxisHandle,'Tag','CompText','FontSize',7);
   Handles.PlantPatch=patch([.55 .65 .65 .55 .55],[.5 .5 .8 .8 .5],'y', ...
      'Parent',AxisHandle,'Tag','PlantPatch');
   Handles.PlantText=text(.575,.65,'P','Parent',AxisHandle,'Tag','PlantText','FontSize',7);
   Handles.SensorPatch=patch([.45 .55 .55 .45 .45],[.05 .05 .35 .35 .05],'y', ...
      'Parent',AxisHandle,'Tag','SensorPatch');
   Handles.SensorText=text(.475,.2,'H','Parent',AxisHandle,'Tag','SensorText','FontSize',7);
      
case 2,
   Handles.OpenLine = line([0.05 .8 .76 NaN .8 .76 NaN .11 .15 .11], ...
      [.65 .65 .68 NaN .65 .62 NaN .62 .65 .68],'Color','k','Parent',AxisHandle);
   Handles.ClosedLine = line([.3 .3 .7 .7 NaN .69 .65 .69],...
      [.65 .2 .2 .65 NaN .17 .2 .23],...
      'Color','k','Parent',AxisHandle,'Tag','ClosedLine');
   Handles.SumPoint = line(.3,.65,'Marker','o','MarkerEdgeColor','k',...
      'MarkerFaceColor','k','MarkerSize',5,'Parent',AxisHandle);
   Handles.FilterPatch=patch([.15 .25 .25 .15 .15],[.5 .5 .8 .8 .5],'y',...
      'Parent',AxisHandle,'Tag','FilterPatch');
   Handles.FilterText=text(.175,.65,'F','Parent',AxisHandle,'Tag','FilterText','FontSize',7);
   Handles.PlantPatch=patch([.45 .55 .55 .45 .45],[.5 .5 .8 .8 .5],'y', ...
      'Parent',AxisHandle,'Tag','PlantPatch');
   Handles.PlantText=text(.475,.65,'P','Parent',AxisHandle,'Tag','PlantText','FontSize',7);
   Handles.CompPatch=patch([.35 .45 .45 .35 .35],[.05 .05 .35 .35 .05],'c',...
      'Parent',AxisHandle,'Tag','CompPatch');
   Handles.CompText=text(.375,.2,'K','Parent',AxisHandle,'Tag','CompText','FontSize',7);
   Handles.SensorPatch=patch([.55 .65 .65 .55 .55],[.05 .05 .35 .35 .05],'y', ...
      'Parent',AxisHandle,'Tag','SensorPatch');
   Handles.SensorText=text(.575,.2,'H','Parent',AxisHandle,'Tag','SensorText','FontSize',7);
   
case 3,
   Handles.OpenLine = line([.2 .8 .76 NaN .8 .76 NaN .31 .35 .31 NaN 0.1 .35 NaN .31 .35 .31], ...
      [.65 .65 .68 NaN .65 .62 NaN .62 .65 .68 NaN .75 .75 NaN .72 .75 .78],...
      'Color','k','Parent',AxisHandle);
   Handles.ClosedLine = line([.2 .2 .7 .7 NaN .59 .55 .59],...
      [.65 .2 .2 .65 NaN .17 .2 .23],...
      'Color','k','Parent',AxisHandle,'Tag','ClosedLine');
   Handles.CompPatch=patch([.35 .45 .45 .35 .35],[.5 .5 .85 .85 .5],'c',...
      'Parent',AxisHandle,'Tag','CompPatch');
   Handles.CompText=text(.375,.675,'K','Parent',AxisHandle,'Tag','CompText','FontSize',7);
   Handles.PlantPatch=patch([.55 .65 .65 .55 .55],[.5 .5 .8 .8 .5],'y', ...
      'Parent',AxisHandle,'Tag','PlantPatch');
   Handles.PlantText=text(.575,.65,'P','Parent',AxisHandle,'Tag','PlantText','FontSize',7);
   Handles.SensorPatch=patch([.45 .55 .55 .45 .45],[.05 .05 .35 .35 .05],'y', ...
      'Parent',AxisHandle,'Tag','SensorPatch');
   Handles.SensorText=text(.475,.2,'H','Parent',AxisHandle,'Tag','SensorText','FontSize',7);
   
case 4,
   Handles.OpenLine = line([.15 .75 .69 NaN .75 .69 NaN .36 .41 .36], ...
      [.75 .75 .78 NaN .75 .72 NaN .72 .75 .78],'Color','k','Parent',AxisHandle);
   Handles.ClosedLine = line([.4 .25 .25 .65 .65 .5 NaN .54 .5 .54],...
      [.65 .65 .2 .2 .65 .65 NaN .17 .2 .23],...
      'Color','k','Parent',AxisHandle,'Tag','ClosedLine');
   Handles.PlantPatch=patch([.4 .5 .5 .4 .4],[.5 .5 .85 .85 .5],'y', ...
      'Parent',AxisHandle,'Tag','PlantPatch');
   Handles.PlantText=text(.425,.675,'P','Parent',AxisHandle,'Tag','PlantText','FontSize',7);
   Handles.CompPatch=patch([.4 .5 .5 .4 .4],[.05 .05 .35 .35 .05],'c', ...
      'Parent',AxisHandle,'Tag','CompPatch');
   Handles.CompText=text(.425,.2,'K','Parent',AxisHandle,'Tag','CompText','FontSize',7);
   
end % switch ConfigNumber

%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenStruct %%% %---Opens the Feedback Structure Window
%%%%%%%%%%%%%%%%%%%%%%%
function a = LocalOpenStruct(ParentFig,OldStructNum,SISOflag);

StdColor = get(0,'DefaultFigureColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'points';

CurrentVal = zeros(1,4);
CurrentVal(OldStructNum)=1;

if SISOflag,
   FigWidth = 170;
   NumConfig = 2;
else
   FigWidth = 300;
	NumConfig = 4;   
end

a = figure('Color',StdColor, ...
   'MenuBar','none', ...
   'WindowStyle','modal',...
	'Name','Feedback Structures', ...
   'NumberTitle','off', ...
   'IntegerHandle','off', ...
   'Resize','off', ...
   'Unit','point', ...
   'Position',[86.25 93.75 FigWidth 180],...
   'visible','off',...
   'Tag','ConfigFig');
      
ConfigText = [{'Compensator in the Forward path'};
   {'Compensator in the Feedback path'};{' '};{' '}];

b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
   'Position',[102 215 113.25 12], ...
   'backgroundcolor',StdColor, ...
   'FontWeight','bold', ...
	'String','Select a configuration', ...
	'Style','text');

for ct=1:NumConfig,
   
   t = uicontrol('Parent',a, ...
      'Units',StdUnit,...
      'style','text', ...
      'FontWeight','bold', ...
      'FontSize',8,...
      'string',ConfigText{ct}, ...
      'BackgroundColor',StdColor, ...
      'Position',[12+(150*floor(ct/3)) 163-(74*rem(ct+1,2)) 150 12]);
   
   b = axes('Parent',a, ...
      'Units',StdUnit, ...
      'Box','on', ...
      'CameraUpVector',[0 1 0], ...
      'Color',[1 1 1], ...
      'Position',[33.75+(144.75*floor(ct/3)) 109-(74*rem(ct+1,2)) 108 50], ...
      'Tag',['Config',num2str(ct),'Axes'], ...
      'XColor',[0 0 0], ...
      'XTickMode','manual', ...
      'YColor',[0 0 0], ...
      'YLimMode','manual', ...
      'YTickMode','manual', ...
      'ZColor',[0 0 0]);
   
   Handles = LocalDrawStruct(b,ct);
      
   ConfigButton(ct) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[0.8 0.8 0.8], ...
      'Position',[12+(150*floor(ct/3)) 134-(74*rem(ct+1,2)) 15 15], ...
      'Style','radiobutton', ...
      'Callback','rlfcn(''radiocallback'');', ...
      'Tag',['Config',num2str(ct),'Button'], ...
      'Value',CurrentVal(ct));
end

if SISOflag,
   set(ConfigButton(1),'UserData',ConfigButton(2));
   set(ConfigButton(2),'UserData',ConfigButton(1));
else
   set(ConfigButton(1),'UserData',ConfigButton(2:4));
   set(ConfigButton(2),'UserData',ConfigButton([1,3:4]));
   set(ConfigButton(3),'UserData',ConfigButton([1:2,4]));
   set(ConfigButton(4),'UserData',ConfigButton(1:3));
end

b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'Position',[5 5 50 20], ...
   'String','Help', ...
   'Callback','loopstruct(''help'',gcbf);', ...
	'Tag','HelpButton');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Position',[FigWidth/2-25 5 50 20], ...
   'String','OK', ...
   'Callback','loopstruct(''apply'',gcbf);', ...
	'Tag','OKButton');
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'Position',[FigWidth-55 5.25 50 20], ...
   'String','Cancel', ...
   'UserData',ParentFig,...
   'Callback','loopstruct(''close'',gcbf);', ...
	'Tag','CancelButton');

set(a,'visible','on',...
   'UserData',struct('Parent',ParentFig,'StructNum',OldStructNum, ...
   'ConfigButtons',ConfigButton));
