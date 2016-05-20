function fig = ltibrowse(varargin);
%LTIBROWSE Open an LTI Browser for the Control System Toolbox GUIs
%   H = LTIBROWSE(Type,ParentFig,ListStr,SystemList,CallbackFcn)
%   opens an LTI Browser and returns the figure handle in H. Type  
%   indicates the purpose of the LTI Browser, either 1) "import" or 
%   2) "delete". ParentFig is the Handle of the GUI from which the   
%   LTI Browser was opened. ListStr is the string to display in the
%   GUIs list box. ListStr should contain the LTI object names, size, 
%   and class. SystemList is acell array of only the names
%   of the LTI objects listed in ListStr. CallbackFcn is a string, 
%   containing the callback function to be invoked when the OK button 
%   is pressed.
%
%   Based on the LTI Browser Type, the following behaviors are followed:
%   1) Import: The LTI Browser shows all LTI objects in the main
%      MATLAB workspace.
%   2) Delete: The LTI Browser shows all LTI objects in the caller
%      function's workspace.
%
%   When the OK button is pressed, the LTI Browser invokes the Callback
%   function, with an additional input argument. For example, if 
%   CallBackFcn = 'myfun(''DoAction'',)'. The function call made after
%   pressing OK is
%                     myfun('DoAction',SelectedModels) 
%   where Selected Models is a cell array containing the names of all 
%   selected models. The Handle for the Parent figure can be used
%   in the callback function by referencing the variable ud.Parent.

%   Karen D. Gondoly, 4-22-98
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:20:55 $

error(nargchk(1,5,nargin));
Type = lower(varargin{1});

if nargin>1,
   error(nargchk(5,5,nargin));
   ParentFig=varargin{2};
   ListStr = varargin{3};
   SystemList = varargin{4};
   CallbackFcn = varargin{5};
end

%---Set up data based on Type
switch Type,
case 'import',
   TitleStr = 'Select the systems to import';
case 'delete',
   TitleStr = 'Select the systems to delete';
case {'help','ok'},
   %---Place holders
otherwise,
   error('Invalid Type in call to LTIBROWSE.');
end

switch Type
case {'import','delete'},
   h0 = LocalOpenFig(ListStr,SystemList,TitleStr,ParentFig,CallbackFcn);
   if nargout, fig = h0; end
   
case 'help',
   LocalOpenHelp;
   
case 'ok',
   BrowserFig = gcbf;
   Type = get(gcbo,'UserData');
   ud = get(BrowserFig,'UserData');
   
   Vals = get(ud.SystemList,'Value');
   AllNames = get(ud.SystemList,'UserData');
   if length(AllNames) & ~isempty(AllNames{1})
      SelectedNames = AllNames(Vals);
      
      if strcmp(Type,'delete'),
         SystemStr = get(ud.SystemList,'String');
         SystemStr(Vals,:)=[];
         AllNames(Vals)=[]; 
         if isempty(AllNames),
            AllNames={''};
         end
         set(ud.SystemList,'Val',1,'String',SystemStr, ...
            'UserData',AllNames)
      end
      
      eval([ud.CallbackFcn(1:end-1),'SelectedNames',ud.CallbackFcn(end)])
   end
   
end

%--------------------------Internal Functions--------------------
%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenFig %%%
%%%%%%%%%%%%%%%%%%%%
function fig = LocalOpenFig(ListStr,AllNames,TitleStr,ParentFig,CallbackFcn);

