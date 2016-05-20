function varargout = rguizfcn(guiAction, varargin),
%RGUIZFCN - GUI interface for zoom function
%    Handles buttondown, buttonup and buttonmotion functions for 
%    RGUIZOOM.
%
%   See also RGUIZOOM
% $Revision: 1.4 $

%   Karen Gondoly 8-6-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   RGUIZFCN is a modification of ZOOMTMW written by Howie Taitel

%==============================================================================
% Event switchyard.
%==============================================================================
switch guiAction,

  case 'butmot',
    %================================================================
    % Put button motion fcn first, as it gets called iteratively.
    %================================================================
    zoomMode = varargin{1};
    i_ZoomButtonMotionFcn(gcf, zoomMode);

  case 'butdwn',
    %================================================================
    % Button down fcn 2nd.  We want fast response here too.
    %================================================================
    if strcmp(get(gca,'Tag'),'LTIdisplayAxes');
      zoomMode = varargin{1};
      i_ZoomButtonDownFcn(gcf, zoomMode);
    end

  case 'butup',
    %================================================================
    % Zoom button up fcn for case of zoomin in.
    %================================================================
    zoomMode = varargin{1};
    i_ZoomButtonUpFcn(gcf, zoomMode);
    rguizoom(gcf,'off');
    %--Turn ButtonDownFcn on response plots back on
    %lines=findobj(gcf,'Tag','RespLine');
    %set(lines,'ButtonDownFcn','rguifcn(''showbox'');');
    %set(gcf,'Pointer','arrow');

  case 'butupOut',
    %================================================================
    % Zoom button up fcn for case of zooming out.
    %================================================================
    zoomMode = varargin{1};
    i_ZoomButtonUpOutFcn(gcf, zoomMode);


  case 'findzoomaxisdata',
    %================================================================
    % Public access to i_FindZoomAxisData.
    %================================================================
    hAx = varargin{1};
    varargout = {i_FindZoomAxisData(hAx)};

  case 'findzoomfigdata',
    %================================================================
    % Public access to i_FindZoomFigureData.
    %================================================================
    fig = varargin{1};
    varargout = {i_FindZoomFigureData(fig)};


  case 'addtostack',
    %================================================================
    % Public access to i_PushLimitsOntoStack.
    %================================================================
    hAx = varargin{1};
    limits = varargin{2};
    i_PushLimitsOntoStack(hAx, limits)

  case 'register',
    %================================================================
    % Public access to i_RegisterButtonFcn.
    %================================================================
    hAx    = varargin{1};
    action = varargin{2};
    fcn    = varargin{3};
    i_RegisterButtonFcn(hAx, action, fcn)

  case 'setgroup',
    fig = varargin{1};
    group = varargin{2};
    i_SetAxesGroup(fig, group);

  case 'getgroup',
    fig = varargin{1};
    zoomFigUserData = i_FindZoomFigureData(fig);
    if isempty(zoomFigUserData),
      varargout = { {} };
      return;
    end
    varargout = {zoomFigUserData.AxesGroups};

  case 'createfigdata',
    fig = varargin{1};
    zoomUserStruct = i_CreateZoomFigureData(fig);
    varargout = {zoomUserStruct};

  case 'zoomout',
    ax = varargin{1};
    hZoomDataContainer = varargin{2};
    zoomMode = varargin{3};
    i_ZoomToOriginalView(ax, hZoomDataContainer, zoomMode);

    % Since we are doing this programmatically, we must manually
    %  clear the button up fcn (usually done as part of the button
    %  up event.
    
    zoomUserData = get(hZoomDataContainer, 'UserData');
    zoomStruct = zoomUserData{2};
    fig = get(ax, 'Parent');
    set(fig, 'WindowButtonUpFcn', zoomStruct.oldWindowButtonUpFcn);
    
  otherwise,
    error('Invalid GUI action (guiAction) specified.');
end


%******************************************************************************
% Function - Button down function for zoom.                                 ***
%******************************************************************************
function i_ZoomButtonDownFcn(fig, zoomMode),

%============================================================================== 
% Find axis under the current point.
% NOTE: The i_FindAxisUnderCurrentPoint function has the side affect of
%   creating the ZoomUserData structure if one does not exist for the 
%   found axis.  The axis under the point is returned (or [] if not found),
%   as well as the handle to the container object for the zoom data.
%============================================================================== 
[ax, hZoomDataContainer] = i_FindAxisUnderCurrentPoint(fig);

if ~isempty(ax),

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Based on the type of buttonpress, zoom in or out.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  switch(GetSelectionType(fig, hZoomDataContainer)),
  
    case 'normal',
      %%%%%%%%%%%%%%%%%%%%%%%%
      % Zoom in (left click).
      %%%%%%%%%%%%%%%%%%%%%%%%
      i_ZoomIn(ax, hZoomDataContainer, zoomMode);

    case 'alt',
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Zoom out one stack level (right click).
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      %---Have to comment out right-click zoom when using Context Menus
      %i_ZoomOut1Level(ax, hZoomDataContainer, zoomMode);

    case 'open',
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Zoom all the way out to the bottom of the stack.
      %  (double click).
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      i_ZoomToOriginalView(ax, hZoomDataContainer, zoomMode);

    case 'extend',
      %%%%%%%%%%%%%%%%%%%%%%
      % Set limits to auto.
      %%%%%%%%%%%%%%%%%%%%%%
      i_ZoomAutoLimits(ax, hZoomDataContainer, zoomMode);

  end

  %============================================================================
  % Call the users buttondown callback.
  %============================================================================
  %zoomUserData = get(hZoomDataContainer, 'UserData');
  %zoomStruct = zoomUserData{2};

  %if ~isempty(zoomStruct.buttondownfcn),
  %  feval(zoomStruct.buttondownfcn, 'zoombuttondown', ax);
  %end

end


%****************************************************************************** 
% Function - Get selection type subject to constraint that                  ***
% double clicks only return open if they are the result of                  ***
% left clicks.                                                              ***
%****************************************************************************** 
function SelectionType = GetSelectionType(fig, hZoomDataContainer),

%==============================================================================
% Initialize.
%==============================================================================
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct = zoomUserData{2};

%==============================================================================
% Constrain 'open' to left mouse button.
%==============================================================================
SelectionType = get(fig, 'SelectionType');

if ( (strcmp(SelectionType, 'open'))              & ...
     (strcmp(zoomStruct.oldSelectionType, 'alt'))   ...
),
  SelectionType = 'alt';
end

%==============================================================================
% Update user data.
%==============================================================================
zoomStruct.oldSelectionType = SelectionType;
zoomUserData{2} = zoomStruct;
set(hZoomDataContainer, 'UserData', zoomUserData);




%****************************************************************************** 
% Function - Find axes under the current point.  The axes must meet the     ***
%  the following criteria:                                                  ***
%    a) ZLabel userdata cannot be NaN                                       ***
%      - this allows a mechanism for suppressing zoom                       ***
%    b) The axis must currently be in 2-D view                              ***
%                                                                           ***
% The zoom user data is created if it does not already exist.               ***
%                                                                           ***
% OUTPUT:                                                                   ***
%  ax - handle of axes or [] if none found                                  ***
%  hzoomDataContainer - handle to container for zoom data.                  ***
%                                                                           ***
% NOTE: NO attempt is made to deal w/ overlapping axes.  In this case,      ***
%        the first axes found will be returned.                             ***
%****************************************************************************** 
function [ax, hZoomDataContainer] = i_FindAxisUnderCurrentPoint(fig)

