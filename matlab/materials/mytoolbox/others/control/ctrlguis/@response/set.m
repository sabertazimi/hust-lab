function Out = set(RespObj,varargin)
%SET  Set properties of Response Object RESPOBJ.
%
%   SET(RESPOBJ,'Property',VALUE)  sets the property of RESPOBJ specified
%   by the string 'Property' to the value VALUE.
%
%   SET(RESPOBJ,'Property1',Value1,'Property2',Value2,...)  sets multiple 
%   Response Object property values with a single statement.
%
%   SET(RESPOBJ,'Property')  displays possible values for the specified
%   property of RESPOBJ.
%
%   SET(RESPOBJ)  displays all properties of RESPOBJand their admissible 
%   values.
%
%   Note:  Resetting the sampling time does not alter the state-space
%          matrices.  Use C2D or D2D for conversion purposes.
%
%   See also  GET, SS, TF, ZPK.
% $Revision: 1.12 $

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Revised for Response Objects: K. Gondoly, 1-5-98
%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
no = nargout;
if ~isa(RespObj,'response'),
   % Call built-in SET. Handles calls like set(gcf,'user',ss)
   builtin('set',RespObj,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(RESPOBJ) or SET(RESPOBJ,Property)');
end

% Get properties and their admissible values when needed
if ni>1,  flag = 'lower';  else flag = 'true';  end
if ni<=2,
   [AllProps,AsgnValues] = pnames(RespObj,flag);
else
   AllProps = pnames(RespObj,flag);
end

AllPropsCaps = pnames(RespObj,'true');

% Handle read-only cases
if ni==1,
   % SET(RESPOBJ) or S = SET(RESPOBJ)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      pvpdisp(AllProps,AsgnValues,':  ')
   end
   return
   
elseif ni==2,
   % SET(RESPOBJ,'Property') or STR = SET(RESPOBJ,'Property')
   Property = varargin{1};
   if ~isstr(Property),
      error('Property names must be single-line strings,')
   end
   
   % Return admissible property value(s)
   imatch = find(strncmpi(Property,AllProps,length(Property)));
   if isempty(imatch),
      error(['Invalid property name "' Property '".']);
   elseif length(imatch)>1,
      lenProp = zeros(size(imatch));
      for ct=1:length(imatch),
         lenProp(ct) = length(AllProps{imatch(ct)});
      end
      % Always take the property with the shortest name
      [garb,ind_imatch]=min(lenProp); 
      imatch = imatch(ind_imatch);
   end
   if no,
      Out = AsgnValues{imatch};
   else
      disp(AsgnValues{imatch})
   end
   return
   
end

% Now left with SET(RESPOBJ,'Prop1',Value1, ...)
name = inputname(1);
if rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end

%---Look through/order property list
%----This is necessary since some properties can not be set independently
%----and other properties should be set in a particular order.
EnteredProps = lower(varargin(1:2:end));
EnteredVals = varargin(2:2:end);

%---Gather all the X/Ylim Properties together
NumXlim = length(find(strncmpi('xlim',EnteredProps,4)));
NumYlim = length(find(strncmpi('ylim',EnteredProps,4)));
NumLimProps =  NumXlim + NumYlim;

ContextMenu = RespObj.UIContextMenu;
for i=1:2:ni-1,
   % Set each PV pair in turn
   Property = varargin{i};
   imatch = find(strncmpi(Property,AllProps,length(Property)));
   if isempty(imatch),
      error(['Invalid property name "' Property '".']);
   elseif length(imatch)>1,
      lenProp = zeros(size(imatch));
      for ct=1:length(imatch),
         lenProp(ct) = length(AllProps{imatch(ct)});
      end
      % Always take the property with the shortest name
      [garb,ind_imatch]=min(lenProp); 
      imatch = imatch(ind_imatch);
   end
   Property = AllProps{imatch};
   Value = varargin{i+1};
   
   switch Property
      
   case 'initializeresponse',
      %---Done when plotting any response plot
      %   Value should be a structure with SystemNames, SystemVisibility,
      % SelectedModels, and SelectedChannels.
      %   Speed up plot initialization by assigning all properties,
      % then executing functions only once
      
      RespObj.SelectedChannels = Value.SelectedChannels;
      RespObj.SelectedModels = Value.SelectedModels;
      RespObj.SystemVisibility = Value.SystemVisibility;
      RespObj = respfcn('makeaxes',RespObj);
      
   case 'arrayselector',
      Value=lower(Value);
      if ~any(strcmpi(Value,{'on';'off'})) | length(find(strcmpi(Value,{'on';'off'}))) > 1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.ArraySelector = Value;
         ArrayHandle = get(RespObj.UIContextMenu.ArrayMenu,'UserData');
         
         %---Toggle the Selector
         switch Value,
         case 'on',
            if ishandle(ArrayHandle),
               paramsel('#criterion',RespObj);
               figure(ArrayHandle);
            else
               %---Call your function here!!!  Kelly               
               paramsel('#init',RespObj);
               
            end
         case 'off',
            if ishandle(ArrayHandle)
               set(ArrayHandle,'visible','off')
            end
         end % switch Value
      end
      
   case 'axesgrouping',
      %---Called by all responses except Bode
      Value = lower(Value);
      if ~any(strcmpi(Value,{'none';'all';'inputs';'outputs'}))
         error(['Bad value for response property: ''',Property,'''.'])
      else
         OldVal = RespObj.AxesGrouping;
         RespObj.AxesGrouping = Value;
         %---Change the Checked property of the Axes Group Context Menus
         GroupInd = find(strcmpi(Value,{'none';'all';'inputs';'outputs'}));
         GroupMenus = struct2cell(RespObj.UIContextMenu.GroupMenu);
         set([GroupMenus{2:5}],'Checked','off')
         set(GroupMenus{GroupInd+1},'Checked','on')
         
         %---Call function for a particular axes grouping
         RespObj = respfcn('makeaxes',RespObj);
      end % if/else isempty(...
      
   case 'channelselector',
      Value=lower(Value);
      if ~any(strcmpi(Value,{'on';'off'})) | length(find(strcmpi(Value,{'on';'off'}))) > 1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.ChannelSelector = Value;
         SelectorHandle = get(RespObj.UIContextMenu.ChannelMenu,'UserData');
         
         %---Toggle the Selector
         switch Value,
         case 'on',
            if ishandle(SelectorHandle),
               set(SelectorHandle,'visible','on');
               figure(SelectorHandle)
            else
               %---Call function to generate a selector
               RespObj = respfcn('makeselector',RespObj);         
            end
         case 'off',
            if ishandle(SelectorHandle)
               set(SelectorHandle,'visible','off')
            end
         end % switch Value
      end
      
   case 'colororder',
      [Value,stat] = cstrchk(Value,Property);
      error(stat);
      RespObj.ColorOrder= Value;
      
   case 'grid',
      Value=lower(Value);
      if ~any(strcmpi(Value,{'on';'off'})) | length(find(strcmpi(Value,{'on';'off'}))) > 1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.Grid = Value;
         %---Change the Checked property of the Grid Context Menu
         set(RespObj.UIContextMenu.GridMenu,'Checked',Value)
         %---Call function that toggles Grid
         RespObj = respfcn('setgrid',RespObj);
      end
      
   case 'inputlabel',
      RespObj.InputLabel= Value;
      RespObj = LocalLabelInputs(RespObj,Value);
      
   case 'linestyleorder',
      [Value,stat] = cstrchk(Value,Property);
      error(stat);
      RespObj.LinestyleOrder= Value;
      
   case 'markerorder',
      [Value,stat] = cstrchk(Value,Property);
      error(stat);
      RespObj.MarkerOrder = Value;
            
   case 'nextplot',
      RespObj.NextPlot = Value;
      
   case 'outputlabel',
      RespObj.OutputLabel= Value;
      RespObj = LocalLabelOutputs(RespObj,Value);
      
   case 'responsehandles',
      RespObj.ResponseHandles = Value;
      
   case 'responsetype',
      RespObj.ResponseType = Value;
      
   case 'selectedchannels',
      RespObj.SelectedChannels = Value;
      
      %---Update the Selector Figure, if applicable
      SelectorHandle = get(RespObj.UIContextMenu.ChannelMenu,'UserData');
      if ishandle(SelectorHandle),
         RespObj = respfcn('updateselector',RespObj);
      end % if ishandle(SelectorHandle)
      
      %---Callback to plot the correct channels
      RespObj = respfcn('makeaxes',RespObj);
      
   case 'selectedmodels',
      RespObj.SelectedModels = Value;
      
      %---Callback to plot the correct models
      RespObj = modeltog(RespObj);
      
   case 'systemnames',
      %---Need proper error handling
      if ~iscell(Value),
         Value=cellstr(Value);
      end
      
      if ~isequal(RespObj.SystemNames,Value);
         OldNames = RespObj.SystemNames;
         RespObj.SystemNames = Value;  
         PlotOptMarkers = [findall(RespObj.PlotAxes,'Tag','PeakResponseMarker');
            findall(RespObj.PlotAxes,'Tag','RiseTimeMarker');
            findall(RespObj.PlotAxes,'Tag','SteadyStateMarker');
            findall(RespObj.PlotAxes,'Tag','SettlingTimeMarker');
            findall(RespObj.PlotAxes,'Tag','StabilityMarginMarker')];
         PlotOptMarkers = findobj(PlotOptMarkers,'Marker','o');
         
         %---Reset UIcontext System Menu labels
         SysNameMenus = RespObj.UIContextMenu.Systems.Names;
         for ctN=1:length(SysNameMenus),
            MenuStr = get(SysNameMenus(ctN),'Label');
            [oldname,legend] = strtok(MenuStr,' (');
            set(SysNameMenus(ctN),'Label',...
               [Value{ctN},legend]);
         end, % for ctN
         
         %---Reset any Plot Characteristic markers
         for ctM = 1:length(PlotOptMarkers),
            str = get(PlotOptMarkers(ctM),'UserData');
            Name = str{1}(9:end);
            [Name,ArrayInd]=strtok(Name,'[');
            nameind = strcmp(Name,OldNames);
            if ~isempty(ArrayInd),
               ArrayInd = [' ',ArrayInd];
               Name = Name(1:end-1);
            end
            str{1}=['System: ',Value{nameind},ArrayInd];
            set(PlotOptMarkers(ctM),'UserData',str)
         end % for ctM
      end % if ~isequal(RespObj.SystemNames,Value)
         
   case 'systemvisibility',
      RespObj.SystemVisibility = Value;
      ResponseHandles=RespObj.ResponseHandles;
      
      if length(ResponseHandles)<length(Value),
         error('Length of SystemVisibility vector exceeds number of plotted responses.')
      end
      
      %---Call function that changes response line property
      RespObj = systemtog(RespObj);
      
   case 'uicontextmenu',
      %---Need proper error handling
      RespObj.UIContextMenu = Value;
                  
   case {'xlimmode','ylimmode'},
      Value=lower(Value);
      if ~any(strcmpi(Value,{'auto';'manual'}))
         error(['Bad value for response property: ''',Property,'''.'])
      else
         eval(['RespObj.',AllPropsCaps{imatch},'= Value;']);
         NumLimProps=NumLimProps-1;
         %---Call function that changes axis limits
         if ~NumLimProps,
            %---Rescale the axes
            [Xlims,Ylims] = axeslims(get(RespObj.UIContextMenu.Main,'UserData'),RespObj);
            RespObj.Ylims = Ylims;
            RespObj.Xlims = Xlims;
         end
      end
      
   case 'xlims'
      LTIDisplayAxes = RespObj.PlotAxes;
      if ~isequal(length(Value),size(LTIDisplayAxes,2)),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.Xlims = Value;
         %---Call function that changes axis limits
         if isequal(NumXlim,1)
            RespObj.XlimMode='manual';  
         end
         NumLimProps=NumLimProps-1;
         if ~NumLimProps,
            %---Rescale the axes
            [Xlims,Ylims] = axeslims(get(RespObj.UIContextMenu.Main,'UserData'),RespObj);
            RespObj.Ylims = Ylims;
            RespObj.Xlims = Xlims;
         end
      end % if ~isequal(...
      
   case 'ylims'
      LTIDisplayAxes = RespObj.PlotAxes;
      
      %---If a single non-cell limit is entered, use it as the standard
      if isequal(size(Value,1),1) & ~iscell(Value),
         YlimsTemp = Value;
         Value = cell(size(LTIDisplayAxes,1),1);
         Value(:) = {YlimsTemp};
      end
      
      if ~isequal(length(Value),size(LTIDisplayAxes,1)),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.Ylims = Value;
         %---Call function that changes axis limits
         if isequal(NumYlim,1)
            RespObj.YlimMode='manual';  
         end
         NumLimProps=NumLimProps-1;
         if ~NumLimProps,
            %---Rescale the axes
            [Xlims,Ylims] = axeslims(get(RespObj.UIContextMenu.Main,'UserData'),RespObj);
            RespObj.Ylims = Ylims;
            RespObj.Xlims = Xlims;
         end
      end % if ~isequal(...
      
   case 'zoom',
      Value = lower(Value);
      ZoomInd = find(strcmpi(Value,{'off';'xon';'yon';'on';'reset'}));
      if isempty(ZoomInd),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         RespObj.Zoom = Value;
         ZoomMenus = struct2cell(RespObj.UIContextMenu.ZoomMenu);
         set([ZoomMenus{2:5}],'Checked','off')
         if ZoomInd>1,
            set(ZoomMenus{ZoomInd},'Checked','on')
         end
         RespObj = respfcn('zoom',RespObj);
      end % if/else isempty(ZoomInd...
      
   case  {'backgroundaxes','plotaxes','parent'},
      error(['Attempt to modify read-only response property: ''',Property,'''.'])
      
   otherwise
      % This should not happen
      error(['Invalid response property: ''',Property,'''.'])
      
   end % switch Property
end % for

% Finally, assign sys in caller's workspace
if ~isempty(name),
   assignin('caller',name,RespObj);
end

% end ../@response/set.m

%---------------------------Internal functions---------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalLabelInputs %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalLabelInputs(RespObj,inNames);

LTIdisplayAxes = RespObj.PlotAxes;

switch RespObj.ResponseType,
case {'step','impulse','nyquist','nichols','bode','margin'},      
   FromText(1:length(inNames),1)={'From: '};
   TitleText = cellstr([strvcat(FromText{:}),strvcat(inNames{:})]);
   for ctL=1:size(LTIdisplayAxes,1),
      T=get(LTIdisplayAxes(ctL,:),{'Title'});
      set(cat(1,T{:}),{'String'},TitleText,'FontSize',8)
   end      
end % switch ResponseType

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalLabelOutputs %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalLabelOutputs(RespObj,outNames);

LTIdisplayAxes = RespObj.PlotAxes;

if ~any(strcmpi(RespObj.ResponseType,{'pzmap';'sigma'})),
   ToText(1:length(outNames),1)={'To: '};
   YlabelText = cellstr([strvcat(ToText{:}),strvcat(outNames{:})]);
   for ctL=1:size(LTIdisplayAxes,2),
      switch RespObj.ResponseType,
      case {'step','impulse','lsim','initial','nyquist','nichols'},
         Y=get(LTIdisplayAxes(:,ctL),{'Ylabel'});
      case {'bode','margin'},
         Y=get(LTIdisplayAxes(2:2:end,ctL),{'Ylabel'});
      end % switch ResponseType
      set(cat(1,Y{:}),{'String'},YlabelText,'FontSize',8)
   end % for ctL
end % if ~any...