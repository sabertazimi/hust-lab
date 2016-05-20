function varargout = zgrid(zeta,wn,s)
%ZGRID  Generate z-plane grid lines for a root locus or pole-zero map.
%   ZGRID generates a grid over an existing discrete z-plane root 
%   locus or pole-zero map.  Lines of constant damping factor (zeta)
%   and natural frequency (Wn) are drawn in within the unit Z-plane 
%   circle.
%
%   If the current figure is empty, ZGRID plots the z-plane grid  
%   and sets the HOLD ON so that the root locus or pole-
%   zero map can be plotted over the grid.
%
%   ZGRID(Z,Wn) plots constant damping and frequency lines for the 
%   damping ratios in the vector Z and the natural frequencies in the
%   vector Wn.  ZGRID(Z,Wn,'new') clears the screen first.
%
%   See also: RLOCUS, SGRID, and PZMAP.

% Old help
%   ZGRID('new') is still supported but is obsolete
%
%   ZGRID('new') clears the graphics screen before plotting the 
%   z-plane grid and sets the HOLD ON so that the root locus or pole-
%   zero map can be plotted over the grid using (for example):
%
%       zgrid('new')
%       rlocus(num,den) or pzmap(num,den)

%   Marc Ullman   May 27, 1987
%   Revised JNL 7-10-87, CMT 7-13-90, ACWG 6-21-92
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.7.1.2 $  $Date: 1999/01/05 15:23:17 $

ni = nargin;
status = ishold;
ax = gca;
ResponseFlag = 0;

%---Check if the current axis is empty
%---if so, act as if sgrid('new') was invoked
kids = get(ax,'children');
if ( isempty(kids) ) & ( ni==0 ),
   ni = 1;
end

if ni==0,   % Plot on existing graph
   %---See if the existing axes is a RespObj BackgroundAxes by checking
   % the kids' tags for 'BackgroundResponseObjectLine'
   % If so, change the "ax" to the PlotAxes
   KidTags = get(kids,{'tag'});         
   BackgroundFlag = find(strcmp(KidTags,'BackgroundResponseObjectLine'));
   if ~isempty(BackgroundFlag),
      try
         %---Wrap in a try. If there's an error, just use the previous axes
         ContextMenu = get(kids(BackgroundFlag),'UserData');
         RespObj = get(ContextMenu,'UserData');
         NewAx = get(RespObj,'PlotAxes');
      end
      %---Check that this is a valid axes handle
      if ishandle(NewAx)
         ax=NewAx;
      end
   end
   
   if strcmp(get(ax,'Tag'),'LTIdisplayAxes'),
      % Check if this is a pzmap Response Object
      ContextMenu = get(ax,'UIcontextMenu');
      RespObj = get(ContextMenu,'UserData');
      %---Check that this is a pole-zero map
      if ~isempty(RespObj),
         if strcmp(get(RespObj,'ResponseType'),'pzmap'),
            ResponseFlag = 1;
            if ~strcmp(get(RespObj,'Grid'),'on'),
               ax = get(RespObj,'PlotAxes');
               set(gcf,'CurrentAxes',ax)
            else
               return
            end               
         else,
            disp('There is no pole-zero map on the current figure.');
            disp('Use zgrid(''new'') to clear the figure.');
            return
         end % if ishandle(NewAx);
      end % if ~isempty(RespObj)
   end % if ~isempty(BackgroundFlag)
   
   zeta = 0:.1:.9;
   wn = 0:pi/10:pi;
   axis(axis)
   hold on
   
elseif ni==1, % Clear screen then plot standard grid
   zeta = 0:.1:.9;
   wn = 0:pi/10:pi;
   hold off
   
elseif ni==2, % Use zeta and wn specified
   hold on
   
elseif ni==3, % Clear screen and use zeta and wn specified
   hold off
end

Color = get(ax,'XColor');

% Plot Unit circle
t=0:.1:6.3;
gridlines = plot(sin(t),cos(t),'LineStyle','-','Color',Color, ...
   'Parent',ax,'Tag','CSTgridLines');
hold on

% Plot damping lines
NanMat = NaN;
I = sqrt(-1);
if ~isempty(zeta),
   m = tan(asin(zeta)) +sqrt(-1);
   Ones = ones(1,length(m));
   zz = [exp((0:pi/20:pi)'*(-m)); NanMat(Ones)];
   zz = zz(:);
   rzz = real(zz);
   izz = imag(zz);
   templines = plot([rzz; rzz],[izz; -izz],'LineStyle',':','Color',Color, ...
      'Parent',ax,'Tag','CSTgridLines');
   gridlines = [gridlines;templines];
end

% Plot natural frequency lines
if ~isempty(wn),
   e_itheta = exp(sqrt(-1)*(pi/2:pi/20:pi)');
   e_r = exp(wn);
   Ones = ones(1,length(e_r));        
   zz = [(ones(length(e_itheta),1)*e_r).^(e_itheta*Ones); NanMat(Ones)];
   zz = zz(:);
   rzz = real(zz);
   izz = imag(zz);
   templines = plot([rzz; rzz],[izz; -izz],'LineStyle',':','Color',Color, ...
      'Parent',ax,'Tag','CSTgridLines');
   gridlines = [gridlines;templines];
end

% Return hold to previous status
if ( (ni==0) | (ni==2) ) & ~status, 
   hold off
end

% Turn the menu on and store the grid lines, if plotted on a RespObj
if ResponseFlag,
   set(RespObj,'GridLines',gridlines)
   CM = get(RespObj,'UIcontextMenu');
	set(CM.GridMenu,'Checked','on');   
end % if ResponseFlag

if nargout,
   varargout{1}=gridlines;
end

% end zgrid
