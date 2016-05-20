function RespObj = gcr(varargin);
%GCR Get handle to the current Response Object
%   R = GCR returns the handle of the current Response Object.
%   The current Response Object is the response plotted to the
%   current axis.  If the current axis does not contain a Response  
%   Object, R is empty.
%
%   To get a different Response Object, click in the axis
%   containing the response plot.
%
%   R = GCR(H) Returns the Response Object plotted to the axis 
%   with handle H.
%
%   See also GCA
% $Revision: 1.3.1.2 $

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   Karen Gondoly 2-19-98.

ni=nargin;
error(nargchk(0,1,ni))

if ni,
   ax = varargin{1};
   if ~ishandle(ax) | ~strcmp(get(ax,'type'),'axes'),
      error('Invalid axis handle passed to GCR');
   end
else
   ax = gca;
end % if ni,

%---Get UicontextMenu and its UserData
L = findobj(ax,'Tag','BackgroundResponseObjectLine'); 
if ~isempty(L), % It's a BackgroundAxes, look for an appropriate Plot Axes
   fig = get(ax,'Parent');
   PlotAxes = findobj(fig,'Tag','LTIdisplayAxes');
   udP = get(PlotAxes,{'UserData'});
   for ctAx=1:length(PlotAxes)
      if isequal(ax,udP{ctAx}.Parent),
         ax = PlotAxes(ctAx);
         break
      end
   end
end
u = get(ax,'UIcontextMenu');

if ~isempty(u),
   R = get(u,'UserData');
else
   R=[];
end

%---Check if UserData is the Response Object
if isa(R,'response')
   RespObj = R;
else
   RespObj = [];
end
