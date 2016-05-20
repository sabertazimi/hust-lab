function cla(RespObj,Childflag)
%CLA Clear current Response Object.
%   CLA(RespObj) clears the Response Object plot represented by RespObj,
%   where RespObj is any response object handle. 

%   CLA(RespObj,ChildFlag) indicates if the any lower level GUIs
%   should be closed when the response plot is cleared. By default, 
%   ChildFlag is 1 and the I/O Selector and Array Selector are closed. 
%   For the LTI Viewer, these windows are left open when toggling 
%   between response plot types.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly 1-27-98.
% $Revision: 1.6 $

% Overloaded CLA for Response Objects

error(nargchk(1,2,nargin));

if isequal(nargin,1),
   Childflag=1;
end

LTIdisplayAxes = get(RespObj,'PlotAxes');
ResponseHandles = get(RespObj,'ResponseHandles');

%---Close any I/O selector
UIcontextMenu = get(RespObj,'UIcontextMenu');
SelectorHandle = get(RespObj.UIContextMenu.ChannelMenu,'UserData');
if ishandle(SelectorHandle) & Childflag,
   close(SelectorHandle)
end % if ishandle(SelectorHandle)

%---Close any array selector
UIcontextMenu = get(RespObj,'UIcontextMenu');
ArrayHandle = get(RespObj.UIContextMenu.ArrayMenu,'UserData');
if ishandle(ArrayHandle) & Childflag,
   %---Must delete the Array Selector since its CloseRequestFcn was reset
   delete(ArrayHandle)
end % if ishandle(SelectorHandle)

%---Clear out any DeleteFcn's from the Response Handles
if ~isempty(ResponseHandles)
   for ctRH=1:length(ResponseHandles),
      RH=ResponseHandles{ctRH};
      if iscell(RH), RH=cat(1,RH{:}); end,
      if iscell(RH), RH=cat(1,RH{:}); end,
      set(RH(ishandle(RH)),'DeleteFcn','')
   end
end

%---Delete the LTI displayAxes;
delete(LTIdisplayAxes(ishandle(LTIdisplayAxes)));

%---Erase the BackgroundAxes labels
BackgroundAxes = get(RespObj,'BackgroundAxes');
L = findobj(BackgroundAxes,'Tag','BackgroundResponseObjectLine');
set(L,'DeleteFcn','');
delete(L)
set(get(BackgroundAxes,'Ylabel'),'string','');
set(get(BackgroundAxes,'Xlabel'),'string','');
set(get(BackgroundAxes,'Title'),'string','');

%---Turn BackgroundAxes visibile and turn off any hold
set(BackgroundAxes,'visible','on','Nextplot','replace')