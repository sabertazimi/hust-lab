function viewresz(ViewerObj);
% VIEWRESZ Resize the LTI Viewer

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/21 16:20:43 $

FigPos = get(ViewerObj.Handle,'Position');

SFPos = get(ViewerObj.StatusFrame,'Position');
set(ViewerObj.StatusFrame,'Position',[SFPos(1:2),FigPos(3)-6,SFPos(4)])

STPos = get(ViewerObj.StatusText,'Position');
set(ViewerObj.StatusText,'Position',[STPos(1:2),FigPos(3)-8,STPos(4)])