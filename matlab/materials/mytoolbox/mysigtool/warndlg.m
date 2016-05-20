function varargout = warndlg(WarnString,DlgName,Replace)
%WARNDLG Warning dialog box.
%  HANDLE = WARNDLG(WARNSTRING,DLGNAME) creates an warning dialog box
%  which displays WARNSTRING in a window named DLGNAME.  A pushbutton
%  labeled OK must be pressed to make the warning box disappear.
%  
%  HANDLE = WARNDLG(WARNSTRING,DLGNAME,CREATEMODE) allows CREATEMODE options
%  that are the same as those offered by MSGBOX.  The default value
%  for CREATEMODE is 'non-modal'.
%
%  WARNSTRING may be any valid string format.  Cell arrays are
%  preferred.
%
%  See also MSGBOX, HELPDLG, QUESTDLG, ERRORDLG.

%  Author: L. Dean
%  Copyright (c) 1984-98 by The MathWorks, Inc.
%  $Revision: 5.12 $  $Date: 1998/03/10 14:29:05 $

if nargin==0,
   WarnString = 'This is the default warning string.';
end
if nargin<2,
   DlgName = 'Warning Dialog';
end
if nargin<3,
   Replace = 'non-modal';
end

handle = msgbox(WarnString,DlgName,'warn',Replace);
set(findobj(gcf,'Tag','MessageBox'),'Fontsize',9,'Fontname','¿¬Êé')
if nargout==1,varargout(1)={handle};end
