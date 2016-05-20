function varargout = slview(varargin);
%SLVIEW initializes and manages the Simulink LTI Viewer
%   SLVIEW is the callback for the Linear Analysis menu located under a
%   Simulink diagram Tools menu. Selecting the Linear Analysis menu
%   opens an LTI Viewer connected to the Simulink diagram, or obtains a
%   new linear model of the diagram if an LTI Viewer already exists.
%
%   When a Simulink LTI Viewer is initialized, a Simulink diagram containing
%   Model Inputs and Outputs is also opened. These drag/drop blocks are used
%   to indicate the input and output signals of the linearized model. The
%   Input and Output Points can be placed at any level of the Simulink diagram.
%
%   Once open, the LTI Viewer functions independently of the Simulink diagram.
%   However, changes made in the diagram can be reflected in the LTI Viewer
%   by re-selecting the Linear Analysis menu.
%
%   To see more help, enter TYPE SLVIEW
%
%   See also LTIVIEW

%   SLVIEW(ACTION,Model_Handle) can be used at the command line to open
%   a Simulink LTI Viewer or execute a callback for the Simulink LTI 
%   Viewer connected to the Simulinkdiagram with the handle Model_Handle. 
%   ACTION specifies what function is executed.
%
%   The following ACTIONS are supported.
%
%   1) Initialize:  Open a Simulink LTI Viewer
%   2) States:      Open a window for specifying the State/Input values
%                   to linearize the model about
%   3) ClearBlocks: Remove all Input/OutputPoint blocks on the diagra
%
%   The LTI Viewer callbacks that are modified to now call SLVIEW actually
%   pass the Model Name as the second input argument. This is also valid.

%   Karen Gondoly, 12-2-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.21.1.3 $

ni=nargin;

%---Must have at least one input argument indicating the action
error(nargchk(1,3,ni));

action = lower(varargin{1});
if nargin>1,
   try
      diagram_name=get_param(varargin{2},'Name');
   catch
      error('Invalid Simulink diagram handle.');
   end
   
   diagram_handle=get_param(diagram_name,'Handle');
   fignum=[];
   
   %---Get remaining input argument
   if isequal(ni,3),
      fignum=varargin{3};
      if ~ishandle(fignum),
         fignum=[]
      end % if ~ishandle(fignum)
   end, % if/else isequal(ni,...)
   
   %---Second check for an open Viewer associated with this diagram
   %---Look for a Simulink menu, then check if the Userdata of the Simulink
   %---menu matches the handle of the Block Diagram
   if isempty(fignum),
      AllFigs = allchild(0);
      Viewers = findobj(AllFigs,'Tag','ResponseGUI');
      NumSimViewers = 0;
      if ~isempty(Viewers),
         SimMenus = findobj(Viewers,'label','Simulink');
         if ~isempty(SimMenus),
            NumSimViewers=length(SimMenus);
            UdSimMenu=get(SimMenus,{'UserData'});
            UdSimMenu=[UdSimMenu{:}];
            indfig = find(diagram_handle==UdSimMenu);
            goodMenu = SimMenus(indfig);
            fignum = get(goodMenu,'Parent');
         end % if ~isempty(SimMenus)
      end % if ~isempty(Viewers)
   end % if isempty(fignum)
   
   %---Update the name of the LTI Viewer
   if ~isempty(fignum)
      set(fignum,'name',['LTI Viewer: ',diagram_name])
   end
end % if nargin>1

%---Perform action
switch action
case 'initialize',
   %---Open a new LTI Viewer
   open_system('Model_Inputs_and_Outputs')
   if isempty(fignum)
      fignum = LocalCustomizeViewer(diagram_name,diagram_handle);      
   else
      figure(fignum)
   end
   varargout{1} = fignum;
   
case 'linearize',
   % Find all the LTI Input and Output Blocks in the diagram
   set(fignum,'Pointer','watch');
   LocalLinearizeDiagram(diagram_name,fignum);
   set(fignum,'Pointer','arrow');
   
