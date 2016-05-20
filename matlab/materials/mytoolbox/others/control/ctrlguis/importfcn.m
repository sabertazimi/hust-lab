function varargout = importfcn(varargin);
%IMPORTFCN contains functions standard to all CODA Import windows
%   DATA = IMPORTFCN(ACTION,ImportFig) performs the action specified by
%   the string ACTION on the Import figure with handle ImportFig. The 
%   output returned in DATA depends on which action is entered.  

%   Possible ACTIONS:
%   1) browsesim, broswemat: Opens a standard MATLAB browser for locating a 
%                            Simulink diagram or MAT-file
%   2) buttoncallback: Performs the actions for the arrow buttons
%   3) editcallback: Performs the actions for the Data edit boxes
%   4) matfile: Performs the actions for the MAT-file radio button
%   5) namecallback: Performs the actions for the Name edit boxes
%   6) simulink: Performs the actions for the Simulink radio button
%   7) workspace: Performs the actions for the Workspace radio button

%   Karen D. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.5 $

ni=nargin;
no = nargout;
error(nargchk(2,2,ni));
action = lower(varargin{1});
ImportFig = varargin{2};
if ~ishandle(ImportFig),
   error('The second input argument must be a valid figure handle.');
end
udImport = get(ImportFig,'UserData');

switch action
   
case {'browsesim','browsemat'}
   switch action
   case 'browsesim',
      filterspec = '*.mdl';
   case 'browsemat',
      filterspec = '*.mat';
   end
   
   udFileEdit = get(udImport.Handles.FileNameEdit,'UserData');
   LastPath = udFileEdit.PathName;
   CurrentPath=pwd;
   if ~isempty(LastPath),
      cd(LastPath);
   end
   [filename,pathname] = uigetfile(filterspec,'Import file:');
   if ~isempty(LastPath),
      cd(CurrentPath);
   end
   
   if filename,
      if ~strcmpi(pathname(1:end-1),CurrentPath)
         ImportStr = [pathname,filename(1:end-4)];
      else
         ImportStr = filename(1:end-4);
      end
      set(udImport.Handles.FileNameEdit,'String',ImportStr);
      switch action
      case 'browsesim',
         importfcn('simulink',ImportFig);
      case 'browsemat',
         importfcn('matfile',ImportFig);
      end
   end
   
case 'buttoncallback',
   %---Callback for the Arrow Buttons
   EditBox = get(gcbo,'UserData');
   AllNames = get(udImport.Handles.ModelList,'String');
   if ~isempty(AllNames), % Make sure these is something in the list
      SelectedName = get(udImport.Handles.ModelList,'Value');
      udEdit = get(EditBox ,'UserData');
      udEdit.String = AllNames{SelectedName};
      udEdit.ListIndex = SelectedName;
      set(EditBox,'String',AllNames{SelectedName},'UserData',udEdit);
   end
   
case 'clearpath',
   %---Callback for the FileNameEdit box
   %    Whenever a new name is entered, update the Userdata
   NewName = get(gcbo,'String');
   indDot = findstr(NewName,'.');
   if ~isempty(indDot),
      NewName=NewName(1:indDot(end)-1);
      set(udImport.Handles.FileNameEdit,'String',NewName)   
   end
      
