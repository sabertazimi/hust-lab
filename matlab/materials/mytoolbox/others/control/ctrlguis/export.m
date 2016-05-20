function varargout = export(varargin)
%EXPORT opens the window for exporting LTI Objects from CODA GUIs
%   EXPORT('initialize',ParentFig,ExportData) opens an Export Window
%   when issued by a callback from the GUI with handle ParentFig. The
%   data available to be exported is passed to the Export window in
%   the structured array ExportData.
%
%   ExportData = EXPORT('getdata') returns an empty structured array
%   in the form that must be passed to EXPORT.

%   Karen D. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.5 $

%---Check if number of input arguments is in the correct range
ni = nargin;
no=nargout;

error(nargchk(1,3,ni));
%---The first input argument should always be a string action
action = lower(varargin{1});
if ~ischar(action)
   error('The first input argument must be a valid string action.');
end

%---Read data based on action
switch action
case 'getdata', % Return an empty Data structure
   ExportData =struct('All',struct('Names',[],'Objects',[]),...
      'DesignModels',struct('Names',[],'Objects',[]),...
      'OpenLoop',struct('Names',[],'Objects',[]),...
      'ClosedLoop',struct('Names',[],'Objects',[]),...
      'Compensators',struct('Names',[],'Objects',[]),...
      'MatName','untitled');
   if no,
      varargout{1}=ExportData;
   end
   return
   
case 'initialize',
   ParentFig = varargin{2};
   ExportData=[];
   if ni>2,
      ExportData = varargin{3};
   end
   if isempty(ExportData),
      ExportData =struct('All',struct('Names',[],'Objects',{}),...
         'DesignModels',struct('Names',[],'Objects',{}),...
         'OpenLoop',struct('Names',[],'Objects',{}),...
         'ClosedLoop',struct('Names',[],'Objects',{}),...
         'Compensators',struct('Names',[],'Objects',{}),...
         'MatName','untitled');
   end
   
otherwise
   ExportFig = varargin{2};
   if ni>2,
      ExportUd = varargin{3};
   else
      ExportUd = get(ExportFig,'UserData');
   end
end % switch action

%---Actions
switch action
case 'initialize',
   ExportFig = LocalOpenFig(ParentFig,ExportData);
   uiwait(ExportFig)
   
   if ishandle(ExportFig)
      close(ExportFig)
   end
   
case 'disk',
   %---Callback from the Export to Disk button
   ExportVal = get(ExportUd.Handles.ModelList,'Value');
   if isempty(get(ExportUd.Handles.ModelList,'String')),
      warndlg('There are no systems to export.','Export Warning');
      return      
   end
   
   if ~isempty(ExportVal),
      
      fname = ExportUd.MatName;
      fname=[fname,'.mat']; % Revisit for CODA -- is a .mat extension already provide
      [fname,p]=uiputfile(fname,'Export to Disk');
      if fname,
         fname = fullfile(p,fname);
         eval([ExportUd.ListData.Names{ExportVal(1)}, ...
               '= ExportUd.ListData.Objects{ExportVal(1)};'])
         save(fname,ExportUd.ListData.Names{ExportVal(1)});
         for ct = 2:length(ExportVal),
            eval([ExportUd.ListData.Names{ExportVal(ct)}, ...
                  '= ExportUd.ListData.Objects{ExportVal(ct)};'])
            save(fname,ExportUd.ListData.Names{ExportVal(ct)},'-append');
         end
      end
      uiresume(ExportFig)
      
   else
      warndlg('You must select some variables in the list box','Export Warning');
   end % if/else ~isempty(ExportVal)
   
case 'workspace',
   %---Callback from the Export to Workspace button
   ExportVal = get(ExportUd.Handles.ModelList,'Value');
   if isempty(get(ExportUd.Handles.ModelList,'String')),
      warndlg('There are no systems to export.','Export Warning');
      return      
   end
   
   if ~isempty(ExportVal),
      w = evalin('base','whos');
      Wname = {w.name};
      overwrite=0;
      for CheckName = 1:length(ExportVal),
         if ~isempty(strmatch(ExportUd.ListData.Names{ExportVal(CheckName)},...
               Wname,'exact')),
            overwrite=1;
            break
         end % if ~isempty...
      end % for CheckName
      
      if overwrite
         switch questdlg(...
               {'At least one of the items you are exporting to'
               'the workspace already exists.'
               ' ';
               'Exporting will overwrite the existing variables.'
               ' '
               'Do you want to continue?'},...
               'Variable Name Conflict','Yes','No','No');
            
         case 'Yes'
            overwriteOK = 1;
         case 'No'
            overwriteOK = 0;
         end % switch questdlg
      else
         overwriteOK = 1;
      end % if/else overwrite
      
      if overwriteOK 
         for k = 1:length(ExportVal)
            assignin('base',...
               ExportUd.ListData.Names{ExportVal(k)},...
               ExportUd.ListData.Objects{ExportVal(k)});
         end % for k
      uiresume(ExportFig)   
      end
   else
      warndlg('You must select some variables in the list box','Export Warning');
      
   end % if ~isempty(ExportVal)
   