case 'clearblocks'
   %---Callback to clear the Input/OutputPoint blocks from the Simulink diagram
   AllInBlocks = find_system(diagram_name,'masktype','InputPoint');
   AllOutBlocks = find_system(diagram_name,'masktype','OutputPoint');
   
   for NumIn=1:length(AllInBlocks)
      delete_block(AllInBlocks{NumIn});
   end
   for NumOut=1:length(AllOutBlocks)
      delete_block(AllOutBlocks{NumOut});
   end
   
case 'closediagram',
   if ishandle(fignum),
      delete(fignum)
      NumSimViewers=NumSimViewers-1;
   end
   
case 'newviewer',
   switch questdlg(...
         {'This new LTI Viewer will not be linked to the'
         'Simulink diagram.'
         ' '
         'Do you wish to continue?'},...
         'Opening a new LTI Viewer','Yes','No','Yes');
      
   case 'Yes'
      ltiview
   case 'No'
      return;
   end % switch questdlg
   
case 'radiocallback',   
   %---Callback for the radio buttons on the Set Operating Conditions window
   ModeHandle = gcbo;
   udFig = get(gcbf,'UserData');
   udMode = get(ModeHandle,'UserData');
   switch get(ModeHandle,'Value');
   case 1,
      %---Since this dialog is modal, the user should not be able to
      % modify their Simulink diagram while the dialog is open. Therefore,
      % the state names, number of states, and state order should not
      % change while the dialog is open. If we make this dialog non-modal,
      % extra protection for these changes would need to be added here.
      SibVals = get(udMode.Siblings,'Value');
      if any(cat(1,SibVals{:})),
         %---Only execute when switching over for the first time.
         set(udMode.Siblings,'Value',0);
         switch udMode.Mode,
         case 1, % Get states from Simulink diagram
            set(udFig.Handles.StateValue,'Enable','off')
            x0=udFig.DiagramStates;
            
         case 2, % Zero initial states
            set(udFig.Handles.StateValue,'Enable','off','String','0')
            
         case 3, % User-defined state values
            set(udFig.Handles.StateValue,'Enable','on')
            x0=get(udFig.Handles.StateValue,{'UserData'});
            x0=cat(1,x0{:});
         end % switch udMode.Mode
         
         if isequal(udMode.Mode,1) | isequal(udMode.Mode,3)
            %---Reset the state edit boxes
            for ct=1:length(x0)
               set(udFig.Handles.StateValue(ct),'String',num2str(x0(ct)));
            end
         end
         
      end  % if any(udMode.Siblings)
            
   case 0,
      set(ModeHandle,'Value',1);
   end
   
case 'states'
   %---Open the Operating Point window
   ICfig = LocalOpenICFig(fignum,diagram_name);
   
case 'stateapply'
   %---Callback for the apply button on the Operating Point window
   ICfig = gcbf;
   udFig = get(ICfig,'UserData');
   udIC = get(udFig.ParentMenu,'UserData');
   
   %---Find New Mode
   ModeVals = get(udFig.Handles.RadioButton,'Value');
   Mode = find(cat(1,ModeVals{:}));
   ChangeFlag = 0;
   
   if ~isequal(udIC.Mode,Mode),
      ChangeFlag=1;
   end
   
   OldControls = udIC.Controls.OperatingConditions;
   if isfield(udFig.Handles,'ControlValue'),
      NewControls = get(udFig.Handles.ControlValue,{'UserData'});   
      NewControls = cat(1,NewControls{:});
      if ~isequal(NewControls,OldControls)
         ChangeFlag = 1;
      end
   else
      NewControls=[];
   end, % if isfield
   
   OldStates = udIC.States.OperatingConditions;
   if isfield(udFig.Handles,'StateValue'),
      NewICs = get(udFig.Handles.StateValue,{'UserData'});
      NewICs = cat(1,NewICs{:});
      if isequal(Mode,3) & ~isequal(NewICs,OldStates), 
         % Only need to update the linear model if in Mode 3 (User-Defined)
         ChangeFlag = 1;
      end
   end, % if isfield
   
   set(udFig.ParentMenu,'UserData',udIC);
      
   if ChangeFlag
      switch questdlg({'The operating point has changed.'; ...
               ''; ...
               'Do you want to generate a new linear model of'; ...
               'the Simulink diagram about this point?'}, ...
            'Simulink LTI Viewer','Yes','No','Cancel','Yes'),
         
      case 'Yes',
         close(ICfig)
         udIC.Controls.OperatingConditions = NewControls;
         udIC.States.OperatingConditions = NewICs;
         udIC.Mode = Mode;
         set(udFig.ParentMenu,'UserData',udIC)
         slview('linearize',...
            get(findobj(udFig.ParentFigure,'Label','Simulink'),'UserData'),...
            udFig.ParentFigure);
         
      case 'No',
         udIC.Mode = Mode;
         udIC.Controls.OperatingConditions = NewControls;
         udIC.States.OperatingConditions = NewICs;
         set(udFig.ParentMenu,'UserData',udIC)
         close(ICfig)
         
      case 'Cancel'
         %---Do nothing
      end % switch questdlg
   else
      close(ICfig)
   end % if ChangeFlag
   