%==============================================================================
% Initialize.
%==============================================================================
figChildren = get(fig, 'Children');
allAxes     = findobj(figChildren, 'flat', 'Type', 'axes','Visible','on');

ax = [];
hZoomDataContainer = [];

%==============================================================================
% Search all axes until find one that falls under current point.  If the
%  zoomUserData does not yet exist, create it.
%
% NOTE: This is done via the axes current point function.  Each axes returns
%       the current point in it's own data units (whether it falls w/in the 
%       axes or not!).  If the current point of a given axes falls w/in it's
%       x and y data, then it is underneath the current point.
%==============================================================================
for i = 1:length(allAxes),
  %============================================================================
  % Initialize this axes.
  %============================================================================
  
  %%%%%%%%%%%%%%%
  % Axis handle.
  %%%%%%%%%%%%%%%
  thisAx = allAxes(i);
  
  %%%%%%%%%%%%%%%%%
  % Current point.
  %%%%%%%%%%%%%%%%%
  thisAxCp  = get(thisAx,'CurrentPoint');
  thisAxXcp = thisAxCp(1,1);
  thisAxYcp = thisAxCp(1,2);

  %============================================================================
  % Make sure that someone is not asking to supress zoom on this axis.
  %============================================================================
  bValidZoomAxes = 0;

  hZLabel = get(thisAx, 'ZLabel');
  ZLabelUserData = get(hZLabel, 'UserData');
  
  if isempty(ZLabelUserData) | ~isnan(ZLabelUserData),
    bValidZoomAxes = 1;
  end
  
  %============================================================================
  % As long as the axes is valid, see if it's under the current point & meets
  %  all criteria.
  %============================================================================
  if bValidZoomAxes == 1,
    XLim = get(thisAx, 'XLim');
    YLim = get(thisAx, 'YLim');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Is this axes under the current point?
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ( ( (XLim(1) <= thisAxXcp) & (thisAxXcp <= XLim(2)) )  &...
         ( (YLim(1) <= thisAxYcp) & (thisAxYcp <= YLim(2)) )   ...
       ),
      
      %%%%%%%%%%%%%%%%%%%%%%
      % Is it in a 2D view?
      %%%%%%%%%%%%%%%%%%%%%%
      if ~i_Is2DAxes(thisAx),
        warning('Zoom does not work for axes in a 3D view.');
        return;
      end
     
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % If necessary, create zoomData.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      hZoomDataContainer = i_FindZoomAxisData(thisAx);
      if isempty(hZoomDataContainer),
        [zoomUserData, hZoomDataContainer] = i_CreateZoomAxisData(thisAx);
      end

  zoomUserData = get(hZoomDataContainer, 'UserData');
  zoomStruct = zoomUserData{2};
  if ~isempty(zoomStruct.buttondownfcn),
    feval(zoomStruct.buttondownfcn, 'zoombuttondown', thisAx);
  end


      %%%%%%%%%%%%%%%%%%%%
      % Return this axis.
      %%%%%%%%%%%%%%%%%%%%
      ax = thisAx;
      return;
 
    end % end if ...XLim(1) ...
  
  end % end if bValidZoomAxes

end %for


%******************************************************************************
% Function - Determines if an axes is in a 2-D view.                        ***
%******************************************************************************
function b2D = i_Is2DAxes(hax),

%==============================================================================
% Initialize.
%==============================================================================
View = get(hax, 'View');

%==============================================================================
% To be 2D or not to be 3D, that is the question.
%==============================================================================
if all(rem(View, 90) == 0),
  b2D = 1;
else,
  b2D = 0;
end


%******************************************************************************
% Function - Create user data for zoom.  It is stored in an invisible line  ***
%   object with a hidden handle.  The tag of the line object is:            ***
%   "@#$TMWzoom".  To retrieve the handle set show hidden handles to        ***
%   yes and use findobj.  Remember text objects are children of axes.       ***
%******************************************************************************
function [zoomUserData, hZoomDataContainer] = i_CreateZoomAxisData(hAx),

%==============================================================================
% Create zoomStruct.
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Axis stack - initialize to 40 levels.
%  Each row contains 4 #'s:  [xmin xmax ymin ymax]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.stack = zeros(40, 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Index of current top of stack.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.topOfStack = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handles to lines for rbbox.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.hLines = zeros(4,1) - 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Keep a copy of the original axis settings.
%  This way we'll have access to them, even
%  if the stack is empty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.originalLimits = [get(hAx, 'XLim'), get(hAx, 'YLim')];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create fields for callbacks.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.buttondownfcn = '';
zoomUserStruct.buttonupfcn   = '';
zoomUserStruct.zoomofffcn    = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create fields for storing old buttonmotionfcn
%  and buttonupfcn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.oldWindowButtonMotionFcn = '';
zoomUserStruct.oldWindowButtonUpFcn = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create fields for previous selection type.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.oldSelectionType = 'blah';


%==============================================================================
% Create the ZoomData.
%==============================================================================
zoomUserData = {'_TMWZoomData', zoomUserStruct};

%==============================================================================
% Create text object to serve as container for this data.
%==============================================================================

%
% hack to get around geck 12322 (flash when adding invis line/text object)
%  to axes.  I should be able to forget about all these defaults and just
%  explicitly parent the thing!!
%

fig = get(hAx, 'Parent');
ShowHiddenHandles = get(0, 'ShowHiddenHandles');
CurrentFigure = get(0, 'CurrentFigure');
CurrentAxes = get(fig, 'CurrentAxes');

set(0, 'ShowHiddenHandles', 'on', 'CurrentFigure', fig);
set(fig, 'CurrentAxes', hAx);

hZoomDataContainer = text( ...
  'Visible',            'off',...
  'EraseMode',          'none',...
  'HandleVisibility',       'off',...
  'Tag',                '@#$TMWzoom'...
);

