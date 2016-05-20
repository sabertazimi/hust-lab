function delresp(ResponseLine);
%DELRESP Delete Response Objects from the command line
%
%  DELRESP(ResponseLine) deletes all axes associated with 
%  the Response Object for the response line with handle 
%  ResponseLine except for the axes containing the line.

%   Karen Gondoly, 7-8-98
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:20:44 $

if ishandle(ResponseLine),
   
   if isequal(get(ResponseLine,'Tag'),'BackgroundResponseObjectLine'),
      %---Invoked from the BackgroundAxes
      ContextMenu = get(ResponseLine,'UserData');
      if ishandle(ContextMenu)
         RespObj = get(ContextMenu,'UserData');
         if isa(RespObj,'response')
            cla(get(ContextMenu,'UserData'));
         end % if isa(RespObj,'response')
      end % if ishandle(ContextMenu)
      
   else, % Invoked from a PlotAxes   
      CallBackAx=get(ResponseLine,'Parent');
      if ishandle(CallBackAx),
         udAx = get(CallBackAx,'UserData');
         if ishandle(udAx.Parent),
            set(udAx.Parent,'Unit','Norm');
            BackPos = get(udAx.Parent,'Position');
            L = findobj(udAx.Parent,'Tag','BackgroundResponseObjectLine');
            ContextMenu = get(L,'UserData');
            
            %---Close any I/O selector
            if ishandle(ContextMenu)
               RespObj = get(ContextMenu,'UserData');
               RespMenu = get(RespObj,'UIcontextMenu');
               SelectorHandle = get(RespMenu.ChannelMenu,'UserData');
               if ishandle(SelectorHandle),
                  close(SelectorHandle)
               end % if ishandle(SelectorHandle)
               
               %---Close any array selector
               ArrayHandle = get(RespMenu.ArrayMenu,'UserData');
               if ishandle(ArrayHandle),
                  %---Must delete the Array Selector since its CloseRequest
                  %      function has been reset
                  delete(ArrayHandle)
               end % if ishandle(SelectorHandle)
            end % if ishandle(ContextMenu)
            
            %---Delete all axes
            DispAx = udAx.Siblings(:);
            DispAx = DispAx(ishandle(DispAx));
            if ~isempty(DispAx)
               LTIlines = findobj(DispAx,'Tag','LTIresponseLines');
               set(LTIlines,'DeleteFcn','');
               DispAx = setdiff(DispAx,CallBackAx);
               delete(DispAx)
            end
            
            set(L,'DeleteFcn','');
            delete(udAx.Parent)
            
            %---Make PlotAxes cover BackgroundAxes area
            set(CallBackAx,'Unit','Norm','Position',BackPos);
            
         end % if ishandle(udAx.Parent)
         if isequal(CallBackAx,gca),
            %---Reset the axes if it is still around. If the figure was destroyed
            %    the current axes is no longer the CallBackAx
            cla reset; % Remove all other PlotAxes settings and lines
            set(CallBackAx,'FontSize',get(0,'DefaultAxesFontSize'), ...
               'UIcontextMenu',[])
         end % if isequal(CallBackAx,gca)
      end % if ishandle(CallBackAx)
   end % if/else isequal(Tag...) 
      
end % if ishandle(ResponseLine)