case 'stateedit',
   %---Callback for the edit boxes on the Operating Point window
   NewVal = str2double(get(gcbo,'String'));
   
   if isnan(NewVal), % Either entered a string or a vector
      set(gcbo,'String',num2str(get(gcbo,'UserData')));
   else
      set(gcbo,'UserData',NewVal);
   end
      
case 'statehelp',
   %---Callback for the Help menu pertaining to Setting Operating Point
   HelpStr = [{'The Operating Point window allows the state and input'};
      {'vectors used when linearizing the Simulink diagram to be specified.'};
      {''};
      {'By default, the linearized model is obtained by setting the state and'};
      {'input variables to zero. To genearate a linear model about a different'};
      {'point:'};
      {''}
      {'   1) Open the Operating Point window from the "Set Operating Point" menu'};
      {'   2) Enter a value for each state and input variable'};
      {'   3) Press the OK button on the Operating Point window'};
      {'   4) Select the "Get Linearized Model" menu on the associated LTI Viewer'};
      {''}
      {'Notes:'};
      {'   1) All the diagram''s states are shown on the Operating Point window and'};
      {'      each must contain a numeric value before closing the window, even'};
      {'      if the state is not contained in the portion of the Simulink '};
      {'      diagram isolated by the LTI Viewer Inputs and Outputs.'};
      {''};
      {'   2) The inputs are the locations of the top level inputs on the'};
      {'      Simulink diagram, i.e. the top level Inport Block locations.'}];
   
   helpwin(HelpStr,'Setting the Operating Point');
   
otherwise
   error('Invalid ACTION specified')
   
end % switch action


%------------------------Local Functions---------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCustomizeViewer %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fignum = LocalCustomizeViewer(diagram_name,diagram_handle);

%---See if any old I/O Point blocks are already in the Simulink diagram.
%allInblks = find_system(diagram_name,'MaskType','InputPoint');
%---Have to loop over the remaining blocks, in case the user has entered
% some new Input Point blocks before the old ones got updated!
%for ct=1:length(allInblks),
%   if isempty(find_system(allInblks{ct},'BlockType','Terminator'))
%      NewInBlocks = replace_block(getfullname(allInblks{ct}), ...
%         'Name',get_param(allInblks{ct},'Name'), ...
%         'cstblocks/Input Point','noprompt');
%      connectline('open',NewInBlocks{1});
%   end % if isempty(Terminator...)
%end % for ct

%---For now, warn the user to run CSTUPDATE if any old Input Point blocks
% are found
allInblks = find_system(diagram_name,'LookUnderMasks','all','FollowLinks','on',...
   'MaskType','InputPoint');
if isempty(get_param(diagram_name, 'blocks'))
   msgbox({'You cannot open the Simulink LTI Viewer before'; ...
      'placing blocks in the Simulink diagram.'; ...
      ''; ...
      'Please, build your model then reselect Linear Analysis.'}, 'Linear Analysis Warning' );
   fignum=[];
   return;
