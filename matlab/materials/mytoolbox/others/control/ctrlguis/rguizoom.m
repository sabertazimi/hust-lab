function out = rguizoom(varargin),
%RGUIZOOM Enable zooming for display axes in the LTI Viewer.
%   RGUIZOOM(H, ACTION) - Applies specified action to figure with
%   handle H.
%   RQUIZOOM(ACTION) or ZOOM ACTION applies specified action to 
%   current figure.
%
%        ACTIONS:
%          'on'     - Enables normal zooming (both x & y directions).
%          'xonly'  - Enables x only zooming.
%          'yonly'  - Enables y only zooming.
%          'off'    - Disables zooming.
%          'state'  - Returns current zoom mode.
%          'out'    - Returns an axis to its original limits.
%
%        GENERAL:
%          ZOOM uses a stack based method in which all ZOOM-ins
%          are stored.  This makes it possible to ZOOM-out to the
%          exact axis limits that were used by each ZOOM-in action.
%
%        SPECIAL ACTIONS:
%          'reset' - Resets zoom by:
%                       a) deleting the stack
%                       b) setting the bottom of the stack (i.e.,
%                          the limits that are used when double
%                          clicking on the figure) to the current
%                          axis limits.
%                    NOTE: 'RESET' requires an axis handle instead of
%                            a figure handle.  If no handle is given,
%                            GCA is used.
%
%        MOUSE OPERATION:
%          ZOOM IN:
%            POINT METHOD - Button #1 on 3, 2 & 1 button mice.
%              Click the mouse on the point of interest.  The new axis
%              limits are centered about the point, and reduced by 0.4.
%
%            BOUNDING BOX METHOD - Button #1 on 3, 2 & 1 button mice.
%              Drag a bounding box around the region of interest.
%              The bounding box defines the new axes limits.
%
%          ZOOM OUT:
%            1 LEVEL - Button # 3 on 3 button mouse.  Button # 2 on
%                      2 Button mice.  <Ctrl-click> on 1 button mice.
%              Zooms out to the previous view in the stack.  If the stack
%              is empty, the view is expanded by 2.5.  The current center
%              point of the axis is maintained.  Note that when the stack
%              is empty, ZOOM will only zoom out as far as the auto axis
%              limits.
%
%            ORIGINAL VIEW - Double click on 3, 2 and 1 button mice.
%              Returns to original view and resets the stack.  The original
%              view refers to the axis limits that were in effect just prior
%              to the first time that the axis was zoomed.
%
%            AXIS AUTO - Button # 2 on 3 button mice.  <Shift-button #1>
%                        on 2 and 1 button mice.
%              Sets the axis limits to auto acording to the current zoom
%              mode (e.g., If the zoomMode is 'xonly', then only the 
%              'XLimMode' of the axis will be set to 'auto').  This allows
%              the entire signal to be viewed.  Note that the auto axis
%              limits are stored in the stack history.
%
%        WHAT AXES DOES ZOOM WORK FOR?
%          ZOOM works for all 2-D axes or 3-D axes that are in a 2-D
%          view.
%
%        Advanced features for GUI programmers that would like to take
%        advantage of zoom are described at the bottom of this file.
%      
%   See also RGUIZFCN
% $Revision: 1.3 $

%   Karen Gondoly 8-6-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   RGUIZOOM is a modification of ZOOM2 written by Howie Taitel

%==============================================================================
% Check # of inputs & outputs.
%==============================================================================

%%%%%%%%%%%%%%
% # of inputs
%%%%%%%%%%%%%%
errmsg = nargchk(0,3,nargin);
if ~isempty(errmsg),
  error(errmsg);
end

%%%%%%%%%%%%%%%
% # of outputs
%%%%%%%%%%%%%%%
errmsg = nargchk(0,1,nargout);
if ~isempty(errmsg),
  error(errmsg);
end

%==============================================================================
% Parse different input argument combinations.
%==============================================================================
bAxes = 0;
advOptions = {
  'addtostack',
  'buttondownfcn',
  'buttonupfcn'
  'zoomofffcn'
  'setgroup'
  'getgroup'
};
advError = 'This action requires 3 input arguments';

