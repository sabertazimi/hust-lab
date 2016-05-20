function varargout = respfcn(varargin)
%RESPFCN Functions invoked by the SET command for Response Objects
%   RESPFCN(ACTION,RespObj) performs the action specified by 
%   ACTION, for the Response Object, RespObj.
%
%   RespObj = RESPFCN(ACTION,RespObj) passes the updated Response Object
%   back to the calling function.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   Karen Gondoly 1-27-98.

ni = nargin;
error(nargchk(2,4,ni));

action = varargin{1};
RespObj = varargin{2};
AllRespProps = get(RespObj);
name = inputname(2);

%---Initialize some variables
onFaceColor=[0 0 0];
offFaceColor=[.8 .8 .8];

try
%---Turn a watch on.
if ~strcmp(action,'zoom'),
   WatchFigNumber = watchon;
end

ContextMenu = get(RespObj,'UIContextMenu');

switch action,
   
case 'closeselector',
   %---Callback from the Close button on the I/O selector
   %---Here, the second input argument is the ContextMenu
   set(RespObj,'ChannelSelector','off');
   
case 'helpselector',
   %---Callback from the Help button on the I/O selector
    helptext = {'I/O Selector', ...
          {'The I/O Selector allows you to display the responses from'; ...
             'specific Input to Output channels.'; ...
             ''; ...
             'The names along the top of the I/O Selector represent the'; ...
             'available model inputs. Similarly, the names down the left'; ...
             'side of the Selector represent the different outputs.'; ...
             ''; ...
             'You can control the I/O channel display using either,'; ...
             '  1) The [all] text'; ...
             '  2) The Input or Output names'; ...
             '  3) The I/O buttons'; ...
             ''; ...
             '1) The [all] text:'; ...
             '   Clicking on the [all] text toggles all the I/O channel'; ...
             '   plots on and off. When the text is red, all plots are shown.'; ...
             ''; ...
             '2) The Input or Output names:'; ...
             '   Clicking on an Input or Output name displays all plots'; ...
             '   for that input or output channel. For example, if you click '; ...
             '   on the first output name, the responses from all inputs to '; ...
             '   the first output are shown. Any selected Input or Output name'; ...
             '   text is shown in red.'; ...
             ''; ...
             '3) The I/O buttons'; ...
             '   You can control the display of individual I/O channels using'; ...
             '   the I/O buttons. Black buttons indicate displayed I/O channels.'; ...
             ''; ...
             '   To use the buttons:'; ...
             '      a) Left-click on any button to show only that channel.'; ...
             '      b) Hold the Shift key down while left-clicking on ';...
             '         multiple buttons to show several I/O channels.'; ...
             '      c) Hold the left mouse button down and drag a rubber'; ...
             '         band around several I/O buttons to display a group'; ...
             '         of I/O channels.'; ...
             '      d) Hold the right-mouse button down on any black I/O '
             '         button to highlight the corresponding response plot.'}};

	helpwin(helptext);

case 'labelinput',
   %---End of set command for InputLabel property
   ResponseType = AllRespProps.ResponseType;
   LTIdisplayAxes = AllRespProps.PlotAxes;
   inNames = AllRespProps.InputLabel;
   switch ResponseType,
   case {'step','impulse','nyquist','nichols','bode','margin'},      
      FromText(1:length(inNames),1)={'From: '};
      TitleText = cellstr([strvcat(FromText{:}),strvcat(inNames{:})]);
      for ctL=1:size(LTIdisplayAxes,1),
         T=get(LTIdisplayAxes(ctL,:),{'Title'});
         set(cat(1,T{:}),{'String'},TitleText,'FontSize',8)
      end      
   end % switch ResponseType
   
case 'labeloutput',
   %---End of set command for OutputLabel property
   ResponseType = AllRespProps.ResponseType;
   LTIdisplayAxes = AllRespProps.PlotAxes;
   outNames = AllRespProps.OutputLabel;
   switch ResponseType,
   case {'step','impulse','lsim','initial','nyquist','nichols'},
      ToText(1:length(outNames),1)={'To: '};
      YlabelText = cellstr([strvcat(ToText{:}),strvcat(outNames{:})]);
      for ctL=1:size(LTIdisplayAxes,2),
         Y=get(LTIdisplayAxes(:,ctL),{'Ylabel'});
         set(cat(1,Y{:}),{'String'},YlabelText,'FontSize',8)
      end 
   case {'bode','margin'},
      ToText(1:length(outNames),1)={'To: '};
      YlabelText = cellstr([strvcat(ToText{:}),strvcat(outNames{:})]);
      for ctL=1:size(LTIdisplayAxes,2),
         Y=get(LTIdisplayAxes(2:2:end,ctL),{'Ylabel'});
         set(cat(1,Y{:}),{'String'},YlabelText,'FontSize',8)
      end 
   end % switch ResponseType
   
case 'makeaxes'
   %---Callback when setting AxesGrouping or SelectedChannels, for
   %----all responses except Bode
   
   %---Hide all ResponseHandles
   ResponseHandles = AllRespProps.ResponseHandles;
   ResponseType = AllRespProps.ResponseType;
   for ctRH=1:length(ResponseHandles),
      RH=ResponseHandles{ctRH};
      RH=cat(1,RH{:});
      set(cat(1,RH{:}),'visible','off')
   end
   
   %---Show/resize the necessary axes and re-parent the ResponseHandles
   if ~any(strcmpi(ResponseType,{'sigma';'pzmap'})),
      RespObj = LocalGroupAxes(RespObj);
   end
   
   %---Turn the correct ResponseHandles back on
   RespObj = systemtog(RespObj);
   
case 'makeselector',
   %---Callback to initialize an I/O selector for the Response Object
   RespObj = LocalMakeSelector(RespObj,onFaceColor,offFaceColor);
   
case 'resetxzoom',
   %---RespObj comes in as the current axis and returns as the Response Object
   RespObj = respfcn('resetfunctions',RespObj);
   ContextMenu = get(RespObj,'UIcontextMenu');
   set(ContextMenu.ZoomMenu.ZoomX,'Check','off')
   %---Set the new axis limits
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   Xlims = get(LTIdisplayAxes(end,:),{'Xlim'});
   set(RespObj,'Xlims',Xlims)
   
case 'resetyzoom',
   %---RespObj comes in as the current axis and returns as the Response Object
   RespObj = respfcn('resetfunctions',RespObj);
   ContextMenu = get(RespObj,'UIcontextMenu');
   set(ContextMenu.ZoomMenu.ZoomY,'Check','off')
   %---Set the new axis limits
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   Ylims = get(LTIdisplayAxes(:,1),{'Ylim'});
   set(RespObj,'Ylims',Ylims)
   
case 'resetxyzoom',
   %---RespObj comes in as the current axis and returns as the Response Object
   RespObj = respfcn('resetfunctions',RespObj);
   ContextMenu = get(RespObj,'UIcontextMenu');
   set(ContextMenu.ZoomMenu.ZoomXY,'Check','off')
   %---Set the new axis limits
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   Xlims = get(LTIdisplayAxes(end,:),{'Xlim'});
   Ylims = get(LTIdisplayAxes(:,1),{'Ylim'});
   set(RespObj,'Xlims',Xlims,'Ylims',Ylims)
   