end
TermBlocks = find_system(allInblks,'LookUnderMasks','all','FollowLinks','on',...
   'BlockType','Terminator');
if ~isequal(length(TermBlocks),length(allInblks)),
   h = msgbox({'Your Simulink model uses an old version of the Input Point Block.'; ...
         ''; ...
         'Use the function CSTUPDATE to update all Input Point Blocks in the '; ...
         'Simulink model.'}, ...
     'Simulink LTI Viewer Warning','replace');  
end

fignum=ltiview;
set(fignum,'Name',['LTI Viewer: ',diagram_name]);

%---Modify the Close Menu Callback 
%----Only Hide the Viewer if the Simulink diagram is still open
CM = findobj(fignum,'Tag','CloseMenu');
CurrentCB = get(CM,'CallBack');
NewCB = ['CurrentSys=get(gcbf,''Name'');', ...
      'CSindcolon=findstr('':'',CurrentSys);', ...
      'LookforBlockName=CurrentSys(CSindcolon+2:end);', ...
      'FoundBlockName=find_system(''Name'',LookforBlockName);', ...
      ['if isempty(FoundBlockName), ',CurrentCB], ...
      'else,', ...
      'set(gcbf,''Visible'',''off'');', ...
      'end;', ...
      'clear CurrentSys CSindcolon LookforBlockName FoundBlockName'];
set(CM,'Callback',NewCB);

%---Modify the New Viewer... menu callback (Want to tell user this is NOT an SL Viewer)
set(findobj(fignum,'Tag','NewMenu'),'Callback',...
   'slview(''newviewer'',get(findobj(gcbf,''Label'',''Simulink''),''UserData''),gcbf);');

%---Add a Simulink specific menu
SimMenu = uimenu(fignum,'Label','Simulink','Position',4,'UserData',diagram_handle);

%---Add menu to linearize model
LinearizeMenu = uimenu(SimMenu, ...
   'Label','Get Linearized Model',...
   'UserData',diagram_handle,...
   'Callback',...
   'slview(''linearize'',get(findobj(gcbf,''Label'',''Simulink''),''UserData''),gcbf);');

try
   [sizes,x0,xNames]=feval(diagram_name,[],[],[],'sizes');
   xNames = LocalCheckStateNames(xNames); % Check for blocks with multiple states
catch
   sizes = [0 0 0 0];x0=[];xNames={};
end
u0 = zeros(sizes(4),1);

%---Get the name of each Inport Block, and correctly dimension it
uNames = LocalGetInportNames(diagram_name,sizes(4));

%---Add a menu to specify the State and Input points to linearize about
%   Use the current diagram Initial State Values as the Operating Condition
UdIC = struct('Mode',1,'Handle',Inf,'States',struct('Names',{xNames},...
   'OperatingConditions',zeros(size(x0))), ...
   'Controls',struct('Names',{uNames},'OperatingConditions',u0));

ICmenu = uimenu(SimMenu, ...
   'Label','Set Operating Point...', ...
   'Separator','on',...
   'Tag','ICmenu', ...
   'Callback', ...
   ['slview(''states'',get(findobj(gcbf,''Label'',''Simulink''),''UserData''))'],...
   'UserData',UdIC);

%---Add menu to delete input/output points
DeleteMenu = uimenu(SimMenu, ...
   'Label','Remove Input/Output Points', ...
   'Callback',...
   'slview(''clearblocks'',get(findobj(gcbf,''Label'',''Simulink''),''UserData''),gcbf)');

%---Add a help entry to the LTI Viewer help
HM = findobj(fignum,'Label','Help');
b = uimenu('Parent',HM, ...
   'Label','Simulink...', ...
   'Callback',...
   ['slview(''statehelp'',get(findobj(gcbf,''Label'',''Simulink''),''UserData''))']);

if isempty(x0),
   %---Disable the menu if there are no states
   set(ICmenu,'Enable','off');
end