switch(nargin),

  case 0,
    %================================================================
    % Toggle (I hacked this in there for backward compat).
    %================================================================
    fig = gcf;
    zoomState = i_ZoomState(fig);
    if ~strcmp(zoomState, 'off'),
      rguizoom off;
    else,
      rguizoom on;
    end

    return;


  case 1,
    %================================================================
    % Only an action was specified.
    %================================================================
    Action = varargin{1};
    if ~isstr(Action),
      error('Action must be a string');
    end
    Action = lower(Action);

    if strcmp(Action, 'reset') | strcmp(Action, 'out'),
      bAxes  = 1;
      handle = gca;
    else,
      handle = gcf;
    end

    switch(Action),
      case advOptions,
        error(advError);
    end

  case 2,
    %================================================================
    % Both a handle and an action were specified.
    %================================================================
    Action = varargin{2};
    if ~isstr(Action),
      error('Action must be a string');
    end
    Action = lower(Action);

    handle = varargin{1};
    if strcmp(Action, 'reset') | strcmp(Action, 'out'),
      bAxes = 1;
    end  

    switch(Action),
      case advOptions,
        error(advError);
    end

  case 3,
    %================================================================
    % Advanced features for GUI programers.  3 args required.  First 
    %   arg is always a handle (either axes or figure).
    %================================================================
    Action = varargin{2};
    if ~isstr(Action),
      error('Action must be a string');
    end
    Action = lower(Action);

    handle = varargin{1};

    switch(Action),

      case 'addtostack',
        bAxes = 1;
      case 'buttondownfcn',
        bAxes = 1;
      case 'buttonupfcn',
        bAxes = 1;
      case 'zoomofffcn',
        bAxes = 1;
      
      case 'setgroup',
      case 'getgroup',

      otherwise, 
         error('Unsupported 3 argument action.');
    end

end

%==============================================================================
% Make sure that we have valid axes and fig handles.
%==============================================================================

%%%%%%%%%%%
% Figure.
%%%%%%%%%%%
if 1 == bAxes,
  bAxesOK = 0;
  hAxes = handle;
  if ( ( ishandle(hAxes) )                    &...
       ( strcmp(get(hAxes, 'Type'), 'axes') )  ...
  ),
    bAxesOK = 1;
  end

  if bAxesOK == 0,
    error('Handle must be a valid axes handle.');
  else,
    fig = get(hAxes, 'Parent');
  end

else,
  bFigureOK = 0;
  fig = handle;
  if ( ( ishandle(fig) )                      &...
       ( strcmp(get(fig, 'Type'), 'figure') )  ...
  ),
    bFigureOK = 1;
  end

  if bFigureOK == 0,
    error('Handle must be a valid figure handle.');
  end

end

