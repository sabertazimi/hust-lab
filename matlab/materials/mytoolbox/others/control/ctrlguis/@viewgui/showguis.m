function showguis(ViewerObj,ShowFlag);
%SHOWGUIS Hide/show the menus related to the LTI Viewer

%   Karen Gondoly, 4-6-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

error(nargchk(2,2,nargin))

set(ViewerObj.FigureMenu.ToolsMenu.ConfigMenu,'Visible',ShowFlag);
set(ViewerObj.FigureMenu.ToolsMenu.Response,'Separator',ShowFlag);

for ct=1:length(ViewerObj.UIContextMenu);
   RespObj=get(ViewerObj.UIContextMenu(ct),'UserData');
   CM=get(RespObj,'UIcontextMenu');
   set(CM.PlotType.Main,'Visible',ShowFlag)
   set(CM.Systems.Main,'Separator',ShowFlag)
end