set(0, 'ShowHiddenHandles', ShowHiddenHandles, 'CurrentFigure', CurrentFigure);
set(fig, 'CurrentAxes', CurrentAxes);


%==============================================================================
% Assign the zoom data to the container.
%==============================================================================
set(hZoomDataContainer, 'UserData', zoomUserData);


%******************************************************************************
% Function - Find container for axis user data.  Returns [] if not found.   ***
%******************************************************************************
function hZoomDataContainer = i_FindZoomAxisData(hAx),

%==============================================================================
% Initialize.
%==============================================================================
ShowHiddenHandles = get(0, 'ShowHiddenHandles');
set(0, 'ShowHiddenHandles', 'on');

%==============================================================================
% Find the zoomUserData.
%==============================================================================
hZoomDataContainer = findobj(hAx, ...
  'Tag',                '@#$TMWzoom',...
  'Type',               'text'...
);

%==============================================================================
% Restore hidden handle setting.
%==============================================================================
set(0, 'ShowHiddenHandles', ShowHiddenHandles);


%******************************************************************************
% Function - Create figure level user data for zoom.  It is stored in the   ***
% Figure's Application Data with the tag TMWzoomAppData.                    ***
% Use GETAPPDATA(gcf,'TMWzoomAppData') to retrieve it.                      ***
%******************************************************************************
function zoomUserStruct = i_CreateZoomFigureData(fig),

%==============================================================================
% Create zoomStruct.
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old windowbuttondownfcn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.oldWindowButtonDownFcn = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Axes group cell array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserStruct.AxesGroups = {};

%==============================================================================
% Create Application Data to serve as container for this data.
%==============================================================================
setappdata(fig,'TMWzoomAppData',zoomUserStruct)

%******************************************************************************
% Function - Find container for figure user data.  Returns [] if not found. ***
%******************************************************************************
function hZoomFigureData = i_FindZoomFigureData(fig),

%==============================================================================
% Find the zoomUserData.
%==============================================================================
hZoomFigureData = getappdata(fig,'TMWzoomAppData');

%******************************************************************************
% Function - Button motion function for zoom.                               ***
%******************************************************************************
function i_ZoomButtonMotionFcn(gcf, zoomMode),

%==============================================================================
% Initialize
%==============================================================================
hZoomDataContainer = i_FindZoomAxisData(gca);
if isempty(hZoomDataContainer),
  error('Zoom user data not found.  This should never happen!');
end
zoomUserData   = get(hZoomDataContainer, 'UserData');
zoomUserStruct = zoomUserData{2};
  
hLines = zoomUserStruct.hLines;

