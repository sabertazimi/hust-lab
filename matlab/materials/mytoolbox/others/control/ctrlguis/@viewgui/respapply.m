function ViewerObj = respapply(varargin);
%RESPAPPLY Apply Response Preference settings to the associated LTI Viewer
% $Revision: 1.7.1.2 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly, 3-23-98

error(nargchk(1,2,nargin));
ViewerObj = varargin{1};
if nargin>1,
   NumConfigs = varargin{2};   
else
   NumConfigs = 1:ViewerObj.Configuration;
end

RespPrefFig = get(ViewerObj.FigureMenu.ToolsMenu.Response,'UserData');
if ishandle(RespPrefFig) & ~isequal(RespPrefFig,0),
   udResp=get(RespPrefFig ,'UserData');
   [CurrentValues,LastValues,ViewerObj] = LocalApplyChanges(RespPrefFig,ViewerObj);
   set(ViewerObj.Handle,'UserData',ViewerObj);
   
   %---Update plots
   
   % 1) If frequency or time vector has changed, recompute entire viewer (takes care of everything)
   
   if ( (strcmp(CurrentValues.TimeVectorMode,'manual')) & ...
         (~isequal(CurrentValues.TimeVector,LastValues.TimeVector)) ) | ...
         ( ~strcmp(CurrentValues.TimeVectorMode,LastValues.TimeVectorMode) ) | ...
         ( (strcmp(CurrentValues.FrequencyVectorMode,'manual')) & ...
         (~isequal(CurrentValues.FrequencyVector,LastValues.FrequencyVector)) ) | ...
         ( (~strcmp(CurrentValues.FrequencyVectorMode,LastValues.FrequencyVectorMode) ) & ...
         (~strcmp(CurrentValues.FrequencyVectorMode,'hold')) ),
      
      %---If the Time Vector is User-defined, make sure it has the same sample time as any 
      %      discrete systems. Otherwise, the step response can not be plotted.
      
      Systems = get(ViewerObj,'Systems');
      Ts = zeros(1,length(Systems));  % sample times
      for ct=1:length(Systems),
         Ts=Systems{ct}.Ts;
      end
      if length(CurrentValues.TimeVector)>2 & ...
            any(abs(Ts(Ts>0)/(CurrentValues.TimeVector(2)-CurrentValues.TimeVector(1))-1)>1e-4),
         errordlg('Spacing of time samples T should match sample period of discrete models.', ...
            'Response Preference Warning')
         return
      elseif all(Ts==-1) & ...
            ~isequal(CurrentValues.TimeVector(end),round(CurrentValues.TimeVector(end)))
         errordlg('Final time must be an integer (No. of samples) when sample times are unspecified.', ...
            'Response Preference Warning');
         
      end
      
      set(ViewerObj.Handle,'UserData',ViewerObj);
      rguifcn('respapply',ViewerObj.Handle);
      return
   end
   
   % 2) Check for conversions
   PlotTypeOrder = ViewerObj.PlotTypeOrder;
   RespObjs = get(ViewerObj.UIContextMenu,{'UserData'});
   if ~isempty(RespObjs)
      for ctConfig = NumConfigs,
         MyRespObj = RespObjs{ctConfig};
         if any(strcmpi(PlotTypeOrder{ctConfig},{'step';'impulse'})),
            isTimeFlag=1;
         else
            isTimeFlag=0;
         end
         
         if isTimeFlag,
            
            %---See if Ylimits are changing
            if ~isequal(CurrentValues.Ylims,LastValues.Ylims) | ...
                  ~strcmp(CurrentValues.YlimMode,LastValues.YlimMode),
               set(MyRespObj,'Ylims',ViewerObj.Ylims,'YlimMode',ViewerObj.YlimMode);
            end
            
            %---See if Settling or Rise Time needs to be updated
            if ~isequal(CurrentValues.SettlingTimeThreshold,LastValues.SettlingTimeThreshold),
               set(MyRespObj,'SettlingTimeThreshold',ViewerObj.SettlingTimeThreshold);
            end
            
            if strcmp(PlotTypeOrder{ctConfig},'step'),
               if ~isequal(CurrentValues.RiseTimeLimits,LastValues.RiseTimeLimits),
                  set(MyRespObj,'RiseTimeLimits',ViewerObj.RiseTimeLimits);
               end
            end % if strcmp(...'step')
            
         else,  % Frequency domain    
            %---Only need to do conversions for Bode and Sigma
            if ~strcmp(CurrentValues.FrequencyUnits,LastValues.FrequencyUnits),
               set(MyRespObj,'FrequencyUnits',ViewerObj.FrequencyUnits);
            end % if ~isequal Frequency scale
            
            if ~strcmp(CurrentValues.MagnitudeUnits,LastValues.MagnitudeUnits),
               set(MyRespObj,'MagnitudeUnits',ViewerObj.MagnitudeUnits);
               UnitFlag=1;
            end
            
            if ~strcmp(PlotTypeOrder{ctConfig},'sigma'), % Do not do Phase for Sigma
               if ~strcmp(CurrentValues.PhaseUnits,LastValues.PhaseUnits),
                  set(MyRespObj,'PhaseUnits',ViewerObj.PhaseUnits);
                  UnitFlag=1;
               end, % if ~isequal Phase scale
            end % if isequal(plottype,3)
            
         end % if/else isTimeFlag
         
         %---Reset the UIcontextMenu UserData
         set(ViewerObj.UIContextMenu(ctConfig),'UserData',MyRespObj);
         
         set(ViewerObj.Handle,'UserData',ViewerObj);
   
         %---See if the units on the Array Selector need to be updated
         if UnitFlag & any(strcmp(PlotTypeOrder{ctConfig},...
               {'bode';'sigma';'nyquist';'nichols'})),
            MyRespObj = RespObjs{ctConfig};
            RespCMenu = get(MyRespObj,'UIcontextMenu');
            if isequal(get(RespCMenu.ArrayMenu,'Visible'),'on') & ...
                  ishandle(get(RespCMenu.ArrayMenu,'UserData')),
               paramsel('#criterion',MyRespObj);
            end
         end % if UnitFlag (Only if units have changed)
      end % for ctConfig      
   end, % if ~isempty(RespObj
   
end % if ishandle(RespPrefFig...)

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalApplyChanges %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function [CurrentValues,LastValues,ViewerObj] = LocalApplyChanges(RespFig,ViewerObj);
%---Set the Revert data after an Apply has been pressed in the Response Pref. Window, 
%---Return the previous and current values so it's easy to see what changed.
ud = get(RespFig,'UserData');
Fields = fieldnames(ud);
RevertValues = cell2struct(cell(length(Fields),1),Fields,1);

%---Get Revert data;
RevertValues.DefaultTime = get(ud.Handles.DefaultTime,'Value');
RevertValues.DefineTime=get(ud.Handles.DefineTime,'Value');
RevertValues.TimeVector=get(ud.Handles.TimeVector,'String');
RevertValues.DefaultYrange=get(ud.Handles.DefaultYrange,'Value');
RevertValues.DefineYrange=get(ud.Handles.DefineYrange,'Value');
RevertValues.YlimVector=get(ud.Handles.YlimVector,'String');
RevertValues.SetTimeTarget=get(ud.Handles.SetTimeTarget,'String');
RevertValues.RiseTimeStart=get(ud.Handles.RiseTimeStart,'String');
RevertValues.RiseTimeEnd=get(ud.Handles.RiseTimeEnd,'String');
RevertValues.DefaultFreq=get(ud.Handles.DefaultFreq,'Value');
RevertValues.RecalcFreq=get(ud.Handles.RecalcFreq,'Value');
RevertValues.DefineFreq=get(ud.Handles.DefineFreq,'Value');
RevertValues.FreqVector=get(ud.Handles.FreqVector,'String');
RevertValues.MagdB=get(ud.Handles.MagdB,'Value');
RevertValues.MagAbs=get(ud.Handles.MagAbs,'Value');
RevertValues.MagLog=get(ud.Handles.MagLog,'Value');
RevertValues.PhaseRad=get(ud.Handles.PhaseRad,'Value');
RevertValues.PhaseDeg=get(ud.Handles.PhaseDeg,'Value');
RevertValues.FreqHz=get(ud.Handles.FreqHz,'Value');
RevertValues.FreqRad=get(ud.Handles.FreqRad,'Value');

%---Store values used for reverting the Response Preference window
ud.Revert = RevertValues;
set(RespFig,'UserData',ud);

%---Get values for comparing old and new values
%---Write all data to the Viewer Object
LastValues.MagnitudeUnits = ViewerObj.MagnitudeUnits;
if RevertValues.MagdB;
   ViewerObj.MagnitudeUnits = 'decibels';
elseif RevertValues.MagAbs;
   ViewerObj.MagnitudeUnits = 'absolute';
elseif RevertValues.MagLog;
   ViewerObj.MagnitudeUnits = 'logrithmic';
end
CurrentValues.MagnitudeUnits = ViewerObj.MagnitudeUnits;

LastValues.PhaseUnits = ViewerObj.MagnitudeUnits;
if RevertValues.PhaseRad;
   ViewerObj.PhaseUnits = 'radians';
elseif RevertValues.PhaseDeg;
   ViewerObj.PhaseUnits = 'degrees';
end
CurrentValues.PhaseUnits = ViewerObj.PhaseUnits;

LastValues.FrequencyUnits = ViewerObj.FrequencyUnits;
if RevertValues.FreqRad;
   ViewerObj.FrequencyUnits = 'rad/s';
elseif RevertValues.FreqHz;
   ViewerObj.FrequencyUnits = 'Hz';
end
CurrentValues.FrequencyUnits = ViewerObj.FrequencyUnits;

LastValues.TimeVectorMode = ViewerObj.TimeVectorMode;
LastValues.TimeVector = ViewerObj.TimeVector;
if RevertValues.DefineTime,
   ViewerObj.TimeVectorMode = 'manual';
else
   ViewerObj.TimeVectorMode = 'auto';
end 

ViewerObj.TimeVector = eval(RevertValues.TimeVector);
CurrentValues.TimeVectorMode = ViewerObj.TimeVectorMode;
CurrentValues.TimeVector = ViewerObj.TimeVector;

LastValues.YlimMode= ViewerObj.YlimMode;
LastValues.Ylims = ViewerObj.Ylims;
if RevertValues.DefineYrange,
   ViewerObj.YlimMode = 'manual';
else
   ViewerObj.YlimMode = 'auto';
end
ViewerObj.Ylims = eval(RevertValues.YlimVector);
CurrentValues.YlimMode= ViewerObj.YlimMode;
CurrentValues.Ylims = ViewerObj.Ylims;

LastValues.SettlingTimeThreshold = ViewerObj.SettlingTimeThreshold;
ViewerObj.SettlingTimeThreshold = eval(RevertValues.SetTimeTarget)/100;
CurrentValues.SettlingTimeThreshold = ViewerObj.SettlingTimeThreshold;

LastValues.RiseTimeLimits= ViewerObj.RiseTimeLimits;
ViewerObj.RiseTimeLimits= [str2double(RevertValues.RiseTimeStart)/100,...
      str2double(RevertValues.RiseTimeEnd)/100];
CurrentValues.RiseTimeLimits= ViewerObj.RiseTimeLimits;

LastValues.FrequencyVectorMode = ViewerObj.FrequencyVectorMode;
LastValues.FrequencyVector = ViewerObj.FrequencyVector;
if RevertValues.DefineFreq,
   ViewerObj.FrequencyVectorMode = 'manual';
else
   if RevertValues.RecalcFreq,
      ViewerObj.FrequencyVectorMode = 'auto';
   else
      ViewerObj.FrequencyVectorMode = 'manual'; %'hold';
   end
end

eval(['W=logspace',RevertValues.FreqVector,';']);
%---Convert any frequency in Hertz to Rad/sec.
if RevertValues.FreqHz,
   W=W*2*pi;
end
ViewerObj.FrequencyVector = W;

CurrentValues.FrequencyVectorMode = ViewerObj.FrequencyVectorMode;
CurrentValues.FrequencyVector = ViewerObj.FrequencyVector;