case 'editcallback',
   %---Callback for the Plant, Sensor, Filter, Compensator Edit boxes
   %---These boxes should contain an index into the List Box string
   %---The Index should be zero when a scalar or LTI constructor is entered
   TryString = get(gcbo,'String');
   udEdit = get(gcbo,'UserData');
   
   if isempty(TryString), % empty value, leave it that way
      udEdit.ListIndex=[];
      udEdit.String='';
   else      
      IndList = strmatch(TryString,udImport.ListData.Names,'exact');
      
      if isempty(IndList),
         %---See if a scalar or LTI constructor was entered
         tempval = eval(TryString,'''nogood''');
         if isa(tempval,'lti') | ...
               ( ~ischar(tempval) & isequal(length(tempval),1) );
            udEdit.String=TryString;
            udEdit.ListIndex=0;
         else, % Revert to last valid entry
            if isempty(udEdit.ListIndex),
               set(gcbo,'String','');
            else
               set(gcbo,'String',udEdit.String);
            end, %if/else isempty(udEdit)
            WarnStr=['You must enter either a variable from the List box or ',...
                  'a scalar, or construct an lti object.'];
            warndlg(WarnStr,'Import Warning');
         end % if/else isa(lti...
      else, % Store the list index
         udEdit.ListIndex=IndList;
         udEdit.String=TryString;
      end % if/else isempty(IndList);
   end % if/else isempty(TryString);
   set(gcbo,'UserData',udEdit);
   
case 'matfile',
   set(udImport.Handles.ModelText,'string','MAT-file Contents');
   set([udImport.Handles.FileNameText,...
         udImport.Handles.FileNameEdit,...
         udImport.Handles.BrowseButton],'enable','on');
   set(udImport.Handles.FileNameText,'String','MAT-file name:');
   set(udImport.Handles.BrowseButton,'Callback','importfcn(''browsemat'',gcbf);');
   set(udImport.Handles.FileNameEdit,...
      'Callback','importfcn(''clearpath'',gcbf);importfcn(''matfile'',gcbf);');
   
   FileName = get(udImport.Handles.FileNameEdit,'String');   
   if isempty(FileName),
      Data=struct('Names','','Objects',[]);
   else
      try
         load(FileName);
         WorkspaceVars=whos;
         sysvar=cell(size(WorkspaceVars));
         s=0;
         for ct=1:size(WorkspaceVars,1),
            VarClass=WorkspaceVars(ct).class;
            if ((strcmp(VarClass,'ss')) | (strcmp(VarClass,'tf')) | (strcmp(VarClass,'zpk')) ) &...
                  isequal(2,length(WorkspaceVars(ct).size)),
               % Only look for Non-array (TF, SS, and ZPK) LTI objects
               s=s+1;
               sysvar(s)={WorkspaceVars(ct).name};
            end % if isa
         end % for ct
         sysvar=sysvar(1:s);
         
         DataObjects = cell(2,1);
         for ctud=1:s,
            DataObjects{ctud} = eval(sysvar{ctud});
         end % for
         Data = struct('Names',{sysvar},'Objects',{DataObjects});
         
      catch
         warndlg(lasterr,'Import Warning'); 
         set(udImport.Handles.FileNameEdit,'String','');
         FileName='';
         Data=struct('Names','','Objects',[]);
      end % try/catch
   end % if/else check on FileName
   
   LocalFinishLoad(ImportFig,udImport,FileName,Data)
   
case 'namecallback',
   %---Callback for the Name Edit field
   newname=get(gcbo,'String');
      
   if isempty(newname) | ... % New name is empty
         ~isnan(str2double(newname(1))) | ... % New name starts with a number
         ~isempty(find(real(newname)==32)); % Name has blanks
      set(gcbo,'String',get(gcbo,'UserData'));
   else
      set(gcbo,'UserData',newname);
   end

case 'simulink',
   set(udImport.Handles.ModelText,'string','LTI Blocks');
   set([udImport.Handles.FileNameText,...
         udImport.Handles.FileNameEdit,...
         udImport.Handles.BrowseButton],'enable','on');
   set(udImport.Handles.FileNameText,'String','Simulink Diagram:');
   set(udImport.Handles.BrowseButton,'Callback','importfcn(''browsesim'',gcbf);');
   set(udImport.Handles.FileNameEdit,...
      'Callback','importfcn(''clearpath'',gcbf);importfcn(''simulink'',gcbf);');
   
   FullName = get(udImport.Handles.FileNameEdit,'String');   
   
   [PathName,FileName]=fileparts(FullName);
   %---First, see if a model with the same name is already open.
   AllDiags = find_system('Type','block_diagram');
   indOpen = find(strcmpi(FileName,AllDiags));
   if ~isempty(indOpen),
      switch questdlg({'A Simulink model with the same name is already open.'; ...
               ''; ...
               'Do you want to replace the open model with the specified model?'}, ...
            'Import Warning','Yes','No','Cancel','Yes');
      case 'Cancel',
         %---Reset FileNameEdit Box to previous string
         udNames = get(udImport.Handles.FileNameEdit,'UserData');
         if ~strcmpi(udNames.PathName(1:end-1),pwd)
            ImportStr = [udNames.PathName,udNames.FileName];
         else
            ImportStr = udNames.FileName;
         end
         set(udImport.Handles.FileNameEdit,'String',ImportStr);
         FullName='';
      case 'Yes',
         switch get_param(AllDiags{indOpen},'dirty'),
         case 'on',
            switch questdlg(['Save ',AllDiags{indOpen},' before closing?'],...
                  ['Closing ',AllDiags{indOpen}],'Yes','No','Cancel','Yes'),
            case 'Yes',
               SaveFlag = 1;
            case 'No',
               SaveFlag = 0;
            case 'Cancel',
               return
            end % switch questdlg
            case 'off',
               SaveFlag = 0
         end % switch dirty
         close_system(AllDiags{indOpen},SaveFlag);
      case 'No',
         %---Reset FileNameEdit Box to previous string
         set(udImport.Handles.FileNameEdit,'String',FileName);
         FullName=FileName;
      end
   end % if ~isempty(indOpen)
   
   if ~isempty(FullName)
      try,
         %---Open the model, or catch a bad model name
         Data=struct('Names','','Objects',[]);
         evalc('open_system(FullName)');
         
         %---Read all LTI blocks out of the Simulink diagram
         LTIblocks = find_system(FileName,'MaskType','LTI Block');
         DataNames = char(LTIblocks);
         
         %---Remove newline and carriage returns
         AsciiVals = real(DataNames);
         if ~isempty(DataNames),
            DataNames(find(AsciiVals==10 | AsciiVals==13))='_';
            DataNames = cellstr(DataNames(:,length(FileName)+2:end));
         end
         
         DataObjects = cell(length(LTIblocks),1);
         
         MaskStrs = get_param(LTIblocks,'MaskValueString');
         
         BadBlockFlag = 0;
         for ct=1:length(MaskStrs)
            BarInd = findstr(MaskStrs{ct},'|');
            DataObjects{ct} = evalin('base',MaskStrs{ct}(1:BarInd-1),'[]');
            if isempty(DataObjects{ct}),
               warndlg('One of the LTI Blocks contains an invalid LTI Object.',...
                  'Import Warning');
               BadBlockFlag = 1;
            end
         end % for ct
         
         if ~BadBlockFlag,
            Data.Names = DataNames;
            Data.Objects = DataObjects;
         end
         
      catch
         warndlg(lasterr,'Import Warning');
         set(udImport.Handles.FileNameEdit,'String','');
         Data=struct('Names','','Objects',[]);
      end, % try/catch
      
      LocalFinishLoad(ImportFig,udImport,FullName,Data)
      
   end % if ~isempty(FileName)
   
case 'workspace',
   set(udImport.Handles.ModelText,'string','Workspace Contents');
   set([udImport.Handles.FileNameText,...
         udImport.Handles.FileNameEdit,...
         udImport.Handles.BrowseButton],'enable','off');
   
   %----Look for all workspace variables of class 'ss', 'tf', or 'zpk'
   WorkspaceVars=evalin('base','whos');
   sysvar=cell(size(WorkspaceVars));
   s=0;
   for ct=1:size(WorkspaceVars,1),
      VarClass=WorkspaceVars(ct).class;
      if ((strcmp(VarClass,'ss')) | (strcmp(VarClass,'tf')) | (strcmp(VarClass,'zpk')) ) &...
            isequal(2,length(WorkspaceVars(ct).size)),
         % Only look for Non-array (TF, SS, and ZPK) LTI objects
         s=s+1;
         sysvar(s,1)={WorkspaceVars(ct).name};
      end % if isa
   end % for ct
   sysvar=sysvar(1:s,1);
   
   DataObjects = cell(s,1);
   for ctud=1:s,
      DataObjects{ctud} = evalin('base',sysvar{ctud});
   end
   
   Data = struct('Names',{sysvar},'Objects',{DataObjects});
   
   set(udImport.Handles.ModelList,'String',sysvar)
   
   %---Update the Import Figure Userdata
   udImport.ListData=Data;
   set(ImportFig,'UserData',udImport);
      
end % switch action


%-----------------------------Internal Functions--------------------------
%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalFinishLoad %%%
%%%%%%%%%%%%%%%%%%%%%%%
function LocalFinishLoad(ImportFig,udImport,FileName,Data)

%---Update the FileNameEdit Userdata
[P,F]=fileparts(FileName);
udNames = get(udImport.Handles.FileNameEdit,'UserData');
udNames.PathName=P; 
udNames.FileName=F;
set(udImport.Handles.FileNameEdit,'UserData',udNames)

%---Update the Import Figure Userdata
set(udImport.Handles.ModelList,'String',Data.Names)
udImport.ListData=Data;
set(ImportFig,'UserData',udImport);