cp = get(gca, 'CurrentPoint'); cp = cp(1,1:2);
xcp = cp(1);
ycp = cp(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first point of line 1 is always the zoom origin.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XDat   = get(hLines(1), 'XDat');
YDat   = get(hLines(1), 'YDat');
origen = [XDat(1), YDat(1)];


%==============================================================================
% Draw rbbox depending on mode.
%==============================================================================
switch(zoomMode),

  case 'normal',
    %================================================================
    % Both x and y zoom.
    % RBBOX - lines:
    % 
    %          2
    %    o-------------
    %    |            |
    %  1 |            | 4
    %    |            |
    %    --------------
    %          3
    %================================================================

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 1.
    %%%%%%%%%%%%%%%%%%%%%%%
    YDat = get(hLines(1), 'YDat');
    YDat(2) = ycp;
    set(hLines(1),'YDat',YDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 1.
    %%%%%%%%%%%%%%%%%%%%%%%
    XDat = get(hLines(2),'XDat');
    XDat(2) = xcp;
    set(hLines(2),'XDat',XDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 3.
    %%%%%%%%%%%%%%%%%%%%%%%
    XDat = get(hLines(3),'XDat');
    YDat = [ycp ycp];
    XDat(2) = xcp;
    set(hLines(3),'XDat',XDat,'YDat',YDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 4.
    %%%%%%%%%%%%%%%%%%%%%%%
    YDat = get(hLines(4), 'YDat');
    XDat = [xcp xcp];
    YDat(2) = ycp;
    set(hLines(4),'XDat',XDat,'YDat',YDat);

  case 'xonly',
    %================================================================
    % x only zoom.
    % RBBOX - lines (only 1-3 used):
    %   
    %    |     1      |
    %  2 o------------| 3 
    %    |            |
    %             
    %================================================================
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set the end bracket lengths (actually the halfLength).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    YLim = get(gca, 'YLim');
    endHalfLength = (YLim(2) - YLim(1)) / 20;

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 1.
    %%%%%%%%%%%%%%%%%%%%%%%
    XDat = get(hLines(1),'XDat');
    XDat(2) = xcp;
    set(hLines(1),'XDat',XDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 2.
    %%%%%%%%%%%%%%%%%%%%%%%
    YDat = [origen(2) - endHalfLength, origen(2) + endHalfLength];
    set(hLines(2), 'YDat', YDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 3.
    %%%%%%%%%%%%%%%%%%%%%%%
    XDat = [xcp xcp];
    YDat = [origen(2) - endHalfLength, origen(2) + endHalfLength];
    set(hLines(3), 'XDat', XDat, 'YDat', YDat);

  case 'yonly',
    %================================================================
    % y only zoom.
    % RBBOX - lines (only 1-3 used):
    %    2
    %  --o--  
    %    |
    %  1 |
    %    |
    %  -----           
    %    3
    %================================================================

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set the end bracket lengths (actually the halfLength).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XLim = get(gca, 'XLim');
    endHalfLength = (XLim(2) - XLim(1)) / 35;

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 1.
    %%%%%%%%%%%%%%%%%%%%%%%
    YDat = get(hLines(1),'YDat');
    YDat(2) = ycp;
    set(hLines(1),'YDat',YDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 2.
    %%%%%%%%%%%%%%%%%%%%%%%
    XDat = [origen(1) - endHalfLength, origen(1) + endHalfLength];
    set(hLines(2), 'XDat', XDat);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Set data for line 3.
    %%%%%%%%%%%%%%%%%%%%%%%
    YDat = [ycp ycp];
    XDat = [origen(1) - endHalfLength, origen(1) + endHalfLength];
    set(hLines(3), 'XDat', XDat, 'YDat', YDat);

end


%******************************************************************************
% Function - Button up function for zoom.                                   ***
%******************************************************************************
function i_ZoomButtonUpFcn(gcf, zoomMode),

%==============================================================================
% Initialize
%==============================================================================
hZoomDataContainer = i_FindZoomAxisData(gca);
if isempty(hZoomDataContainer),
  error('Zoom user data not found.  This should never happen!');
end
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct   = zoomUserData{2};

hLines = zoomStruct.hLines;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first point of line 1 is always the zoom origen.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XDat   = get(hLines(1), 'XDat');
YDat   = get(hLines(1), 'YDat');
origen = [XDat(1), YDat(1)];

%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the current limits.
%%%%%%%%%%%%%%%%%%%%%%%%%
currentXLim = get(gca, 'XLim');
currentYLim = get(gca, 'YLim');

%==============================================================================
% Perform zoom operation based on zoom mode.
%==============================================================================
switch(zoomMode),

  case 'normal',
    %================================================================
    % Both x and y zoom.
    % RBBOX - lines:
    % 
    %          2
    %    o-------------
    %    |            |
    %  1 |            | 4
    %    |            |
    %    --------------
    %          3
    %================================================================

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the end point of zoom operation.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %
    % Get current point.
    %
    cp = get(gca, 'CurrentPoint'); cp = cp(1,1:2);
    xcp = cp(1);
    ycp = cp(2);

    %
    % Clip to current axes.
    %
    if xcp > currentXLim(2),
      xcp = currentXLim(2);
    end
    if xcp < currentXLim(1),
      xcp = currentXLim(1);
    end
    if ycp > currentYLim(2),
      ycp = currentYLim(2);
    end
    if ycp < currentYLim(1),
      ycp = currentYLim(1);
    end

    endPt = [xcp ycp];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the Xlimits mode: POINT or RBBOX.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bPointMode = 0;
    if origen(1) == endPt(1),
      bPointMode = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the new X-Limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (bPointMode == 0),
      %%%%%%%%%%%%%%%%%%%%
      % Bounding Box Mode.
      %%%%%%%%%%%%%%%%%%%%

      XLim = [origen(1) endPt(1)];
      if XLim(1) > XLim(2),
        XLim = XLim([2 1]);
      end

    else,
      %%%%%%%%%%%%%%%%%%%%
      % Point Mode.
      %%%%%%%%%%%%%%%%%%%%
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Divide the horizontal into 5 divisions.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      XLim = get(gca, 'XLim'); XDiff = (XLim(2) - XLim(1)) / 5;
      if strcmp(get(gca, 'XScale'), 'log'),
        % XLim(1) must be >= 1;

        candidateXMin = xcp - XDiff;
        if candidateXMin < 1,
          xmin  = 1;
          delta = 1 - candidateXMin;
          xmax  = xcp + XDiff + delta;
        else,
          xmin = xcp - XDiff;
          xmax = xcp + XDiff;
        end

        XLim = [xmin xmax];

      else,
        XLim = [xcp - XDiff, xcp + XDiff];
      end

    end  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set new Xlimits.
    % NOTE: Check that the limits aren't equal.  This happens
    %   at very small limits.  In this case, we do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if XLim(1) ~= XLim(2),
      set(gca, 'XLim', XLim);
    else,
      warning('Axis limits cannot be zoomed any further!');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the Ylimits mode: POINT or RBBOX.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bPointMode = 0;
    if origen(2) == endPt(2),
      bPointMode = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the new Y-Limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (bPointMode == 0),
      %%%%%%%%%%%%%%%%%%%%
      % Bounding Box Mode.
      %%%%%%%%%%%%%%%%%%%%

      YLim = [origen(2) endPt(2)];
      if YLim(1) > YLim(2),
        YLim = YLim([2 1]);
      end

    else,
      %%%%%%%%%%%%%%%%%%%%
      % Point Mode.
      %%%%%%%%%%%%%%%%%%%%

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Divide the vertical into 5 divisions.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      YLim = get(gca, 'YLim'); YDiff = (YLim(2) - YLim(1)) / 5;
      if strcmp(get(gca, 'YScale'), 'log'),
        % YLim(1) must be >= 1

        candidateYMin = ycp - YDiff;
        if candidateYMin < 1,
          ymin = 1;
          delta = 1 - candidateYMin;
          ymax = ycp + YDiff + delta;
        else,
          ymin = ycp - YDiff;
          ymax = ycp + YDiff;
        end

        YLim = [ymin ymax];

      else,  
        YLim = [ycp - YDiff, ycp + YDiff];
      end

    end  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set new Ylimits.
    % NOTE: Check that the limits aren't equal.  This happens
    %   at very small limits.  In this case, we do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if YLim(1) ~= YLim(2),
      set(gca, 'YLim', YLim);
    else,
      warning('Axis limits cannot be zoomed any further!');
    end
 
  case 'xonly',
    %================================================================
    % x only zoom.
    % RBBOX - lines (only 1-3 used):
    %   
    %    |     1      |
    %  2 o------------| 3 
    %    |            |
    %             
    %================================================================

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the end point of zoom operation.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %
    % End pt is the 2nd point of line 1.
    %
    XDat = get(hLines(1), 'XDat');
    xcp = XDat(2);

    %
    % Clip to current axes.
    %
    if xcp > currentXLim(2),
      xcp = currentXLim(2);
    end
    if xcp < currentXLim(1),
      xcp = currentXLim(1);
    end

    endPt = [xcp origen(2)];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine mode: POINT or RBBOX.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if xcp == origen(1),
      bPointMode = 1;
    else,
      bPointMode = 0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the new limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (bPointMode == 0),
      %%%%%%%%%%%%%%%%%%%%
      % Bounding Box Mode.
      %%%%%%%%%%%%%%%%%%%%

      %%%%%%%%%%%%%%%%%%%%%%%%%%
      % Calculate new X Limits
      %%%%%%%%%%%%%%%%%%%%%%%%%%
      XLim = [origen(1) endPt(1)];
      if XLim(1) > XLim(2),
        XLim = XLim([2 1]);
      end

    else,
      %%%%%%%%%%%%%%%%%%%%
      % Point Mode.
      %%%%%%%%%%%%%%%%%%%%

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Divide the horizontal into 5 divisions.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      XLim = get(gca, 'XLim'); XDiff = (XLim(2) - XLim(1)) / 5;
      if strcmp(get(gca, 'XScale'), 'log'),
        % XLim(1) must be >= 1;

        candidateXMin = xcp - XDiff;
        if candidateXMin < 1,
          xmin  = 1;
          delta = 1 - candidateXMin;
          xmax  = xcp + XDiff + delta;
        else,
          xmin = xcp - XDiff;
          xmax = xcp + XDiff;
        end

        XLim = [xmin xmax];

      else,
        XLim = [xcp - XDiff, xcp + XDiff];
      end
    
    end  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set new Xlimits.
    % NOTE: Check that the limits aren't equal.  This happens
    %   at very small limits.  In this case, we do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if XLim(1) ~= XLim(2),
      set(gca, 'XLim', XLim);
    else,
      warning('Axis limits cannot be zoomed any further!');
    end


  case 'yonly',
    %================================================================
    % y only zoom.
    % RBBOX - lines (only 1-3 used):
    %    2
    %  --o--  
    %    |
    %  1 |
    %    |
    %  -----           
    %    3
    %================================================================

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the end point of zoom operation.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %
    % End pt is the 2nd point of line 1.
    %
    YDat = get(hLines(1), 'YDat');
    ycp = YDat(2);

    %
    % Clip to current axes.
    %
    if ycp > currentYLim(2),
      ycp = currentYLim(2);
    end
    if ycp < currentYLim(1),
      ycp = currentYLim(1);
    end

    endPt = [origen(1) ycp];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine mode: POINT or RBBOX.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ycp == origen(2),
      bPointMode = 1;
    else,
      bPointMode = 0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the new limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (bPointMode == 0),
      %%%%%%%%%%%%%%%%%%%%
      % Bounding Box Mode.
      %%%%%%%%%%%%%%%%%%%%

      %%%%%%%%%%%%%%%%%%%%%%%%%%
      % Calculate new Y Limits
      %%%%%%%%%%%%%%%%%%%%%%%%%%
      YLim = [endPt(2) origen(2)];
      if YLim(1) > YLim(2),
        YLim = YLim([2 1]);
      end

    else,
      %%%%%%%%%%%%%%%%%%%%
      % Point Mode.
      %%%%%%%%%%%%%%%%%%%%

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Divide the vertical into 5 divisions.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      YLim = get(gca, 'YLim'); YDiff = (YLim(2) - YLim(1)) / 5;
      if strcmp(get(gca, 'YScale'), 'log'),
        % YLim(1) must be >= 1

        candidateYMin = ycp - YDiff;
        if candidateYMin < 1,
          ymin = 1;
          delta = 1 - candidateYMin;
          ymax = ycp + YDiff + delta;
        else,
          ymin = ycp - YDiff;
          ymax = ycp + YDiff;
        end

        YLim = [ymin ymax];

      else,  
        YLim = [ycp - YDiff, ycp + YDiff];
      end

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set new Ylimits.
    % NOTE: Check that the limits aren't equal.  This happens
    %   at very small limits.  In this case, we do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if YLim(1) ~= YLim(2),
      set(gca, 'YLim', YLim);
    else,
      warning('Axis limits cannot be zoomed any further!');
    end

end %switch

%============================================================================
% Call the users buttonup callback.
%============================================================================
if ~isempty(zoomStruct.buttonupfcn),  
  feval(zoomStruct.buttonupfcn, 'zoombuttonup', gca);
end

%==============================================================================
% Push old limits onto stack.
%==============================================================================
limits = [currentXLim currentYLim];
i_FastPushLimitsOntoStack(hZoomDataContainer, limits);

%==============================================================================
% Delete the RBBOX lines.
%==============================================================================
delete(hLines);

%==============================================================================
% Restore motion & up functions.
%==============================================================================
set(gcf,'windowbuttonmotionfcn', zoomStruct.oldWindowButtonMotionFcn);
set(gcf,'windowbuttonupfcn', zoomStruct.oldWindowButtonUpFcn);

%==============================================================================
% Update links.
%==============================================================================
i_UpdateLinks(gca, zoomMode);


%******************************************************************************
% Function - Handle the zoom in actions.                                    ***
%******************************************************************************
function i_ZoomIn(ax, hZoomDataContainer, zoomMode)


%============================================================================
% Create the lines used for the rbbox.
% NOTE: All lines are initialize to contain 2 pts where both points
%       are located at the current point (i.e., zoom origen).
%============================================================================
cp = get(ax, 'CurrentPoint'); cp = cp(1,1:2);
x  = ones(2,4) * cp(1);
y  = ones(2,4) * cp(2);

hLines = line(x,y, ...
  'Visible',          'on',...
  'EraseMode',        'xor',...
  'Color',            [0.5 0.5 0.5],...
  'Tag',              '_TMWZoomLines'...
);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store the handles to the lines in the userdata.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomUserData   = get(hZoomDataContainer, 'UserData');
zoomUserStruct = zoomUserData{2};

zoomUserStruct.hLines = hLines;
    
%============================================================================
% Set the motion and up fcn's.
%============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%
% Store old window fcns.
%%%%%%%%%%%%%%%%%%%%%%%%%
fig = get(ax, 'Parent');
zoomUserStruct.oldWindowButtonMotionFcn = get(fig, 'WindowButtonMotionFcn');
zoomUserStruct.oldWindowButtonUpFcn = get(fig, 'WindowButtonUpFcn');

%%%%%%%%%%%%%%
% Set new one.
%%%%%%%%%%%%%%
set(fig, 'WindowButtonMotionFcn', ['rguizfcn(''butmot'',''',zoomMode,''');']);
set(fig, 'WindowButtonUpFcn', ['rguizfcn(''butup'',''',zoomMode,''');']);

%==============================================================================
% Update the axes user data.
%==============================================================================
zoomUserData(2) = {zoomUserStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);


%******************************************************************************
% Function - Push new axes limits onto stack.                               ***
%   If zoom is not active, no action is taken.  If there is no zoom Data,   ***
%   it is created.                                                          ***
%                                                                           ***
% NOTE:  This version of the function can be called from the command line.  ***
%   As such, a lot of error checking is done.  It calls                     ***
%   i_FastPushLimitsOntoStack, which does no error checking.                ***
%******************************************************************************
function i_PushLimitsOntoStack(hAx, limits),

%==============================================================================
% Initialize.
%==============================================================================
bzoomActive = i_IsZoomActive(get(hAx, 'Parent'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If zoom not active, do nothing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if bzoomActive == 0,
  errmsg = sprintf(...
    ['Attempt to push axes onto zoom stack while zoom is inactive.\n' ...
     'No action taken.'...
    ]...
  );
  error(errmsg);
  return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the zoom user data.
%%%%%%%%%%%%%%%%%%%%%%%%%
hZoomDataContainer = i_FindZoomAxisData(hAx);
if isempty(hZoomDataContainer),
  [zoomUserData, hZoomDataContainer] = i_CreateZoomAxisData(hAx);
else,
  zoomUserData = get(hZoomDataContainer, 'UserData');
end

%==============================================================================
% Are these valid axis limits?
%==============================================================================
if i_IsValidLimits(limits) == 0,
  error('Invalid axis limits.');
end

%==============================================================================
% Put the limits onto the stack.
%==============================================================================
i_FastPushLimitsOntoStack(hZoomDataContainer, limits);


%******************************************************************************
% Function - Put new limits onto stack.                                     ***
% NOTE: No error checking is done.  It is assumed that zoomUserData exits,  ***
%  and that the limits are valid.                                           ***
%******************************************************************************
function i_FastPushLimitsOntoStack(hZoomDataContainer, limits),

%==============================================================================
% Initialize.
%==============================================================================
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct = zoomUserData{2};

%==============================================================================
% Add limits to stack.
%==============================================================================
zoomStruct.topOfStack = zoomStruct.topOfStack + 1;
zoomStruct.stack(zoomStruct.topOfStack,:) = limits;

%==============================================================================
% Reset zoomUserData.
%==============================================================================
zoomUserData(2) = {zoomStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);

%******************************************************************************
%Function - Is zoom active?                                                 ***
%******************************************************************************
function bZoomActive = i_IsZoomActive(fig),

zoomCmd = get(fig, 'WindowButtonDownFcn');
if isempty(findstr('rguizfcn', zoomCmd)),
  bZoomActive = 0;
else,
  bZoomActive = 1;
end

%******************************************************************************
% Function - Are these valid axis limits ([xmin xmax ymin ymax])?           ***
%******************************************************************************
function bValidLimits = i_IsValidLimits(limits),

[m,n] = size(limits);

if max(m,n) ~= 4,
  bValidLimits = 0;
  return;
end

if ((m~=1) & (n~=1) ),
  bValidLimits = 0;
  return;
end

if ( (limits(1) >= limits(2)) |...
     (limits(3) >= limits(4))  ...
   ),
  bValidLimits = 0;
  return;
end

bValidLimits = 1;

%******************************************************************************
%Function - Zoom out 1-level (pop zoom stack)                               ***
%******************************************************************************
function i_ZoomOut1Level(ax, hZoomDataContainer, zoomMode),

%==============================================================================
% Initialize.
%==============================================================================
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct = zoomUserData{2};

%==============================================================================
% Pop the stack & restore the limits.
%==============================================================================
if zoomStruct.topOfStack ~= 0,
  set(ax,...
    'XLim',     zoomStruct.stack(zoomStruct.topOfStack,1:2),...
    'YLim',     zoomStruct.stack(zoomStruct.topOfStack,3:4)...
  );
  zoomStruct.topOfStack = zoomStruct.topOfStack - 1;

else,
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % If we are at the bottom of the stack, zoom out by X.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  i_ZoomOutByX(ax, zoomMode);

end

%============================================================================
% Set the WindowButtonUpFcn.
%============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%
% Store old window fcn.
%%%%%%%%%%%%%%%%%%%%%%%%%
fig = get(ax, 'Parent');
zoomStruct.oldWindowButtonUpFcn = get(fig, 'WindowButtonUpFcn');

%%%%%%%%%%%%%%
% Set new one.
%%%%%%%%%%%%%%
set(fig, 'WindowButtonUpFcn', ['rguizfcn(''butupOut'',''',zoomMode,''');']);

%==============================================================================
% Update the axes user data.
%==============================================================================
zoomUserData(2) = {zoomStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);

%==============================================================================
% Update links.
%==============================================================================
i_UpdateLinks(gca, zoomMode);


%******************************************************************************
% Function - Handle the 'extend' (shift&click) button event by zooming all  ***
%  the way out (i.e. axis auto).  This function obeys the zoom              ***
%  state.  So, if we are in XONLY zoom, only the XLim is set to 'auto'.     ***
%                                                                           ***
% NOTE - The current limits are pushed onto the stack.                      ***
%******************************************************************************
function i_ZoomAutoLimits(ax, hZoomDataContainer, zoomMode),

%==============================================================================
% Push the current limits onto the stack.
%==============================================================================
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct = zoomUserData{2};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Push the current limits onto the stack.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_FastPushLimitsOntoStack(hZoomDataContainer, [get(ax, 'XLim') get(ax, 'YLim')]);

%==============================================================================
% Set appropriate axis limits to auto.
%==============================================================================
i_SetLimsToAuto(ax, zoomMode);

%============================================================================
% Set the WindowButtonUpFcn.
%============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%
% Store old window fcn.
%%%%%%%%%%%%%%%%%%%%%%%%%
fig = get(ax, 'Parent');
zoomStruct.oldWindowButtonUpFcn = get(fig, 'WindowButtonUpFcn');

%%%%%%%%%%%%%%
% Set new one.
%%%%%%%%%%%%%%
set(fig, 'WindowButtonUpFcn', ['rguizfcn(''butupOut'',''',zoomMode,''');']);

%==============================================================================
% Update the axes user data.
%==============================================================================
zoomUserData(2) = {zoomStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);

%==============================================================================
% Update links.
%==============================================================================
i_UpdateLinks(gca, zoomMode);


%******************************************************************************
% Function - Based on specified zoomMode, sets the axis limits to auto.     ***
%******************************************************************************
function i_SetLimsToAuto(ax, zoomMode),

switch(zoomMode),

  case 'normal',
    set(ax, 'XLimMode', 'auto', 'YLimMode', 'auto');

  case 'xonly',
    set(ax, 'XLimMode', 'auto');

  case 'yonly',
    set(ax, 'YLimMode', 'auto');

  otherwise,
    error('Invalid zoomMode.');

end


%******************************************************************************
% Function - Zoom out by a factor of X (obey zoomMode).                     ***
%  This zooms out by the same factor that is used when zooming in by        ***
%  POINT mode.  Currently point mode uses:                                  ***
%    newrange = (2/5) * oldrange, so here we use:                           ***
%    newrnage = (5/2) * oldrange.                                           ***
%                                                                           ***
% If the limits produced by zooming out are "larger" than the limits that   ***
%  would occur by using auto limits, then the auto limits are used.         ***
%                                                                           ***
% NOTE: Unlike the point mode of zooming in, which centers the new limits   ***
%  about the zoom point, zooming out does no centering.  It simply expands  ***
%  the range about the current axis center.                                 ***
%******************************************************************************
function i_ZoomOutByX(ax, zoomMode),

%==============================================================================
% Initialize.
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Factor - This must be consistent w/ factor used in the POINT
%  mode for used for zoomin in.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
factor = (5/2);


%==============================================================================
% Zoom out.
%==============================================================================
switch(zoomMode),

  case 'normal',

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the zoomed out limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XLim = get(ax, 'XLim'); Xcenter = mean(XLim); 
    YLim = get(ax, 'YLim'); Ycenter = mean(YLim); 

    XLimOrig = XLim;
    YLimOrig = YLim;

    XDelta = (Xcenter - XLim(1)) * factor;
    YDelta = (Ycenter - YLim(1)) * factor;

    XLim = [Xcenter - XDelta, Xcenter + XDelta];
    YLim = [Ycenter - YDelta, Ycenter + YDelta];

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the auto limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'XLimMode', 'auto');
    set(ax, 'YLimMode', 'auto');
    XLimAuto = get(ax, 'XLim');
    YLimAuto = get(ax, 'YLim');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clip the zoom to the auto boundaries.
    %
    % If the original limit already encompassed
    % the data, than do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XLim(1) = max(XLim(1), XLimAuto(1));
    if (XLim(1) > XLimOrig(1)),
      XLim(1) = XLimOrig(1);
    end
    
    XLim(2) = min(XLim(2), XLimAuto(2));
    if (XLim(2) < XLimOrig(2)),
      XLim(2) = XLimOrig(2);
    end
    
    YLim(1) = max(YLim(1), YLimAuto(1));
    if (YLim(1) > YLimOrig(1)),
      YLim(1) = YLimOrig(1);
    end
    
    YLim(2) = min(YLim(2), YLimAuto(2));
    if (YLim(2) < YLimOrig(2)),
      YLim(2) = YLimOrig(2);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % Set the new limits.
    %%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'XLim', XLim, 'YLim', YLim);

  case 'xonly',

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the zoomed out limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XLim = get(ax, 'XLim'); Xcenter = mean(XLim); 

    XLimOrig = XLim;


    XDelta = (Xcenter - XLim(1)) * factor;

    XLim = [Xcenter - XDelta, Xcenter + XDelta];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the auto limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'XLimMode', 'auto');
    XLimAuto = get(ax, 'XLim');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clip the zoom to the auto boundaries.
    %
    % If the original limit already encompassed
    % the data, than do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    XLim(1) = max(XLim(1), XLimAuto(1));
    if (XLim(1) > XLimOrig(1)),
      XLim(1) = XLimOrig(1);
    end
    
    XLim(2) = min(XLim(2), XLimAuto(2));
    if (XLim(2) < XLimOrig(2)),
      XLim(2) = XLimOrig(2);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % Set the new limits.
    %%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'XLim', XLim);

  case 'yonly',

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the zoomed out limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    YLim = get(ax, 'YLim'); Ycenter = mean(YLim); 
    YLimOrig = YLim;

    YDelta = (Ycenter - YLim(1)) * factor;

    YLim = [Ycenter - YDelta, Ycenter + YDelta];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the auto limits.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'YLimMode', 'auto');
    YLimAuto = get(ax, 'YLim');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clip the zoom to the auto boundaries.
    %
    % If the original limit already encompassed
    % the data, than do nothing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    YLim(1) = max(YLim(1), YLimAuto(1));
    if (YLim(1) > YLimOrig(1)),
      YLim(1) = YLimOrig(1);
    end
    
    YLim(2) = min(YLim(2), YLimAuto(2));
    if (YLim(2) < YLimOrig(2)),
      YLim(2) = YLimOrig(2);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % Set the new limits.
    %%%%%%%%%%%%%%%%%%%%%%
    set(ax, 'YLim', YLim);

  otherwise,
    error('Invalid zoomMode.');

end


%******************************************************************************
% Function - Jump back to bottom of stack (i.e., return view to "original").
%******************************************************************************
function i_ZoomToOriginalView(ax, hZoomDataContainer, zoomMode),

%==============================================================================
% Initialize.
%==============================================================================
zoomUserData = get(hZoomDataContainer, 'UserData');
zoomStruct = zoomUserData{2};

%==============================================================================
% Restore original limits.
%==============================================================================
limits = zoomStruct.originalLimits;
set(ax, 'XLim', limits(1:2), 'YLim', limits(3:4));

%==============================================================================
% Reset stack pointer to bottom (i.e., the stack is empty).
%==============================================================================
zoomStruct.topOfStack = 0;

%============================================================================
% Set the WindowButtonUpFcn.
%============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%
% Store old window fcn.
%%%%%%%%%%%%%%%%%%%%%%%%%
fig = get(ax, 'Parent');
zoomStruct.oldWindowButtonUpFcn = get(fig, 'WindowButtonUpFcn');

%%%%%%%%%%%%%%
% Set new one.
%%%%%%%%%%%%%%
set(fig, 'WindowButtonUpFcn', ['rguizfcn(''butupOut'',''',zoomMode,''');']);

%==============================================================================
% Update the axes user data.
%==============================================================================
zoomUserData(2) = {zoomStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);

%==============================================================================
% Update links.
%==============================================================================
i_UpdateLinks(gca, zoomMode);



%******************************************************************************
% Function - Register user defined buttonup or buttondown fcn.
%******************************************************************************
function i_RegisterButtonFcn(hAx, action, fcn),

%==============================================================================
% Initialize.
%==============================================================================
if ~isstr(fcn),
  error('Function must be a string');
end
bzoomActive = i_IsZoomActive(get(hAx, 'Parent'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If zoom not active, do nothing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if bzoomActive == 0,
  errmsg = sprintf(...
    ['Attempt to set buttonfcn while zoom is inactive.\n' ...
     'No action taken.'...
    ]...
  );
  error(errmsg);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the zoom user data.
%%%%%%%%%%%%%%%%%%%%%%%%%
hZoomDataContainer = i_FindZoomAxisData(hAx);
if isempty(hZoomDataContainer),
  [zoomUserData, hZoomDataContainer] = i_CreateZoomAxisData(hAx);
else,
  zoomUserData = get(hZoomDataContainer, 'UserData');
end

zoomStruct = zoomUserData{2};
 
%==============================================================================
% Install function into current user data.
%==============================================================================
switch(action),

  case 'buttonupfcn',
    zoomStruct.buttonupfcn = fcn;

  case 'buttondownfcn',
    zoomStruct.buttondownfcn = fcn;

  case 'zoomofffcn',
    zoomStruct.zoomofffcn = fcn;
end

%==============================================================================
% Set new user data.
%==============================================================================
zoomUserData(2) = {zoomStruct};
set(hZoomDataContainer, 'UserData', zoomUserData);


%******************************************************************************
% Function - Execute buttonupfcn for right & double click.
%******************************************************************************
function i_ZoomButtonUpOutFcn(fig, zoomMode),

hZoomDataContainer = i_FindZoomAxisData(gca);
zoomUserData       = get(hZoomDataContainer, 'UserData');
zoomStruct         = zoomUserData{2};

%============================================================================
% Call the users buttonup callback.
%============================================================================
if ~isempty(zoomStruct.buttonupfcn),
  feval(zoomStruct.buttonupfcn, 'zoombuttonup', gca);
end

%============================================================================
% Restore the windowbuttonupfcn.
%============================================================================
set(fig, 'WindowButtonUpFcn', zoomStruct.oldWindowButtonUpFcn);

%******************************************************************************
% Function - Set axes group in figure level user data.                      ***
%******************************************************************************
function i_SetAxesGroup(fig, groups),

%==============================================================================
% Initialize
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If zoom is not active, bail.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if i_IsZoomActive(fig) == 0,
  error('Zoom must be active in order to set axes groups.');
end

%%%%%%%%%%%%%%%%%%%%%%
% Validate group data.
%%%%%%%%%%%%%%%%%%%%%%
if ~iscell(groups),
  error('Axes groups must be cell arrays');
end

[m,n] = size(groups);
if (~((m == 1) | (n == 1))) & ~isempty(groups),
  error('Groups must be either a scalar or vector cell array.');
end

nGroups = max(m,n);
for i=1:nGroups,
  bGroup = i_IsGroupData(groups{i});
  if bGroup ~= 1,
    error('Invalid axes group.');
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieve figure level data container.  If not found, create one.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zoomFigUserData = i_FindZoomFigureData(fig);
if isempty(zoomFigUserData),
  zoomFigUserData = i_CreateZoomFigureData(fig);
end

%==============================================================================
% Install the data into the container.
%==============================================================================
zoomFigUserData.AxesGroups = groups;
setappdata(fig, 'TMWzoomAppData',zoomFigUserData);

%******************************************************************************
% Function - Is data of the correct for form specifying a group?            ***
%******************************************************************************
function bGroup = i_IsGroupData(group),

bGroup = 1;

if length(group) ~= 2,
  bGroup = 0;
  return;
end

groupStyle = lower(group{1});
switch(groupStyle),
  case 'gridgroup',
  case 'listgroup',
  otherwise,
    bGroup = 0;
    return;
end

if ~isnumeric(group{2}),
  bGroup = 0;
end    
  
%******************************************************************************
% Function - Update linked axes.                                            ***
% NOTES:  These are dangerous functions.  No checking is done to see if     ***
%  the axis handles in each group are valid.  If a linked axis disappers,   ***
%  an error will occur.                                                     ***
%******************************************************************************
function i_UpdateLinks(srcAxes, zoomMode),

%==============================================================================
% Initialize.
% NOTE: If the figure user data does not, exist, then there are no links,
%  so bail.
%==============================================================================
fig = get(srcAxes, 'Parent');

zoomFigUserData = i_FindZoomFigureData(fig);
if isempty(zoomFigUserData),
  return;
end

AxesGroups = zoomFigUserData.AxesGroups;

allflag=0;
if strcmp(zoomMode,'normal'),
  allflag=1;
end

%==============================================================================
% For each axes group, identify the group type and update the linked axes.
%==============================================================================
nAxesGroups = length(AxesGroups);
for i=1:nAxesGroups,
  groupType = AxesGroups{i}{1};

  switch(lower(groupType)),

    case 'gridgroup',
      i_UpdateAxesInGridGroup(srcAxes, AxesGroups{i}{2},allflag);
    case 'listgroup',
      i_UpdateAxesInListGroup(srcAxes, AxesGroups{i}{2}, zoomMode);
    otherwise,
      error('Invalid group type.');

  end %switch
end %for


%******************************************************************************
% Function - Update linked axes for GridGroup.                              ***
% GridGroup => All handles in the same row as the src, get their YLims      ***
%  set to the YLims of the srcAxes and all handles in the same col as src   ***
%  get their XLims set to the XLims of the srcAxes.  This functionality is  ***
%  used by the PLOTMATRIX function.                                         ***
%******************************************************************************
function i_UpdateAxesInGridGroup(srcAxes, grid, allflag),

%==============================================================================
% Initialize
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find indices of srcAxes.  If we don't find it, then this grid
% contains no links to this axes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n, m] = find(grid == srcAxes);
if isempty(n),
  return;
end

%==============================================================================
% Grab the col and row of links & remove the srcHandle from each.
%==============================================================================
rowLinks = grid(n,:);  rowLinks(m) = [];
colLinks = grid(:,m);  colLinks(n) = [];

if allflag, % xyzoom...update all the Xlimits
  colLinks=grid(:);
end 

%==============================================================================
% Retrieve the limits from the src axis.
%==============================================================================
srcXLim = get(srcAxes, 'XLim');
srcYLim = get(srcAxes, 'YLim');

%==============================================================================
% Set linked axes limits.
%==============================================================================
for i=1:length(rowLinks),
  limits = [get(rowLinks(i), 'XLim') get(rowLinks(i), 'YLim')];
  i_PushLimitsOntoStack(rowLinks(i), limits);
  set(rowLinks(i), 'YLim', srcYLim);
end

for i=1:length(colLinks),
  limits = [get(colLinks(i), 'XLim') get(colLinks(i), 'YLim')];
  i_PushLimitsOntoStack(colLinks(i), limits);
  set(colLinks(i), 'XLim', srcXLim);
end

%******************************************************************************
% Function - Update linked axes for ListGroup.                              ***
% ListGroup => All handles in list get the identical X & Y lims as          ***
% the srcAxes.                                                              ***
%******************************************************************************
function i_UpdateAxesInListGroup(srcAxes, list, zoomMode),

%==============================================================================
% Initialize
%==============================================================================

%%%%%%%%%%%%%%%%%%%%%%
% Flatten out matrix.
%%%%%%%%%%%%%%%%%%%%%%
list = list(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find indices of srcAxes.  If we don't find it, then this list
% contains no links to this axes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index = find(list == srcAxes);
if isempty(index),
  return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the srcAxes from the list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
list(index) = [];

%==============================================================================
% Retrieve the limits from the src axis.
%==============================================================================
srcXLim = get(srcAxes, 'XLim');
srcYLim = get(srcAxes, 'YLim');

%==============================================================================
% Set linked axes limits.
%==============================================================================

%--- kdg ---% Changed to accomodate different modes

%for i=1:length(list),
%  limits = [get(list(i), 'XLim') get(list(i), 'YLim')];
%  i_PushLimitsOntoStack(list(i), limits);
%  set(list(i), 'XLim', srcXLim, 'YLim', srcYLim);
%end

for i=1:length(list),
  limits = [get(list(i), 'XLim') get(list(i), 'YLim')];
  i_PushLimitsOntoStack(list(i), limits);

  switch zoomMode
   case 'xonly'
     set(list(i), 'XLim', srcXLim);
   case 'yonly'
     set(list(i), 'YLim', srcYLim);
   case 'normal',
     set(list(i), 'XLim', srcXLim, 'YLim', srcYLim);
  end % switch
end