DefaultFigColor = get(0,'DefaultFigureColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'points';

ud = struct('Parent',ParentFig,'CallbackFcn',CallbackFcn,...
   'SystemList',[]);

h0 = figure('Color',DefaultFigColor, ...
	'IntegerHandle','off', ...
	'MenuBar','none', ...
	'Name','LTI Browser', ...
	'NumberTitle','off', ...
	'PaperPosition',PointsToPixels*[18 180 576 432], ...
   'PaperUnits','points', ...
   'Resize', 'off', ...
	'Position',[106 135 320 267], ...
   'Tag','LTIBrowserFigure', ...
   'WindowStyle','modal');
h1 = uicontrol('Parent',h0, ...
   'Unit',StdUnit,...
	'BackgroundColor',DefaultFigColor, ...
	'Position',PointsToPixels*[16 243 290 20], ...
	'String',TitleStr, ...
	'Style','text');
h1 = uicontrol('Parent',h0, ...
   'Unit',StdUnit,...
	'BackgroundColor',DefaultFigColor, ...
	'Position',PointsToPixels*[21 222 63 20], ...
	'String','Name', ...
	'Style','text');
h1 = uicontrol('Parent',h0, ...
   'Unit',StdUnit,...
	'BackgroundColor',DefaultFigColor, ...
	'Position',PointsToPixels*[128.5 222 63 20], ...
	'String','Size', ...
	'Style','text');
h1 = uicontrol('Parent',h0, ...
   'Unit',StdUnit,...
	'BackgroundColor',DefaultFigColor, ...
	'Position',PointsToPixels*[236 221.5 63 20], ...
	'String','Class', ...
   'Style','text');

ud.SystemList = uicontrol('Parent',h0, ...
   'Unit',StdUnit,...
   'BackgroundColor',[1 1 1], ...
   'FontName','courier',...
   'Max',2,...
	'Position',PointsToPixels*[20 45 285 176], ...
	'String',ListStr, ...
	'Style','listbox', ...
   'Tag','SystemList', ...
   'UserData',AllNames, ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
   'CallBack','ltibrowse(''ok'');close(gcbf)',...
   'Unit',StdUnit,...
   'UserData',TitleStr(end-5:end),...
	'Position',PointsToPixels*[20 10 55 25], ...
	'String','OK', ...
	'Tag','OkButton');
h1 = uicontrol('Parent',h0, ...
   'Callback','close(gcbf)',...
   'Unit',StdUnit,...
	'Position',PointsToPixels*[97 10 55 25], ...
   'String','Cancel', ...
	'Tag','CancelButton');
h1 = uicontrol('Parent',h0, ...
	'Callback','ltibrowse(''help'');',...   
   'Unit',StdUnit,...
	'Position',PointsToPixels*[174 10 55 25], ...
	'String','Help', ...
   'Tag','HelpButton');
h1 = uicontrol('Parent',h0, ...
   'CallBack','ltibrowse(''ok'');',...
   'Unit',StdUnit,...
   'UserData',TitleStr(end-5:end),...
	'Position',PointsToPixels*[250 10 55 25], ...
	'String','Apply', ...
	'Tag','ApplyButton');

set(h0,'UserData',ud)

if nargout > 0, fig = h0; end


%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenHelp %%%
%%%%%%%%%%%%%%%%%%%%%
function LocalOpenHelp;
helptext={'Importing', ...
      {'The LTI Browser is used to import LTI models from the main';
      'MATLAB workspace into the LTI Viewer.';
      '';
      'To import a model';
      '  1) Select the desired models in the LTI Browser List';
      '  2) Press the OK or Apply Button';
      '';
      'Press Cancel to close the window without importing any models.';
      '';
      '';
      'The LTI Browser List shows all the LTI models available in the ';
      'main MATLAB workspace.';
      '';
      'The list provides the following information about each LTI model:';
      '   1) Its name: If an LTI model with this name already exists in';
      '      the Viewer, you are prompted to over-write it.';
      '';
      '   2) Its size: Each LTI model in the LTI Viewer must have the same ';
      '      size. Attempting to import an incompatible model generates an';
      '      appropriate warning message.';
      '';
      '   3) Its type: Any type of LTI model may be imported into the LTI';
      '      Viewer, with the limitation that time domain response plots';
      '      cannot be shown for FRD models.';
      '';
      'You may select any number of variables in this list to import.';
      'To select multiple models:';
      '   1) Click and drag the cursor over several variables in the list.';
      '   2) Hold the Control key and click on individual variables.';
      '   3) Hold the Shift key and click on a variable, to select a range.';
      ''}};

helpwin(helptext);