%==============================================================================
% Take appropriate action.
%==============================================================================
switch(Action),

  %==================================================================
  % Enable a zoom mode.
  %==================================================================
  case 'on',
    i_SaveOldWinButtonDownIfNeeded(fig);
    zoomMode = 'normal';
    set(fig, 'WindowButtonDownFcn', ['rguizfcn(''butdwn'',''',zoomMode,''');']);

  case 'xonly',
    i_EnableXonlyMode(fig);
  case 'xon',
    i_EnableXonlyMode(fig);  

  case 'yonly',
    i_EnableYonlyMode(fig);
  case 'yon',
    i_EnableYonlyMode(fig);


  %==================================================================
  % Turn zoom off.
  %==================================================================
  case 'off',
    i_zoomOff(fig);


  %==================================================================
  % Get the current zoom state.
  %==================================================================
  case 'state',
    out = i_ZoomState(fig);

  %==================================================================
  % Reset zoom.
  %==================================================================
  case 'reset',

    if ~strcmp(i_ZoomState(fig), 'off'),
      hZoomDataContainer = rguizfcn('findzoomaxisdata', hAxes);

      if ~isempty(hZoomDataContainer),
        zoomUserData = get(hZoomDataContainer, 'UserData');
        zoomStruct = zoomUserData{2};

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Reset stack and orignal view.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        zoomStruct.topOfStack = 0;
        zoomStruct.originalLimits = [get(hAxes, 'XLim'), get(hAxes, 'YLim')];

        zoomUserData(2) = {zoomStruct};
        set(hZoomDataContainer, 'UserData', zoomUserData);
      end
    end

  %==================================================================
  % Zoom out.
  %==================================================================
  case 'out',
    zoomState = i_ZoomState(fig);
    if strcmp(zoomState, 'off'),
      set(hAxes, 'XLimMode', 'auto', 'YLimMode', 'auto');
    else,
      hZoomDataContainer = rguizfcn('findzoomaxisdata', hAxes);
      if ~isempty(hZoomDataContainer),
        rguizfcn('zoomout', hAxes, hZoomDataContainer, zoomState);
      end
    end


  %==================================================================
  % Add limits to stack for given axes.
  %==================================================================
  case 'addtostack',
    rguizfcn('addtostack', hAxes, varargin{3});

  case 'buttondownfcn',
    rguizfcn('register', hAxes, Action, varargin{3});
  case 'buttonupfcn',
    rguizfcn('register', hAxes, Action, varargin{3});
  case 'zoomofffcn',
    rguizfcn('register', hAxes, Action, varargin{3});

  case 'setgroup',
    rguizfcn('setgroup', fig, varargin{3});

  case 'getgroup',
    out = rguizfcn('getgroup', fig);


  otherwise,
    error('Invalid zoom action.');

end %switch


%******************************************************************************
% Function - What is the zoom state?                                        ***
% NOTE: the 'off' state means that either the WindowButtonDownFcn is either ***
%  empy or not set to one of the zoom commands.                             ***
%******************************************************************************
function zoomState = i_ZoomState(fig),

zoomCmd = get(fig, 'WindowButtonDownFcn');
if ( (length(zoomCmd) < 8)               | ...
     (~strcmp(zoomCmd(1:8), 'rguizfcn') )   ...
),
  zoomState = 'off';
else,
  k = max(find(zoomCmd == ' '));
  zoomState = zoomCmd(k+1:end);
end

%******************************************************************************
% Function - Enable Xonly Mode.                                             ***
% Called both for 'xon' and 'xonly'.                                        ***
%******************************************************************************
function i_EnableXonlyMode(fig)

i_SaveOldWinButtonDownIfNeeded(fig);

zoomMode = 'xonly';
set(fig, 'WindowButtonDownFcn', ['rguizfcn(''butdwn'',''',zoomMode,''');']);

%******************************************************************************
% Function - Enable Yonly Mode.                                             ***
% Called both for 'yon' and 'yonly'.                                        ***
%******************************************************************************
function i_EnableYonlyMode(fig)

i_SaveOldWinButtonDownIfNeeded(fig);

zoomMode = 'yonly';
set(fig, 'WindowButtonDownFcn', ['rguizfcn(''butdwn'',''',zoomMode,''');']);


%******************************************************************************
% Function - Save the old windowbuttondownfcn (if needed).                  ***
% We only do this if the zoom state is off, otherwise we would be saving    ***
% one of our zoom buttondownfcn's instead of the users.                     ***
% BTW.  This guarantees that the figure data container get's created when   ***
% zoom is turned on.                                                        ***
%******************************************************************************
function i_SaveOldWinButtonDownIfNeeded(fig),     

if strcmp(i_ZoomState(fig), 'off'),
  zoomUserStruct = rguizfcn('findzoomfigdata', fig);

  if isempty(zoomUserStruct),
    zoomUserStruct = rguizfcn('createfigdata', fig);
  end

  zoomUserStruct.oldWindowButtonDownFcn = get(fig, 'WindowButtonDownFcn');
  setappdata(fig,'TMWzoomAppData', zoomUserStruct);

end

function i_zoomOff(fig),

if strcmp(i_ZoomState(fig), 'off'),
  return;
end

figChildren = get(fig, 'Children');
allAxes     = findobj(figChildren, 'flat', 'Type', 'axes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Destroy our user data from each axis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(allAxes),
  thisAxes = allAxes(i);
  hZoomDataContainer = rguizfcn('findzoomaxisdata', thisAxes);

  if ~isempty(hZoomDataContainer),
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Call the axes 'zoomofffcn'.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    zoomUserData = get(hZoomDataContainer, 'UserData');
    zoomStruct   = zoomUserData{2};
    if ~isempty(zoomStruct.zoomofffcn),
       eval(zoomStruct.zoomofffcn)
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % Delete the zoomData.
    %%%%%%%%%%%%%%%%%%%%%%
    delete(hZoomDataContainer);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Restore the WindowButtonDownFcn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomStruct = rguizfcn('findzoomfigdata', fig);
if ~isempty(zoomStruct),
  set(fig, 'WindowButtonDownFcn', zoomStruct.oldWindowButtonDownFcn);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Destroy our user data from the figure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmappdata(fig,'TMWzoomAppData');


% ******************INFORMATION************************************************
%1) ZOOM is done on a figure basis instead of the axes basis because the 
%   default behavior for new plot commands is to destroy the current axes
%   and create a new one.  This makes it difficult to maintain information
%   between calls to plot.  The algorithm employed here is to find an axes
%   associated with a buttondown event.  If that axes is in a 2-D view & does
%   not have a ZLABEL user data set to NaN, then zoom it.
%
%2) ZOOM needs to maintain a data structure in order to function.  For
%   this purpose a line object with a hidden handle is created on the 
%   first buttondown action for each axes.  
%
%3) ZOOM uses the 'WindowButtonDownFcn', the 'WindowButtonUpFcn', and the 
%   'WindowButtonMotionFcn' of the figure.  The 'WindowButtonDownFcn' sets
%   the 'WindowButtonMotionFcn' and the 'WindowButtonUpFcn'.  The
%   'WindowButtonUpFcn' unsets the 'WindowButtonMotionFcn' and itself.
%   As such, ZOOM only needs acces to the UpFcn and the MotionFcn during
%   actual zooming, but the 'WindowButtonDownFcn' is necessary for the 
%   duration (i.e., as long as ZOOM is active, the 'WindowButtonDownFcn'
%   must be set).
%
%4) DATA STRUCTURE:
%   See function i_CreateZoomData in RGUIZFCN.M.
%
%5) See the RGUIZFCN.M file.
%
%6) Pushing limits onto the stack. 
%     This functionality was added to aid gui designers that may
%     offer more than 1 way of controlling the axes.  For instance
%     zooming or typing limits into an edit field.  If it is desired
%     to have zoom keep track of changes in axes limits that take place
%     from the edit controls, then the gui programmer must have a method
%     of adding to the stack.
%
%     Note that the proper method of doing this is to push the current
%     limits onto the stack BEFORE changing the limits!
%
%     'addtostack' - Add an axis limit to the stack history.  The
%                    only valid syntax for this action is:
%                    ZOOM(HAXES, 'ADDTOSTACK', LIMITS), where LIMITS
%                    is of the form: [Xmin Xmax Ymin Ymax].
%
%                    NOTE: ADDTOSTACK require an axis handle instead of
%                    a figure handle.  If zoom is not active, no action
%                    is taken.  If there is no stack, one is created.
%
%7) SUPRRESSING ZOOM
%          To suppress zoom for a given axes set it's ZLABELS user data
%          to NaN.  This may be useful if axes are used in non-standard
%          ways such as background's for GUI's.
%
%8) Callbacks
%  It is sometimes useful to be notified of certain actions in zoom.  For
%  instance to update an edit control whos display is of the axes limits,
%  we need to know that zoom action has occurred.  There are currently
%  3 callbacks that may be registered.
%    'buttondownfcn' - called when the button down event occurs
%    'buttonupfcn'   - called when the button up event occurs
%    'zoomofffcn'    - called when zoom is turned off
%
%  The callbacks are called in addition to the normal operation of zoom.
%  They are meant mainly as a method of notification.  It may be dangerous
%  to use the buttondownfcn.  If your buttondownfcn sets the windowbuttonupfcn
%  or the windowbuttonmotionfcn there will definately be conflicts with ZOOM.
%
% The callback should be the name of a function.  ZOOM will call this function
%  with 2 arguments:
%    1) the identifier string: 'zoombuttondown', 'zoombuttonup', or 'zoomoff'
%    2) the handle to the axes that was just zoomed.
%
% The syntax to register a callback function is:
% ZOOM(HAXES, 'functiontype', 'function'), where functiontype is one of:
%  buttondownfcn, buttonupfcn, or zoomofffcn;
%
%9) Axes groups.
% Linked axes provides a method of automatically applying the zoomed limits
% of a given axes to one or more other axes.  There are 2 types of groups:
%   a) ListGroup - Assume that the srcAxes (the one clicked in) is in a
%        given group.  Each handle in that group gets the axis limits set to
%        identical axis limits as the srcAxes.
%   b) GridGroup - Assume that the srcAxes (the one clicked in) is in a 
%        given group.  Here the axes group must be defined as matrix.  Each
%        handle in the same column as the srcAxes gets it's XLims set to
%        the same XLims as the srcAxes.  Each handle in the same row as the
%        srcAxes gets its YLims set to the same YLims as the srcAxes.
%
%  Axes groups are specified as a cell array.  Each cell represents a group.
%  A group itself is defined as a cell of length 2.  The first is a text flag
%  identifying the group type and the 2nd is a vector or matrix of axes handles.
%
%  groups = { {'ListGroup', [hax1 hax2]} } defines a list group.
%  groups = { ('ListGroup', [hax1 hax2]}, {'GridGroup', [hax3 hax4;hax5 hax6]} }
%    defines both a ListGroup and a GridGroup.
%
% The syntax to define Groups for a given figure is:
%   zoom(hfig, 'setgroup', groups);
% The syntax to retrieve the current groups is:
%   groups = zoom(hfig, 'getgroup', []);
%
% NOTE: ZOOM assumes that the handles defining the groups are valid axes handles.
%       ZOOM MUST be active setting groups.
%