case 'makelist',
   %---Callback to make the list in the ModelList listbox based on DisplayType
   PopupData = struct('ListBoxStr',[],...
      'AllListNames',[],...
      'AllListData',[],...
      'ListIndices',struct('All',[],'DM',[],'OL',[],'CL',[],'K',[]));
   
   if ~isempty(ExportUd.All.Names), % Undesignated models
      AllListNames = ExportUd.All.Names;
      AllListObjects = ExportUd.All.Objects;
      AllNames = ExportUd.All.Names;
   else
      AllListNames={};
      AllListObjects = {};
      AllNames={};
   end
   NumAll=length(AllNames);
   
   if ~isempty(ExportUd.DesignModels.Names), % Design Models
      ModelNames= cell(size(ExportUd.DesignModels.Names));
      [ModelNames{:}]=deal('DM: ');
      ModelNames = strcat(ModelNames,ExportUd.DesignModels.Names);
      AllListNames = [AllListNames;ModelNames];
      AllNames = [AllNames;ExportUd.DesignModels.Names];
      AllListObjects = [AllListObjects;ExportUd.DesignModels.Objects];
      PopupData.ListIndices.DM = NumAll+1:NumAll+length(ModelNames); 
      NumAll=NumAll+length(ModelNames);
   end
   
   if ~isempty(ExportUd.OpenLoop.Names), % Open-loop models
      OLModelNames= cell(size(ExportUd.OpenLoop.Names));
      [OLModelNames{:}]=deal('OL: ');
      OLModelNames = strcat(OLModelNames,ExportUd.OpenLoop.Names);
      AllListNames = [AllListNames;OLModelNames];
      AllNames = [AllNames;ExportUd.OpenLoop.Names];
      AllListObjects = [AllListObjects;ExportUd.OpenLoop.Objects];
      PopupData.ListIndices.OL = NumAll+1:NumAll+length(OLModelNames);     
      NumAll=NumAll+length(OLModelNames);
   end
   
   if ~isempty(ExportUd.ClosedLoop.Names), % Closed-loop models
      CLModelNames= cell(size(ExportUd.ClosedLoop.Names));
      [CLModelNames{:}]=deal('CL: ');
      CLModelNames = strcat(CLModelNames,ExportUd.ClosedLoop.Names);
      AllListNames = [AllListNames;CLModelNames];
      AllNames = [AllNames;ExportUd.ClosedLoop.Names];
      AllListObjects = [AllListObjects;ExportUd.ClosedLoop.Objects];
      PopupData.ListIndices.CL = NumAll+1:NumAll+length(CLModelNames);     
      NumAll=NumAll+length(CLModelNames);
   end
   
   if ~isempty(ExportUd.Compensators.Names), % Compensators
      CompNames= cell(size(ExportUd.Compensators.Names));
      [CompNames{:}]=deal('K: ');
      CompNames = strcat(CompNames,ExportUd.Compensators.Names);
      AllListNames = [AllListNames;CompNames];
      AllNames = [AllNames;ExportUd.Compensators.Names];
      AllListObjects = [AllListObjects;ExportUd.Compensators.Objects];
      PopupData.ListIndices.K = NumAll+1:NumAll+length(CompNames);     
      NumAll=NumAll+length(CompNames);
   end
   
   PopupData.ListIndices.All=1:NumAll;
   PopupData.ListBoxStr = AllListNames;
   PopupData.AllListNames = AllNames;
   PopupData.AllListData = AllListObjects;
   
   set(ExportUd.Handles.TypePopup,'UserData',PopupData);   
   set(ExportUd.Handles.ModelList,'String',AllListNames);
   
   ExportUd.ListData.Names = AllNames;   
   ExportUd.ListData.Objects = AllListObjects;   
   set(ExportFig,'UserData',ExportUd)

