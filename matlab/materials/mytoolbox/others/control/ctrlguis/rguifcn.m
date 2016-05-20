function varargout = rguifcn(varargin)
%RGUIFCN Contains the callback functions used by the LTI Viewer
%   RGUIFCN(ACTION,FIG) performs the callback specified by action
%   for the figure with handle FIG. FIG can be either a figure
%   containing Response Objects or an LTI Viewer. 
%
%   See also LTIVIEW

%   Karen Gondoly, 9-9-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.17.1.3 $

error(nargchk(2,4,nargin));

action=varargin{1};
LTIviewerFig=varargin{2};
StatusStr = [];

%---Turn a watch on...not done for the response line ButtonDownFcn
try
if ~strcmp(action,'showbox'),
   WatchFigNumber = watchon;
end

switch action
   
case 'addsystems',
   %---Append new systems onto the response plots (either for 'current' plottype
   %-----or after an import.
   
   %---A third input argument contains the system data in a structure with fields
   %----'Systems','Names','PlotStrs', 'FRDindices', 'ExtraArgs'
   if nargin<3,
      error('Wrong number of input arguments for "AddSystems" action.');
   end	
   
   SystemData = varargin{3};
   
   %---A possible 4th input argument allows the Warning to be toggled on or off
   %    PromptFlag=1: Warning is shown when Systems will be overwritten
   %    PromptFlag=0: Overwrites duplicate systems without warning.
   if isequal(nargin,4)
      PromptFlag=varargin{4}; 
   else,
      PromptFlag=0;
   end
   
   ViewerObj = get(LTIviewerFig,'UserData');
   AllViewProps = get(ViewerObj);
   
   %---Look for systems that were already in the Viewer (based on System Name)
   [OldSystems,indNew,indOld] = intersect(SystemData.Names,AllViewProps.SystemNames);
   OverwriteFlag=0;
   if ~isempty(OldSystems) 
      if PromptFlag,
         Str = [{'The following systems already exist in the LTI Viewer:';
               ''};
            SystemData.Names(indNew);
            {'';
               'Do you want to overwrite the old values of these systems';
               'with the newer versions?'}];
         
         switch questdlg(Str,'Updating the LTI Viewer');
            
         case 'Yes', % Deletes the systems
            OverwriteFlag=1;
         case 'No' 
            % Do not delete the systems
         case 'Cancel';
            %---Kill's entire Add System, even if systems have changed
            StatusStr='None of the systems were updated.';
            return
         end % switch questdlg
      else, % Remove systems without prompting
         OverwriteFlag=1;
      end, % if PromptFlag
   end, % if ~isempty(OldSystems)
   
   if OverwriteFlag,
      AllViewProps.Systems(indOld) = SystemData.Systems(indNew);
      AllViewProps.SystemNames(indOld) = SystemData.Names(indNew);
      AllViewProps.PlotStrings(indOld) = SystemData.PlotStrs(indNew);
   end
   
   SystemData.Systems(indNew)=[];
   SystemData.Names(indNew)=[];
   SystemData.PlotStrs(indNew)=[];
   FRDtemp = [];
   if ~isempty(indNew) & ~isempty(SystemData.FRDindices), % FRDindices need to be reset
      for ctF = 1:length(SystemData.Systems),
         if isa(SystemData.Systems{ctF},'frd');
            FRDtemp=[FRDtemp,ctF];
         end % if isa
      end % for ctF
      SystemData.FRDindices = FRDtemp;
   end % if ~isempty(indNew)
   
   Systems = [AllViewProps.Systems;SystemData.Systems];
   Names = [AllViewProps.SystemNames;SystemData.Names];
   PlotStrs = [AllViewProps.PlotStrings; SystemData.PlotStrs];
   
   SystemData.FRDindices = SystemData.FRDindices + length(AllViewProps.Systems);
   FRDi = unique([AllViewProps.FrequencyData;SystemData.FRDindices(:)]); % Column
   
   %---Find, and fill, any empty Plot Strings
   indempty = find(strcmpi('',PlotStrs));
   if ~isempty(indempty)
      FRDflag = zeros(length(indempty),1);
      [emptyFRDs,FRDind,indind]=intersect(FRDi,indempty);
      FRDflag(indind)=1;
      pstr = viewpstr(ViewerObj,indempty,FRDflag);
      PlotStrs(indempty) = pstr;
   end
     
   NewSystemData = struct('PlotStrs',{PlotStrs},'Names',{Names},...
      'Systems',{Systems},'FRDindices',{FRDi});
   set(ViewerObj,'InitializeViewer',NewSystemData);
   
case 'setsystems',
   ViewerObj = varargin{3};
   ViewerObj = LocalPlotSwitch(ViewerObj,LTIviewerFig);
     
case 'deletesys',
   %---Callback from the Delete menu
   ViewerObj = get(LTIviewerFig,'UserData');
   SysNames = varargin{3};
   AllNames = get(ViewerObj,'SystemNames');
   [garb1,garb2,indDelete]=intersect(SysNames,AllNames);
   ViewerObj = deletesys(ViewerObj,indDelete);
      
case 'refreshsys'   
	%---Callback from the Refresh menu   
   StatusStr = LocalUpdateSystems(LTIviewerFig);
   
case 'respapply',
   %---Finish up applying the Response Preferences, if Responses need to be recalculated
   ViewerObj = get(LTIviewerFig,'UserData');
   ViewerObj = LocalPlotSwitch(ViewerObj,LTIviewerFig);

case 'showbox'
   %----ButtonDownFcn for the plotted lines
   downtype=get(LTIviewerFig ,'SelectionType');
   ax=get(LTIviewerFig ,'CurrentAxes'); 
   ContextMenu = get(ax,'UIContextMenu');
   RespObj = get(ContextMenu,'UserData');
   AllRespProps = get(RespObj);
   
   %---Get Response Data
   ResponseType = AllRespProps.ResponseType;
   ResponseHandles = AllRespProps.ResponseHandles;
   SystemNames = AllRespProps.SystemNames;
   udLine = get(gcbo,'UserData');
   Handles = ResponseHandles{udLine.System}{udLine.Output,udLine.Input};
   NumArray = prod(size(Handles));
   
   %---Make appropriate system name string
   if ~isequal(1,NumArray), % Array
      ArrayDimsStr = sprintf(',%d',udLine.Array);
      sysstr = ['System: ',SystemNames{udLine.System},'(',num2str(udLine.Output), ...
         ',',num2str(udLine.Input),ArrayDimsStr,')'];
   elseif ~isequal(prod(size(ResponseHandles{udLine.System})),1), % MIMO
      sysstr = ['System: ',SystemNames{udLine.System},'(',num2str(udLine.Output), ...
         ',',num2str(udLine.Input),')'];      
   else % SISO, non-array
      sysstr = ['System: ',SystemNames{udLine.System}];
   end
   
   CP=get(ax,'CurrentPoint');
   
   switch downtype
   case 'normal'
      udText=[];
      %---Left mouse button...show current point
      %---Get suitable labels for display
      ud=get(ax,'UserData');
      BackgroundAxes = ud.Parent;
      Xstr = get(get(BackgroundAxes,'Xlabel'),'String');
      Ystr = get(get(BackgroundAxes,'Ylabel'),'String');
      
      switch ResponseType, % Get additional info based on ResponseType
      case {'bode','margin'},
         %---Get mag. or phase text based on which line is selected
         LTIdisplayAxes = get(RespObj,'PlotAxes');
         [numout,numin]=find(LTIdisplayAxes==ax);
         indcolon = findstr(';',Ystr);
         
         if ~rem(numout,2), % Phase Plot
            Ystr = Ystr(1:indcolon-1);
         else % Magnitude plot
            Ystr = Ystr(indcolon+2:end);
         end
         
      case 'nichols',
         %---Remove "Open-loop" text
         Xstr = Xstr(11:end);
         Ystr = Ystr(11:end);
         
      case 'nyquist',
         %---Keep first four characters
         Xstr = Xstr(1:end-5);
         Ystr = Ystr(1:end-5);
         
      end % switch ResponseType
      
      textstr={sysstr;[Ystr,': ',num2str(CP(1,2),'%0.3g')]; ...
            [Xstr,': ',num2str(CP(1,1),'%0.3g')]};            
      
      switch ResponseType, % Tack Frequency onto text
      case {'nyquist','nichols'},
         Freq = get(RespObj,'Frequency');
         ArrayInd = sub2ind(size(Handles),udLine.Array(1),udLine.Array(2));
         SysFreq = Freq{udLine.System}{ArrayInd};
         Xdata=get(gcbo,'Xdata');
         Ydata=get(gcbo,'Ydata');
         AllDist = ( (Xdata-CP(1,1)).^2 + (Ydata-CP(1,2)).^2 ).^(0.5);
         [garb,indFreq]=min(AllDist);
         MyFreq=SysFreq(indFreq);
         %---Get and abbreviate the Frequency Unit String
         FreqUnit = get(RespObj,'FrequencyUnit');
         if ~strncmpi(lower(FreqUnit),'h',1),
            FreqUnit = 'rad/sec';
         else
            FreqUnit = 'Hz';
         end
         textstr=[textstr;{['Freq (',FreqUnit,'): ',num2str(MyFreq,'%0.3g')]}];
      end % switch ResponseType
      
      set(LTIviewerFig ,'WindowButtonUpFcn','rguifcn(''showpointbuttonup'',gcbf);')
      
   case 'alt'
      AllRespProps = get(RespObj);
      %---Right mouse button...show associated point on the selector
      %---Get and store the original plot preferences
      
      %---If the response is on the LTI Viewer, also show the sampling time
      if isequal(get(LTIviewerFig,'Tag'),'ResponseGUI');
         ViewerObj = get(LTIviewerFig,'UserData');
         Systems = get(ViewerObj,'Systems');
         if isdt(Systems{udLine.System}),
            if isequal(Systems{udLine.System}.Ts,-1),
               Tdstr='unspecified';
            else
               Tdstr = num2str(Systems{udLine.System}.Ts);
            end % if/else isequal(Systems.Td,-1)
            sysstr = char({sysstr;['Sampling time: ',Tdstr]});
         end % if isdt(System)
      end

      InputName = AllRespProps.InputLabel;
      OutputName = AllRespProps.OutputLabel;
      ResponseType = AllRespProps.ResponseType;
      udText = cell(4,1);
      udText{1}=get(gcbo,'Color');
      udText{2}=get(gcbo,'Linestyle');
      udText{3}=get(gcbo,'Marker');
      set(gcbo,'LineStyle','-','Linewidth',2)
      
      if strcmp(get(RespObj,'ChannelSelector'),'on'),     
         %---change the associated dot
         ContextMenu = AllRespProps.UIContextMenu;
         SelectorFig = get(ContextMenu.ChannelMenu,'UserData');
         CloseButton = findobj(SelectorFig,'Tag','SelectorCloseButton');
         udSelector = get(CloseButton,'UserData');
         patchHndl=findobj(udSelector.AllDots,'UserData',[udLine.Output udLine.Input]);
         set(patchHndl,'Color',[1 1 0],'MarkerFaceColor',[1 1 0]);
         
         %---Store the old line data and Selector Figure Handle in the text UserData
         udText{4} = SelectorFig;
      end % if ChannelSelector is on
      
      %---Add descriptive text to the current plot
      switch ResponseType
      case {'sigma','pzmap','margin'},
         textstr={sysstr};
      case {'lsim';'initial'},
         outname=OutputName{udLine.Output};
         textstr = {sysstr;outname};
      otherwise,
         inname=InputName{udLine.Input};
         outname=OutputName{udLine.Output};
         textstr={sysstr;[inname,' to ',outname]};
      end % switch ResponseType
      
      set(LTIviewerFig ,'WindowButtonUpFcn','rguifcn(''showboxbuttonup'',gcbf);')
   otherwise,
      
      return % Don't do anything for other button down types
   end % switch downtype
   
   T=text(CP(1,1),CP(1,2),textstr,'tag','temptext','UserData',udText, ...
      'parent',ax,'Interpreter','none', ...
      'VerticalAlignment','bottom','FontSize',8,'visible','off');
   
   E = get(T,'Extent');
   delete(T)
   
   %---Put the text and patch on a superimposed invisible linear axes 
   % This avoids the problem of text extents being incorrect on log scales
   axtemp = axes('Parent',LTIviewerFig,'Pos',get(ax,'Position'), ...
      'Xlim',get(ax,'Xlim'),'Ylim',get(ax,'Ylim'),'Tag','TempAxes', ...
      'Visible','off');
   
   T=text(E(1),E(2),textstr,'tag','temptext','UserData',udText, ...
      'parent',axtemp,'Interpreter','none', ...
      'VerticalAlignment','bottom','FontSize',8,'visible','off');
   
   E = get(T,'Extent');
   Ylim=get(axtemp,'Ylim');
   if E(2)+E(4) > Ylim(2),
      set(T,'VerticalAlignment','top');
   end
   Xlim = get(axtemp,'Xlim');
   if E(1)+E(3) > Xlim(2),
      if E(1)-E(3) < Xlim(1),
         set(T,'HorizontalAlignment','center');
      else	
         set(T,'HorizontalAlignment','right');
      end
   end
   E = get(T,'Extent');
      
   P=patch([E(1),E(1)+E(3),E(1)+E(3),E(1),E(1)], ...
      [E(2),E(2),E(2)+E(4),E(2)+E(4),E(2)],'w',...
      'EdgeColor','w','parent',axtemp,'tag','temppatch');
   
   kids = get(axtemp,'Children');
   set(axtemp,'Children',[kids(2);kids(1);kids(3:end)]);
   set(T,'visible','on');
   
case 'showpointbuttonup'
   %----ButtonUpFcn for normal selection on response plots
   % Remove temptext
   T=findall(LTIviewerFig,'Tag','TempAxes');
   delete(T)
   
   % Make sure plot options are at top of figure's children
   Popts = findobj(findall(Parent),'Marker','o');
   Popts = [findobj(Popts,'Tag','PeakResponseMarker');
      findobj(Popts,'Tag','RiseTimeMarker');
      findobj(Popts,'Tag','SettlingTimeMarker');
      findobj(Popts,'Tag','StabilityMarginMarker');
      findobj(Popts,'Tag','SteadyStateMarker')];
   if ~isempty(Popts)
      uistack(unique(Popts),'top');
   end
   
   set(gcf,'WindowButtonUpFcn',' ')
   
case 'showboxbuttonup'
   A=findall(LTIviewerFig,'Tag','TempAxes');
   onFaceColor=[0 0 0];
   
   %----ButtonUpFcn for alternate selection on response plots
   T = findobj(LTIviewerFig ,'Tag','temptext');
   
   %---Get UserData for Text: Cell array of {Color;Linestyle;Marker;SelectorHandle}
   udText = get(T,'UserData');
   
   if ~isempty(udText{4}),
      CloseButton = findobj(udText{4},'Tag','SelectorCloseButton');
      udSelector = get(CloseButton,'UserData');
      patchHndl=findobj(udSelector.AllDots,'color',[1 1 0]);
      set(patchHndl,'Color',onFaceColor,'MarkerFaceColor',[0 0 0])
   end
   
   % Remove tempaxes
   delete(A)
   
   %---Reset LineStyles
   lineHndl=findobj(LTIviewerFig ,'Type','line','LineWidth',2);
   set(lineHndl,'Color',udText{1},...
      'LineStyle',udText{2},'LineWidth',0.5,...
      'Marker',udText{3})
   
   set(gcf,'WindowButtonUpFcn',' ')
   
case 'switchplot',
   %---Callback for the Plot Type menu
   
   %---Requires a third input argument which is the callback object
   if nargin<3,
      error('Wrong number of input arguments for "SwitchPlot" callback.')
   end
   PlotTypeMenu = varargin{3};
   
   %---Issue a warning if Lsim or Initial is choosen
   if any(strcmpi(get(PlotTypeMenu,'Label'),{'lsim','initial'})),
      warndlg({'Linear Simulations and Initial Condition responses '; ...
            'cannot be invoked within the LTI Viewer.'; ...
            ''; ...
            'To view one of these responses, initialize a new LTI Viewer '; ...
            'from the command line using the LSIM or INITIAL plot type.'},...
         'LTI Viewer Warning','modal');
      if ishandle(WatchFigNumber)
         watchoff(WatchFigNumber);
      end
      return
   end
   
   ViewerObj = get(LTIviewerFig,'UserData');
   [ViewerObj,ChangedArea] = LocalPlotSwitch(ViewerObj,LTIviewerFig,PlotTypeMenu);
   
   %---Change the PlotType of the Array Selector
   ContextMenu = get(ViewerObj,'UIcontextMenu');
   RespObj = get(ContextMenu(ChangedArea),'UserData');
   RespCMenu = get(RespObj,'UIcontextMenu');
   if isequal(get(RespCMenu.ArrayMenu,'Visible'),'on')
      paramsel('#plottype',RespObj)
   else
      set(RespObj,'ArraySelector','off')
   end
   
case 'plotoptbuttondown'
   %----ButtonDownFcn for the PlotOption lines
   
   textstr=get(gcbo,'UserData');           
   ax=get(LTIviewerFig ,'CurrentAxes');
   Xlim=get(ax,'Xlim');
   dX=Xlim(2)-Xlim(1);
   Ylim=get(ax,'Ylim');
   dY=Ylim(2)-Ylim(1);
   CP=get(ax,'CurrentPoint');
   if CP(1,1) > ( Xlim(2)-(dX/10) ),
      horiz='right';
   else
      horiz='left';
   end
   if CP(1,2) > ( Ylim(2)-(dY/10) ),
      vert='top';
   else
      vert='bottom';
   end
   
   T=text(CP(1,1),CP(1,2),textstr,'tag','temptext','FontSize',8,'visible','off', ...
      'parent',ax,'Interpreter','none', ...
		'VerticalAlignment',vert,'HorizontalAlignment',horiz);
     
   E = get(T,'Extent');
   delete(T)
   
   %---Put the text and patch on a superimposed invisible linear axes 
   % This avoids the problem of text extents being incorrect on log scales
   axtemp = axes('Parent',LTIviewerFig,'Pos',get(ax,'Position'), ...
      'Xlim',get(ax,'Xlim'),'Ylim',get(ax,'Ylim'),'Tag','TempAxes', ...
      'Visible','off');
   
   T=text(E(1),E(2),textstr,'tag','temptext', ...
      'parent',axtemp,'Interpreter','none', ...
      'VerticalAlignment','bottom','FontSize',8,'visible','off');
   
   E = get(T,'Extent');
   Ylim=get(axtemp,'Ylim');
   if E(2)+E(4) > Ylim(2),
      set(T,'VerticalAlignment','top');
   end
   Xlim = get(axtemp,'Xlim');
   if E(1)+E(3) > Xlim(2),
      if E(1)-E(3) < Xlim(1),
         set(T,'HorizontalAlignment','center');
      else	
         set(T,'HorizontalAlignment','right');
      end
   end
   E = get(T,'Extent');
      
   P=patch([E(1),E(1)+E(3),E(1)+E(3),E(1),E(1)], ...
      [E(2),E(2),E(2)+E(4),E(2)+E(4),E(2)],'w',...
      'EdgeColor','w','parent',axtemp,'tag','temppatch');
   
   kids = get(axtemp,'Children');
   set(axtemp,'Children',[kids(2);kids(1);kids(3:end)]);
   set(T,'visible','on');
   
   set(LTIviewerFig,'WindowButtonUpFcn','rguifcn(''showpointbuttonup'',gcbf);')
   
case 'arrangeview',
   %---Called when setting the Configuration number of a Viewer Object
   %---The 2nd input argument is the Viewer Object
   %   Requires 2 additional arguments, ,OldConfig and OldOrder
   ViewerObj = LTIviewerFig;
   LTIviewerFig = get(ViewerObj,'Handle');
   OldConfig = varargin{3};
   OldOrder = varargin{4};
   ViewerObj = LocalArrangeView(LTIviewerFig,ViewerObj,OldConfig,OldOrder);
   
case 'configure'
   %---Callback for Viewer Configuration menu
   ViewerObj = get(LTIviewerFig,'UserData');
   set(ViewerObj,'ConfigurationWindow','on');
   
case 'changelines'
   %-----Callback when changing the plotting preferences
   PlotFig=findobj('Tag','PlotPrefs');
   RespWins=findobj('Tag','ResponseGUI');
   ViewerObjs = get(RespWins,{'UserData'});
   
   %---Use Viewer Object Method for applying preferences
   for ctV = 1:length(ViewerObjs),
      V = plotapply(ViewerObjs{ctV});
      ViewerObjs{ctV}=V;
   end
   
case 'export',
   %---Callback for the Export Menu
   ViewerObj = get(LTIviewerFig,'UserData');
   Systems = get(ViewerObj,'Systems');
   Names = get(ViewerObj,'SystemNames');
   StatusStr = 'Select the systems to export.';
   %---Make the ExportData
   ExportData = export('getdata');
   ExportData.MatName='Viewerdata';
   
   %---Add Models
   ExportData.All.Names = Names;
   ExportData.All.Objects = Systems;
   
   export('initialize',LTIviewerFig,ExportData);
   
case 'importsys',
   %---Callback to apply an import 
   ViewerObj = get(LTIviewerFig,'UserData');
   
   SelectedNames = varargin{3};
   FRDi=[];
   
   OldSystems = get(ViewerObj,'Systems');
   if ~isempty(OldSystems)
      [numout,numin]=size(OldSystems{1});
   else
      numout=[];numin=[];
   end
   
   Systems = cell(size(SelectedNames));
   SystemNames = Systems;
   PlotStrs = Systems; PlotStrs(:)={''};
   
   %---Weed out any systems with the wrong number of I/Os
   NumSys=0;
   NumBad = 0;
   BadSystems = cell(length(SelectedNames),1);
   for ct=1:length(SelectedNames),
      tempsys = evalin('base',SelectedNames{ct});
      [numoutnew,numinnew]=size(tempsys);
      if isempty(numout),
         [numout,numin]=size(tempsys);
      end
      
      if isequal(numout,numoutnew) & isequal(numin,numinnew),
         NumSys=NumSys+1;
         Systems{NumSys}=tempsys;
         SystemNames{NumSys}=SelectedNames{ct};
         %---system has changed...redo userdata
         if isa(Systems{NumSys},'frd'),
            FRDi = [FRDi,NumSys];
         end
      else
         NumBad = NumBad+1;
         BadSystems{NumBad,1} = SelectedNames{ct};
         StatusStr='Systems with a different number of I/O''s were not added.';
      end % if/else isequal(numout,numoutnew...   
   end % for ct
   
   SystemData = struct('Names',{SystemNames(1:NumSys)},...
      'Systems',{Systems(1:NumSys)},...
      'PlotStrs',{PlotStrs(1:NumSys)},...
      'FRDindices',{FRDi}, ...
      'ExtraArg',[]);
   
   rguifcn('addsystems',LTIviewerFig,SystemData,1);
   
   if ~isempty(StatusStr)
      %---Issue a more visible warning about importing incompatible systems
      warndlg(cat(1,{'The following systems have a different number '; ...
            'of inputs and/or outputs than those currently displayed' ; ...
            'in the LTI Viewer. These systems were not imported.'; ...
            ''},BadSystems(1:NumBad)), ...
         'Import Warning');
   end
   
case 'initdelete',
   %---Callback for the Delete menu
   ViewerObj = get(LTIviewerFig,'UserData');
   Systems = get(ViewerObj,'Systems');
   SystemNames = get(ViewerObj,'SystemNames');
   size_str = cell(size(SystemNames));
   class_str = cell(size(SystemNames));
   for ctS = 1:length(SystemNames),
      class_str{ctS}=class(Systems{ctS});
      if isequal(length(size(Systems{ctS})),2);
         s = mat2str(size(Systems{ctS}));
         s = strrep(s,' ','x');
         size_str{ctS} = s(2:end-1);
      else
         size_str{ctS} = [num2str(length(size(Systems{ctS}))),'-D'];
      end
   end
   AllNames = strvcat(SystemNames{:});
   MaxName = size(AllNames,2);
   NameBlanks = repmat(max(0,blanks(15-MaxName)),size(AllNames,1),1);
   AllSize = strvcat(size_str);
   MaxSize = size(AllSize,2);
   SizeBlanks = repmat(max(0,blanks(13-MaxSize )),size(AllSize,1),1);
   AllClass = strvcat(class_str{:});
   ListStr = [AllNames,char(NameBlanks),AllSize,char(SizeBlanks),AllClass];
     
   StatusStr='Select the systems to remove from the LTI Viewer.';
     
   ltibrowse('delete',LTIviewerFig,ListStr,SystemNames, ...
      'rguifcn(''deletesys'',ud.Parent,)');
   
case 'initimport',
   WorkspaceVars = evalin('base','whos');
   ltivars = zeros(size(WorkspaceVars));
   size_str = cell(size(WorkspaceVars));
   for ct=1:size(WorkspaceVars,1),
      VarClass=WorkspaceVars(ct).class;
      if any(strcmpi(VarClass,{'ss';'tf';'zpk';'frd'})),
         ltivars(ct)=ct;
         if isequal(length(WorkspaceVars(ct).size),2);
            s = mat2str(WorkspaceVars(ct).size);
            s = strrep(s,' ','x');
            size_str{ct} = s(2:end-1);
         else
            size_str{ct} = [num2str(length(WorkspaceVars(ct).size)),'-D'];
         end
      end % if isa
   end % for ct
   WorkspaceVars = WorkspaceVars(find(ltivars));
   AllNames = strvcat(WorkspaceVars.name);
   MaxName = size(AllNames,2);
   NameBlanks = repmat(max(0,blanks(15-MaxName)),size(AllNames,1),1);
   AllSize = strvcat(size_str(find(ltivars)));
   MaxSize = size(AllSize,2);
   SizeBlanks = repmat(max(0,blanks(13-MaxSize )),size(AllSize,1),1);
   AllClass = strvcat(WorkspaceVars.class);
   ListStr = [AllNames,char(NameBlanks),AllSize,char(SizeBlanks),AllClass];
   
   ltibrowse('import',gcbf,ListStr,cellstr(AllNames), ...
      'rguifcn(''importsys'',ud.Parent,)');

case 'openresppref',
   ViewerObj = get(LTIviewerFig,'UserData');
   OpenRespFig = get(gcbo,'UserData');
   
   if ishandle(OpenRespFig) & ~isequal(OpenRespFig,0),
      figure(OpenRespFig);
   else
      set(ViewerObj,'ResponsePreferences','on');
   end % if/else ishandle(OpenRespFig)
   StatusStr = 'This Response Preference window applies to this LTI Viewer, only.';
   
case 'openlinepref',
   ViewerObj = get(LTIviewerFig,'UserData');
   OpenLineFig = get(gcbo,'UserData');
   
   if ishandle(OpenLineFig) & ~isequal(OpenLineFig,0),
      figure(OpenLineFig);
   else
      set(ViewerObj,'LineStylePreferences','on');
   end % if/else ishandle(OpenLineFig)
   StatusStr = 'This Linestyle Preference window applies to this LTI Viewer, only.';
   
case {'printfig', 'makefig'},
   %-----Callback for Send to Figure menu
   printfig = figure('name','LTI Viewer Responses', 'Visible', 'off');
   AxesPos = [0.13 0.11 0.775 0.815]; % Normalized axes pos;
   
   ViewerObj = get(LTIviewerFig,'UserData');
   BackgroundAxes = get(ViewerObj,'BackgroundAxes');
   AllAxesPos = get(ViewerObj,'AxesPosition');
   
   B = copyobj(BackgroundAxes,printfig);
   LTIdisplayAxes = findobj(LTIviewerFig,'Tag','LTIdisplayAxes');
   h=copyobj(LTIdisplayAxes,printfig);
   kids = get([h;B],{'children'});
   
   remapfig(AllAxesPos{1},AxesPos,printfig,[h;B]);
   
   DeleteKids = findobj(cat(1,kids{:}),'type','line');
   set(DeleteKids,'deletefcn','');
   set(DeleteKids,'ButtonDownFcn','');
   set(h,'uicontextmenu',[],'Userdata',[],'Tag','')
   X = get(B,{'Xlabel'});
   Y = get(B,{'Ylabel'});
   set([cat(1,X{:});cat(1,Y{:})],'visible','on');
   switch action,
   case 'printfig',
      printdlg(printfig);
      
      if isunix,
         kids = allchild(0);
         waitfor(kids(1));
      end
      close(printfig)
   case 'makefig',
      set(printfig, 'visible', 'on');
   end %switch action
     
case 'help'
   %----Callback for help button
   LocalOpenHelp;
   
case 'closewindow'   
   %----Callback for closing the current Response GUI
   ViewerObj = get(LTIviewerFig,'UserData');
   FigMenu = get(ViewerObj,'FigureMenu');
   %---See if preference windows are open
   PP=get(FigMenu.ToolsMenu.Linestyle,'UserData');
   if PP & ishandle(PP), close(PP), end,
   RP=get(FigMenu.ToolsMenu.Response,'UserData');
   if RP & ishandle(RP), close(RP), end,
   ConfigWin = get(FigMenu.ToolsMenu.ConfigMenu,'UserData');
   if ishandle(ConfigWin),
      close(ConfigWin)
   end
   
   delete(LTIviewerFig)
      
end % switch action

if ~isempty(StatusStr),
   StatusText = findobj(LTIviewerFig,'Tag','StatusText');
   set(StatusText,'String',StatusStr);
end

if nargout,
   varargout{1}=ViewerObj;
end

%---Turn the watch back off
if ~strcmp(action,'showbox') &  ishandle(WatchFigNumber),
   watchoff(WatchFigNumber);
end

catch
   if ~strcmp(action,'showbox') &  ishandle(WatchFigNumber),
      watchoff(WatchFigNumber);
   end
end % try/catch

%---------------------------Internal functions----------------------------
%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalAddOptions %%%
%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalAddOptions(RespObj,OldProps,NewPlotType);

%---If going between time domain responses (or frequency domain responses),
%     save the settings of common Plot Options

if any(strcmpi(OldProps.ResponseType,{'step';'impulse';'initial'})) & ...
      any(strcmpi(NewPlotType,{'step';'impulse';'initial'})),
   if strcmp(OldProps.PeakResponse,'on');
      set(RespObj,'PeakResponse','on');   
   end
end

if any(strcmpi(OldProps.ResponseType,{'step';'impulse'})) & ...
      any(strcmpi(NewPlotType,{'step';'impulse'})),
   if strcmp(OldProps.SettlingTime,'on');
      set(RespObj,'SettlingTime','on');   
   end
end

if any(strcmpi(OldProps.ResponseType,{'bode';'sigma'})) & ...
      any(strcmpi(NewPlotType,{'bode';'sigma'})),
   if strcmp(OldProps.PeakResponse,'on');
      set(RespObj,'PeakResponse','on');   
   end
end

if any(strcmpi(OldProps.ResponseType,{'bode';'nyquist';'nichols'})) & ...
      any(strcmpi(NewPlotType,{'bode';'nyquist';'nichols'})),
   if strcmp(OldProps.StabilityMargin,'on');
      set(RespObj,'StabilityMargin','on');   
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalArrangeView %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = LocalArrangeView(varargin);
%LocalArrangeView is a method that changes the Response Plot 
%   arrangement on the LTI Viewer, from a call to:
%     set(ViewerObj,'Configuration',ConfigNum)

error(nargchk(4,4,nargin));

ViewerFig = varargin{1};
ViewerObj = varargin{2};
OldConfig = varargin{3};
OldOrder = varargin{4};

LTIdisplayAxes=[];
AllViewProps = get(ViewerObj);
NewConfig = AllViewProps.Configuration;
BackgroundAxes = AllViewProps.BackgroundAxes;
UIcontextMenu = AllViewProps.UIContextMenu;
PlotTypeOrder = AllViewProps.PlotTypeOrder;

OldAxesPos = AllViewProps.AxesPosition{OldConfig};
NewAxesPos = AllViewProps.AxesPosition{NewConfig};

%---Get Viewer Data
Systems = AllViewProps.Systems;
SystemNames = AllViewProps.SystemNames;
PlotStr = AllViewProps.PlotStrings;

%---Determine which plots can simply be remapped
OldPlots = strvcat(OldOrder{1:OldConfig});
NewPlots = strvcat(PlotTypeOrder{1:NewConfig});
[RemapPlots,RemapTo,RemapFrom]=intersect(NewPlots,OldPlots,'rows');

%---Initialize the new BackgroundAxes and UIcontextMenu
NewBackground = zeros(NewConfig,1);
NewMenus = zeros(NewConfig,1);
NewBackground(RemapTo)=BackgroundAxes(RemapFrom);
if ~isempty(UIcontextMenu),
   NewMenus(RemapTo)=UIcontextMenu(RemapFrom);
   set(ViewerObj,'UIcontextMenu',NewMenus,'BackgroundAxes',NewBackground);
end

%---First Remap Response plots
for ctRemap = 1:length(RemapTo),
   if ~isempty(UIcontextMenu),
      RespObj = get(UIcontextMenu(RemapFrom(ctRemap)),'UserData');
      LTIdisplayAxes = get(RespObj,'PlotAxes');
   end
   remapfig(OldAxesPos(RemapFrom(ctRemap),:),...
      NewAxesPos(RemapTo(ctRemap),:),ViewerFig,...
      [BackgroundAxes(RemapFrom(ctRemap));LTIdisplayAxes(:)]);
end     

%---Then, add any necessary response plots
RedoPlots=1:NewConfig;
RedoPlots(RemapTo)=[];
for ctRedo = RedoPlots;
   if ctRedo>OldConfig | ~isempty(intersect(ctRedo,RemapFrom)),
      NewBackground(ctRedo,1) = axes('Parent',ViewerFig, ...
         'Units','norm', ...
         'Visible','on', ...
         'Position',NewAxesPos(ctRedo,:));
   else
      RemapFrom=[RemapFrom;ctRedo];
      NewBackground(ctRedo,1)=BackgroundAxes(ctRedo);
      set(NewBackground(ctRedo,1),'Position',NewAxesPos(ctRedo,:));
      if ~isempty(UIcontextMenu)
         RespObj = get(UIcontextMenu(ctRedo),'UserData');
         cla(RespObj,1); 
      end
   end
   
   set(ViewerObj,'BackgroundAxes',NewBackground);
   if ~isempty(Systems)
      ViewerObj = LocalPlotSwitch(ViewerObj,ViewerFig,PlotTypeOrder{ctRedo},ctRedo);
   end % if ~isempty(Systems)
end % for ctRedo

%---Lastly, delete any leftover response plots.
DeleteAx=1:OldConfig;
DeleteAx(RemapFrom)=[];
if ~isempty(DeleteAx),
   for ctDelete = DeleteAx,
      if ~isempty(UIcontextMenu)
         RespObj = get(UIcontextMenu(ctDelete),'UserData');
         if isa(RespObj,'response')
            cla(RespObj,1);
         end
      end
      delete(BackgroundAxes(ctDelete));
   end % for ctDelete
end 

if nargout,
   varargout{1}=ViewerObj;
end

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGetResets %%%
%%%%%%%%%%%%%%%%%%%%%%
function [ResetPropStr,NewProps,UpdateArrayFlag] = ...
   LocalGetResets(NewProps,OldProps,NewPlotType,AllViewProps);

NewNames = AllViewProps.SystemNames;
if any(strcmpi(NewPlotType,{'step';'impulse';'lsim';'initial';'pzmap'})),
   NewNames(AllViewProps.FrequencyData)=[];
end

[garb,iNew,iOld]=intersect(NewNames,OldProps.SystemNames);
NumOld = length(OldProps.SystemVisibility);
ResetPropStr = '';

if ~strcmp(OldProps.AxesGrouping,'none');
   ResetPropStr=[ResetPropStr,',''AxesGrouping'',''',OldProps.AxesGrouping,''''];
end

[numinold,numoutold]=size(OldProps.SelectedChannels);
[numinnew,numoutnew]=size(NewProps.SelectedChannels);
if ~all(OldProps.SelectedChannels) & ~any(strcmpi(NewPlotType,{'pzmap';'sigma'})) & ...
      ~any(strcmpi(OldProps.ResponseType,{'pzmap';'sigma'})) & ...
      isequal(numinold,numinnew) & isequal(numoutold,numoutnew),
   NewProps.SelectedChannels = OldProps.SelectedChannels;
   ResetPropStr = [ResetPropStr,',''SelectedChannels'',NewProps.SelectedChannels'];
end

if ~all(strcmpi('on',OldProps.SystemVisibility)),
   NewProps.SystemVisibility(iNew) = OldProps.SystemVisibility(iOld);
   ResetPropStr = [ResetPropStr,',''SystemVisibility'',NewProps.SystemVisibility'];
end

ArrayChange=0;
UpdateArrayFlag=0;
for ctSM=1:length(iOld)
   if ~all(OldProps.SelectedModels{iOld(ctSM)}) & ...
         isequal(size(OldProps.SelectedModels{iOld(ctSM)}),size(NewProps.SelectedModels{iNew(ctSM)})),
      NewProps.SelectedModels(iNew(ctSM)) = OldProps.SelectedModels(iOld(ctSM));
      ArrayChange=1;
   elseif ~isequal(size(OldProps.SelectedModels{iOld(ctSM)}),size(NewProps.SelectedModels{iNew(ctSM)})),
      UpdateArrayFlag=1;
   end
end % for ctSM

%---Trip the UpdateFlag if new systems were added
if length(NewProps.SystemVisibility)>length(OldProps.SystemVisibility),
   UpdateArrayFlag=1;
end

if ArrayChange,
   ResetPropStr = [ResetPropStr,...
         ',''SelectedModels'',NewProps.SelectedModels'];
end

if strcmpi('on',OldProps.Grid),
   ResetPropStr = [ResetPropStr,',''Grid'',''on'''];
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalPlotSwitch %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ViewerObj,MyArea] = LocalPlotSwitch(varargin);
%LocalPlotSwitch Change the Response types shown on the LTI Viewer
%   LocalPlotSwitch(ViewerObj,LTIviewerFig) is called when the PlotTypeOrder
%   of an LTI Viewer is changed. In this mode, LocalPlotSwitch checks all the
%   Response Objects on the Viewer to see if they conform with the types
%   and orders in the new PlotTypeOrder. If not, the appropriate responses
%   are recomputed and plotted.
%
%   LocalPlotSwitch(ViewerObj,LTIviewerFig,HMenu) changes only the Response
%   Object containing the Plot Type Menu with Handle Hmenu. This is the
%   callback for a particular Response Plot's Plot Type Menu.
%
%   LocalPlotSwitch(ViewerObj,LTIviewerFig,NewPlotType,MyArea) initializes
%   the Response Type NewPlotType in the Response area MyArea. This is used
%   when new Response Areas are added via the Viewer Configuration window

error(nargchk(2,4,nargin));
ViewerObj = varargin{1};
LTIviewerFig = varargin{2};

AllViewProps = get(ViewerObj);

AllMenus = AllViewProps.UIContextMenu;
PlotTypeOrder = AllViewProps.PlotTypeOrder;

ni=nargin;

if isequal(ni,2)
   PlotTypeMenu=[];
   NewPlotType = PlotTypeOrder;
   UIcontextMenu = AllMenus;
   MyArea=1:1:length(AllViewProps.BackgroundAxes);
elseif isequal(ni,3),
   PlotTypeMenu = varargin{3};
   NewPlotType = cellstr(lower(get(PlotTypeMenu,'label')));
   UIcontextMenu = get(get(PlotTypeMenu,'Parent'),'Parent');
   RespObj = get(UIcontextMenu,'UserData');
   BackgroundAxes = get(RespObj,'BackgroundAxes');
   MyArea = find(AllViewProps.BackgroundAxes==BackgroundAxes);
   %---Update the PlotTypeOrder
   indresp=strmatch(NewPlotType,PlotTypeOrder);
   PlotTypeOrder(indresp)=PlotTypeOrder(MyArea);
   PlotTypeOrder(MyArea)=NewPlotType;
elseif isequal(ni,4),
   NewPlotType = cellstr(varargin{3});
   MyArea = varargin{4};
   UIcontextMenu=[];
end

NewFlag=0;
if isempty(UIcontextMenu);
   NewFlag = 1;
end

ArrayUpdateHandles=[];
ArrayUpdateFlag = zeros(1,length(MyArea));
for ct = 1:length(MyArea),
   sArg=0;
   ExtraArg = {[]};
   if strcmp(NewPlotType{ct},'initial'),
      sArg=sArg+1;
      ExtraArg{sArg} = AllViewProps.InitialCondition;
   end
   
   if strcmp(NewPlotType{ct},'lsim'),
      sArg=sArg+1;
      ExtraArg{sArg} = AllViewProps.InputSignal;
   end
   
   BackgroundAxes = AllViewProps.BackgroundAxes(MyArea(ct));
   %---Get any extra arguments and preferences from the Viewer Object
   if any(strcmpi(NewPlotType{ct},{'step';'impulse';'initial';'lsim'})) & ...
         strcmp(AllViewProps.TimeVectorMode,'manual')
      sArg=sArg+1;
      ExtraArg{sArg} = AllViewProps.TimeVector; % For Time domain responses
   elseif any(strcmpi(NewPlotType{ct},{'bode','nyquist','nichols','sigma'})) & ...
         any(strcmpi(AllViewProps.FrequencyVectorMode,{'manual','hold'})),
      sArg=sArg+1;
      ExtraArg{sArg} = AllViewProps.FrequencyVector;
   end
      
   %---Set up System data, only include FRD for bode, nyquist, nichols, and sigma
   SysStr='';
   Systems = AllViewProps.Systems;
   PlotStrs = AllViewProps.PlotStrings;
   
   if any(strcmpi(NewPlotType{ct},{'step';'impulse';'lsim';'initial';'pzmap'})),
      Systems(AllViewProps.FrequencyData)=[];
      PlotStrs(AllViewProps.FrequencyData)=[];
      if isempty(Systems)
         warndlg({'Time domain response plots cannot be shown when the Viewer ';...
               'contains only Frequency Response Data.'; ...
               ''; ...
               'Use the right-click menu or, if a right-click menu'; ...
               'is not available, the Viewer Configuration window to select a'; ...
               'frequency domain plot type.'}, ...
            'LTI Viewer Warning');
         return
      end
   end
      
   if ~NewFlag,
      %---Store old Response Object Properties
      RespObj = get(UIcontextMenu(ct),'UserData');
      OldProps = get(RespObj);
      
      %---Store any old I/O and Array Selector Figures
      SelectorHandle = get(OldProps.UIContextMenu.ChannelMenu,'UserData');
      ArrayHandle = get(OldProps.UIContextMenu.ArrayMenu,'UserData');
      
      %---Close any open Selectors for PZMAP/Sigma plots, SISO systems,
      % or Viewers that were initialized with Initial or Lsim.
      [No,Ni]=size(Systems{1});
      if ( any(strcmpi(NewPlotType{ct},{'pzmap';'sigma'})) | ...
            isequal(prod(No,Ni),1) ) | ...
            ( any(strcmpi(OldProps.ResponseType,{'initial';'lsim'})) ),
         IOflag = 1; % Close any open Selectors
      else
         IOflag = 0; % Leave the Selectors on
      end
      cla(RespObj,IOflag);  
   end % if ~NewFlag
   
   for ctA=1:length(Systems)
      SysStr = [SysStr,'Systems{',num2str(ctA),'},'];
      %---Get any PlotStr for the System
      if ~isempty(PlotStrs{ctA}),
         SysStr = [SysStr,'''',PlotStrs{ctA},''','];
      end
   end, % for ctA
   
   %---plot data
   if ~strcmp(NewPlotType{ct},'pzmap'),
      try
         eval([NewPlotType{ct},'(BackgroundAxes,',SysStr,'ExtraArg{:})']);
      catch
         errordlg(lasterr,'LTI Viewer Error')
         return
      end
      RespObj = gcr(BackgroundAxes);
      
      %---If using a time domain response and setting the time vector, set Xlim to manual
      %-----likewise, for frequency response vectors
      if (any(strcmpi(NewPlotType{ct},{'step';'impulse';'initial';'lsim'})) & ...
            strcmp(AllViewProps.TimeVectorMode,'manual') ) |  ...
            ( any(strcmpi(NewPlotType{ct},{'bode','sigma'})) & ...
            strcmp(AllViewProps.FrequencyVectorMode,'manual') ),
         Xlim = get(RespObj,'Xlim');
         Xlim = cat(1,Xlim{:});
         if any(strcmpi(NewPlotType{ct},{'bode','sigma'})),
            if iscell(AllViewProps.FrequencyVector)
               Xlim(:,2) = AllViewProps.FrequencyVector{end};
            else
               Xlim(:,2) = AllViewProps.FrequencyVector(end);
            end
         else
            Xlim(:,2) = AllViewProps.TimeVector(end);
         end
         Xlim = num2cell(Xlim,2);
         set(RespObj,'Xlims',Xlim);
      end
      
      %---If using a time domain response, and setting the Ylim]
      if any(strcmpi(NewPlotType{ct},{'step';'impulse';'initial';'lsim'})) & ...
            strcmp(AllViewProps.YlimMode,'manual')
         set(RespObj,'Ylims',AllViewProps.Ylims);
      end
      
   else
      %---Changes here must be reflected in ltiview.m, as well
      z=cell(length(Systems),1);
      p=cell(length(Systems),1);
      CO = AllViewProps.ColorOrder; 
      for ctSys=1:length(Systems);
         [p{ctSys},z{ctSys}]=pzmap(Systems{ctSys});
         if isempty(PlotStrs{ctSys}),
            PlotStrs{ctSys} = CO{ctSys-(length(CO)*floor((ctSys-1)/length(CO)))};
         end
      end
      RespObj = ltiplot('pzmap',Systems,BackgroundAxes,z,p,PlotStrs,...
         'SystemNames',AllViewProps.SystemNames);
   end % if/else ~strcmp(NewPlotType{ct}...
   
   %---Reset Units and Characteristics constraints
   switch NewPlotType{ct},
   case {'sigma';'bode';'nyquist';'nichols'},
      
      if ~strcmpi(AllViewProps.FrequencyUnits,'radianspersecond'),
         set(RespObj,'FrequencyUnits',AllViewProps.FrequencyUnits);
      end
      if ~strcmpi(AllViewProps.MagnitudeUnits,'decibels'),
         set(RespObj,'MagnitudeUnits',AllViewProps.MagnitudeUnits);
      end
      
      if ~strcmpi(NewPlotType{ct},'sigma') & ~strcmpi(AllViewProps.PhaseUnits,'degrees'),
         set(RespObj,'PhaseUnits',AllViewProps.PhaseUnits);
      end
      
   case {'step','impulse'},
      if ~isequal(AllViewProps.SettlingTimeThreshold,0.02)
         set(RespObj,'SettlingTimeThreshold',AllViewProps.SettlingTimeThreshold);
      end
      if strcmpi(NewPlotType{ct},'step') & ~isequal(AllViewProps.RiseTimeLimits,[0.1,0.9])
         set(RespObj,'RiseTimeLimits',AllViewProps.RiseTimeLimits);
      end   
   end % switch NewPlotType
   
   TempMenu = get(RespObj,'Uicontextmenu');
   
   %---Update Context Menus with LTI Viewer specific options
   RespObj = respfcn('viewermenus',RespObj);
   
   if ~NewFlag
      %---Update any old response properties
      [ResetPropStr,NewProps,ArrayUpdateFlag(ct)] = LocalGetResets(get(RespObj),OldProps, ...
         NewPlotType{ct},AllViewProps);
      if ~isempty(ResetPropStr)
         eval(['set(RespObj',ResetPropStr,')']);
      end
   
      %---Re-parent any open I/O or Array Selector windows
      if ishandle(SelectorHandle),
         set(SelectorHandle,'Name',['I/O Selector: ',NewPlotType{ct}],...
            'UserData',TempMenu.Main);
         set(TempMenu.ChannelMenu,'UserData',SelectorHandle);
      end
      
      if ishandle(ArrayHandle),
         set(TempMenu.ArrayMenu,'UserData',ArrayHandle(ct));
         ArrayUpdateHandles = [ArrayUpdateHandles,ArrayHandle];
      end

      %---Add any Plot Options
      RespObj = LocalAddOptions(RespObj,OldProps,NewPlotType{ct});
      
   end % if ~NewFlag
   
   set(TempMenu.Main,'UserData',RespObj); % Make sure to store new properties
   AllMenus(MyArea(ct),1)=TempMenu.Main;   
   set(ViewerObj,'UIcontextMenu',AllMenus);
   ViewerObj = plotapply(ViewerObj,MyArea(ct));   
   
end % for ct=(1:length(MyArea)

%---Reset the System Names
%----If a ViewerObj has a valid name, use it...otherwise, use the default
%    names generated by the response plot 
indEmpty = find(strcmpi('',AllViewProps.SystemNames));
if ~isempty(indEmpty),
   OldUntitled = find(strncmpi('untitled',AllViewProps.SystemNames,8));
   if ~isempty(OldUntitled),
      UsedInds = char(OldNames(OldUntitled));
      UsedInds = str2num(UsedInds(:,9:end));
      AvailInds = 1:(length(sys) + max(UsedInds));
      AvailInds(UsedInds)=[];
      SysInd = cellstr(strjust(num2str(AvailInds(1:length(sys))'),'left'));
   else
      SysInd = cellstr(strjust(num2str([1:length(indEmpty)]'),'left'));  
   end
   systext (1:length(indEmpty),1)={'untitled'};
   AllViewProps.SystemNames(indEmpty) = cellstr([strvcat(systext {:}),strvcat(SysInd{:})]);
end
set(ViewerObj,'PlotTypeOrder',PlotTypeOrder,'SystemNames',AllViewProps.SystemNames);

%---Update the Array Selectors, if necessary (must be done after setting names)
if ~NewFlag,
   s=0;
   for ct = 1:length(MyArea),
      if ArrayUpdateFlag(ct),
         paramsel('#refresh',get(AllMenus(MyArea(ct)),'UserData'));
      end % if ArrayUpdateFlag(ct)
   end % for ct
end % if ~NewFlag

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalUpdateSystems %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function StatusStr = LocalUpdateSystems(varargin);
StatusStr=[];

LTIviewerFig = varargin{1};
if nargin>1,
   sysvar = varargin{2}; % Pass in systems to import 
   ImportFlag = 1;
else
   sysvar = []; % Refresh Viewer from systems in Workspace
	ImportFlag = 0;   
end

ViewerObj = get(LTIviewerFig,'UserData');
AllProps = get(ViewerObj);

SystemName = AllProps.SystemNames;
Systems = AllProps.Systems;
PlotStrs = AllProps.PlotStrings;
FRDi = AllProps.FrequencyData;
tempFRDi = zeros(length(Systems),1);
ChangedSystems = Systems;
ChangedFRDi = FRDi;
ChangeStr='';DeleteStr='';
DeleteInds=[];

if isempty(sysvar)
   %----Look for all workspace variables of class 'ss', 'tf', or 'zpk'
   WorkspaceVars=evalin('base','whos');
   sysvar=cell(size(WorkspaceVars));	
   s=0;
   for ct=1:size(WorkspaceVars,1),
      VarClass=WorkspaceVars(ct).class;
      if any(strcmpi(VarClass,{'ss';'tf';'zpk';'frd'})),
         s=s+1;
         sysvar(s)={WorkspaceVars(ct).name};
      end % if isa
   end % for ct
   sysvar=sysvar(1:s);
end

if ~isempty(SystemName),   
   for ct=1:length(SystemName),
      NameInd=find(strcmp(SystemName{ct},sysvar));
      if ~isempty(NameInd), % System name is still in workspace, check contents
         newsys = evalin('base',SystemName{ct});
         if ~isequal(Systems{ct},newsys),
            %---system has changed...redo userdata
            if isa(Systems{ct},'frd') & ~isa(newsys,'frd'),
               ChangedFRDi(find(ChangedFRDi==ct))=[];
               % Remove markers from old FRD plot strings
               PlotStrs(ct) = viewpstr(ViewerObj,ct,0);
            elseif ~isa(Systems{ct},'frd') & isa(newsys,'frd'),
               ChangedFRDi = [ChangedFRDi;ct];
               % Add markers to new FRD plot strings
               PlotStrs(ct) = viewpstr(ViewerObj,ct,1);
            end
            ChangedSystems{ct}=newsys; 
            ChangeStr={'Some systems were changed in the workspace.';
               '';
               'Do you want to reflect these changes in the LTI Viewer?'};
         end
      else % System is no longer in the workspace
         DeleteInds=[DeleteInds,ct];
         DeleteStr={'Some systems are no longer in the workspace.';
            '';
            'Do you want to remove these systems from the LTI Viewer?'};
      end % if/else ~isempty(NameInd)
   end % for ct
   
end % if ~isempty(SystemName)

DeleteFlag=0;ChangeFlag=0;

%---Ask to remove old systems (Not when doing an Import)
if ~isempty(DeleteStr) & ~ImportFlag, 
   switch questdlg(DeleteStr,'Updating the LTI Viewer');
   case 'Yes', % Deletes the systems
      DeleteFlag = 1;
   case 'No' % Do not delete the systems
      DeleteFlag = 0;
   case 'Cancel';
      %---Kill's entire Refresh, even if systems have changed
      return
   end % switch questdlg
   
end % if ~isempty(DeleteStr)

%---Ask to update changed systems
if ~isempty(ChangeStr)
   switch questdlg(ChangeStr,'Updating the LTI Viewer');
      
   case 'Yes',
      Systems = ChangedSystems; % Use the changed the systems
      FRDi = unique(ChangedFRDi);
      ChangeFlag = 1;
   case 'No' % Do not change the systems
      ChangeFlag = 0;
   case 'Cancel';
      %---Kill's entire Refresh, without deleting or updating
      return
   end % switch questdlg
end % if ~isempty(ChangeStr)

StatusStr='All systems now reflect the current Workspace values.';

if DeleteFlag, % Remove entries
   Systems(DeleteInds)=[];
   SystemName(DeleteInds)=[];
   PlotStrs(DeleteInds)=[];
   if ~isempty(FRDi)
      tempFRDi(FRDi)=FRDi;
      tempFRDi(DeleteInds)=[];
      FRDi = tempFRDi(find(tempFRDi));
   end
   ViewerObj = deletesys(ViewerObj,DeleteInds);
end % if DeleteFlag

if ChangeFlag, % Update plots
   StatusStr='All systems now reflect the current Workspace values.';
   SystemData = struct('Systems',{Systems},...
      'Names',{SystemName},...
      'PlotStrs',{PlotStrs},...
      'FRDindices',{FRDi});
   set(ViewerObj,'FrequencyData',FRDi);
   rguifcn('addsystems',LTIviewerFig,SystemData,0)
end

%%%%%%%%%%%%%%%%%%%%%
%%% LocalOpenHelp %%%
%%%%%%%%%%%%%%%%%%%%%
function LocalOpenHelp;
titleStr=['LTI Viewer'];

helpStr1={'The LTI Viewer is an interactive environment for comparing ';
   'time and frequency responses of LTI systems. The Viewer can contain';
   'up to six response areas, where each response area can show a different';
   'response type and be independently manipulated';
   '';
   'The LTI Viewer controls are found in two main locations:';
   '   1) The Figure menus (File, Tools, and Help)';
   '   2) Right click menus (from any axes displaying a response plot';
   '';
   'The Figure menus provide high level tools for manuipulating data in the';
   'LTI Viewer, and configuring the appearance of the Viewer.';
   '';
   '   FILE allows you to Import/Export/Delete LTI Objects from the ';
   '        Viewer''s workspace, or open/close/print the Viewer';
   '   TOOLS opens additional windows for configuring the number of';
   '         response areas to show on the Viewer, as well as setting ';
   '         up response and linestyle preferences.';
   '   HELP provides tips on using the Viewer and related windows.';
   '';
   'The Right click menus provide tools for manipulating the actual,';
   '    responses.'
   ' ';
   'The Viewer provides the following Right-click menus:';
   '   1) Plot Type: Lists all the available response types';
   '   2) Systems: Shows what LTI objects are available in the Viewer';
   '   3) Plot Options: Calculates response characteristics, such as rise time';
   '   4) Axes Grouping: Places the response of different I/O channels ';
   '      onto the same axes';
   '   5) Select I/Os...: Opens a figure for choosing particular';
   '      I/O channels to display';
   '   6) Zoom: Allows you to select a region of the response plots to view';
   '   7) Grid: Turns on a grid appropriate for the particular response type';
   '';
   'Each response area has its own Right-click menu. Changes made using one ';
   'response area''s right-click menu are not mapped to the other response areas.'};   

helpStr2={'The Plot Type menu allows you to toggle between the different';
   'response types.';
   '';
   'To use the menu:';
   '   1) Highlight the Plot Type menu. A list of all available response';
   '      types opens.';
   '   2) Scroll down to the desired response type';
   '   3) Press the left mouse button';
   '';
   'The currently displayed response type is preceeded by a check mark.';
   '';
   'The following response types may be selected while working inside the Viewer';
   '   1) Step';
   '   2) Impulse';
   '   3) Bode';
   '   4) Nyquist';
   '   5) Nichols';
   '   6) Sigma';
   '   7) Pzmap';
   ''
   'Lsim and Initial are only available when initializing the LTI Viewer.'};

helpStr3={'The Systems menu allows you to select which LTI objects in the';
   ' Viewer''s workspace should be displayed in a particular response area.';
   '';
   'By selecting LTI objects in the Systems menu, you can toggle the ';
   'response plots on and off.';
   ''
   'To use the menu:';
   '   1) Highlight the Systems menu. A list of all available LTI objects';
   '      opens. This list shows you the name of the object and a legend,';
   '      after the name, for that object''s response plot.';
   '   2) Scroll down to the desired LTI object';
   '   3) Press the left mouse button';
   '';
   'Systems currently displayed are preceeded by a check mark.'};

helpStr4={'The Plot Options menu calculates various response characteristics.';
   '';
   'To toggle the display of any response characteristic on and off:';
   '   1) Highlight the Plot Options menu. A list of all response ';
   '       characteristics that can be calculated for the particular';
   '       response type opens.';
   '   2) Scroll down to the desired response characteristic';
   '   3) Press the left mouse button';
   ''
   'The value for the calculated response characteristic is displayed';
   'using a solid circle of the same color as the associated response plot';
   '';
   'A check mark proceeds all plot options that are currently displayed.';
   '';
   'To view the actual value of the response characteristic, hold the left';
   'mouse button down on any of the solid circles.'};

helpStr5={'The Axes Grouping combines the responses of different axes onto a';
   'single axes.'
   '';
   'Selecting the Axes Grouping menu provides four grouping options.';
   '   1) None {default} places each I/O channel''s response on a separate axes';
   '   2) All places all the I/O channel responses on a single axes';
   '   3) Inputs places the responses of a particular output from all the inputs';
   '      on a single axes';
   '   4) Outputs places the responses of all outputs from a particular input';
   '      on a single axes';
   '';
   'A check mark proceeds the current axes grouping setting.'};

helpStr6={'The Select I/Os menu opens a window that allows you to select ';
   'particular I/O channels to view.';
   '';
   'The I/O Selection window is a grid of I/O buttons and labels. ';
   'Using the buttons, you can configure which I/O channels you want';
   'particular displayed in your response area. To use the grid:';
   '';
   '   1) Left click on an I/O button to display only that I/O channel';
   '   2) Hold down the Shift key while left clicking on several I/O ';
   '      buttons, to display multiple channels';
   '   3) Hold down the left mouse button and drag the resultant rubber';
   '      band around the set of I/O channels to display';
   '   4) Left click on any text label to show all channels for a particular';
   '      input or output.';
   ''
   'In addition, if you hold down the right mouse button on any previously';
   'selected I/O button, the associated response plots are highlighted on ';
   'the Viewer.'};

helpStr7={'The Zoom menu allows you to view particular regions of the';
   'response plot.'
   ''
   'Selecting the Zoom menu shows the four possible zoom types:';
   '   1) In-X: zooms only along the X-axis';
   '   2) In-Y: zooms only along the Y-axis';
   '   3) X-Y: zooms along both the X and Y-axes';
   '   4) Out: rescales the axes to show all currently shown data';
   '';
   'To perform a zoom:';
   '   1) Left click on the desired zoom type. If you selected any ';
   '      zoom type other then Out, the Viewer''s cursor changes';
   '      to a cross hair.';
   '   2) Hold the left mouse button down while dragging the cursor';
   '      through the desired region to view';
   '   3) Release the mouse button';
   '';
   'Zooming is deactivated after zooming once. To further zoom, reselect';
   'the zoom type.';
   ''
   'You can return to the zoom menu while zoom is turned on by right clicking';
   'on any of the response axes. The active zoom type is preceeded by a check ';
   'mark. Reselecting this zoom type toggles off the zoom and returns ';
   'the cursor to an arrow.'};

helpStr8={'The Grid menu toggles an appropriate grid on and off.'
   '';
   'To toggle the grid, highlight the Grid menu and press the left';
   'mouse button. A check mark proceeds the Grid menu when a grid is shown.';
   '';
   'All plots are given a normal square grid, except:';
   '    1) SISO Nichols charts are plotted with an Nichols Grid';
   '    2) PZmaps of all continuous systems are given an S-grid';
   '    3) PZmaps of all discrete systems are given a Z-grid'};

helpStr9={'The LTI Viewer Tools menus provide additional features for manipulating';
   '   the LTI system responses. These menus include:';
   '';
   'The Viewer Configuration window allows you to specify how many response';
   'areas are shown on the LTI Viewer. Each response area can show a different';
   'response type and has its own set of right-click menus.';
   '';
   'Two preferences windows are available from the Tools menu.';
   '  1) The Response Preferences window is used to set the desired time ';
   '     and frequency ranges for all responses, as well as set the units ';
   '     for displaying Bode diagrams.';
   '';
   '  2) The Linestyle Preferences window is used to alter the appearance of';
   '     the response plots, including the color, linestyles, and markers';
   '     used to distinquish the different responses.';
   '';
   '  For additional help on these windows, see their Help windows'};

helpStr10={'The LTI Viewer contains additional Point-and-Click features that';
   '  can assist you with analyzing the responses. These include';
   '';
   '   1) Hold down the right mouse button on an I/O button in the I/O Selection';
   '      window to highlight the associated response in the Viewer';
   '';
   '   2) Hold down the right mouse button on any of reponse plot to show which';
   '      system and I/O channel it represents';
   '';
   '   3) Hold down the left mouse button  on any response plot to displays';
   '      the response''s value at the pointer location';
   '';
   '   4) Hold down the left mouse button on any pole/zeros to display its values';
   '';
   '   5) Hold down the left mouse button on any of the o''s associated with a ';
   '      calculated Plot Option to display the actual calculated value';
   '';
   ' When you release the mouse button, the displayed text disappears.'};


helpwin({'Overview',helpStr1; ...
   'Plot Types',helpStr2; ...
   'Systems',helpStr3; ...
   'Plot Options',helpStr4; ...
   'Axes Grouping',helpStr5; ...
   'I/O Selection',helpStr6; ...
   'Zoom',helpStr7; ...
   'Grid',helpStr8; ...
   'Tools',helpStr9; ...
   'Additional Features',helpStr10}, ...
   'Overview','LTI Viewer Help');