case 'resetfunctions',
   %---Callback to clean up after a zoom...Here, RespObj is an LTIdisplayAxes
   ContextMenu = get(RespObj,'UIcontextMenu');
   %---Reinitialize the Response Object and Context Menu data structure
   RespObj = get(ContextMenu,'UserData');
   ContextMenu = get(RespObj,'UIcontextMenu');
   
   FigHandle = get(RespObj,'Parent');
   LTIdisplayAxes = get(RespObj,'PlotAxes');
   lines=findobj(LTIdisplayAxes(:),'Tag','LTIresponseLines');
   set(FigHandle,'Pointer','arrow');
   
   %--Turn ButtonDownFcn on response plots back on
   if strcmp(get(RespObj,'ResponseType'),'pzmap'),
      set(lines,'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);');
   else
      set(lines,'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
   end % if/else strcmp(plottype)
   
   PlotOpts = [findobj(LTIdisplayAxes(:),'Tag','PeakResponseMarkers','Marker','o');
      findobj(LTIdisplayAxes(:),'Tag','SteadyStateMarkers','Marker','o');
      findobj(LTIdisplayAxes(:),'Tag','RiseTimeMarkers','Marker','o');
      findobj(LTIdisplayAxes(:),'Tag','SettlingTimeMarkers','Marker','o');
      findobj(LTIdisplayAxes(:),'Tag','StabilityMarginMarkers','Marker','o')];
   if ~isempty(PlotOpts),
      set(PlotOpts,'ButtonDownFcn',...
         'rguifcn(''plotoptbuttondown'',gcbf);');
   end
   
case 'selectall',
   %---All text callback
   OnChannels = AllRespProps.SelectedChannels;
   ToggleColor=get(gcbo,'Color');
   
   if isequal(ToggleColor,[1 0 0]); % Red, was on before
      OnChannels = zeros(size(OnChannels));
   else
      OnChannels = ones(size(OnChannels));
   end % if/else isequal
   set(RespObj,'SelectedChannels',OnChannels);
   
case 'selectcircle',
   %---CallbackObj for selecting markers on the I/O Selector Figure
   %---Toggle the selected state or multi-select based on the SelectionType
   OnChannels = AllRespProps.SelectedChannels;
   
   %---Get Selection Type and perform appropriate action
   downtype=get(gcbf,'SelectionType');
   switch downtype
      
   case {'open','normal'}
      %---Double-click...show only that channel
      NewChannelInd=zeros(size(OnChannels));
      ijData=get(gcbo,'UserData');
      NewChannelInd(ijData(1),ijData(2))=1;
      set(RespObj,'SelectedChannels',NewChannelInd)
      
   case 'extend'
      %---Shift-click left...multi select channels
      if get(gcbo,'Color')==onFaceColor, 
         ChannelVal=0;
      else
         ChannelVal=1;
      end
      
      %---Update AxesMenu Userdata
      ijData=get(gcbo,'UserData');
      OnChannels(ijData(1),ijData(2))=ChannelVal;
      set(RespObj,'SelectedChannels',OnChannels)
      
   case 'alt'
      %---Click-right...LTIdisplayAxes related line
      if isequal(get(gcbo,'color'),[0 0 0]),
         set(gcbo,'Color',[1 1 0],'MarkerFaceColor',[1 1 0])
         ijData=get(gcbo,'UserData');
         IndIn = ijData(2); 
         IndOut = ijData(1);
         
         if strcmp(AllRespProps.ResponseType,'bode') | strcmp(AllRespProps.ResponseType,'margin'),
            %---Update ijdata to get correct ResponseHandles
            ijData=[ijData;ijData];
            ijData(1,1) = 2*ijData(1,1)-1;
            ijData(2,1) = ijData(1,1)+1;
         end
         
         LTIdisplayAxes=get(RespObj,'PlotAxes');
         ResponseHandles = get(RespObj,'ResponseHandles');
         SystemNames = get(RespObj,'SystemNames');
         OutputName = get(RespObj,'OutputLabel');
         InputName = get(RespObj,'InputLabel');
         
         %---Initialize UserData for the Selector I/O window
         respline=cell(length(ResponseHandles),1);
         linestyle = cell(length(ResponseHandles),3);
         
         %---Find the appropriate channel for all the systems
         indTemp=0;
         for ctData = 1:size(ijData,1),
            for ctl=1:length(ResponseHandles),
               indTemp=indTemp+1;
               AllModelLines = ResponseHandles{ctl}{ijData(ctData,1),ijData(ctData,2)};
               SizeArray = size(ResponseHandles{ctl}{ijData(ctData,1),ijData(ctData,2)});
               respline{indTemp} = findobj(cat(1,AllModelLines{:}),...
                  'Tag','LTIresponseLines');
               TextAxes = get(respline{indTemp},'Parent');
               linestyle{indTemp,1}=get(respline{ctl},{'Color'});
               linestyle{indTemp,2}=get(respline{ctl},{'Linestyle'});
               linestyle{indTemp,3}=get(respline{ctl},{'Marker'});
               set(respline{indTemp},'LineStyle','-','Linewidth',2)
               %---Add descriptive text to the current plot
               outname=OutputName{IndOut};
               inname=InputName{IndIn};
               sysname = SystemNames{ctl};
               textstr={['System: ',sysname];[inname,' to ',outname]};
               Xdata=get(respline{indTemp}(1),'Xdata');
               Ydata=get(respline{indTemp}(1),'Ydata');
               T=text(Xdata(10),Ydata(10),textstr,'Tag','temptext', ...
                  'parent',TextAxes,...
                  'Interpreter','none', ...
                  'VerticalAlignment','bottom','FontSize',8, ...
                  'visible','off');  	      
               E = get(T,'Extent');
               delete(T)
               
               %---Put the text and patch on a superimposed invisible linear axes 
               % This avoids the problem of text extents being incorrect on log scales
               axtemp(indTemp,1) = axes('Parent',get(TextAxes,'Parent'),'Pos',get(TextAxes,'Position'), ...
                  'Xlim',get(TextAxes,'Xlim'),'Ylim',get(TextAxes,'Ylim'),'Tag','TempAxes', ...
                  'Visible','off');
               
               T=text(E(1),E(2),textstr,'tag','temptext', ...
                  'parent',axtemp(indTemp,1),'Interpreter','none', ...
                  'VerticalAlignment','bottom','FontSize',8,'visible','off');
               
               E = get(T,'Extent');
               Ylim=get(axtemp(indTemp,1),'Ylim');
               if E(2)+E(4) > Ylim(2),
                  set(T,'VerticalAlignment','top');
               end
               Xlim = get(axtemp(indTemp,1),'Xlim');
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
                  'EdgeColor','w','parent',axtemp(indTemp,1),'tag','temppatch');
               
               kids = get(axtemp(indTemp,1),'Children');
               set(axtemp(indTemp,1),'Children',[kids(2);kids(1);kids(3:end)]);
               set(T,'visible','on');           
            end % for ctl
         end % for ctData
         
         CloseButton = findobj(gcbf,'Tag','SelectorCloseButton');
         udClose = get(CloseButton,'UserData');
         udClose.TempAxes=axtemp;
         udClose.LineHandles=respline; 
         udClose.LineStyles=linestyle;
         udClose.SelectedDot=gcbo;
         set(gcbf,'WindowButtonUpFcn',...
            ['respfcn(''selectcirclebuttonup'',', ...
               'get(get(gcbf,''UserData''),''UserData''));'])
         set(CloseButton,'UserData',udClose)
         
      end % if isequal(gcbo color)
   end % switch downtype
   
case 'selectcirclebuttonup',
   %---Button up for an Alt selection type of a I/O selector button
   CloseButton = findobj(gcbf,'Tag','SelectorCloseButton');
   udClose = get(CloseButton,'UserData');
   delete(udClose.TempAxes);
   
   %---Switch the dot color back
   set(udClose.SelectedDot,'Color',onFaceColor,'MarkerFaceColor',onFaceColor)
   
   %---Convert the line back
   for ctl=1:length(udClose.LineHandles),
      set(udClose.LineHandles{ctl},{'Color'},udClose.LineStyles{ctl,1},...
         'LineWidth',0.5,{'Linestyle'},udClose.LineStyles{ctl,2},...
         {'Marker'},udClose.LineStyles{ctl,3})
      
   end % for ctl
   
   %---Clear out the CloseButton UserData
   udClose.SelectedDot=[];udClose.LineHandles=[];
   udClose.TempText=[];udCLose.LineHandles=[];
   set(CloseButton,'UserData',udClose)
   %---Put ContextMenu Handle back into UserData
   set(gcbf,'WindowButtonUpFcn',' ')
   
case 'selectrbbox'
   %---rbbox selection of I/O channels
   % Toggle the selected state or multi-select based on the SelectionType
   OnChannels = AllRespProps.SelectedChannels;
   OnChannels = zeros(size(OnChannels));
   
   SelectorFig = gcbf;
   ax=gcbo;
   dots = findobj(ax,'Marker','o');
   CP=get(ax,'CurrentPoint');
   maxX=max(get(ax,'Xlim'));
   maxY=max(get(ax,'Ylim'));
   
   %---Get figure current point data
   FigUnits=get(SelectorFig,'Unit');
   set(SelectorFig,'unit','norm');
   set(ax,'unit','norm');
   axpos=get(ax,'Position');
   P=get(SelectorFig,'CurrentPoint');
   
   %---Draw the rubberband box
   rect = rbbox;
   rect(1)=max([0,(rect(1)-axpos(1))]);
   rect(2)=max([0,(rect(2)-axpos(2))]);
   rect(1:2)=rect(1:2)./axpos(3:4);
   rect(3:4)=rect(3:4)./axpos(3:4);
   if rect(1)<0,
      rect(1)=0;
   end
   if rect(2)<0,
      rect(2)=0;
   end
   if rect(3)>1;
      rect(3)=1;
   end
   if rect(4)>1,
      rect(4)=1;
   end
   
   %---Get the current rectangle 
   XV=[rect(1);
      rect(1)+rect(3);
      rect(1)+rect(3);
      rect(1);
      rect(1)];
   
   YV=[rect(2);
      rect(2);
      rect(2)+rect(4);
      rect(2)+rect(4);
      rect(2)];
   
   Xdata = get(dots,'Xdata');
   Xdata = cat(1,Xdata{:});
   Ydata = get(dots,'Ydata');
   Ydata = cat(1,Ydata{:});
   
   Xdata=Xdata/maxX;
   Ydata=((ones(size(Ydata))*maxY)-Ydata)/maxY;
   
   indots=inpolygon(Xdata,Ydata,XV,YV);
   inds=find(indots);
   
   %---Return figure back to original units
   set(SelectorFig,'Unit',FigUnits);
   
   %---Proceed with callback based on whether systems or channels are selected
   if ~isempty(inds),
      for ctI=1:length(inds)
         ijData=get(dots(inds(ctI)),'UserData');
         OnChannels(ijData(1),ijData(2))=1;
      end
      set(RespObj,'SelectedChannels',OnChannels)
   end
   
case 'selecttext',
   % Toggle the selected column on and off, turn everything else off
   OnChannels = AllRespProps.SelectedChannels;
   OnChannels = zeros(size(OnChannels));
   ToggleColor=get(gcbo,'Color');
   
   if isequal(ToggleColor,[1 0 0]); % Red, was on before
      ChannelVal=0;
   else
      ChannelVal=1;
   end % if/else isequal
   
   ud=get(gcbo,'UserData');
   if isequal(ud(2),1), % Selecting an output..highlight whole row
      OnChannels(ud(1),:)=1;
   else
      OnChannels(:,ud(1))=1;
   end
   
   %---Show appropriate response plots
   set(RespObj,'SelectedChannels',OnChannels)
   
