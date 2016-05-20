function varargout = sgrid(zeta,wn)
%SGRID  Generate s-plane grid lines for a root locus or pole-zero map.
%   SGRID generates a grid over an existing continuous s-plane root 
%   locus or pole-zero map.  Lines of constant damping ratio (zeta)
%   and natural frequency (Wn) are drawn in.
%   
%   If the current figure is empty, SGRID plots the s-plane grid 
%   and turns the HOLD ON so that the root locus or pole-zero map 
%   can be plotted over the grid.
%
%   SGRID(Z,Wn) plots constant damping and frequency lines for the 
%   damping ratios in the vector Z and the natural frequencies in the
%   vector Wn.
%
%   See also: RLOCUS, ZGRID and PZMAP.

% Old help
%   SGRID('new') is still supported but is obsolete
%
%   SGRID('new') clears the graphics screen before plotting the 
%   s-plane grid so that the root locus or pole-zero map can be 
%   plotted over the grid using (for example):
%
%       sgrid('new')
%       hold on
%       rlocus(num,den) or pzmap(num,den)
%

%   Clay M. Thompson
%   Revised ACWG 6-21-92, AFP 10-15-94
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.7.1.2 $  $Date: 1999/01/05 15:23:07 $

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

if ni==0,   % Use existing axis limits
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
            disp('Use sgrid(''new'') to clear the figure.');
            return
         end % if ishandle(NewAx);
      end % if ~isempty(RespObj)
   end % if ~isempty(BackgroundFlag)
   
   limits = [get(ax,'XLim') get(ax,'YLim')];
   set(ax,'XLim',limits(1:2),'YLim',limits(3:4),'NextPlot','add')
   set(get(ax,'Parent'),'NextPlot','add')
   
   % Round-up axis limits but try to get more than one natuaral frequency lines in axes
   wmax = 10 .^round(log10(2*max(abs(limits))));
   dx = wmax/10;
   wn= 0:dx:wmax;
   zeta = [ 0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1 ];
   
elseif ni==1,   % Standard scale
   set(ax,'NextPlot','replace')
   wn = 0:1:10;
   zeta = [ 0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1 ];
   
else
   hold on
end

NanMat = NaN;
Color = get(ax,'XColor');
gridlines = [];
if ~isempty(wn),  % Plot natural frequency lines
   zx = 0:.01:1;
   [w,z] = meshgrid(wn,zx);
   [mcols, nrows] = size(z);
   NanRow = NanMat(ones(1,nrows));
   re = [-w.*z; NanRow];
   re = re(:);
   im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
   im = im(:);
   gridlines = plot([re; re],[im; -im],'LineStyle',':','Color',Color, ...
      'Parent',ax,'Tag','CSTgridLines');
   hold on
end

if ~isempty(zeta), % Plot damping lines
   limits = [get(ax,'XLim') get(ax,'YLim')];
   [w,z] = meshgrid([0;wn(:);2*max(limits(:))]',zeta);
   w = w';
   z = z';
   [mcols, nrows] = size(z);
   NanRow = NanMat(ones(1,nrows));
   re = [-w.*z; NanRow];
   re = re(:);
   im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
   im = im(:);
   templines = plot([re; re],[im; -im],'LineStyle',':','Color',Color,...
      'Parent',ax,'Tag','CSTgridLines');
   
   gridlines = [gridlines;templines];
   % Uncomment the following lines if you want damping ratio lines labeled.
   % Now put wn labels on the curve
   %n = mcols+1;
   %for i = 1:nrows,
   %  text(re(n*(i-1)+nrows),im(n*(i-1)+nrows),sprintf('%.3g',zeta(nrows-i+1)))
   %end
end

if (ni~=1) & (~status),
   % Return hold to previous status
   set(ax,'NextPlot','replace')
end

% Turn the menu on and store the grid lines, if plotted on a RespObj
if ResponseFlag,
   set(RespObj,'GridLines',gridlines)
   CM = get(RespObj,'UIcontextMenu');
	set(CM.GridMenu,'Checked','on');   
end % if ResponseFlag

if nargout,
   varargout{1} = gridlines;
end

% end sgrid