%----Set the StatusText
StatusStr=['Use the Input/OutputPoint blocks to define the linear model.'];
set(findobj(fignum,'Tag','StatusText'),'String',StatusStr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalLinearizeDiagram %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fignum = LocalLinearizeDiagram(diagram_name,fignum);

s = find_system(diagram_name,'masktype','InputPoint');
Hin = get_param(s,'Handle');
Hin = cat(1,Hin{:});
InNames = get_param(Hin,'Name');

s = find_system(diagram_name,'masktype','OutputPoint');
Hout = get_param(s,'Handle');
Hout = cat(1,Hout{:});
OutNames = get_param(Hout,'Name');

%---Quick exit if there are no LTI Input/Output Points in the diagram
msgstr=[];
if isempty(Hin) & isempty(Hout),
   msgstr = {'To construct an analysis model, drag and drop the ';
      'Input and Output Point blocks onto the desired input and';
      'output signals in the Simulink diagram.'};

elseif isempty(Hin) 
   msgstr = {'There are no Input Point blocks in the Simulink diagram';
      '';
      'To construct an analysis model, drag and drop Input Point ';
      'blocks onto the desired input signals in the Simulink diagram.'};
   
elseif  isempty(Hout),
   open_system('Model_Inputs_and_Outputs')
   msgstr = {'There are no Output Point blocks in the Simulink diagram';
      '';
      'To construct an analysis model, drag and drop Output Point ';
      'blocks onto the desired output signals in the Simulink diagram.'};
end

if ~isempty(msgstr)
   open_system('Model_Inputs_and_Outputs')
   msgbox(msgstr,'Linearizing Simulink diagrams');
   return
end

%---Otherwise, obtain the linear model of the specified segment of the diagram
try
   [sizes,x0,xNames]=feval(diagram_name,[],[],[],'sizes');
   xNames = LocalCheckStateNames(xNames); % Check for blocks with multiple states
catch
   errordlg(lasterr,'Simulink LTI Viewer Error')
   return
end

%---Get initial states based on mode
udIC = get(findobj(fignum,'Tag','ICmenu'),'UserData');
switch udIC.Mode,
case 1
   x0 = struct('Names',{xNames},...
      'Values',x0);
case 2
   x0 = struct('Names',{xNames},...
      'Values',zeros(size(x0)));
case 3
   [garb,indOld,indNew]=intersect(udIC.States.Names,xNames);
   Newx0 = udIC.States.OperatingConditions(indOld);
   
   %---If new states have appeared prompt the user to re-enter the state values.
   if ~isequal(length(x0),length(Newx0)),
      warndlg({'The states in the Simulink diagram have changed.'; ...
            ''; ...
            'When specifying user-defined state values, all state names in the Simulink'; ...
            'diagram must match those listed in the Set Operating Points window.'; ...
            ''; ...
            'Open the Set Operating Points window to specify values for these'; ...
            'new states.'}, ...
         'Simulink LTI Viewer Warning');
      return
   else
      %---If States have been reorder, or if some states were removed
      % complete the linearization. 
      x0 = struct('Names',{xNames},...
         'Values',Newx0);
   end
   
end % switch udIC.Mode

%---If new controls have appeared or names have changed, warn the user
%   that the old values are being zeroed out, but do the linearization
uNames = LocalGetInportNames(diagram_name,sizes(4));
[garb,indOld,indNew]=intersect(udIC.Controls.Names,uNames);
u0 = zeros(sizes(4),1);
if ~isempty(indOld)
   u0(indNew) = udIC.Controls.OperatingConditions(indOld);
end

if ~isequal(length(u0),length(indOld))
   set(findobj(fignum,'Tag','StatusText'),'String', ...
      ['Inports on the Simulink diagram have changed. These are being set ', ...
      'to zero for linearization']);
end

try
   LinearSys=linsub(diagram_name,Hin,Hout,0,x0,u0);
catch
   LinearSys=[];
end

if isempty(LinearSys), 
   %---Return if the diagram could not be linearized
   err_msg=lasterr;
   warndlg(['The Simulink diagram ''',diagram_name,''' could not be linearized', ...
         'for the current set of Input/Output Points. ', ...
         err_msg],...
      'Simulink LTI Viewer Warning');
   try
      feval(diagram_name,[],[],[],'term'); % Make sure to turn diagram off
   catch
      compileflag=0;
   end
   return
else
   %---Add the names of any LTI Input/OutputPoint blocks to the model
   [numin,numout] = size(LinearSys);
end

% If a Viewer is open, find the systems in the Viewer
%---Find any previous versions of the linearized Simulink diagram
ViewerObj = get(fignum,'UserData');
Systems = get(ViewerObj,'Systems');

if ~isempty(Systems)
   [numinOrig,numoutOrig]=size(Systems{1});
else 
   numinOrig=0;
   numoutOrig=0;
end

if  ~isequal(numin,numinOrig) | ~isequal(numout,numoutOrig),
   %---If the number of inputs/outputs differs between the old and new model,
   %----reinitialize with the new model.
   ltiview('clear',fignum);
   existflag=1;
else
   %---Look for the number of linearized models in the Selected Browser
   UsedNames = get(ViewerObj,'SystemNames');
   UsedNames=char(UsedNames);
   
   if ~isempty(UsedNames),
      StrIndices = UsedNames(:,length(diagram_name)+2:end);
      UsedIndices = zeros(size(StrIndices,1),1);
      for ctR=1:size(StrIndices,1),
         UsedIndices(ctR,1) = str2double(char(StrIndices(ctR,:)));
      end
      if isempty(UsedIndices),
         UsedIndices=0;
      end
   else
      UsedIndices=0;
   end
   existflag = max(UsedIndices)+1; 
   
   %---Assign the Linear System to the next available Simulink diagram name
   
end % if/else ~isequal(numin,numinOrig)...

%---Add the new system to the diagram
eval([diagram_name,'_',num2str(existflag),'=LinearSys;']);
ltiview('current',eval([diagram_name,'_',num2str(existflag)]),fignum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGetInportNames %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function uNames = LocalGetInportNames(diagram_name,numin)

Inports = find_system(diagram_name,'SearchDepth',1,'BlockType','Inport');
feval(diagram_name,[],[],[],'compile');
CPW = get_param(Inports,'CompiledPortWidths');
feval(diagram_name,[],[],[],'term')
uNames = cell(numin,1);
numout=1;
for ct=1:length(Inports)
   uNames(numout:numout+CPW{ct}.Outport-1) = {getfullname(Inports{ct})};
   numout=numout+CPW{ct}.Outport;
end
uNames = uniqname(uNames);


%%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenICFig %%%
%%%%%%%%%%%%%%%%%%%%%%
function a = LocalOpenICFig(ViewerFig,diagram_name);

%---Get last set of state ICs and names
ICmenu = findobj(ViewerFig,'Tag','ICmenu');
ud = get(ICmenu,'UserData');

%---Get the current state ICs and names
[sizes,x0,xNames]=feval(diagram_name,[],[],[],'sizes');
xNames = LocalCheckStateNames(xNames); % Check for blocks with multiple states
numControls = sizes(4);
numStates = length(x0);

Oldx0 = ud.States.OperatingConditions;
OldxNames = ud.States.Names;
Oldu0 = ud.Controls.OperatingConditions;
OlduNames = ud.Controls.Names;

%---Reorder stored state values/names to match current diagram configuration
%   Also zeros out new states, and states with new names
%   Make size of state vector match current diagram configuration
[garb,indOld,indNew]=intersect(OldxNames,xNames);
Allx0 = zeros(size(x0)); 
if ~isempty(indOld)
   Allx0(indNew) = Oldx0(indOld);
end

%---Get new Control Names/Lengths
uNames = LocalGetInportNames(diagram_name,sizes(4));
%---Reorder stored control values/names to match current diagram configuration
%---Reordering occurs when Users type new Port Numbers into the Inport Blocks
%   Also zeros out new control , and control with new names
[garb,indOld,indNew]=intersect(OlduNames,uNames);
ControlVals = zeros(sizes(4),1);
if ~isempty(indOld)
   ControlVals(indNew) = Oldu0(indOld);
end

%---Store any changed state/control order
ud.States.Names = xNames;
ud.States.OperatingConditions = Allx0;
ud.Controls.Names = uNames;
ud.Controls.OperatingConditions = ControlVals;
set(ICmenu,'UserData',ud)

%---Pick the correct states based on the Mode (and set Value box enable)
ValEnable = 'off';
switch ud.Mode
case 1, % Use Simulink diagram states
   ICs = x0;
case 2, % Use zero state values
   ICs = zeros(length(x0),1);
case 3, % Use User-defined state values
   ICs = Allx0;
   ValEnable = 'on';
end

%---Open an IC window of the correct size
ViewerPos = get(ViewerFig,'Position');
StdUnit = 'character';
StdColor = get(0,'DefaultUIcontrolBackgroundColor');

%---Determine figure and frame heights
FigHeight = 16 + 2*max([numControls,numStates]);
StateFrameHeight = 11 + 2*numStates;
ControlFrameHeight = 4 + 2*numControls;

udFig = struct('ParentFigure',ViewerFig,'ParentMenu',ICmenu,...
   'Diagram',diagram_name,'UserDefinedStates',Allx0,...
   'DiagramStates',x0, ...
   'StateNames',{xNames},'Handles',[]);

a = figure('Color',[0.8 0.8 0.8], ...
   'MenuBar','none', ...
   'Name',['Operating Point: ',diagram_name], ...
   'NumberTitle','off', ...
   'IntegerHandle','off',...
   'HandleVis','Callback',...
   'WindowStyle','modal',...   
   'Unit',StdUnit, ...
   'Visible','off',...
   'Color',StdColor, ...
   'Position',[ViewerPos(1:2) 100 FigHeight], ...
   'Tag','InitialConditionFig');

%---Add State Field
b = uicontrol('Parent',a, ...
   'BackgroundColor',StdColor, ...
   'Units',StdUnit, ...
   'Position',[2 FigHeight-StateFrameHeight-1 66 StateFrameHeight], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',[29 FigHeight-2.5 12 2], ...
   'FontWeight','Bold',...
   'String','States', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'BackgroundColor',StdColor, ...
   'Units',StdUnit, ...
   'Position',[3.5 FigHeight-8 63 6.25], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',[5 FigHeight-3.4 20 2], ...
   'FontWeight','Bold',...
   'Horiz','left',...
   'String','Linearize about:', ...
   'Style','text');
RadioStrs={'Initial states in Simulink diagram';
   'Zero state values';
   'User-defined state values'};
RadioVals=zeros(3,1);
RadioVals(ud.Mode)=1;
for ct=1:3,
   udFig.Handles.RadioButton(ct) = uicontrol('Parent',a, ...
      'BackgroundColor',StdColor, ...
      'CallBack','slview(''radiocallback'');', ...
      'Units',StdUnit, ...
      'Position',[5 FigHeight-2.5-ct*1.75 42 1.5], ...
      'String',RadioStrs{ct},...
      'Value',RadioVals(ct), ...
      'Style','radiobutton');
end
set(udFig.Handles.RadioButton(1),'UserData',...
   struct('Mode',1,'Siblings',udFig.Handles.RadioButton(2:3)));
set(udFig.Handles.RadioButton(2),'UserData',...
   struct('Mode',2,'Siblings',udFig.Handles.RadioButton(1:2:3)));
set(udFig.Handles.RadioButton(3),'UserData',...
   struct('Mode',3,'Siblings',udFig.Handles.RadioButton(1:2)));

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',[4 FigHeight-11 10 2], ...
   'FontWeight','Bold',...
   'String','Names', ...
   'Horiz','left',...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...
   'Position',[55 FigHeight-11 10 2], ...
   'String','Value', ...
   'Style','text');

%---Add Control Field
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',[70 FigHeight-ControlFrameHeight-1 28 ControlFrameHeight], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...
   'Position',[79 FigHeight-2.5 10 2], ...
   'String','Inputs', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...
   'Position',[72 FigHeight-4 10 2], ...
   'Horiz','left',...
   'String','Names', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...
   'Position',[85 FigHeight-4 10 2], ...
   'String','Value', ...
   'Style','text');

%---Add window buttons
udFig.Handles.HelpButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',[30 0.5 10 2], ...
   'String','Help', ...
   'Callback',['slview(''statehelp'',''',diagram_name,''');'], ...
   'Tag','HelpButton');
udFig.Handles.ApplyButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',[45 0.5 10 2], ...
   'String','OK', ...
   'Callback',['slview(''stateapply'',''',diagram_name,''');'], ...
   'Tag','ApplyButton');
udFig.Handles.CancelButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',[60 0.5 10 2], ...
   'String','Cancel', ...
   'Callback','close(gcbf)', ...
   'Tag','CancelButton');

%---Add State edit boxes
for ctStates = 1:length(xNames),
   StateName = xNames{ctStates};
   %---Remove newline and carriage returns
   AsciiVals = real(StateName);
   StateName(find(AsciiVals==10 | AsciiVals==13))=' ';
   
   udFig.Handles.StateName(ctStates,1) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',StdColor, ...
      'HorizontalAlignment','left', ...
      'Position',[4 FigHeight-11-(ctStates*2) 50 1.75], ...
      'UserData',StateName,...
      'ToolTip',StateName,...
      'Tag','StateNames', ...
      'Style','text');
   
   if length(StateName)>45;
      indslash = findstr('/',StateName);
      indslash = indslash(find(indslash > (length(StateName)-42) ));
      if isempty(indslash),
         indslash = length(StateName-41);
      end % if isempty(indslash)
      StateName = ['...',StateName(indslash(1)+1:end)];
   end % if length(StateName)
   
   set(udFig.Handles.StateName(ctStates,1),'String',...
      [num2str(ctStates),'. ',StateName]);
      
   udFig.Handles.StateValue(ctStates,1) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[1 1 1], ...
      'CallBack',['slview(''stateedit'',''',diagram_name,''');'],...
      'Position',[55 FigHeight-10.8-(ctStates*2) 10 1.75], ...
      'UserData',Allx0(ctStates), ...
      'Horiz','left', ...
      'String',num2str(ICs(ctStates)), ...
      'Tag','StateValues', ...
      'Enable',ValEnable,...
      'Style','edit');
end, % for ctStates

%---Add Control Edit Boxes
for ctControl = 1:numControls,
   udFig.Handles.ControlName(ctControl,1) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',StdColor, ...
      'HorizontalAlignment','left', ...
      'Position',[72 FigHeight-4.2-(ctControl*2) 13 1.75], ...
      'String',uNames(ctControl), ...
      'Tag','ControlNames', ...
      'Style','text');
   udFig.Handles.ControlValue(ctControl,1) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[1 1 1], ...
      'CallBack',['slview(''stateedit'',''',diagram_name,''');'],...
      'Position',[85 FigHeight-4-(ctControl*2) 10 1.75], ...
      'UserData',ControlVals(ctControl), ...
      'Horiz','left', ...
      'String',num2str(ControlVals(ctControl)), ...
      'Tag','ControlValues', ...
      'Style','edit');
end, % for ctStates

kids = allchild(a);
set(kids,'Unit','Norm');

set(a,'UserData',udFig,'visible','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckStateNames %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xNames = LocalCheckStateNames(xNames);

%---Append numbers to blocks with multiple states
[xTemp,ix,jx] = unique(xNames);
if length(xTemp) < length(xNames),
   for k=1:length(xNames)
      if jx(k) > 0
         kx = find(jx==jx(k));
         if length(kx) > 1 
            for n=1:length(kx)
               xNames{kx(n)} = [xNames{kx(n)} '(' int2str(n) ')'];
            end
            jx(kx) = zeros(size(kx));
         end
      end % if jx(k)>0
   end % for k
end % if length(xTemp)...   