case 'changelist',
   %---Callback to change the list in the ModelList listbox based on DisplayType
   DisplayType = popupstr(ExportUd.Handles.TypePopup);
   PopupData = get(ExportUd.Handles.TypePopup,'UserData');
   
   if ~isempty(PopupData.ListBoxStr),
      %---Get previously selected names;
      ListVals = get(ExportUd.Handles.ModelList,'Value');
      OldString = get(ExportUd.Handles.ModelList,'String');
      
      switch DisplayType(1:3),
      case 'All', % All
         DataInd = PopupData.ListIndices.All;
      case 'Des', % Design Models
         DataInd = PopupData.ListIndices.DM;
      case 'Ope', % Open-loop Models
         DataInd = PopupData.ListIndices.OL;
      case 'Clo', % Closed-loop Models
         DataInd = PopupData.ListIndices.CL;
      case 'Com', % Compensators
         DataInd = PopupData.ListIndices.K;
      end % switch DisplayType
      
      %---Reset the selected values
      NewString = PopupData.ListBoxStr(DataInd);
      NewVals=[];
      for ctVal=1:length(ListVals),
         NewVals=[NewVals;strmatch(OldString(ListVals(ctVal)),NewString)];
      end % for ctVal
      if isempty(NewVals)
         NewVals=1;
      end
      
      ExportUd.ListData.Names = PopupData.AllListNames(DataInd);   
      ExportUd.ListData.Objects = PopupData.AllListData(DataInd);   
      set(ExportUd.Handles.ModelList,'String',PopupData.ListBoxStr(DataInd),...
         'Value',NewVals);
      set(ExportFig,'UserData',ExportUd)
   end, % if ~isempty(...
   
case 'cancel',
   %---Cancel button callback
   uiresume(ExportFig)
   
case 'help',
   %---Help Button callback
   helptext={'Exporting', ...
         {'The Export window is used to export a LTI models from any of ';
         'the Graphical User Interfaces in the MATLAB Control Design and';
         'Analysis environment';
         '';
         'Data can be exported to:';
         '  1) The MATLAB workspace';
         '  2) A MAT-file';
         '';
         'To export data';
         '  1) Select the data in the Export List';
         '  2) Press the appropriate Export Button';
         '';
         'Press Cancel to close the window without exporting any data.';
         '';
         'Flip through the remaining Topics for a detailed description of how ';
         'to export data.'};
      'Export List',...
         {'The Export List shows all the models available to be exported.';
         'The list is derived from the GUI used to open the Export window';
         '';
         'This data can be in one of five forms:';
         '   1) Design Models - A data structure containing all design model elements';
         '   2) Open-loop Models - Open-loop models (K*P*H) stored as LTI objects';
         '   3) Closed-loop Models - Closed-loop models stored as LTI objects';
         '   4) Compensators - LTI compensator';
         '   5) Undesignated - Models that do not fit into one of the previous four';
         '                     categories. Shown only when ALL is selected';
         '';
         'You may select any number of variables in this list to export.';
         'Data is always exported to the variable names shown in the list box.';
         '';
         'In the case of the Design Models, data is exported in this structure:';
         '';
         '    DesignModelName = Name;';
         '                      Plant: Name';
         '                             Object';
         '                      Sensor: Name';
         '                             Object';
         '                      Filter: Name';
         '                             Object';
         '                      Structure';
         '                      FeedbackSign';
         ''
         'Where:';
         '    Structure = 1: Compensator in the Forward Path';
         '              = 2: Compensator in the Feedback Path';
         ''
         '    FeedbackSign = 1: Positive Feedback';
         '                 =-1: Negative Feedback'};
      'Show menu',...
         {'The Show menu allows you to filter what data is contained in the ';
         'Export list.';
         '';
         'You may choose to show:';
         '   1) All: (Undesignated models, design models, compensators, and';
         '            open- and closed-loop models)';
         '   2) Design Models (only)';
         '   3) Open-loop Models (only)';
         '   4) Closed-loop Models (only)';
         '   5) Compensators (only)';
         ' ';
         'Undesignated models are shown only when All is selected.';
         ' ';
         'Each model type is prefaced by a particular code, based on the model type;'
         '   1) No code: Undesignated models';
         '   2) DM: Design models';
         '   3) OL: Open-loop models';
         '   4) CL: Closed-loop models';
         '   5) K:  Compensators'};
      'Export Buttons',...
         {'Press one of the Export Buttons to export the data.';
         '';
         '1) Export to Disk: Saves the data to a MAT-file';
         '2) Export to Workspace: Saves the data in the MATLAB workspace';
         ''
         'Data is saved to the variable names shown in the list.';
         '';
         'When selecting Export to Disk:';
         '  1) Select the desired MAT-file name from the provided browser';
         '  2) Press: Save to finish the export';
         '            Cancel to abort the export';
         '';
         'When selecting Export to Workspace, you are warned if there is a conflict';
         'between the names of variables to be exported and those currently in ';
         'the Workspace.'; 
         ''
         'On the provided warning dialog:';
         '  1) Press Yes to override the variables in the workspace.';
         '  2) Press No to abort the export.';}};
   
   helpwin(helptext);
otherwise
   error('Invalid Export action')
end % switch action

%--------------------------Internal Functions------------------------
%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenFig %%%
%%%%%%%%%%%%%%%%%%%%
function a = LocalOpenFig(ParentFig,ExportData);

StdColor = get(0,'DefaultFigureColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'points';

ud = ExportData;
ud.ListData = struct('Names','','Objects',[]);

%---Open an Export figure
a = figure('Color',StdColor, ...
	'MenuBar','none', ...
   'Visible','off',...
   'Name','Export LTI Models/Compensators', ...
   'IntegerHandle','off',...
   'NumberTitle','off', ...
   'Resize', 'off', ...
   'WindowStyle','modal',...
   'Position',[193 127 340 262], ...
	'Tag','ExportLTIFig');

%---Add the Export List controls
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',StdColor, ...
	'Position',PointsToPixels*[4 6 179 244], ...
	'Style','frame');
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',StdColor, ...
	'Position',PointsToPixels*[51 236 90 19], ...
	'String','Export List', ...
	'Style','text');
