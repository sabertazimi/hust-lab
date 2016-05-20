function varargout = waitdlg(WaitString,DlgName,Replace)
% WAITDLG Wait dialog box.
%  HANDLE = WAITDLG(WaitString,DlgName,CREATEMODE) creates an 
%  wait dialog box which displays WaitString in a window 
%  named DlgName.    
%
%  WaitString will accept any valid string input but a cell 
%  array is preferred.
%
%  

NumArgIn = nargin;
if NumArgIn==0,
   WaitString = {'This is the default wait string.'};
end

if NumArgIn<2,  DlgName = 'Wait Dialog'; end
if NumArgIn<3,  Replace='non-modal'     ; end

% Backwards Compatibility
if ischar(Replace),
  if strcmp(Replace,'on'),
    Replace='replace';
  elseif strcmp(Replace,'off'),
    Replace='non-modal';
  end
end

Handle=figure('Menubar','none',...
   'Color',[0.8314,0.8157,0.7843],...
   'NumberTitle','off',...
   'Name',DlgName,...
   'Resize','off',...
   'unit','normalize',...
   'position',[0.3,0.4,0.4,0.15]);
backclr=get(Handle,'Color');
MsgHandle=uicontrol(Handle,'Style','text',...
   'Backgroundcolor',backclr,...
   'Units','normalize',...
   'Position',[0.05,0.1,0.9,0.8],...
   'String',WaitString,...
   'Tag','MessageBox',...
   'HorizontalAlignment','center',...
   'Fontsize',10,...
   'Fontname','¿¬Êé');
if nargout==1,varargout(1)={handle};end