case 'setgrid',
   %---Callback from set(RespObj,'Grid',...
   plottype = AllRespProps.ResponseType;
   gridflag = AllRespProps.Grid;
   LTIdisplayAxes = AllRespProps.PlotAxes;
   
   if ~strcmp(plottype,'pzmap') & ~strcmp(plottype,'nichols')
      switch gridflag, 
      case 'on',% Add grid      
         
         set(LTIdisplayAxes(:),'Xgrid','on','Ygrid','on');
         
      case 'off', % Remove grid
         set(LTIdisplayAxes(:),'Xgrid','off','Ygrid','off');
         
      end % switch gridflag
   end % ~strcmp(plottype 
   
case 'setnicgrid',
   %---Callback from set(PZrespObj,'Grid'...
   gridflag = AllRespProps.Grid;
   LTIdisplayAxes = AllRespProps.PlotAxes;
   if ~isequal(size(LTIdisplayAxes),[1 1])
      switch gridflag
      case 'on',% Add grid      
         set(LTIdisplayAxes(:),'Xgrid','on','Ygrid','on');
      case 'off', % Remove grid
         set(LTIdisplayAxes(:),'Xgrid','off','Ygrid','off');
      end % switch gridflag
      
   elseif isequal(size(LTIdisplayAxes),[1 1]),
      %---Add/remove an Ngrid
      switch gridflag, 
      case 'on',% Add grid      
         [phase,gain] = ngrid;
         Color = get(LTIdisplayAxes(1,1),'Xcolor');
         GridLines = line(phase,gain,'LineStyle',':',...
            'Color',Color,'parent',LTIdisplayAxes(1,1));
         set(RespObj,'GridLines',GridLines);
      case 'off',
         GridLines = get(RespObj,'GridLines');
         GridLines = GridLines(ishandle(GridLines));
         delete(GridLines);
      end % switch gridflag
   end % if/else size(LTIdisplayaxes)
   
case 'setpzgrid',
   %---Callback from set(PZrespObj,'Grid'...
   gridflag = AllRespProps.Grid;
   GridType = AllRespProps.GridType;
   
   switch gridflag,
   case 'on',
      switch GridType
      case 'square',
         LTIdisplayAxes = AllRespProps.PlotAxes;
         set(LTIdisplayAxes(:),'Xgrid','on','Ygrid','on');
         
      otherwise
         eval(['GridLines = ',GridType,';'])
         set(RespObj,'GridLines',GridLines);
      end% switch GridType
      
   case 'off',
      switch GridType
      case 'square',
         LTIdisplayAxes = AllRespProps.PlotAxes;
         set(LTIdisplayAxes(:),'Xgrid','off','Ygrid','off');
         
      otherwise
         GridLines = get(RespObj,'GridLines');
         GridLines = GridLines(ishandle(GridLines));
         delete(GridLines);
      end % switch GridType
   end, % switch gridflag
   
case 'replotopt',
   IndShow = [];
   MarkerType = varargin{3};
   OptType = varargin{4};
   RespObj = LocalRemovePlotOpt(RespObj,MarkerType,IndShow);
   eval(['RespObj = ',OptType,'(RespObj,IndShow);']);

case 'showmargin',
   %---Display/Hide the Stability Margin Marker
   IndShow = [];
   if ni>2,
      IndShow = varargin{3};
   end
   
   ShowFlag = get(RespObj,'StabilityMargin');
   
   switch ShowFlag,
   case 'on', % Plot the Stability Margin markers (should never need to be calculated)
      RespObj = LocalPlotStability(RespObj,IndShow);
   case 'off', % Remove the Stability Margin markers
      RespObj = LocalRemovePlotOpt(RespObj,'StabilityMarginMarker',IndShow);
   end
   
case 'showpeak',
   %---Display/Hide the Peak Response Marker
   IndShow = [];
   if ni>2,
      IndShow = varargin{3};
   end
      
   switch AllRespProps.PeakResponse,
   case 'on', % Plot the Peak Response markers (should never need to be calculated)
      RespObj = LocalPlotPeak(RespObj,IndShow);
   case 'off', % Remove the Peak Response markers
      RespObj = LocalRemovePlotOpt(RespObj,'PeakResponseMarker',IndShow);
   end
   
case 'showrise',
   IndShow = [];
   if ni>2,
      IndShow = varargin{3};
   end
      
   switch AllRespProps.RiseTime,
   case 'on', % Plot the Rise Time markers (should never need to be calculated)
      RespObj = LocalPlotRiseTime(RespObj,IndShow);
   case 'off', % Remove the Rise Time markers
      RespObj = LocalRemovePlotOpt(RespObj,'RiseTimeMarker',IndShow);
   end
   
case 'showsettling',
   %---Display/Hide the Settling Time Marker
   IndShow = [];
   if ni>2,
      IndShow = varargin{3};
   end
      
   switch AllRespProps.SettlingTime,
   case 'on', % Plot the Settling Time markers (should never need to be calculated)
      RespObj = LocalPlotSetTime(RespObj,IndShow);
   case 'off', % Remove the Settling Time markers
      RespObj = LocalRemovePlotOpt(RespObj,'SettlingTimeMarker',IndShow);
   end
   
case 'showsteady',
   %---Display/Hide the Steady State Marker
   IndShow = [];
   if ni>2,
      IndShow = varargin{3};
   end
      
   switch AllRespProps.SteadyState,
   case 'on', % Plot the Steady State markers (should never need to be calculated)
      RespObj = LocalPlotSteadyState(RespObj,IndShow);
   case 'off', % Remove the Steady State markers
      RespObj = LocalRemovePlotOpt(RespObj,'SteadyStateMarker',IndShow);
   end   
   
case 'updateselector',
   %---Callback when setting SelectedChannels, if the Selector is open
   SelectorFig = get(ContextMenu.ChannelMenu,'UserData');
   CloseButton = findobj(SelectorFig,'Tag','SelectorCloseButton');
   udClose=get(CloseButton,'UserData');
   
   %---Turn on Dots
   OnChannels = logical(get(RespObj,'SelectedChannels'));
   set(udClose.AllDots,'Color',offFaceColor,'MarkerFaceColor',offFaceColor)
   set([udClose.AllText;udClose.InputText;udClose.OutputText],'Color',[0 0 0]);
   set(udClose.AllDots(find(OnChannels)),...
      'Color',onFaceColor,'MarkerFaceColor',onFaceColor)
   
   %---See if any text should be turned on
   [numY,numU]=size(OnChannels);
   [indy,indu]=find(OnChannels);
   OnY=unique(indy);
   OnU=unique(indu);
   if isequal(length(OnY),numY) & isequal(length(OnU),numU),
      set(udClose.AllText,'Color',[1 0 0]);
   elseif isequal(length(OnY),numY) & isequal(length(OnU),1);
      set(udClose.InputText(OnU),'Color',[1 0 0]);
   elseif isequal(length(OnY),1) & isequal(length(OnU),numU);
      set(udClose.OutputText(OnY),'Color',[1 0 0])
   end % if/else isequal...
   
case 'viewermenus',
   %---Add LTI Viewer specific menus to Response Objects
   ResponseType = AllRespProps.ResponseType;
   ContextMenu = AllRespProps.UIContextMenu;
   AllPlotTypes = {'Step';'Impulse';'Bode';'Nyquist';'Nichols';'Sigma';'PZmap'; ...
         'Lsim';'Initial'};
   indtype = strmatch(ResponseType,lower(AllPlotTypes));
   Callback = 'rguifcn(''''switchplot'''',gcbf,gcbo);';
   %---Add a Plot Type menu with current selection checked
   ContextMenu.PlotType.Main = uimenu(ContextMenu.Main,'label','Plot Type', ...
      'Position',1);
   for ctMenu = 1:length(AllPlotTypes)
      if isequal(ctMenu,indtype), CheckVal = 'on';
      else, CheckVal = 'off';
      end
      
      eval(['ContextMenu.PlotType.',AllPlotTypes{ctMenu}, ...
            '= uimenu(ContextMenu.PlotType.Main,''label'',''',AllPlotTypes{ctMenu}, ...
            ''',''Callback'',''',Callback,''',''Check'',''',CheckVal,''');']);
   end
   
   set(ContextMenu.Systems.Main,'Separator','on');
   
   %---For SISO Frequency domain responses, add a Margins menu
   numin = length(get(RespObj,'InputLabel'));
   numout = length(get(RespObj,'OutputLabel'));
   if any(strcmp(ResponseType,{'bode';'nichols';'nyquist'})) & ...
         isequal(numin,1) & isequal(numout,1),
      set(ContextMenu.PlotOptions.Main,'visible','on');
      ContextMenu.PlotOptions.StabilityMargin = uimenu(ContextMenu.PlotOptions.Main,...
         'label','Stability Margins',...
         'Callback',['menufcn(''togglemargin'',',...
            'get(get(get(gcbo,''Parent''),''Parent''),''UserData''));']);
      
   end
   set(RespObj,'UIcontextMenu',ContextMenu);
   
case 'zoom',
   %---Set the Zoom state of the LTIdisplayAxes
   ZoomState = AllRespProps.Zoom;
   FigHandle = AllRespProps.Parent;
   LTIdisplayAxes = AllRespProps.PlotAxes;
   lines=findobj(LTIdisplayAxes,'type','line');
   
   switch ZoomState,
   case {'xon','yon','on'},
      set(FigHandle,'Pointer','crosshair');
      
      %--Turn ButtonDownFcn on response plots off
      set(lines,'ButtonDownFcn',' ');
      
      % Hides the other axes from the zoom
      Zlabels = get(findobj(FigHandle,'type','axes'),{'Zlabel'});
      set([Zlabels{:}],'UserData',NaN);   
      Zlabels = get(LTIdisplayAxes,{'Zlabel'});
      set([Zlabels{:}],'UserData',[]);
      
      switch ZoomState;
      case 'xon', % xonly
         %---Nyquist and Nichols can zoom only along a column
         if any(strcmpi(AllRespProps.ResponseType,{'nyquist','nichols'})),
            groups={{'GridGroup',LTIdisplayAxes}};
         else
            groups={{'ListGroup',LTIdisplayAxes(:)}};
         end
         zoomfcn='xonly';
         zoomofffcn = 'respfcn(''resetxzoom'',gca);';
      case 'yon', % yonly
         groups={{'GridGroup',LTIdisplayAxes}};
         zoomfcn='yonly';
         zoomofffcn = 'respfcn(''resetyzoom'',gca);';
      case 'on', % xy
         groups={{'GridGroup',LTIdisplayAxes}};
         zoomfcn='on';
         zoomofffcn = 'respfcn(''resetxyzoom'',gca);';
      end % switch ZoomState 
      
      feval('rguizoom',FigHandle,zoomfcn);
      rguizoom(FigHandle,'setgroup',groups);
      feval('rguizoom',get(RespObj,'BackgroundAxes'),...
         'zoomofffcn',zoomofffcn);
      
   case 'reset',
      set(RespObj,'XlimMode','auto','YlimMode','auto')      
      set(RespObj,'Zoom','off')
      
   case 'off',
      
      rguizoom(FigHandle,'off');
      set(FigHandle,'Pointer','arrow');
      
      %--Turn ButtonDownFcn on response plots on
      RespLines = findobj(lines,'Tag','LTIresponseLines');
      if strcmp(AllRespProps.ResponseType,'pzmap'),
         set(RespLines,'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);');
      else
         set(RespLines,'ButtonDownFcn','rguifcn(''showbox'',gcbf);');
      end % if/else strcmp(plottype)
      
      PlotOpts = [findobj(lines,'Tag','PeakResponseMarkers','Marker','o');
         findobj(lines,'Tag','SteadyStateMarkers','Marker','o');
         findobj(lines,'Tag','RiseTimeMarkers','Marker','o');
         findobj(lines,'Tag','SettlingTimeMarkers','Marker','o');
         findobj(lines,'Tag','StabilityMarginMarkers','Marker','o')];
      if ~isempty(PlotOpts),
         set(PlotOpts,'ButtonDownFcn',...
            'rguifcn(''plotoptbuttondown'',gcbf);');
      end
   end % switch ZoomState      
   
end % switch action

%---Store any changes to the Response Object
%---Shouldn't need to do this since @object/set.m stores any changes
%set(ContextMenu.Main,'UserData',RespObj)

if nargout,
   varargout{1}=RespObj;
end

%---Turn the watch back off
if ~strcmp(action,'zoom') & ishandle(WatchFigNumber)
   watchoff(WatchFigNumber);
end

catch 
   %---Turn the watch back off
   if ~strcmp(action,'zoom') & ishandle(WatchFigNumber)
      watchoff(WatchFigNumber);
   end
end % try/catch

%------------------------------Internal Functions-------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGetAxesPosition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxesPos =LocalGetAxesPosition(Ny,Nu,Parent);

%---AxesPos is a cell array of size (Ny*Nu,1)
%---Each element in the array is a valid row vector axis position 

AxesUnit=get(Parent,'Unit');
set(Parent,'units','pixel');
position=get(Parent,'Position');
set(Parent,'unit',AxesUnit);
AxesPos=cell(Ny*Nu,1);

position(1)=position(1)+25;
position(3)=position(3)-25;
position(2)=position(2)+5;
position(4)=position(4)-17;

SWH = position(3:4)./[Nu Ny];
offset=[0.01, 0.05];
if Ny==1,
   offset(2)=0;
end
if Nu==1,
   offset(1)=0;
end
inset=offset.*SWH;
AWH = (1-3*offset).*SWH;

for ctU=1:Nu,
   for ctY=1:Ny,
      AxesPos{sub2ind([Ny,Nu],ctY,ctU)} = [(position(1:2)+[ctU-1 Ny-ctY].*SWH+inset), AWH];
   end % for ctY
end % for ctU

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGroupAxes %%%
%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalGroupAxes(RespObj);

%---Generate the correct Grid of LTIdisplayAxes and reparent the ResponseHandles
AllProps = get(RespObj);
LTIdisplayAxes = AllProps.PlotAxes;
BackgroundAxes = AllProps.BackgroundAxes;
ResponseHandles = AllProps.ResponseHandles;
OnChannels = AllProps.SelectedChannels;
AxesGrouping = AllProps.AxesGrouping;

%---Get number of needed LTIdisplayAxes based on I/O selection
[tempy,tempu] = find(OnChannels);
OnPatch=[tempy,tempu];

%---Hide the current axes
Y = get(LTIdisplayAxes,{'Ylabel'});
T = get(LTIdisplayAxes,{'Title'});
set(cat(1,Y{:}),'visible','off');
set(cat(1,T{:}),'visible','off');
set(LTIdisplayAxes,'visible','off',...
   'XticklabelMode','manual',...
   'YticklabelMode','manual')

if ~isempty(OnPatch)
   OnY = unique(tempy);
   OnU = unique(tempu);
   
   %---Modify number of axes needed (and visibility of axes titles/ylabels)
   %----based on AxesGrouping
   switch AxesGrouping
   case 'none', % No grouping
      TitleVis = 'on';
      YlabelVis = 'on';
      Ny=length(OnY); Nu=length(OnU);
   case 'all', % Group all
      if length(OnU)>1,
         TitleVis = 'off';
         OnU=1;
      else 
         TitleVis = 'on';
      end
      if length(OnY)>1
         YlabelVis = 'off';
         OnY=1;
      else
         YlabelVis = 'on';
      end
      Ny=1; Nu=1;  
   case 'inputs', % Group inputs
      if length(OnU)>1,
         TitleVis = 'off';
         OnU=1;
      else 
         TitleVis = 'on';
      end
      YlabelVis = 'on';
      Ny=length(OnY); Nu=1; 
   case 'outputs', % Group outputs
      TitleVis = 'on';
      if length(OnY)>1
         YlabelVis = 'off';
         OnY=1;
      else
         YlabelVis = 'on';
      end
      Ny=1; Nu=length(OnU); 
   end % switch AxesGrouping
   
   %---Change the number of axes for various response types
   ResponseType = get(RespObj,'ResponseType');
   switch ResponseType,
   case {'bode','margin'}
      OnY=sort([(2*OnY)-1; 2*OnY]);
      Ny=Ny*2;
   case {'lsim','initial'},
      Nu=1;
      OnU=1;
   end
   
   %---Get axes positions based on number of axes
   AxesPos = LocalGetAxesPosition(Ny,Nu,BackgroundAxes);
   
   %---Resize the necessary LTIdisplayAxes
   ResizeAxes=LTIdisplayAxes(OnY,:);
   ResizeAxes=ResizeAxes(:,OnU);
   set(ResizeAxes(:),'Unit','pixel');
   set(ResizeAxes(:),{'Position'},AxesPos)
   set(ResizeAxes(:),'Unit','norm');
   
   %---Re-parent the ResponseHandles
   for ctOn=1:size(OnPatch,1),
      for ctSys=1:length(ResponseHandles),
         switch ResponseType
         case {'bode','margin'};,
            RHrow=(2*OnPatch(ctOn,1))-1;
         otherwise
            RHrow = OnPatch(ctOn,1);
         end
         switch AxesGrouping
         case 'none', % No grouping
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',...
               ResizeAxes(find(RHrow==OnY),find(OnPatch(ctOn,2)==OnU)));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',...
                  ResizeAxes(find(2*OnPatch(ctOn,1)==OnY),find(OnPatch(ctOn,2)==OnU)));
            end
            
         case 'all', % Group all
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(1,1));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2,1));
            end
            
         case 'inputs', % Group inputs
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(find(RHrow==OnY),1));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2*find(OnPatch(ctOn,1)==OnY),1));
            end
            
         case 'outputs', % Group outputs
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(1,find(OnPatch(ctOn,2)==OnU)));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2,find(OnPatch(ctOn,2)==OnU)));
            end
            
         end % switch AxesGrouping
      end % for ctSys
   end % for ctOn
   
   %---Turn Axes visibility on
   set(ResizeAxes(:,1),'YtickLabelMode','auto')
   if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
      Y=get(ResizeAxes(2:2:end,1),{'Ylabel'});
   else
      Y=get(ResizeAxes(:,1),{'Ylabel'});
   end
   set(cat(1,Y{:}),'visible',YlabelVis);
   set(ResizeAxes(end,:),'XtickLabelMode','auto');
   T=get(ResizeAxes(1,:),{'Title'});
   set(cat(1,T{:}),'visible',TitleVis);
   set(ResizeAxes(1:end-1,:),'xticklabel',[]);
   set(ResizeAxes(:,2:end),'yticklabel',[])
   
   set(ResizeAxes,'visible','on')
   
end

%%%%%%%%%%%%%%%%%%%%
%%% LocalInd2Sub %%%
%%%%%%%%%%%%%%%%%%%%
function ind = LocalInd2Sub(siz,ndx),
%IND2SUB Multiple subscripts from linear index.
%   IND2SUB is used to determine the equivalent subscript values
%   corresponding to a given single index into an array.
%
%   Modified: 2-12-98, to return entire index in a signal variable

ind=zeros(size(siz));
n = length(siz);
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
for i = n:-1:1,
  ind(i) = floor(ndx/k(i))+1;
  ndx = rem(ndx,k(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalMakeSelector %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalMakeSelector(RespObj,OnFaceColor,OffFaceColor);

%---Get other relevant data from Object
OnChannels = get(RespObj,'SelectedChannels');
ContextMenu = get(RespObj,'UIcontextMenu');
plottype=get(RespObj,'ResponseType');
[numOutputs,numInputs]=size(get(RespObj,'PlotAxes'));
if any(strcmp(plottype,{'bode';'margin'})),
   numOutputs = numOutputs/2;
end  

%---Can not bring up for SISO systems or for PZMAP or SIGMA responses
if (numOutputs==1) & (numInputs==1),
   warndlg('I/O channel selection is not available for SISO models','I/O selection warning');
   return
else
   if any(strcmp(plottype,{'pzmap';'sigma'})),
      warndlg('I/O channel selection is not available for the current response type',...
         'I/O selection warning');
      return
   end
end

% Get common I/O names
inNames = get(RespObj,'InputLabel');
% Remove the inNames when opening for INITIAL or LSIM
if any(strcmpi(plottype,{'initial';'lsim'})),
   inNames={''};
end

outNames = get(RespObj,'OutputLabel'); 

StdColor = get(0,'DefaultFigureColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'points';

%---Get position of Parent Figure
Parent = get(RespObj,'Parent');
ParentUnit = get(Parent,'Unit');
set(Parent,'Unit','pixel')
ParentPos = get(Parent,'Position');
set(Parent,'Unit',ParentUnit);

FigWidth = 150+(numInputs*20);
FigHeight = 120+(numInputs*20);
FigPos = [max([20,ParentPos(1)+(ParentPos(3)/3)-FigWidth])...
      max([20,ParentPos(2)-FigHeight]) FigWidth FigHeight];

ChannelFig=figure('Units',StdUnit,...
   'Position',PointsToPixels*FigPos,...
   'Number','off',...
   'IntegerHandle','off',...
   'HandleVisibility','Callback',...
   'Menu','none',...
   'Name',['I/O Selector: ',plottype],...
   'Color',StdColor,...
   'DeleteFcn',['respfcn(''closeselector'',',...
      'get(get(gcbf,''UserData''),''UserData''));'],...
   'UserData',ContextMenu.Main,...
   'Tag','ChannelFig');

HelpButton = uicontrol(ChannelFig,...
   'Unit',StdUnit,...
   'Position',PointsToPixels*[10 10 60 20],...
   'Style','pushbutton',...
   'String','Help',...
   'callback',['respfcn(''helpselector'',',...
      'get(get(gcbf,''UserData''),''UserData''));'],...
   'Tag','HelpButton');
CloseButton = uicontrol(ChannelFig,...
   'Unit',StdUnit,...
   'Position',PointsToPixels*[75 10 60 20],...
   'Style','pushbutton',...
   'String','Close',...
   'callback',['respfcn(''closeselector'',',...
      'get(get(gcbf,''UserData''),''UserData''));'],...
   'Tag','SelectorCloseButton');   
ax = axes('Parent',ChannelFig,...
   'ButtonDownFcn',['respfcn(''selectrbbox'',',...
      'get(get(gcbf,''UserData''),''UserData''));'], ...
   'Color',StdColor,...
   'Tag','selector',...
   'Unit',StdUnit,...
   'Position',PointsToPixels*[10 40 FigPos(3)-20 FigPos(4)-50],...
   'Box','on',...
   'Ydir','reverse',...
   'Xlim',[0 numInputs+1],...
   'Ylim',[0 numOutputs+1],...
   'Xtick',[],...
   'Ytick',[]);
set(ax,'Xtick',[],'Ytick',[])

set(ax,'unit','norm');

dots=zeros(numOutputs,numInputs);
%---UserData is stored as [output#,input#], to be consistent with
%----indexing into LTI objects
for i=0:numInputs,
   for j=0:numOutputs,
      if (i==0) & (j==0),
         AllText=text(i+0.5,j+0.5,'[ all ]', ...
            'Parent',ax, ...
            'Interpreter','none', ...
            'ButtonDownFcn',['respfcn(''selectall'',',...
               'get(get(gcbf,''UserData''),''UserData''));'], ...
            'Tag','AllText', ...
            'FontSize',7, ...
            'HorizontalAlignment','center', ...
            'FontWeight','bold', ...
            'VerticalAlignment','middle');
      elseif j==0,
         InText(i,1)=text(i+0.5,j+0.5,inNames{i}, ...
            'Parent',ax, ...
            'Interpreter','none', ...
            'ButtonDownFcn',['respfcn(''selecttext'',',...
               'get(get(gcbf,''UserData''),''UserData''));'], ...
            'FontWeight','bold', ...
            'UserData',[i,2], ...
            'FontSize',7, ...
            'Tag','InText', ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle');
      elseif i==0,
         OutText(j,1)=text(i+0.5,j+0.5,outNames{j}, ...
            'Parent',ax, ...
            'Interpreter','none', ...
            'ButtonDownFcn',['respfcn(''selecttext'',',...
               'get(get(gcbf,''UserData''),''UserData''));'], ...
            'UserData',[j,1], ...
            'FontSize',7, ...
            'FontWeight','bold', ...
            'HorizontalAlignment','center', ...
            'Tag','OutText', ...
            'VerticalAlignment','middle');
      else
         if OnChannels(j,i),
            DotColor=OnFaceColor;
         else
            DotColor=OffFaceColor;
         end
         dots(j,i)=line(i+0.5,j+0.5,'Color',DotColor, ...
            'Parent',ax, ...
            'Marker','o', ...
            'MarkerFaceColor',DotColor, ...
            'MarkerEdgeColor','k', ...
            'MarkerSize',7, ...
            'LineStyle','none', ...
            'UserData',[j,i], ...
            'ButtonDownFcn',['respfcn(''selectcircle'',',...
               'get(get(gcbf,''UserData''),''UserData''));']);
      end % if/else i/j 
   end % for j
end % for i

%---Determine text colors based on OnChannels
[indy,indu]=find(OnChannels);
OnY=unique(indy);
OnU=unique(indu);
if isequal(length(OnY),numOutputs) & isequal(length(OnU),numInputs),
   set(AllText,'Color',[1 0 0]);
elseif isequal(length(OnY),numOutputs) & isequal(length(OnU),1);
   set(InText(OnU,1),'Color',[1 0 0]);
elseif isequal(length(OnY),1) & isequal(length(OnU),numInputs);
   set(OutText(OnY,1),'Color',[1 0 0])
end % if/else isequal...

%---Store handles in the Close Button
udClose = struct('AllDots',dots,...
   'AllText',AllText,'InputText',InText,'OutputText',OutText,...
   'SelectedDot',[],'LineHandles',[],'LineStyles',[],'TempText',[]);
set(CloseButton,'UserData',udClose)

%---Store the Selector handle in the Select I/Os menu
set(ContextMenu.ChannelMenu,'Userdata',ChannelFig)

%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotPeak %%%
%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalPlotPeak(RespObj,IndShow);

AllProps = get(RespObj);

LTIdisplayAxes = AllProps.PlotAxes;
PeakRespVals = get(RespObj,'PeakResponseValue');
set(RespObj,'PeakResponseValue',PeakRespVals);
ResponseHandles = AllProps.ResponseHandles;
SystemVis = AllProps.SystemVisibility;
AllOnModels = AllProps.SelectedModels;
OnChannel = AllProps.SelectedChannels;

plottype = get(RespObj,'ResponseType');
if any(strcmp(plottype,{'step';'impulse';'initial'})),
   Xstr = 'Time';
   RowInd = 1:size(LTIdisplayAxes,1);   
else
   Xstr = 'Frequency';
   RowInd=1:2:size(LTIdisplayAxes,1);
end

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndShow),
   IndShow = [1:1:length(ResponseHandles)];
end

for ctSys = IndShow,
   Yvals = PeakRespVals(ctSys).Peak;
   Xvals = eval(['PeakRespVals(ctSys).',Xstr]);
   
   Trow = 0;
   for ctrow=1:length(RowInd),
      Trow=Trow+1;
      for ctcol=1:size(LTIdisplayAxes,2),
         Handles = ResponseHandles{ctSys}{RowInd(ctrow),ctcol};
         OnModels=AllOnModels{ctSys};
         NumArray=prod(size(Handles));
         for ctModel = 1:NumArray,
            ResponseLine = findobj(Handles{ctModel},...
               'Tag','LTIresponseLines');
            
            %---Check visibility of Model against System
            ModelVis=SystemVis{ctSys};
            if ~OnModels(ctModel) | ~OnChannel(ctrow,ctcol),
               ModelVis='off';
            end
            
            CC=get(ResponseLine(1),'Color');
            LineParent = get(ResponseLine(1),'Parent');
            Y=get(LTIdisplayAxes(ctrow,ctcol),'Ylim');
            X=get(LTIdisplayAxes(ctrow,ctcol),'Xlim');
            T=line([Xvals(Trow,ctcol,ctModel),Xvals(Trow,ctcol,ctModel)],...
               [Y(1),Yvals(Trow,ctcol,ctModel)],...
               'parent',LineParent,'color','k',...
               'Tag','PeakResponseMarker','HitTest','off',...
               'linestyle','-.','HandleVisibility','off','visible',ModelVis);
            T2=line([X(1),Xvals(Trow,ctcol,ctModel)],...
               [Yvals(Trow,ctcol,ctModel),Yvals(Trow,ctcol,ctModel)],...
               'Tag','PeakResponseMarker','HitTest','off',...
               'parent',LineParent,'color','k',...
               'linestyle','-.','HandleVisibility','off','visible',ModelVis);
            if NumArray>1,
               ArrayDimsStr = sprintf(',%d',LocalInd2Sub(size(Handles),ctModel));
               UdStr = ['System: ',PeakRespVals(ctSys).System,'(',...
                     num2str(ctrow),',',num2str(ctcol),ArrayDimsStr,')'];
            else
               UdStr = ['System: ',PeakRespVals(ctSys).System];
            end
            T3=line(Xvals(Trow,ctcol,ctModel),Yvals(Trow,ctcol,ctModel),...
               'parent',LineParent,...
               'Tag','PeakResponseMarker',...
               'Marker','o','HandleVisibility','off', ...
               'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
               'MarkerSize',6,'HandleVisibility','off','visible',ModelVis, ...
               'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
               'UserData',{UdStr; ...
                  ['Max: ',num2str(Yvals(Trow,ctcol,ctModel),'%0.3g')]; ...
                  ['At ',Xstr,': ',num2str(Xvals(Trow,ctcol,ctModel),'%0.3g')]});
            Handles{ctModel} = [Handles{ctModel};T;T2;T3];
         end % for ctModel   
         ResponseHandles{ctSys}{RowInd(ctrow),ctcol}=Handles;   
      end % for ctcol  
   end % for ctrow
end % for ctSys

set(RespObj,'ResponseHandles',ResponseHandles)

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotRiseTime %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalPlotRiseTime(RespObj,IndShow);

AllProps = get(RespObj);

LTIdisplayAxes = AllProps.PlotAxes;
RiseTimeVals = get(RespObj,'RiseTimeValue');
set(RespObj,'RiseTimeValue',RiseTimeVals);
ResponseHandles = AllProps.ResponseHandles;
SystemVis = AllProps.SystemVisibility;
AllOnModels = AllProps.SelectedModels;
OnChannel = AllProps.SelectedChannels;

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndShow),
   IndShow = [1:1:length(ResponseHandles)];
end

for ctSys = IndShow,
   Yvals = RiseTimeVals(ctSys).Amplitude;
   Xvals = RiseTimeVals(ctSys).RiseTime;
   Startvals = RiseTimeVals(ctSys).StartTime;
   
   for ctrow=1:size(LTIdisplayAxes,1),
      for ctcol=1:size(LTIdisplayAxes,2),
         Handles = ResponseHandles{ctSys}{ctrow,ctcol};
         OnModels=AllOnModels{ctSys};
         NumArray = prod(size(Handles));
         for ctModel = 1:NumArray,
            ResponseLine = findobj(Handles{ctModel},...
               'Tag','LTIresponseLines');
            
            %---Check visibility of Model against System
            ModelVis=SystemVis{ctSys};
            if ~OnModels(ctModel) | ~OnChannel(ctrow,ctcol),
               ModelVis='off';
            end
            
            CC=get(ResponseLine,'Color');
            LineParent = get(ResponseLine,'Parent');
            X=get(LTIdisplayAxes(ctrow,ctcol),'Xlim');
            T=line([X(1);Xvals(ctrow,ctcol,ctModel)],...
               [Yvals(ctrow,ctcol,ctModel);Yvals(ctrow,ctcol,ctModel)],...
               'parent',LineParent,'HandleVisibility','off', ...
               'Tag','RiseTimeMarker','HitTest','off',...
               'color','k','linestyle','-.','visible',ModelVis);
            Y=get(LTIdisplayAxes(ctrow,ctcol),'Ylim');
            T2=line([Startvals(ctrow,ctcol,ctModel);Startvals(ctrow,ctcol,ctModel)],...
               [Y(1);Yvals(ctrow,ctcol,ctModel)],...
               'Tag','RiseTimeMarker','HitTest','off',...
               'parent',LineParent, ...
               'HandleVisibility','off','visible',ModelVis, ...
               'color','k','linestyle','-.');
            T3=line([Xvals(ctrow,ctcol,ctModel);Xvals(ctrow,ctcol,ctModel)]+Startvals(ctrow,ctcol,ctModel),...
               [Y(1),Yvals(ctrow,ctcol,ctModel)],...
               'Tag','RiseTimeMarker','HitTest','off',...
               'parent',LineParent, ...
               'HandleVisibility','off','visible',ModelVis, ...
               'color','k','linestyle','-.');
            if NumArray>1,
               ArrayDimsStr = sprintf(',%d',LocalInd2Sub(size(Handles),ctModel));
               UdStr = ['System: ',RiseTimeVals(ctSys).System,'(',...
                     num2str(ctrow),',',num2str(ctcol),ArrayDimsStr,')'];
            else
               UdStr = ['System: ',RiseTimeVals(ctSys).System];
            end
            if isfinite(Xvals(ctrow,ctcol,ctModel)),
               udstr={UdStr;['Rise Time: ',num2str(Xvals(ctrow,ctcol,ctModel),'%0.3g')]};
            elseif isinf(Xvals(ctrow,ctcol,ctModel)),
               udstr={UdStr;['is unstable']};
            elseif isnan(Xvals(ctrow,ctcol,ctModel)),
               udstr={UdStr;['Rise Time: N/A']};
            end
            T4=line(Xvals(ctrow,ctcol,ctModel)+Startvals(ctrow,ctcol,ctModel),Yvals(ctrow,ctcol,ctModel),'marker','o',...
            'Tag','RiseTimeMarker',...
            'markersize',6,'HandleVisibility','off', ...
            'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
            'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);',...
            'parent',LineParent, ...
            'UserData',udstr,'visible',ModelVis);	
            Handles{ctModel} = [Handles{ctModel};T;T2;T3;T4];
         end % for ctModel   
         ResponseHandles{ctSys}{ctrow,ctcol}=Handles;   
      end % for ctcol
   end % for ctrow
end % for ctSys

set(RespObj,'ResponseHandles',ResponseHandles)

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotSetTime %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalPlotSetTime(RespObj,IndShow);

AllProps = get(RespObj);

LTIdisplayAxes = AllProps.PlotAxes;
SetTimeVals = get(RespObj,'SettlingTimeValue');
set(RespObj,'SettlingTimeValue',SetTimeVals);
ResponseHandles = AllProps.ResponseHandles;
SystemVis = AllProps.SystemVisibility;
SetLim = AllProps.SettlingTimeThreshold;
AllOnModels = AllProps.SelectedModels;
OnChannel = AllProps.SelectedChannels;

if isa(RespObj,'stepplot'),
   SteadyStateVal = AllProps.SteadyStateValue;
end

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndShow),
   IndShow = [1:1:length(ResponseHandles)];
end

for ctSys = IndShow,
   Yvals = SetTimeVals(ctSys).Amplitude;
   Xvals = SetTimeVals(ctSys).SettlingTime;
   if isa(RespObj,'stepplot'),
      K = SteadyStateVal(ctSys).Amplitude;
   elseif isa(RespObj,'impplot'),
      K = zeros([size(ResponseHandles{ctSys}),size(ResponseHandles{ctSys}{1})]);
   end
   
   for ctrow=1:size(LTIdisplayAxes,1),
      for ctcol=1:size(LTIdisplayAxes,2),
         Handles = ResponseHandles{ctSys}{ctrow,ctcol};
         OnModels=AllOnModels{ctSys};
         NumArray = prod(size(Handles));
         for ctModel = 1:NumArray,
            if ~isinf(Xvals(ctrow,ctcol,ctModel)) & ~isnan(Xvals(ctrow,ctcol,ctModel)),
               ResponseLine = findobj(Handles{ctModel},...
                  'Tag','LTIresponseLines');
               
               %---Check visibility of Model against System
               ModelVis=SystemVis{ctSys};
               if ~OnModels(ctModel) | ~OnChannel(ctrow,ctcol),
                  ModelVis='off';
               end
               CC=get(ResponseLine,'Color');
               LineParent = get(ResponseLine,'Parent');
               
               TargetUp = SetTimeVals(ctSys).Amplitude(ctrow,ctcol,ctModel);
               TargetDown = K(ctrow,ctcol,ctModel) - ...
                  (SetTimeVals(ctSys).Amplitude(ctrow,ctcol,ctModel) - ...
                  K(ctrow,ctcol,ctModel));
               
               if NumArray>1,
                  ArrayDimsStr = sprintf(',%d',LocalInd2Sub(size(Handles),ctModel));
                  UdStr = ['System: ',SetTimeVals(ctSys).System,'(',...
                        num2str(ctrow),',',num2str(ctcol),ArrayDimsStr,')'];
               else
                  UdStr = ['System: ',SetTimeVals(ctSys).System];
               end
               udstr={UdStr; ...
                     ['Settling Time: ',num2str(Xvals(ctrow,ctcol,ctModel),'%0.3g')]};
               Xlim=get(LTIdisplayAxes(ctrow,ctcol),'Xlim');
               T=line(Xlim,[TargetUp,TargetUp],...
                  'Tag','SettlingTimeMarker','HitTest','off',...
                  'parent',LineParent,'HandleVisibility','off', ...
                  'color','k','linestyle','-.','visible',ModelVis);
               T1=line(Xlim,[TargetDown,TargetDown],...
                  'Tag','SettlingTimeMarker','HitTest','off',...
                  'parent',LineParent,'HandleVisibility','off', ...
                  'color','k','linestyle','-.','visible',ModelVis);
               
               Y=get(LTIdisplayAxes(ctrow,ctcol),'Ylim');
               T2=line([Xvals(ctrow,ctcol,ctModel);Xvals(ctrow,ctcol,ctModel)],...
                  [Y(1),Yvals(ctrow,ctcol,ctModel)],...
                  'Tag','SettlingTimeMarker','HitTest','off',...
                  'parent',LineParent,'HandleVisibility','off', ...
                  'color','k','linestyle','-.','visible',ModelVis);
               T3=line(Xvals(ctrow,ctcol,ctModel),Yvals(ctrow,ctcol,ctModel),...
                  'marker','o','markersize',6,'HandleVisibility','off', ...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Tag','SettlingTimeMarker',...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);',...
                  'parent',LineParent, ...
                  'UserData',udstr,'visible',ModelVis);	
               
               Handles{ctModel} = [Handles{ctModel};T;T1;T2;T3];
            end % if ~isinf
         end % for ctModel
         ResponseHandles{ctSys}{ctrow,ctcol}=Handles;   
         end % for ctcol
   end % for ctrow
end % for ctSys

set(RespObj,'ResponseHandles',ResponseHandles)

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotStability %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalPlotStability(RespObj,IndShow);

AllProps = get(RespObj);

LTIdisplayAxes = AllProps.PlotAxes;
MarginVals = get(RespObj,'StabilityMarginValue');
set(RespObj,'StabilityMarginValue',MarginVals);
ResponseHandles = AllProps.ResponseHandles;
ResponseType = AllProps.ResponseType;
SystemVis = AllProps.SystemVisibility;
AllOnModels = AllProps.SelectedModels;
MagUnit = AllProps.MagnitudeUnits;
FreqUnit = AllProps.FrequencyUnits;
PhUnit = AllProps.PhaseUnits;
OnChannel = AllProps.SelectedChannels;

if strcmpi(MagUnit,'decibels')
      Gmline = 0;
      MagStr = ' dB';
else
	Gmline = 1;
      MagStr='';
end % if strcmpi(MagUnit)
 
if strncmpi(FreqUnit,'h',1)
   FreqStr = ' Hertz';
else
   FreqStr = ' rad/sec';
end

if strcmpi(PhUnit,'degrees')
   PhStr = ' deg.';
   Pmline=-180;
else
   PhStr = ' rad.';
   Pmline = -pi;
end

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndShow),
   IndShow = [1:1:length(ResponseHandles)];
end
unstabFlag = 0;

for ctSys = IndShow,
   OnModels=AllOnModels{ctSys};
   Handles1 = ResponseHandles{ctSys}{1,1};
   if strcmp(ResponseType,'bode');
      Handles2 = ResponseHandles{ctSys}{2,1};
   end
   NumArray = prod(size(Handles1));
   Tg=[];Tp=[];
   sysname = MarginVals(ctSys).System;
   Gm = MarginVals(ctSys).GainMargin;
   Wcg = MarginVals(ctSys).GMFrequency;
   Pm = MarginVals(ctSys).PhaseMargin;
   Wcp = MarginVals(ctSys).PMFrequency;

   switch ResponseType,
   case 'bode',
      if strcmpi(MagUnit,'decibels'),
         GmPlot = -1*Gm;
      else
         GmPlot = 1./Gm;
      end
   case 'nyquist',
      AllFreqs = AllProps.Frequency;
      if strcmpi(MagUnit,'decibels'),
         GmAct = 10.^(Gm./20);
      else
         GmAct = Gm;
      end
   case 'nichols',
      AllFreqs = AllProps.Frequency;
      if strcmpi(MagUnit,'decibels'),
         GmDb = Gm;
      else
         GmDb = 20*log10(Gm);
      end
      if strcmpi(PhUnit,'degrees')
         PmDeg = Pm;
      else,
         PmDeg = (180/pi)*Pm;
      end
   end % switch ResponseType

   for ctModel = 1:NumArray,
      if ~unstabFlag & (~Pm(ctModel) & isnan(Wcp(ctModel)) & isnan(Wcg(ctModel)) | ...
            isinf(Pm(ctModel)) | isinf(Gm(ctModel)) ) 
         LTIviewerFig=AllProps.Parent;
         ST = findobj(LTIviewerFig,'Tag','StatusText');
         if strcmp(ResponseType,'bode'),
            set(ST,'string',['Infinite or zero (unstable) stability margins ', ...
                  'are displayed as open circles.']);
         else
            set(ST,'string',['Infinite or zero (unstable) stability margins ', ...
                  'are not displayed.']);
         end           
      end
      
      ResponseLine = findobj(Handles1{ctModel},'Tag','LTIresponseLines');     
      CC=get(ResponseLine(1),'Color');
      %---Check visibility of Model against System
      
      ModelVis=SystemVis{ctSys};
      if ~OnModels(ctModel),
         ModelVis='off';
      end
      
      if NumArray>1,
         ArrayDimsStr = sprintf(',%d',LocalInd2Sub(size(Handles1),ctModel));
         UdStr = ['System: ',sysname,'(1,1',ArrayDimsStr,')'];
      else
         UdStr = ['System: ',sysname];
      end
      switch ResponseType
      case 'bode',
         %---Gm lines
         Xd=get(ResponseLine(1),'Xdata');
         Yd=get(ResponseLine(1),'Ydata');
         if ~isempty(Wcg) & ~isnan(Wcg(ctModel)), 
            if (Wcg(ctModel) > Xd(1)) & (Wcg(ctModel) < Xd(end)),
               Xlim = get(LTIdisplayAxes(1,1),'Xlim');
               Tg(1,1)=line([Wcg(ctModel);Wcg(ctModel)],...
                  [GmPlot(ctModel);Gmline],'Parent',LTIdisplayAxes(1,1), ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'HandleVisibility','off','HitTest','off',...
                  'Color',[.7 .7 .7],'LineStyle','-');
               %---Changing the linestyle below requires a change in AXESLIMS.m
               Tg(2,1)=line(Xlim,[Gmline;Gmline],'parent',LTIdisplayAxes(1,1), ...
                  'Visible',ModelVis,'HandleVisibility','off',...
                  'Color',[.7 .7 .7],'LineStyle','-.');
               Tg(3,1)=line([Wcg(ctModel)],[GmPlot(ctModel)],...
                  'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
                  'Tag','StabilityMarginMarker',...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr];...
                     ['Frequency: ',num2str(Wcg(ctModel),'%0.3g'),FreqStr]});
               Handles1{ctModel} = [Handles1{ctModel};Tg];
            else,
               if Wcg(ctModel) < Xd(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               str = ['Frequency: ',num2str(Wcg(ctModel),'%0.3g')];
               if isfinite(Wcg(ctModel))
                  str = [str,FreqStr];
               end
               Tg(1,1)=line(Xpoint,Ypoint,...
                  'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
                  'Tag','StabilityMarginMarker',...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr];str});
               Handles1{ctModel} = [Handles1{ctModel};Tg];
            end % if/else Wcg inside plotted range of frequencies.
         else,
            if isinf(Gm(ctModel))
               GMstr = 'Gain Margin: Inf';
            else 
               GMstr = 'Unstable closed loop';
            end
            Tg(1,1)=line(Xd(end),[Yd(end)],...
               'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
               'Visible',ModelVis,'MarkerEdgeColor',CC, ...
               'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
               'Tag','StabilityMarginMarker',...
               'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
               'UserData',{UdStr;GMstr});
            Handles1{ctModel} = [Handles1{ctModel};Tg];
         end
         
         % Pm lines
         if Pm<0,
            Pmline=-Pmline;
         end
         ResponseLine2 = findobj(Handles2{ctModel},'Tag','LTIresponseLines');     
         Xd=get(ResponseLine2(1),'Xdata');
         Yd=get(ResponseLine2(1),'Ydata');
         if ~isempty(Wcp) & isfinite(Wcp(ctModel)),
            if (Wcp(ctModel) > Xd(1)) & (Wcp(ctModel) < Xd(end)),
               str = ['Frequency: ',num2str(Wcp(ctModel),'%0.3g')];
               if isfinite(Wcp(ctModel))
                  str = [str,FreqStr];
               end
               Xlim = get(LTIdisplayAxes(2,1),'Xlim');
               Tp(1,1)=line([Wcp(ctModel);Wcp(ctModel)],[Pm(ctModel)+Pmline;Pmline],...
                  'Parent',LTIdisplayAxes(2,1),'HitTest','off','Tag','StabilityMarginMarker', ...
                  'Visible',ModelVis,'HandleVisibility','off','Color',[.7 .7 .7],'LineStyle','-');
               Tp(2,1)=line(Xlim,[Pmline Pmline],'parent',LTIdisplayAxes(2,1), ...
                  'Visible',ModelVis,'HandleVisibility','off','HitTest','off',...
                  'Tag','StabilityMarginMarker','Color',[.7 .7 .7],'LineStyle','-.');
               Tp(3,1)=line(Wcp(ctModel),[Pm(ctModel)+Pmline],...
                  'Parent',LTIdisplayAxes(2,1),'Handle','off', ...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Phase Margin: ',num2str(Pm(ctModel),'%0.3g'),PhStr];str});
               Handles2{ctModel} = [Handles2{ctModel};Tp];
            else
               if Wcp(ctModel) < Xd(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               Tp(1,1)=line(Wcp(ctModel),[Pm(ctModel)+Pmline],...
                  'Parent',LTIdisplayAxes(2,1),'Handle','off', ...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Phase Margin: ',num2str(Pm(ctModel),'%0.3g'),PhStr]; ...
                     ['Frequency: ',num2str(Wcp(ctModel),'%0.3g'),FreqStr]});
               Handles2{ctModel} = [Handles2{ctModel};Tp];
            end % if/else Wcg inside plotted range of frequencies.
         elseif isinf(Pm(ctModel)),
            Tp(1,1)=line(Xd(end),Yd(end),...
               'Parent',LTIdisplayAxes(2,1),'Handle','off', ...
               'Visible',ModelVis,'MarkerEdgeColor',CC,...
               'Marker','o','MarkerSize',6,'Tag','StabilityMarginMarker',...
               'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
               'UserData',{UdStr; ...
                  'Phase Margin: Inf'});
            Handles2{ctModel} = [Handles2{ctModel};Tp];            
         end
         
      case 'nyquist',
         % Need the frequency data for each curve, to make sure the margin lines on it.
         Xd=get(ResponseLine(1),'Xdata');
         Yd=get(ResponseLine(1),'Ydata');
         ud = get(ResponseLine(1),'UserData');
         FreqVec = AllFreqs{ud.System}{ud.Array(1,1),ud.Array(1,2)};;
         if ~isempty(Wcg) & isfinite(GmAct(ctModel)), 
            if (Wcg(ctModel) > FreqVec(1)) & (Wcg(ctModel) < FreqVec(end)),
               Tg(1,1)=line([-1;-1/GmAct(ctModel)],[0;0],'parent',LTIdisplayAxes(1,1),...
                  'HandleVisibility','off',...
                  'Tag','StabilityMarginMarker',...
                  'Color',[.7 .7 .7], ...
                  'Visible',ModelVis,'linestyle','-');
               Tg(2,1)=line([-1/GmAct(ctModel)],[0],'Parent',LTIdisplayAxes(1,1),...
                  'Tag','StabilityMarginMarker',...
                  'HandleVisibility','off','visible',ModelVis, ...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr]; ...
                     ['Frequency: ',num2str(Wcg(ctModel),'%0.3g'),FreqStr]});
               Tg(3,1)=line([-1],[0],'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'visible',ModelVis,'color','k','marker','+','markersize',8);
            elseif Gm(ctModel),
               if Wcg(ctModel) < FreqVec(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               str = ['Frequency: ',num2str(Wcg(ctModel),'%0.3g')];
               if isfinite(Wcg(ctModel))
                  str = [str,FreqStr];
               end
               Tg(1,1)=line(Xpoint, Ypoint,'Parent',LTIdisplayAxes(1,1),...
                  'Tag','StabilityMarginMarker',...
                  'HandleVisibility','off','visible',ModelVis, ...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr; ...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr];str});
            end % if/else Wcg in the range of plotted frequencies
         end % if ~isempty(Wcg...)
         
         if ~isempty(Wcp) & isfinite(Pm(ctModel)), 
            if (Wcp(ctModel) > FreqVec(1)) & (Wcp(ctModel) < FreqVec(end)),
               %---Find the intersection of Gm with the curve
               if strcmpi(PhUnit,'degrees'),
                  Xpm=cos((pi/180)*(Pm(ctModel)+180));
                  Ypm=sin((pi/180)*(Pm(ctModel)+180));
               else
                  Xpm=cos(Pm(ctModel)+pi);
                  Ypm=sin(Pm(ctModel)+pi);
               end, % if/else strcmp(PhUnit)
               Tp(1,1)=line([0,Xpm],[0;Ypm],'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'color',[.7 .7 .7],'linestyle','-','visible',ModelVis);	
               Tp(2,1)=line(0,0,'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'color',[.7 .7 .7],'Marker','+','visible',ModelVis);	
               Tp(3,1)=line(Xpm,Ypm,'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC,'visible',ModelVis, ...
                  'marker','o','markersize',6,'visible',ModelVis,...
                  'buttondownfcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Phase Margin: ',num2str(Pm(ctModel),'%0.3g'),PhStr]; ...
                     ['Frequency: ',num2str(Wcp(ctModel),'%0.3g'),FreqStr]});
            elseif Pm(ctModel),
               if Wcg(ctModel) < FreqVec(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               str = ['Frequency: ',num2str(Wcp(ctModel),'%0.3g')];
               if isfinite(Wcp(ctModel))
                  str = [str,FreqStr];
               end
               Tp(1,1)=line(Xpoint,Ypoint,'parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC,'visible',ModelVis, ...
                  'marker','o','markersize',6,'visible',ModelVis,...
                  'buttondownfcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Phase Margin: ',num2str(Pm(ctModel),'%0.3g'),PhStr];str});
            end % if/else Wcp in range of plotted freq's.
         end % if/else ~isempty(Wcp...
         
         Handles1{ctModel} = [Handles1{ctModel};Tg;Tp];
         
      case 'nichols',
         Xd=get(ResponseLine(1),'Xdata');
         Yd=get(ResponseLine(1),'Ydata');
         ud = get(ResponseLine(1),'UserData');
         FreqVec = AllFreqs{ud.System}{ud.Array(1,1),ud.Array(1,2)};;
         if ~isempty(Wcg) & isfinite(GmDb(ctModel)), 
            if (Wcg(ctModel) > FreqVec(1)) & (Wcg(ctModel) < FreqVec(end)),
               Tg(1,1)=line([-180;-180],[0;-1*GmDb(ctModel)],'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'Color',[.7 .7 .7],'LineStyle','-');
               Tg(2,1)=line(-180,-1*GmDb(ctModel),'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'Buttondownfcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr];...
                     ['Frequency: ',num2str(Wcg(ctModel),'%0.3g'),FreqStr]});
            elseif Gm(ctModel)
               if Wcg(ctModel) < FreqVec(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               str = ['Frequency: ',num2str(Wcg(ctModel),'%0.3g')];
               if isfinite(Wcg(ctModel))
                  str = [str,FreqStr];
               end
               Tg(1,1)=line(Xpoint,Ypoint,'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'Buttondownfcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Gain Margin: ',num2str(Gm(ctModel),'%0.3g'),MagStr];str});
            end % if/else Wcg in range of frequencies
         end % if/else ~isempty(Wcg)
         
         if ~isempty(Wcp) & isfinite(PmDeg(ctModel)), 
            if (Wcp(ctModel) > FreqVec(1)) & (Wcp(ctModel) < FreqVec(end)),
               Tp(1,1)=line([-180;-180+PmDeg(ctModel)],[0;0],'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'Color',[.7 .7 .7],'LineStyle','-');	
               Tp(2,1)=line(-180,0,'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'Color',[.7 .7 .7],'Marker','+');	
               Tp(3,1)=line(-180+PmDeg(ctModel),0,'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Phase Margin: ',num2str(PmDeg(ctModel),'%0.3g'), 'deg.'];...
                     ['Frequency: ',num2str(Wcp(ctModel),'%0.3g'),FreqStr]});
            elseif PmDeg(ctModel)
               if Wcg(ctModel) < FreqVec(1),
                  Xpoint = Xd(1);
                  Ypoint = Yd(1);
               else
                  Xpoint = Xd(end);
                  Ypoint = Yd(end);
               end
               str = ['Frequency: ',num2str(Wcp(ctModel),'%0.3g')];
               if isfinite(Wcp(ctModel))
                  str = [str,FreqStr];
               end
               Tp(1,1)=line(Xpoint,Ypoint,'Parent',LTIdisplayAxes(1,1),'HandleVisibility','off', ...
                  'Tag','StabilityMarginMarker',...
                  'Visible',ModelVis,'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'Marker','o','MarkerSize',6,...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);', ...
                  'UserData',{UdStr;...
                     ['Phase Margin: ',num2str(PmDeg(ctModel),'%0.3g'), 'deg.'];str});
            end % if/else Wcp in range of plotted frequencies
         end % if ~isempty(Wcg)
         Handles1{ctModel} = [Handles1{ctModel};Tg;Tp];
         
      end % switch ResponseType
   end % for ctModel
   ResponseHandles{ctSys}{1,1}=Handles1;   
   if strcmp(ResponseType,'bode');
      ResponseHandles{ctSys}{2,1}=Handles2;
   end
   
end % for ctSys

set(RespObj,'ResponseHandles',ResponseHandles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotSteadyState %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalPlotSteadyState(RespObj,IndShow);

AllProps = get(RespObj);
LTIdisplayAxes = AllProps.PlotAxes;
SteadyStateVals = AllProps.SteadyStateValue;
ResponseHandles = AllProps.ResponseHandles;
SystemVis = AllProps.SystemVisibility;
AllOnModels = AllProps.SelectedModels;
OnChannel = AllProps.SelectedChannels;

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndShow),
   IndShow = [1:1:length(ResponseHandles)];
end

for ctSys = IndShow,
   K=SteadyStateVals(ctSys).Amplitude;
   for ctrow=1:size(LTIdisplayAxes,1),
      for ctcol=1:size(LTIdisplayAxes,2),
         Handles = ResponseHandles{ctSys}{ctrow,ctcol};
         OnModels=AllOnModels{ctSys};
         NumArray = prod(size(Handles));
         for ctModel = 1:NumArray,
            ResponseLine = findobj(Handles{ctModel},...
               'Tag','LTIresponseLines');
            
            %---Check visibility of Model against System
            ModelVis=SystemVis{ctSys};
            if ~OnModels(ctModel) | ~OnChannel(ctrow,ctcol),
               ModelVis='off';
            end
            LineParent = get(ResponseLine,'Parent');
            
            CC=get(ResponseLine,'Color');
            t = get(ResponseLine,'Xdata');
            R = get(ResponseLine,'Ydata');
            sysname = SteadyStateVals(ctSys).System;
            if ~isinf(K(ctrow,ctcol,ctModel))
               T=line([t(1);t(end)],[K(ctrow,ctcol,ctModel);K(ctrow,ctcol,ctModel)],...
                  'HandleVisibility','off','HitTest','off', ...
                  'parent',LineParent,...
                  'color',[.7 .7 .7],'linestyle','-.', ...
                  'visible',ModelVis,...
                  'Tag','SteadyStateMarker');
               if NumArray>1,
                  ArrayDimsStr = sprintf(',%d',LocalInd2Sub(size(Handles),ctModel));
                  UdStr = ['System: ',SteadyStateVals(ctSys).System,'(',...
                        num2str(ctrow),',',num2str(ctcol),ArrayDimsStr,')'];
               else
                  UdStr = ['System: ',SteadyStateVals(ctSys).System];
               end
               T2=line([t(end)],[K(ctrow,ctcol,ctModel)],'HandleVisibility','off', ...
                  'MarkerEdgeColor',CC,'MarkerFaceColor',CC, ...
                  'parent',LineParent,'marker','o','markersize',6, ...
                  'ButtonDownFcn','rguifcn(''plotoptbuttondown'',gcbf);',...
                  'visible',ModelVis, ...
                  'Tag','SteadyStateMarker',...
                  'UserData',{UdStr;['DC gain: ',num2str(K(ctrow,ctcol,ctModel),'%0.3g')]});
            end
            Handles{ctModel} = [Handles{ctModel};T;T2];
         end % for ctModel
         ResponseHandles{ctSys}{ctrow,ctcol}=Handles;   
      end % for ctcol
   end % for ctrow
end % for ctSys

set(RespObj,'ResponseHandles',ResponseHandles)

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalRemovePlotOpt %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalRemovePlotOpt(RespObj,Tag,IndRemove);
ResponseHandles = get(RespObj,'ResponseHandles');

%---IndShow is a row vector of which systems need to be plotted
%     If IndShow is empty, plot all responses
if isempty(IndRemove),
   IndRemove = [1:1:length(ResponseHandles)];
end

for ct = IndRemove,
   AllModelLines = ResponseHandles{ct};
   AllLines = cat(2,AllModelLines{:});
   RemoveLines=findobj(cat(1,AllLines{:}),'Tag',Tag);
   delete(RemoveLines);
   for ctrow=1:size(AllModelLines,1),
      for ctcol=1:size(AllModelLines,2),
         ModelLines = AllModelLines{ctrow,ctcol};
         for ctModel=1:prod(size(ModelLines)),
            ModelLines{ctModel}=ModelLines{ctModel}(ishandle(ModelLines{ctModel}));
         end % for ctModel
         AllModelLines{ctrow,ctcol}=ModelLines;
      end % for ctcol
   end % for ctrow
   ResponseHandles{ct}=AllModelLines;
end % for ct

set(RespObj,'ResponseHandles',ResponseHandles)