ud.Handles.ModelList = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',[1 1 1], ...
	'Position',PointsToPixels*[11 43 166 194], ...
   'Style','listbox', ...
   'Max',2,...
   'FontName','courier',...
	'Tag','ModelList', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',StdColor, ...
	'HorizontalAlignment','left', ...
	'Position',PointsToPixels*[14 17 37 18], ...
	'String','Show:', ...
   'Style','text');

%---Determine the Export list based on what fields in the ExportData are populated
ExportList={'All';'Design Models';'Open-loop Models';
   'Closed-loop Models';'Compensators'};

saveInd = [logical(1); ~isempty(ExportData.DesignModels.Objects);
   ~isempty(ExportData.OpenLoop.Objects);
   ~isempty(ExportData.ClosedLoop.Objects);
   ~isempty(ExportData.Compensators.Objects)];

ud.Handles.TypePopup = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Callback','export(''changelist'',gcbf);',...
	'Position',PointsToPixels*[56 17 122 19], ...
	'String',ExportList(saveInd), ...
	'Style','popupmenu', ...
	'Tag','TypePopup', ...
	'Value',1);

%---Add the window buttons
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',StdColor, ...
	'Position',PointsToPixels*[189 7 147 243], ...
	'Style','frame');
ud.Handles.DiskButton = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'Position',PointsToPixels*[198 220 125 20], ...
   'Callback','export(''disk'',gcbf);',...
	'String','Export to Disk', ...
	'Tag','DiskButton');
ud.Handles.WorkspaceButton = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'Position',PointsToPixels*[198 193 125 20], ...
   'Callback','export(''workspace'',gcbf);',...
	'String','Export to Workspace', ...
	'Tag','WorkspaceButton');
b = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'BackgroundColor',StdColor, ...
	'Position',PointsToPixels*[195 183 136 1], ...
	'Style','frame');
ud.Handles.HelpButton= uicontrol('Parent',a, ...
	'Units',StdUnit, ...
	'Position',PointsToPixels*[198 130 125 20], ...
   'Callback','export(''help'',gcbf);',...
	'String','Help', ...
	'Tag','HelpButton');
ud.Handles.CancelButton = uicontrol('Parent',a, ...
	'Units',StdUnit, ...
   'Position',PointsToPixels*[198 156 125 20], ...
   'Callback','export(''cancel'',gcbf);',...
	'String','Cancel', ...
	'Tag','CancelButton');

set(a,'UserData',ud,'visible','on')
export('makelist',a,ud);
