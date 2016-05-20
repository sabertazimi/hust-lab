function Out = set(ViewerObj,varargin)
%SET  Set properties of LTI Viewer.
%
%   SET(VIEWEROBJ,'Property',VALUE)  sets the property of VIEWEROBJspecified
%   by the string 'Property' to the value VALUE.
%
%   SET(VIEWEROBJ,'Property1',Value1,'Property2',Value2,...)  sets multiple 
%   Response Object property values with a single statement.
%
%   SET(VIEWEROBJ,'Property')  displays possible values for the specified
%   property of VIEWEROBJ.
%
%   SET(VIEWEROBJ)  displays all properties of VIEWEROBJand their admissible 
%   values.
%
%   Note:  Resetting the sampling time does not alter the state-space
%          matrices.  Use C2D or D2D for conversion purposes.
%
%   See also  GET, SS, TF, ZPK.
% $Revision: 1.7 $

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Revised for Response/GUI Objects: K. Gondoly, 1-5-98
%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
no = nargout;
if ~isa(ViewerObj,'viewgui'),
   % Call built-in SET. Handles calls like set(gcf,'user',ss)
   builtin('set',ViewerObj,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(ViewerObj) or SET(ViewerObj,Property)');
end

% Get properties and their admissible values when needed
if ni>1,  flag = 'lower';  else flag = 'true';  end
if ni<=2,
   [AllProps,AsgnValues] = pnames(ViewerObj,flag);
else
   AllProps = pnames(ViewerObj,flag);
end

AllPropsCaps = pnames(ViewerObj,'true');

% Handle read-only cases
if ni==1,
   % SET(ViewerObj) or S = SET(ViewerObj)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      pvpdisp(AllProps,AsgnValues,':  ')
   end
   return
   
elseif ni==2,
   % SET(ViewerObj,'Property') or STR = SET(ViewerObj,'Property')
   Property = lower(varargin{1});
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

% Now left with SET(ViewerObj,'Prop1',Value1, ...)
name = inputname(1);
if isempty(name),
   error('First argument to SET must be a named variable.')
elseif rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end

%---Initialize the PlotTypeOrder, in case the configuration is changed
OldOrder=ViewerObj.PlotTypeOrder;

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
      
   case 'initializeviewer',
      %---Hidden property to initialize Viewer efficiently
      ViewerObj.PlotStrings= Value.PlotStrs;
      ViewerObj.SystemNames = Value.Names;
      ViewerObj.FrequencyData = Value.FRDindices;
      ViewerObj.Systems = Value.Systems;
      set(ViewerObj.Handle,'UserData',ViewerObj); % Store data before going on.
      ViewerObj = rguifcn('setsystems',ViewerObj.Handle,ViewerObj);
      set(ViewerObj.StatusText,'String',...
         'Right-click on any response plot axes to access the LTI Viewer controls.');
      
   case 'axesposition',
      %---Called by all responses except Bode
         ViewerObj.AxesPosition = Value;
      
   case  {'parent','figuremenu','handle'},
      error(['Attempt to modify read-only response property: ''',Property,'''.'])
      
   case 'backgroundaxes',
      ViewerObj.BackgroundAxes = Value;
      
   case 'configuration',
      %---Configuration should be set second!!!
      OldConfig = ViewerObj.Configuration;
      ViewerObj.Configuration= Value;
      ViewerObj = rguifcn('arrangeview',ViewerObj,OldConfig,OldOrder);
      set(ViewerObj.StatusText,'String',...
         ['LTI Viewer configuration changed from ',num2str(OldConfig),' to ', ...
            num2str(Value),'.']);
      
   case 'configurationwindow',
      Value=lower(Value);
      if isempty(strmatch(Value,{'on';'off'})) | length(strmatch(Value,{'on';'off'}))>1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.ConfigurationWindow= Value;
         ConfigurationHandle = get(ViewerObj.FigureMenu.ToolsMenu.ConfigMenu,'UserData');
         
         %---Toggle the Selector
         switch Value,
         case 'on',
            if ishandle(ConfigurationHandle),
               set(ConfigurationHandle,'visible','on');
            else
               %---Call function to generate a selector
               ConfigWin = configax(get(ViewerObj,'Handle'),...
                  get(ViewerObj,'Configuration'));  
               set(ViewerObj.FigureMenu.ToolsMenu.ConfigMenu,'UserData',ConfigWin)
            end
            set(ViewerObj.StatusText,'String',...
               ['Change the number and type ', ...
                  'of responses shown in the Viewer.']);
         case 'off',
            if ishandle(ConfigurationHandle)
               set(ConfigurationHandle,'visible','off')
            end
         end % switch Value
      end
      
   case 'colororder',
      ViewerObj.ColorOrder = Value;
      
   case 'frequencydata',
      OldValue = ViewerObj.FrequencyData;
      ViewerObj.FrequencyData = Value;
      
   case 'frequencyvector',
      ViewerObj.FrequencyVector= Value;
      
   case 'frequencyvectormode',
      Value=lower(Value);
      if isempty(strmatch(Value,{'auto';'manual';'hold'})) 
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.FrequencyVectorMode = Value;
      end
            
   case 'systemnames',
      ViewerObj.SystemNames = Value;
      RespObjs = get(ViewerObj.UIContextMenu,{'UserData'});
      PlotTypes = ViewerObj.PlotTypeOrder;
      TimeValues = Value;
      TimeValues(ViewerObj.FrequencyData)=[];
      for ctR=1:length(RespObjs),
         if any(strcmpi(PlotTypes{ctR},{'sigma';'bode';'nyquist';'nichols'})),
            set(RespObjs{ctR},'SystemNames',Value);
         else
            set(RespObjs{ctR},'SystemNames',TimeValues);
         end
      end, % for ctR
      
   case 'plotstrings',
      ViewerObj.PlotStrings= Value;
      
   case 'plottypeorder',
      %---Changing the PlotTypeOrder will not recompute anything
      OldOrder = ViewerObj.PlotTypeOrder;
      ViewerObj.PlotTypeOrder = Value;
      
   case 'linestyleorder'
      ViewerObj.LineStyleOrder = Value;
      
   case 'linestylepreferences',
      ViewerObj.LineStylePreferences = Value;
      switch lower(Value),
      case 'off',
         PlotPrefFig = get(ViewerObj.FigureMenu.ToolsMenu.Linestyle,'UserData');
         if ishandle(PlotPrefFig) & ~isequal(PlotPrefFig,0)
            close(PlotPrefFig);
         end
         set(ViewerObj.FigureMenu.ToolsMenu.Linestyle,'UserData',[]);
         
      case 'on',
         PlotPrefFig = rguipopts('initialize',ViewerObj.Handle);
         set(ViewerObj.FigureMenu.ToolsMenu.Linestyle,'UserData',PlotPrefFig);
      end
      
   case 'markerorder',
      ViewerObj.MarkerOrder = Value;
      
   case 'responsepreferences',
      ViewerObj.ResponsePreferences = Value;
      switch lower(Value),
      case 'off',
         RespPrefFig = get(ViewerObj.FigureMenu.ToolsMenu.Response,'UserData');
         if ishandle(RespPrefFig) & ~isequal(RespPrefFig,0)
            close(RespPrefFig);
         end
         set(ViewerObj.FigureMenu.ToolsMenu.Response,'UserData',[]);
         
      case 'on',
         RespPrefFig = rguiropts('initialize',ViewerObj.Handle);
         set(ViewerObj.FigureMenu.ToolsMenu.Response,'UserData',RespPrefFig);
      end
      
   case 'risetimelimits',
      if ~isequal(length(Value),2) | Value(1)>Value(2) | ...
            Value(1)<0 | Value(2)>1,
         error(['Bad value for response property: ''',Property,'''.'])
      end
      ViewerObj.RiseTimeLimits = Value;
      
   case 'settlingtimethreshold',
      if ~isequal(length(Value),1) | Value>1,
         error(['Bad value for response property: ''',Property,'''.'])
      end
      ViewerObj.SettlingTimeThreshold = Value;
      
   case 'magnitudeunits',
      if isempty(strmatch(Value,{'decibels';'absolute';'logrithmic'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.MagnitudeUnits = Value;
      end
      
   case 'phaseunits',
      if isempty(strmatch(Value,{'degrees';'radians'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.PhaseUnits = Value;
      end
      
   case 'frequencyunits',
      if isempty(strmatch(Value,{'hertz';'hz';'radianspersecond';'rad/s'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.FrequencyUnits = Value;
      end
      
   case 'systems',
      ViewerObj.Systems = Value;
      ViewerObj = rguifcn('setsystems',ViewerObj.Handle,ViewerObj);
      
   case 'timedata',
      ViewerObj.TimeData = Value;
      
   case 'timevector',
      ViewerObj.TimeVector= Value;
      
   case 'timevectormode',
      Value=lower(Value);
      if isempty(strmatch(Value,{'auto';'manual'})) 
         error(['Bad value for response property: ''',Property,'''.'])
      else
         ViewerObj.TimeVectorMode = Value;
      end
      
   case 'visible',
      ViewerObj.Visible = Value;
      
   case 'uicontextmenu',
      %---Need proper error handling
      ViewerObj.UIContextMenu = Value;
      
   case 'initialcondition';
      ViewerObj.InitialConditions= Value;
      
   case 'inputsignal';
      ViewerObj.InputSignal= Value;

   otherwise
      % This should not happen
      error(['Invalid response property: ''',Property,'''.'])
      
   end % switch Property
end % for

% Finally, assign sys in caller's workspace
if ~isempty(name),
   assignin('caller',name,ViewerObj)
end

set(ViewerObj.Handle,'UserData',ViewerObj);

% end ../@viewgui/set.m


