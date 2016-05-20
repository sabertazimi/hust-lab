function varargout = errordlg(ErrorString,DlgName,Replace)
%ERRORDLG Error dialog box.
%  HANDLE = ERRORDLG(ErrorString,DlgName,CREATEMODE) creates an 
%  error dialog box which displays ErrorString in a window 
%  named DlgName.  A pushbutton labeled OK must be pressed 
%  to make the error box disappear.  
%
%  ErrorString will accept any valid string input but a cell 
%  array is preferred.
%
%  ERRORDLG uses MSGBOX.  Please see the help for MSGBOX for a
%  full description of the input arguments to ERRORDLG.
%  
%  See also MSGBOX, HELPDLG, QUESTDLG, WARNDLG.

%  Author: L. Dean
%  Copyright (c) 1984-98 by The MathWorks, Inc.
%  $Revision: 5.17 $  $Date: 1998/03/10 14:29:03 $

NumArgIn = nargin;
if NumArgIn==0,
   ErrorString = {'This is the default error string.'};
end

if NumArgIn<2,  DlgName = 'Error Dialog'; end
if NumArgIn<3,  Replace='non-modal'     ; end

% Backwards Compatibility
if ischar(Replace),
  if strcmp(Replace,'on'),
    Replace='replace';
  elseif strcmp(Replace,'off'),
    Replace='non-modal';
  end
end

handle = msgbox(ErrorString,DlgName,'error',Replace);
set(findobj(gcf,'Tag','MessageBox'),'Fontsize',9,'Fontname','¿¬Êé')
if nargout==1,varargout(1)={handle};end
