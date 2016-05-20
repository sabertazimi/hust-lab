function varargout = menufcn(varargin)
%MENUFCN callbacks for Response Object context menus
%   MENUFCN(ACTION,RespObj) performs the action specified by 
%   ACTION, for the Response Object, RespObj. The Callback Object
%   is assumed to be the Context Menu invoking the callback
% $Revision: 1.3 $

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   Karen Gondoly 1-27-98.

ni = nargin;
error(nargchk(2,2,ni));

action = varargin{1};
RespObj = varargin{2};
ContextMenu = get(RespObj,'UIContextMenu');

switch action,

case 'gridcallback',
   %---Grid Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'Grid','on')
   else,
      set(RespObj,'Grid','off')
   end 
   
case 'groupcallback',
   %---Axes Grouping menu callback
   MenuName = get(gcbo,'Label');
   set(RespObj,'AxesGrouping',lower(MenuName));
   
case 'selectios',
   %---I/O selector menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'ChannelSelector','on')
   else,
      set(RespObj,'ChannelSelector','off')
   end 
   
case 'selectmodels',
   %---Array selector menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'ArraySelector','on')
   else,
      set(RespObj,'ArraySelector','off')
   end 
   
case 'systemtoggle',
   %---System Name menu callback
   SysPos = get(gcbo,'Position');
   SysVis = get(RespObj,'SystemVisibility');
   
   if strcmp(get(gcbo,'check'),'off'),
      SysVis{SysPos} = 'on';
   else
      SysVis{SysPos} = 'off';
   end
   
   set(RespObj,'SystemVisibility',SysVis);
   
case 'togglemargin',
   %---Gain/Phase Margin Plot Option Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'StabilityMargin','on')
   else,
      set(RespObj,'StabilityMargin','off')
   end 
   
case 'togglepeak',
   %---Peak Response Plot Option Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'PeakResponse','on')
   else,
      set(RespObj,'PeakResponse','off')
   end 
   
case 'togglerise',
   %---Rise Time Plot Option Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'RiseTime','on')
   else,
      set(RespObj,'RiseTime','off')
   end 
   
case 'togglesettling',
   %---Settling Time Plot Option Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'SettlingTime','on')
   else,
      set(RespObj,'SettlingTime','off')
   end 

case 'togglesteady'
   %---Steady State Plot Option Menu callback
   if strcmp(get(gcbo,'check'),'off'),
      set(RespObj,'SteadyState','on')
   else,
      set(RespObj,'SteadyState','off')
   end 
   
case 'zoomcallback',
   %---Zoom menu callbacks
   ZoomPos = get(gcbo,'Position'); % 1 = 'xon', 2 - 'yon', 3 = 'on', 4 = 'reset'
   if strcmp(get(gcbo,'check'),'off'),
      switch ZoomPos,
      case 1, % X-only
         set(RespObj,'Zoom','xon')
      case 2, % Y-only
         set(RespObj,'Zoom','yon')
      case 3, % X-Y
         set(RespObj,'Zoom','on');
      case 4, % Out
         set(RespObj,'Zoom','reset');
      end % switch ZoomPos
   else
      set(RespObj,'Zoom','off')
   end  % if/else strcmp(...
   
end % switch action

%---Store Object in the Context Menu Userdata (This ensures the whole object,
%----and not just the Response Object parent is stored)
set(ContextMenu.Main,'UserData',RespObj);
