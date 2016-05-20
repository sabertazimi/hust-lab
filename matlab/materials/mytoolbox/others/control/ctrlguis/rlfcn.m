function varargout = rlfcn(varargin);
%RLFCN contains the callback functions for the Root Locus Design GUI
%   RLFCN(ACTION) calls the callback function specified by ACTION. 
%   The Root Locus Design GUI is assumed to be the Callback Figure
%
%   RLFCN(ACTION,RLfig) provides the handle, RLfig, of the Root Locus Design
%   GUI to perform the action on.
%
%   RLFCN(ACTION,RLfig,udRL) also provides the userdata, udRL, of the Root
%   Locus Design GUI that should be used when performing the action.
%
%   See also  RLTOOL

%   Karen D. Gondoly
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.10 $

ni=nargin;

if ni
   action = lower(varargin{1});
end

if ni>1,   
   RLfig = varargin{2};
   %---This is not always true when RLFCN is called by one of the
   %---children figures (e.g. Edit Compensator), in these cases, the individual
   %---callbacks reinitialize RLfig
else
   RLfig = gcbf;
end

if ni>2,
   udRL = varargin{3};
else
   udRL = get(RLfig,'UserData');
end

StatusStr=[];

switch action
   
case 'windowbuttondown',
   %---Root Locus Window ButtonDownFcn
   %---See if the cursor is a hand,
   if strcmp(udRL.Figure.Pointer.Style,'hand');
      setptr(RLfig,'closedhand');
      ButtonDownTag = get(udRL.Figure.Pointer.Object,'Tag');
      %---Invoke either the drag closed-loop pole or compensator p/z option
      if strcmp(ButtonDownTag,'CurrentClosedPoles'),
         rlfcn('pzbuttondown',RLfig,udRL);
      elseif strcmp(ButtonDownTag,'FilterPoles'),
         rlfcn('filterpole',RLfig,udRL);
      else
         rlfcn('compbuttondown',RLfig,udRL);
      end      
   end % if/else strcmp(Pointer,'hand')
   
case 'windowbuttonup',
   %---Root Locus Window ButtonUpFcn
   %---Check if the current pointer is a hand
   if strcmp(udRL.Figure.Pointer.Style,'hand');
      set(RLfig,'Pointer','arrow');
      drawnow
   end % if/else strcmp(Pointer,'hand')
   
case 'windowbuttonmotion',
   %---Root Locus WindowButtonMotionFcn
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   
   if get(udRL.Handles.AddPoleButton,'Value') | get(udRL.Handles.AddZeroButton,'Value') | ...
         get(udRL.Handles.EraseButton,'Value'),
      %---Button is pressed in, make sure the cursor is only custom while
      %---over the axis
      
      if any(CP(:,3)==1)
         set(RLfig,'Pointer','custom');
      else
         set(RLfig,'Pointer','arrow');
      end
      
   else % Default mode...make the cursor into a hand over draggable objects
      udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
      AllMovable = [udAx.ClosedLoopPoles';udAx.Compensator.Poles;udAx.Compensator.Zeros];
      if ~isempty(AllMovable)
         AllX = get(AllMovable,{'Xdata'});
         AllY = get(AllMovable,{'Ydata'});
         
         %---Make a box around each point
         Xlims = get(udRL.Handles.LTIdisplayAxes,'Xlim');
         Xdiff = (5/(231/(Xlims(2)-Xlims(1))));
         Ylims = get(udRL.Handles.LTIdisplayAxes,'Ylim');
         Ydiff = (5/(231/(Ylims(2)-Ylims(1))));
         AllXmin = cat(1,AllX{:})-Xdiff;
         AllXmax = cat(1,AllX{:})+Xdiff;
         AllYmin = cat(1,AllY{:})-Ydiff;
         AllYmax = cat(1,AllY{:})+Ydiff;
         
         Xsquares = [AllXmin, AllXmax, AllXmax, AllXmin, AllXmin];
         Ysquares = [AllYmin, AllYmin, AllYmax, AllYmax, AllYmin];
         
         HandFlag=0;
         for ct=1:length(AllMovable),
            if inpolygon(CP(1,1),CP(1,2),Xsquares(ct,:)',Ysquares(ct,:)'),
               setptr(RLfig,'hand');
               HandFlag=1;
               udRL.Figure.Pointer.Style = 'hand';
               udRL.Figure.Pointer.Object = AllMovable(ct);
            end
         end  % for ct
         
         if ~HandFlag,
            set(RLfig,'Pointer','arrow')
            udRL.Figure.Pointer.Style = 'arrow';
         end
         
         set(RLfig,'UserData',udRL)
      end % if ~isempty(AllMovable)
   end % if/else any(state)
   
case 'plotpole',
   %---ButtonDownFcn for the axes to plot the pole
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   DenText = udRL.Handles.DenText;
   set(udRL.Handles.AddPoleButton,'Value',0);
   set(udRL.Handles.DefaultLocusFcn,'Value',1);
   
   %----If Pole is within 5% of the Real axis, constrain it to be a real pole
   Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');
   if abs(CP(1,2))<=(0.05*(Ylim(2)-Ylim(1)));
      NewPole = CP(1,1);
      StatusStr2=[{['New pole location at ',num2str(NewPole)]};
         {'Use the Move button or Edit Compensator menu to alter the pole location'}];
   else, % Make into a complex pair
      NewPole=[CP(1,1)+CP(1,2)*i;CP(1,1)-CP(1,2)*i];
      StatusStr2=[{['New pole locations at ',...
                  num2str(real(NewPole(1))),char(177),num2str(abs(imag(NewPole(2))))]};
         {'Use the Edit Compensator menu to alter the pole locations.'}];
   end
   [garb,OldPole]=zpkdata(udRL.Compensator.Object,'v');
   AllPoles = [OldPole;NewPole];
   udRL.Compensator.Object.p  = AllPoles;
   
   %---Add new poles to the Root Locus Axes
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   for ctP=1:length(NewPole),
      NewCompPole(ctP,1)=line(real(NewPole(ctP)),imag(NewPole(ctP)),'LineStyle','none',...
         'Marker','x','Color',udAx.Preferences.Compensator,'MarkerSize',9,'Tag','CompPoles', ...
         'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
         'ButtonDownFcn','rlfcn(''compbuttondown'');');
   end
   
   %---Redraw the Root Locus
   set(RLfig,'CurrentAxes',udRL.Handles.LTIdisplayAxes)
   [udRL,StatusStr] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   if isempty(StatusStr),
      StatusStr=StatusStr2;
   end
   
   %---Update History
   udRL.History=[udRL.History;StatusStr(1)];
   
   %---Update the figure UserData
   set(RLfig,'UserData',udRL);
   
   %---Update the Denominator Text
   LocalUpdateText('den',AllPoles,DenText,udRL);
   
   %---Update the Root Locus Axis Userdata
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   udAx.Compensator.Poles = [udAx.Compensator.Poles;NewCompPole];
   set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
   
case 'plotzero',   
   %---ButtonDownFcn for the axes to plot the pole
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   set(udRL.Handles.AddZeroButton,'Value',0);
   set(udRL.Handles.DefaultLocusFcn,'Value',1);
   
   %---Quick exit if only Compensator Zeros exist. A system in this form
   %----is not compatible with some of the CST functions. To avoid the warnings
   %----that would ensue, disallow this type of system in the GUI.
   if isempty(udAx.Model.Poles) & isempty(udRL.Compensator.Object.p{:}),
      warndlg(['A system with only zeros is incompatible with some of the ',...
            'Control System Toolbox functions and is, therefore, not allowed.'],...
         'Root Locus System Warning');
      LocalSetButtonState([0 0 0],udRL.Handles.LTIdisplayAxes,1,udRL);
      return
   end
   
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   NumText = udRL.Handles.NumText;
   
   %----If Pole is near the Real axis, constrain it to be a real pole
   Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');
   if abs(CP(1,2))<(0.05*(Ylim(2)-Ylim(1)));
      NewZero = CP(1,1);
      StatusStr2=[{['New zero location at ',num2str(NewZero)]};
         {'Use the Edit Compensator menu to alter the zero location.'}];
   else, % Make into a complex pair
      NewZero=[CP(1,1)+CP(1,2)*i;CP(1,1)-CP(1,2)*i];
      StatusStr2=[{['New zero locations at ',...
                  num2str(real(NewZero(1))),char(177),num2str(abs(imag(NewZero(2))))]};
         {'Use the Edit Compensator menu to alter the zero locations.'}]; 
   end
   
   %---Check that the new system is valid;
   Comp=udRL.Compensator.Object;
   [oldZero,AllPoles]=zpkdata(Comp,'v');
   AllZeros = [oldZero;NewZero];
   Comp.z = AllZeros;
   Properflag = LocalCheckProper(udRL.Model.Plant.Object,Comp,...
      udRL.Model.Sensor.Object,udRL.Model.Structure);
   if ~Properflag,
      warndlg(['The system you tried to create is not compatible with ',...
            'some of the Control System Toolbox functions and, therefore, ',...
            'is not allowed in the Root Locus Design GUI.  This is usually ',...
            'the result of an improper system in the forward or feedback loop.'],...
         'Changing Compensator Warning');
      LocalSetButtonState([0 0 0],udRL.Handles.LTIdisplayAxes,1,udRL);
      return
   end
   
   udRL.Compensator.Object.z  = AllZeros;
   for ctZ=1:length(NewZero),
      NewCompZeros(ctZ,1)=line(real(NewZero(ctZ)),imag(NewZero(ctZ)),'LineStyle','none',...
         'Marker','o','Color',udAx.Preferences.Compensator,'Tag','CompZeros', ...
         'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
         'ButtonDownFcn','rlfcn(''compbuttondown'');');
   end
   
   %---Redraw the Root Locus
   set(RLfig,'CurrentAxes',udRL.Handles.LTIdisplayAxes)
   [udRL,StatusStr] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   if isempty(StatusStr),
      StatusStr=StatusStr2;
   end   
   
   %---Update History
   udRL.History=[udRL.History;StatusStr(1)];
   
   %---Update the figure UserData
   set(RLfig,'UserData',udRL);
   
   %---Update the Numerator Text
   LocalUpdateText('num',AllZeros,NumText,udRL);
   
   %---Update the Root Locus Axis Userdata
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   udAx.Compensator.Zeros= [udAx.Compensator.Zeros;NewCompZeros];
   set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
   
case 'erasecomp',
   set(udRL.Handles.EraseButton,'Value',0);
   set(udRL.Handles.DefaultLocusFcn,'Value',1);
   
   if ni==2,
      CurrentPZ = varargin{2};
      %---Reinitialize the Root Locus Figure Userdata
      RLfig = gcbf;
      udRL = get(RLfig,'UserData');
   else
      CurrentPZ = gcbo;
   end
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   %---Get all the Compensator Poles
   CompPoles = udAx.Compensator.Poles;
   numPoles = length(CompPoles);
   CompZeros = udAx.Compensator.Zeros; 
   AllCompPZ = [udAx.Compensator.Poles;udAx.Compensator.Zeros];
   
   inddelete = find(CurrentPZ==AllCompPZ);
   Xdata = get(CurrentPZ,'Xdata');
   Ydata = get(CurrentPZ,'Ydata');
   if Ydata
      PZloc = [Xdata+Ydata*i];
      %---Check for a complex conjugate
      AllYdata = get(AllCompPZ,'Ydata');
      indpair = find((-1*Ydata)==[AllYdata{:}]);
      inddelete=[inddelete;indpair];
   else
      PZloc=Xdata;
   end
   
   if max(inddelete)>numPoles
      PZtype = 'CompZeros';
      CompZeros(inddelete-numPoles)=[];
   else
      PZtype = 'CompPoles';
      CompPoles(inddelete)=[];
   end
   
   switch PZtype
   case 'CompPoles'
      RPoles = get(CompPoles,{'Xdata'});
      IPoles = get(CompPoles,{'Ydata'});
      if ~isempty(RPoles),
         poles = cat(1,RPoles{:})+(i*cat(1,IPoles{:}));
      else
         poles=[];
      end
      
      %---Check that the new system is valid;
      Comp=udRL.Compensator.Object;
      Comp.p=poles;
      Properflag = LocalCheckProper(udRL.Model.Plant.Object,Comp,...
         udRL.Model.Sensor.Object,udRL.Model.Structure);
      if ~Properflag,
         warndlg(['The system you tried to create is not compatible with ',...
               'some of the Control System Toolbox functions and, therefore, ',...
               'is not allowed in the Root Locus Design GUI.  This is usually ',...
               'the result of an improper system in the forward or feedback loop.'],...
            'Erasing Warning');
         return
      end
      
      udRL.Compensator.Object.p  = poles;
      LocalUpdateText('den',poles,udRL.Handles.DenText,udRL);
      PZtext='pole';
   case 'CompZeros'
      RZeros = get(CompZeros,{'Xdata'});
      IZeros = get(CompZeros,{'Ydata'});
      if ~isempty(RZeros ),
         zero = cat(1,RZeros{:})+(i*cat(1,IZeros{:}));
      else
         zero=[];
      end
      udRL.Compensator.Object.z  = zero;
      PZtext='zero';
      LocalUpdateText('num',zero,udRL.Handles.NumText,udRL);
   end
   
   %---Redraw the Root Locus
   set(RLfig,'CurrentAxes',udRL.Handles.LTIdisplayAxes)
   [udRL,StatusStr] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   
   if length(inddelete)==1,
      StatusStr = {['A compensator ',PZtext,' at',num2str(PZloc),' has been removed.']};
   elseif length(inddelete)==2
      StatusStr = {['Compensator ',PZtext,'s at',num2str(real(PZloc)),char(177), ...
               num2str(abs(imag(PZloc))),' have been removed.']};
   end
   
   if ~isempty(StatusStr)
      udRL.History=[udRL.History;StatusStr(1)];
   end
   
   %---Update the figure UserData
   set(RLfig,'UserData',udRL);
   delete(AllCompPZ(inddelete))
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   udAx.Compensator.Poles = CompPoles;
   udAx.Compensator.Zeros = CompZeros;
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx);
   
case 'default',
   %---Callback for the Default button
   DefaultVal = get(gcbo,'Value');
   if ~DefaultVal,
      set(gcbo,'Value',1);
   else
      set(get(gcbo,'UserData'),'Value',0)
      StatusStr = LocalSetButtonState([0 0 0],udRL.Handles.LTIdisplayAxes,1,udRL);
   end
   
case 'togglecallback',
   %---Initial callback for the RootLocusFcn togglebuttons    
   %---Get the current figure Point
   ButtonVal=get(gcbo,'Value');
   if ~ButtonVal,
      StatusStr = LocalSetButtonState([0 0 0],udRL.Handles.LTIdisplayAxes,1,udRL);
      set(udRL.Handles.DefaultLocusFcn,'Value',1)
   else
      set(get(gcbo,'UserData'),'Value',0)
      
      switch get(gcbo,'Tag'),
      case 'AddPoleButton',
         setVals=[1 0 0];
      case 'AddZeroButton',
         setVals=[0 1 0];
      case 'EraseButton',
         setVals=[0 0 1];
      end % switch Tag
      
      StatusStr = LocalSetButtonState(setVals,udRL.Handles.LTIdisplayAxes,1,udRL);
   end % if/else ButtonVal
   
case 'endmovecomp'
   %---Callback to end the mouse movement of poles
   set(RLfig,'WindowButtonMotionFcn','rlfcn(''windowbuttonmotion'');', ...
      'WindowButtonUpFcn','rlfcn(''windowbuttonup'');',...
      'Pointer','arrow');
   kids = get(udRL.Handles.LTIdisplayAxes,'children');
   
   StatusStr='Ready';
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   %---Make the Closed-loop poles' EraseMode = 'normal';
   set(udAx.ClosedLoopPoles,'EraseMode','normal');
   
   [Z,P]=zpkdata(udRL.Compensator.Object,'v');
   
   LocalUpdateText('num',Z,udRL.Handles.NumText,udRL);
   LocalUpdateText('den',P,udRL.Handles.DenText,udRL); 
   
   %---Update the history
   Xdata = get(gco,'Xdata');
   Ydata = get(gco,'Ydata');
   HistoryText = ['        were moved to ',num2str(Xdata)];
   if Ydata,
      HistoryText = [HistoryText,char(177),num2str(abs(Ydata))];
   end
   udRL.History = [udRL.History;{HistoryText}];
   
   %---Redraw the Root Locus with a fresh set of complete gains
   [udRL,StatusStr2] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   
   set(RLfig,'UserData',udRL);
   
   %---Clear MOVEFCN 
   clear movefcn
   
case 'selectgain'
   %---Callback to place the closed-loop poles at the specified location
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   
   %---Find the gain needed to achieve the desired closed-loop pole
   sys = LocalComputeSystem(udRL,'rlocus');
   [k,Poles] = rlocfind(sys,[CP(1,1)+(CP(1,2)*i)]);
   
   udRL.Compensator.Gain = k;
   set(udRL.Handles.GainEdit,'String',num2str(k));
   udRL = LocalChangeClosedLoopPoles(RLfig,udRL);
   
   StatusStr = {['Moving the closed-loop poles changed the gain to ',num2str(k)]};,
   
   %---Update the History Text
   udRL.History = [udRL.History;
      {['The gain was changed to ',num2str(k(1))]}];
   set(RLfig,'UserData',udRL);
   
case 'zoomcallback',
   %---Callback for the Y/X/XY Zoom buttons
   %---Turn any previously selected zoom off
   ZoomVal=get(gcbo,'Value');
   
   if ~ZoomVal
      %---Turn the zoom back off
      rguizoom(RLfig,'off')
      set(RLfig,'WindowButtonUpFcn','rlfcn(''windowbuttonup'');', ...
         'WindowButtonMotionFcn','rlfcn(''windowbuttonmotion'');');
      states=[get(udRL.Handles.AddPoleButton,'Value'),...
            get(udRL.Handles.AddZeroButton,'Value'),...
            get(udRL.Handles.EraseButton,'Value')];
      LocalSetButtonState(states,udRL.Handles.LTIdisplayAxes,1,udRL);
      StatusStr = 'Ready';
   else      
      ZoomType = get(gcbo,'Tag');
      set(get(gcbo,'UserData'),'Value',0);
      
      switch ZoomType,
      case 'XzoomButton',
         zoomstate = 'xonly';
      case 'YzoomButton',
         zoomstate = 'yonly';
      case 'XYzoomButton',
         zoomstate = 'on';
      end
      
      %---Remove all other button down functions and set the WindowButtonUpFcn
      %----to replace them.
      LocalSetButtonState([0 0 0],udRL.Handles.LTIdisplayAxes,0,udRL); 
      % The additional input argument turn off the default buttondownfcn's
      
      %---Change the cursor to a crosshair
      set(RLfig,'Pointer','crosshair');
      
      feval('rguizoom',zoomstate);
      feval('rguizoom',findobj(RLfig,'Tag','LTIdisplayAxes'),...
         'zoomofffcn','rlfcn(''resetfunctions'');');
      
      %---Turn off the current WindowButtonMotion and Up functions
      set(RLfig,'WindowButtonUpFcn','','WindowButtonMotionFcn','');
      
      StatusStr = [{'Drag the cursor over the region to zoom in on.'}];
   end, % if/else state
   
case 'resetfunctions',
   %---ButtonUpFcn after a zoom is executed
   set(RLfig,'WindowButtonUpFcn','rlfcn(''windowbuttonup'');', ...
      'WindowButtonMotionFcn','rlfcn(''windowbuttonmotion'');');
   states=[get(udRL.Handles.AddPoleButton,'Value'),...
         get(udRL.Handles.AddZeroButton,'Value'),...
         get(udRL.Handles.EraseButton,'Value')];
   LocalSetButtonState(states,udRL.Handles.LTIdisplayAxes,1,udRL);
   
   %---Make sure square and equal settings are correct
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   if udAx.Preferences.Square & udAx.Preferences.Equal,
      %---If the axis limits aren't equal, turn the square off
      if ~isequal(diff(abs(get(udRL.Handles.LTIdisplayAxes,'Xlim'))),...
            diff(abs(get(udRL.Handles.LTIdisplayAxes,'Ylim'))) ),
         rlfcn('axissquare');
      end
   end
   StatusStr = 'Ready';
   
   set([udRL.Handles.XYzoomButton,udRL.Handles.YzoomButton,udRL.Handles.XzoomButton],...
      'Value',0);
   
case 'unzoom'
   %---Callback for the Full Zoom button
   %---Remove the dotted lines and zoom tightly into the remaining data
   set([udRL.Handles.FullViewButton,get(udRL.Handles.FullViewButton,'UserData')],'Value',0);
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   kids = get(udRL.Handles.LTIdisplayAxes,'children');
   
   %---Get rid of the axis lines/turn off the grid to only zoom on the Rlocus
   dotkids = findobj(kids,'LineStyle',':');
   ZgridLine = findobj(kids,'LineStyle','-','Tag','');
   ZetaLines = findobj(kids,'Tag','ZetaConstraints');
   WnLines = findobj(kids,'Tag','WnConstraints');
   TsLines = findobj(kids,'Tag','TsConstraints');
   delete([dotkids;ZetaLines;WnLines;TsLines;ZgridLine]); 
   
   set(udRL.Handles.LTIdisplayAxes,'XlimMode','auto','YlimMode','auto');
   Xlim = get(udRL.Handles.LTIdisplayAxes,'Xlim');
   Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');
   Ylim = [min([-1,Ylim(1)]),max([1,Ylim(2)])];
   Xlim = [min([-1,-1*abs(Xlim(1)),-1*abs(Xlim(2))]),max([1,abs(Xlim(2)),abs(Xlim(2))])];
   
   %---Add the dotted lines and grid
   udAx.Limit.X=Xlim;
   udAx.Limit.Y=Ylim;
   set(udRL.Handles.LTIdisplayAxes,'Xlim',Xlim,'Ylim',Ylim,'UserData',udAx)
   LocalPlotGrid(RLfig,udRL.Handles.LTIdisplayAxes,udAx);
   udRL = LocalAxisLines(udRL);
   set(RLfig,'UserData',udRL)
   
   StatusStr = [{'The entire locus is now shown. '}];
   
case 'savepref'   %---Callback to save the current axis limits to the preferences;
   set(gcbo,'Value',0);
   Xlim = get(udRL.Handles.LTIdisplayAxes,'Xlim');
   Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   udAx.Preferences.X=Xlim;
   udAx.Preferences.Y=Ylim;
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx);
   
case 'restorepref'
   %---Callback to save the current axis limits to the preferences;
   set(gcbo,'Value',0);
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   if ~isempty(udAx.Preferences.X),
      set(udRL.Handles.LTIdisplayAxes,'Xlim',udAx.Preferences.X,'Ylim',udAx.Preferences.Y);
      StatusStr={'Restoring the stored axis preferences.'};
      
      %---Determine if the equal or square buttons need to be toggled.
      equalval = udAx.Preferences.Equal;
      squareval = udAx.Preferences.Square;
      
      if squareval & equalval & ... 
            ~isequal(udAx.Preferences.X(1),udAx.Preferences.X(2)) & ... 
            ~isequal(udAx.Preferences.Y(1),udAx.Preferences.Y(2)), % Turn Equal off if axis limits are not the same
         rlfcn('axisequal',RLfig);
         StatusStr(2)={'The Axis equal settings is being overridden.'};
      end
      
      udRL = LocalAxisLines(udRL);
      
   else
      StatusStr = {'No preferences have been saved.'};
   end
   
case 'axissquare',
   set(udRL.Handles.AxesSquare,'Value',0);
   %---Callback for the Axis Square button in the Axis Settings toolbar
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   if ~udAx.Preferences.Square; % Setting to square
      StatusStr = {'The Root Locus Axes are now square.'};
      set(udRL.Handles.LTIdisplayAxes,'PlotBoxAspectRatio',[1 1 1]);
      if udAx.Preferences.Equal, % Also set to equal
         maxlim = max([abs(get(udRL.Handles.LTIdisplayAxes,'Xlim')), ...
               get(udRL.Handles.LTIdisplayAxes,'Ylim')]);
         maxlim=ceil(maxlim);
         set(udRL.Handles.LTIdisplayAxes,'Xlim',[-maxlim,maxlim],'Ylim',[-maxlim,maxlim]);
         StatusStr = [{'The Root Locus Axes limits are square and have equal aspect ratios.'};
            {'Manually changing the limits will turn off one of these properties.'}];
      end
      newtip = 'Make Axes rectangular';
      udAx.Preferences.Square = 1;
   else
      StatusStr = {'The Root Locus Axes are no longer square.'};
      set(udRL.Handles.LTIdisplayAxes,'PlotBoxAspectRatioMode','auto');
      newtip = 'Make Axes square';
      udAx.Preferences.Square = 0;
   end
   
   %---Update the icon
   LocalUpdateIcon(udRL.Handles.AxesSquare)   
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx);
   set(udRL.Handles.AxesSquare,'ToolTipString',newtip);
   udRL = LocalAxisLines(udRL);
   
case 'axisequal',
   set(udRL.Handles.AxesEqual,'Value',0);
   %---Callback for the Axis Equal button in the Axis Settings Toolbar
   udAx = get(udRL.Handles.LTIdisplayAxes,'Userdata');
   DARmode = get(udRL.Handles.LTIdisplayAxes,'DataAspectRatioMode');
   
   if ~udAx.Preferences.Equal; % Setting to equal
      StatusStr = {'The Root Locus Axes now have an equal aspect ratio.'};
      newtip = 'Use unequal axes aspect ratios';
      set(udRL.Handles.LTIdisplayAxes,'DataAspectRatio',[1 1 1]);
      if udAx.Preferences.Square % also set to square
         StatusStr = [{'The Root Locus Axes limits are square and have equal aspect ratios.'};
            {'Manually changing the limits will turn off one of these properties.'}];
         maxlim = max([abs(get(udRL.Handles.LTIdisplayAxes,'Xlim')),...
               get(udRL.Handles.LTIdisplayAxes,'Ylim')]);
         maxlim=ceil(maxlim);
         set(udRL.Handles.LTIdisplayAxes,'Xlim',[-maxlim,maxlim],'Ylim',[-maxlim,maxlim]);
      end
      udAx.Preferences.Equal=1;
   else
      StatusStr = {'The Root Locus Axes no longer have an equal aspect ratio.'};
      newtip = 'Use equal axes aspect ratios';
      set(udRL.Handles.LTIdisplayAxes,'DataAspectRatioMode','auto');
      udAx.Preferences.Equal=0;
   end
   
   LocalUpdateIcon(udRL.Handles.AxesEqual)
   set(udRL.Handles.AxesEqual,'ToolTipStr',newtip);
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx);
   udRL = LocalAxisLines(udRL);
   
case 'filterpole',
   %---ButtonDown for the filter poles
   FilterPole = gcbo;
   UdPole = get(FilterPole,'Userdata');
   
   textstr=[{['Damping: ',num2str(UdPole.Damping,'%1.3g'),';  Natural Frequency: ',...
               num2str(UdPole.NaturalFrequency,'%5.3g')]};
      {' '};
      {'Caution: Pre-filter poles do not move.'};];
   msgbox(textstr,'Pre-Filter Pole Location');
   StatusStr='Ready';
   
case 'pzbuttondown'
   %---Normal ButtonDownFcn for the closed-loop poles
   if ni==3, % Called from the WindowButtonDownFcn
      P = udRL.Figure.Pointer.Object;
      set(RLfig,'CurrentObject',P);
   else
      P = gcbo;
   end
   
   udP=get(P,'UserData');
   wn=udP.NaturalFrequency;
   z = udP.Damping;
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   
   %---Set up text string based on whether pole is real or complex
   if isequal(abs(z),1), % Real pole;
      textstr=[{'Drag the selected closed-loop pole along the locus.'};
         {['Location: ',num2str(get(P,'Xdata'),'%5.3g')]}];
   else
      textstr=[{'Drag the selected closed-loop pole pair along their loci.'};
         {['Locations: ',num2str(get(P,'Xdata'),'%5.3g'),...
                  char(177),num2str(get(P,'Ydata'),'%5.3g'),...
                  'i; Damping: ',num2str(z(1),'%1.3g'),...
                  ';  Natural Freq: ',num2str(wn(1),'%5.3g')]}];
   end
   set(udRL.Handles.StatusText,'String',textstr);
   
   %---Make the Closed-loop poles' EraseMode = 'xor';
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   set(udAx.ClosedLoopPoles,'EraseMode','xor');
   
   %---Set WindowButtonUp and WindowButtonMotion Fcn so poles can be dragged
   set(RLfig,'WindowButtonUpFcn','rlfcn(''pzbuttonup'');', ...
      'WindowButtonMotionFcn','rlfcn(''pzbuttonmove'');');
   
case 'pzbuttonmove',
   %---WindowButtonMotionFcn for moving the closed-loop poles
   WarnStatus =warning; % Protection against warnings (#34091)
   warning off;
   
   MyHandle = gco;
   if isempty(MyHandle),
      MyHandle = udRL.Figure.Pointer.Object;
   end
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   CLpoles = udAx.ClosedLoopPoles';
   
   Xp=get(CLpoles,{'Xdata'});
   Yp=get(CLpoles,{'Ydata'});
   
   %---Get poles in decreasing imaginary order, so they match the output of rlocfind
   P = [[Xp{:}]+[Yp{:}]*i]';
   
   CP = get(udRL.Handles.LTIdisplayAxes,'CurrentPoint');
   [minHandle,Index]=min(abs(CLpoles-MyHandle));
   
   %---Compute the appropriate characteristic equation
   sys = LocalComputeSystem(udRL,'rlocus');
   
   [k,Poles] = rlocfind(sys,[CP(1,1)+CP(1,2)*i]);
   
   %---Sort the old and new poles. MATCHLSQ is in the internal fucntions
   %---If we decide to move this out of @lti/private, we can remove the internal
   GoodPoles = matchlsq(P,Poles);   
   
   set(findobj(udRL.Handles.GainEdit),'String',num2str(k));
   
   set(CLpoles,{'Xdata'},num2cell(real(GoodPoles)), ...
      {'Ydata'},num2cell(imag(GoodPoles)))
   
   %---Set up text based on whether pole is real or complex
   [Wn,Zeta]=damp(GoodPoles(Index));
   if isequal(Zeta,1), % Real pole;
      textstr=[{'Drag the selected closed-loop pole along the locus.'};
         {['Location: ',num2str(CP(1,1),'%5.3g')]}];
   else
      textstr=[{'Drag the selected closed-loop pole pair along their loci.'};
         {['Locations: ',num2str(CP(1,1),'%5.3g'),...
                  char(177),num2str(CP(1,2),'%5.3g'),...
                  'i; Damping: ',num2str(Zeta,'%1.3g'),...
                  ';  Natural Freq: ',num2str(Wn,'%5.3g')]}];
   end
   
   set(udRL.Handles.StatusText,'String',textstr);
   
   udRL.Compensator.Gain = k;
   set(RLfig,'Userdata',udRL);
   warning(WarnStatus)
   
case 'pzbuttonup'
   %---Normal ButtonUpFcn for the closed-loop poles
   set(RLfig,'WindowButtonUpFcn','rlfcn(''windowbuttonup'');', ...
      'WindowButtonMotionFcn','rlfcn(''windowbuttonmotion'');', ...
      'Pointer','arrow');
   
   %---Make the Closed-loop poles' EraseMode = 'normal';
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   set(udAx.ClosedLoopPoles,'EraseMode','normal');

 % StatusStr='Ready';
   
   %---Reset the closed-loop pole UserData
   udRL = LocalChangeClosedLoopPoles(RLfig,udRL);   
   
   %---Update the History text
   udRL.History = [udRL.History;
      {['The gain was changed to ',get(udRL.Handles.GainEdit,'String')]}];
   
   set(RLfig,'UserData',udRL);         
   
case 'compbuttondown',
   %---Compensator Pole/Zero ButtonDownFcn
   switch get(RLfig,'SelectionType');
      
   case 'normal', % click and hold....move the pole/zero
      if ni==3, % called from WindowButtonDownFcn
         CallBackKid = udRL.Figure.Pointer.Object;
         set(RLfig,'CurrentObject',CallBackKid)
      else
         CallBackKid = gcbo;
      end
      KidType = get(CallBackKid,'Tag');
      
      StatusStr={['Drag the compensator ',lower(KidType(5:end)),' to the desired location']};
      udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
      
      %---Make the Closed-loop poles' EraseMode = 'xor';
      set(udAx.ClosedLoopPoles,'EraseMode','xor');
      
      kids = get(udRL.Handles.LTIdisplayAxes,'children');
      
      CompPoles = udAx.Compensator.Poles;
      CompZeros = udAx.Compensator.Zeros;
      
      switch KidType,
      case 'CompPoles',
         CompareKids = CompPoles;
         MoveType = 'Pole';
      case 'CompZeros',
         CompareKids = CompZeros;
         MoveType = 'Zero';
      end
      
      AllYdata = [get(CompareKids,'Ydata')];
      if ~iscell(AllYdata);
         AllYdata=num2cell(AllYdata);
      end
      AllYdata = [AllYdata{:}];
      
      AllXdata = [get(CompareKids,'Xdata')];
      if ~iscell(AllXdata);
         AllXdata=num2cell(AllXdata);
      end
      AllXdata = [AllXdata{:}];
      
      currentkid = find(CompareKids==CallBackKid);
      CurYdata = get(CallBackKid,'Ydata');
      CurXdata = get(CallBackKid,'Xdata');
      if CurYdata,
         sibkid = find((AllYdata==(-1*CurYdata)) & (AllXdata==CurXdata) );
      else
         sibkid=[];
      end
      
      MoveHandles = CompareKids([currentkid,sibkid]);
      
      switch KidType,
      case 'CompPoles',
         CompPoles([currentkid,sibkid]) = [];
      case 'CompZeros',
         CompZeros([currentkid,sibkid])= [];
      end
      
      udAx.MoveData.MoveType = MoveType;
      udAx.MoveData.MoveHandles = MoveHandles;
      RZeros = get(CompZeros,{'Xdata'});
      IZeros = get(CompZeros,{'Ydata'});
      if ~isempty(RZeros),
         udAx.MoveData.LocusSystem.Z = cat(1,RZeros{:})+(i*cat(1,IZeros{:}));
      else
         udAx.MoveData.LocusSystem.Z = [];
      end
      RPoles = get(CompPoles,{'Xdata'});
      IPoles = get(CompPoles,{'Ydata'});
      if ~isempty(RPoles),
         udAx.MoveData.LocusSystem.P = cat(1,RPoles{:})+(i*cat(1,IPoles{:}));
      else
         udAx.MoveData.LocusSystem.P = [];
      end
      
      set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
      
      %---Set up the History Text
      HistoryText = ['Compensator ',lower(KidType(5:end)),' at ',num2str(CurXdata)];
      if CurYdata,
         HistoryText = [HistoryText,char(177),num2str(CurYdata)];
      end
      udRL.History = [udRL.History;{HistoryText}];
      
      set(RLfig,'WindowButtonMotionFcn','movefcn(gco);', ...
         'WindowButtonUpFcn','rlfcn(''endmovecomp'');',...
         'UserData',udRL);
      
   case 'open', % Open the Edit Compensator window
      rlfcn('editcomp');      
   end
   
case 'showgrid'
   %---Grid Checkbox callback
   val = get(gcbo,'Value');
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   udAx.Grid.State=val;
   set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
   LocalPlotGrid(RLfig,udRL.Handles.LTIdisplayAxes,udAx);
   
   %---Reset any axis buttondown functions
   states=[get(udRL.Handles.AddPoleButton,'Value'),...
         get(udRL.Handles.AddZeroButton,'Value'),...
         get(udRL.Handles.EraseButton,'Value')];
   LocalSetButtonState(states,udRL.Handles.LTIdisplayAxes,1,udRL);
   StatusStr='Ready';
   
case 'changegain'
   %---Callback for GainEdit
   GainBox = gcbo;
   NewGain = str2double(get(GainBox,'String'));
   
   %---Check for valid number
   if isnan(NewGain), 
      set(GainBox,'String',udRL.Compensator.Gain);
      return
   end
      
   udRL.Compensator.Gain = NewGain;
   
   %---Recalculate the closed-loop poles
   udRL = LocalChangeClosedLoopPoles(RLfig,udRL);   
   
   %---Update the History
   StatusStr =  {'The closed-loop poles were moved to the appropriate'; ...
            ['locations for a gain of ',num2str(NewGain),'.']};
   udRL.History = [udRL.History;StatusStr];
   set(RLfig,'UserData',udRL)
   
case 'changeconfig'
   %---Callback for the --> button
   ConfigButton = gcbo;
   SignText = findobj(RLfig,'Tag','SignText');
   
   udConfig = get(ConfigButton,'UserData');
   if udConfig==1,
      udConfig=2;
   else
      udConfig=1;
   end
   
   set(ConfigButton,'UserData',udConfig);
   udRL.Model.Structure = udConfig;
   
   %---Redraw the configuration
   rlfcn('configapply',RLfig,udRL);
   
case 'changesign'
   %---Callback for the +/- button
   SignText = findobj(RLfig,'Tag','SignText');
   ud = get(SignText,'UserData');
   
   switch ud
   case 1
      % Change to negative feedback
      set(SignText,'String','-','UserData',-1);
      udRL.Model.FeedbackSign=-1;
      StatusStr = {'The compensator now uses negative feedback'};
   case -1
      % Change to positive feedback
      set(SignText,'String','+','UserData',1);
      udRL.Model.FeedbackSign=1;
      StatusStr = {'The compensator now uses positive feedback'};
   end
   
   b = findobj(RLfig,'Tag','ConfigurationAxes');
   set(b,'Ylim',[0 1],'Xlim',[.0 .9]);
   set(RLfig,'UserData',udRL)
   
   %---Update the Root Locus,
   try
      [udRL,StatusStr2] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   catch   
      % Turn watch off
      set(RLfig,'Pointer','arrow')
   end
   %---Update the History
   udRL.History = [udRL.History;StatusStr];
   set(RLfig,'UserData',udRL);
   
case 'editcomp'
   %---Edit Compensator menu callback
   EditMenu = udRL.Handles.Menus.Options.EditComp;
   Comp = udRL.Compensator.Object;
   
   [fignum] = LocalEditComp(RLfig,udRL);
   set(EditMenu,'UserData',fignum)
   StatusStr = [{'Click the Pole/Zero text to see the Denominator/Numerator.'};
      {'Check the Delete box to remove the associated pole/zero'}];
   
case 'comptext',
   %---Callback for the Pole/Zero text on the Edit Compensator window
   EditFig = gcbf;
   udEdit = get(EditFig,'UserData');
   RLfig = udEdit.Parent;
   udRL = get(RLfig,'UserData');
   Comp = udRL.Compensator.Object;
   [P,Z] = pzmap(Comp);
   DenText = LocalUpdateText('den',P,[],udRL);
   NumText = LocalUpdateText('num',Z,[],udRL);
   
   callstr = get(gcbo,'String');
   if strmatch('Zeros',callstr);
      H = msgbox(['Numerator = ',NumText]);
   else
      H = msgbox(['Denominator = ',DenText]);
   end
   
   udEdit.Children = [udEdit.Children;H];
   set(EditFig,'UserData',udEdit);
   
case 'planttext',
   %---Callback for the numerator/denominator text
   ShowFig = gcbf;
   udShow = get(ShowFig,'UserData');
   RLfig = udShow.Parent;
   udRL = get(RLfig,'UserData');
   Udo=get(gcbo,'UserData');
   P=Udo.Roots;
   DenText = LocalUpdateText('den',P,[],udRL);
   
   callstr = get(gcbo,'String');
   if strmatch('Zeros:',callstr);
      NumText = DenText;
      if ~isequal(Udo.Gain,1) & isempty(P),
         NumText = num2str(Udo.Gain);
      elseif ~isequal(Udo.Gain,1) & ~isempty(P) 
         NumText = [num2str(Udo.Gain),'*',NumText];
      end
      H = msgbox(['Numerator = ',NumText]);
   else
      H = msgbox(['Denominator = ',DenText]);
   end
   
   udShow.Children = [udShow.Children;H];
   set(ShowFig,'UserData',udShow);
   
case 'showobj',
   %---Callback for the Show Object button on the Model Data window
   ShowObj = get(gcbo,'Tag');
   udShow = get(gcbf,'UserData');
   RLfig = udShow.Parent;
   udRL = get(RLfig,'UserData');
   
   ObjStr = evalc(['udRL.Model.',ShowObj,'.Object']);
   NameStr = eval(['udRL.Model.',ShowObj,'.Name']);
   msgbox(ObjStr,[ShowObj,' LTI Object: ',NameStr],'none',[],[],'modal')

case 'editedit', 
   %---Callback for the edit boxes on the Edit Compensator window
   EditBox = gcbo;
   ud = get(EditBox,'UserData');
   StrVal = get(EditBox,'String');
   if ~isempty(StrVal)
      NewVal = str2double(get(EditBox,'String'));
      if isnan(NewVal),
         set(EditBox,'String',ud);
      else
         set(EditBox,'UserData',NewVal)
      end % if/else isnan
   end, % if ~isempty(StrVal)
   
case {'editaddpole','editaddzero'},
   %---Callback for the Add Pole/Zero button on the Edit Compensator window
   EditFig = gcbf;
   AllControls = allchild(EditFig);
   set([AllControls;EditFig],'unit','points');
   ResizeFrame = findobj(AllControls,'Tag','ResizeFrame');
   resizepos = get(ResizeFrame,'Position');
   sizeFig = get(EditFig,'Position');
   PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
   
   NumPoles = length(findobj(EditFig,'Tag','PoleCheck'));
   NumZeros = length(findobj(EditFig,'Tag','ZeroCheck'));
   if strcmp(action,'editaddpole');
      numpzhave = NumPoles;
      numpzother = NumZeros;
      leftedge = 225; % pix
      checkpos = get(findobj(EditFig,'Tag','PoleCheck'),'pos');
      CheckTag = 'PoleCheck';
   else
      numpzhave = NumZeros;
      numpzother = NumPoles;
      leftedge = 21; %pix
      checkpos = get(findobj(EditFig,'Tag','ZeroCheck'),'pos');
      CheckTag = 'ZeroCheck';
   end
   
   %---See if figure needs to be bigger
   if numpzhave >= numpzother,
      resizeamount = 25; % pix
   else
      resizeamount = 0;
   end
   
   if ~iscell(checkpos),
      checkpos = num2cell(checkpos,2);
   end
   
   if resizeamount,
      sizeFig(2)=sizeFig(2)-(resizeamount*PointsToPixels);
      sizeFig(4)=sizeFig(4)+(resizeamount*PointsToPixels);
      set(EditFig,'Position',sizeFig);
      textkids = findobj(AllControls,'style','text');
      editkids = findobj(AllControls,'style','edit');
      framekids = findobj(AllControls,'Tag','NameFrame');
      checkkids = findobj(AllControls,'style','checkbox');
      movekids = [textkids;editkids;checkkids;framekids];
      pos = get(movekids,'Position');
      changepos=cell(size(pos));
      changepos(:) = {[0 resizeamount*PointsToPixels 0 0]};
      newpos = num2cell(cat(1,pos{:})+cat(1,changepos{:}),2);
      set(movekids,{'Position'},newpos);
      
      changepos=cell(size(resizepos));
      changepos(:) = {[0 0 0 resizeamount*PointsToPixels]};
      newpos = num2cell(cat(1,resizepos{:})+cat(1,changepos{:}),2);
      set(ResizeFrame,{'Position'},newpos);
   end
   
   if ~isempty(checkpos),
      if length(checkpos)>1,
         bottomedge = min(cat(1,checkpos{:}))/PointsToPixels; %pix
      else
         bottomedge = checkpos{:}/PointsToPixels; %pix
      end
      bottomedge = bottomedge(2)+resizeamount; %pix
   else
      bottomedge = (resizepos{1}(4)./PointsToPixels)+resizeamount; %pix
   end
   
   realb = uicontrol('Parent',EditFig, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'HorizontalAlignment','left', ...
      'UserData','', ...
      'Position',[leftedge+28 bottomedge-25 60 20]*PointsToPixels, ...
      'Style','edit');
   
   b = uicontrol('Parent',EditFig, ...
      'Units','points', ...
      'Position',PointsToPixels*[leftedge+90 bottomedge-25 15 20], ...
      'String',char(177), ...
      'Style','text');
   
   imagb = uicontrol('Parent',EditFig, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'HorizontalAlignment','left', ...
      'UserData','', ...
      'Position',[leftedge+105 bottomedge-25 60 20]*PointsToPixels, ...
      'Tag','Imag', ...
      'Style','edit');
   
   b = uicontrol('Parent',EditFig, ...
      'Units','points', ...
      'Position',PointsToPixels*[leftedge+165 bottomedge-27 15 20], ...
      'String','i', ...
      'Style','text');
   
   checkP = uicontrol('Parent',EditFig, ...
      'Units','points', ...
      'Position',[leftedge bottomedge-25 20 20]*PointsToPixels, ...
      'UserData',[realb,imagb], ...
      'Tag',CheckTag, ...
      'Style','checkbox');
   
   %---Sizing hack for Unix stations
   if isunix
      set(EditFig,'Position',sizeFig+1);
   end
   
case 'editcompname', 
   %---Callback for the Compensator Name edit box
   compname=get(gcbo,'String');
   
   if isempty(compname) | ... % New name is empty
         ~isnan(str2double(compname(1))) | ... % New name starts with a number
         ~isempty(find(real(compname)==32)); % Name has blanks
      set(gcbo,'String',get(gcbo,'UserData'));
   else
      set(gcbo,'UserData',compname);
   end
   
case 'editapply'
   %---Callback for the Apply button on the Edit Compensator window
   EditFig = gcbf;
   udEdit = get(EditFig,'UserData');
   RLfig = udEdit.Parent;
   udRL = get(RLfig,'UserData');
   
   %---Get the new name
   CompName = get(findobj(EditFig,'Tag','NameEdit'),'String');
   udRL.Compensator.Name = CompName;
   
   Poles = findobj(EditFig,'Tag','PoleCheck');
   Zeros = findobj(EditFig,'Tag','ZeroCheck');
   P = zeros(length(Poles)*2,1);
   Z = zeros(length(Zeros)*2,1);
   
   %---Read the new poles....finish getting values!!!
   numP = 0;
   for ctP = 1:length(Poles),
      if get(Poles(ctP),'Value')==0
         udP = get(Poles(ctP),'UserData');
         realP = str2double(get(udP(1),'String'));
         imagP = str2double(get(udP(2),'String'));
         if isnan(imagP) | ~imagP,
            if ~isnan(realP),
               numP = numP+1;
               P(numP) = realP;
            end
         else
            numP = numP+2;      
            if isnan(realP),
               realP=0;
            end
            P(numP-1)= realP+i*imagP;
            P(numP)=realP-i*imagP;
         end
      end % if get(Poles...
   end % for ctP
   P = P(1:numP);
   
   %---Read the new zeros
   numZ = 0;
   for ctZ = 1:length(Zeros),
      if get(Zeros(ctZ),'Value')==0,
         udZ = get(Zeros(ctZ),'UserData');
         realZ = str2double(get(udZ(1),'String'));
         imagZ = str2double(get(udZ(2),'String'));
         if isnan(imagZ) | ~imagZ,
            if ~isnan(realZ)
               numZ = numZ+1;
               Z(numZ) = realZ;
            end
         else
            numZ = numZ+2;
            if isnan(realZ),
               realZ=0;
            end
            Z(numZ-1)= realZ+i*imagZ;
            Z(numZ)=realZ-i*imagZ;
         end
      end % if get(Zeros...
   end % for ctP
   Z = Z(1:numZ);
   
   %---Update the Root Locus figure userdata      
   oldComp = udRL.Compensator.Object;
   Comp = zpk(Z,P,1,oldComp.Ts);
   
   if ~isequal(oldComp,Comp), % changes were made, update the RL figure
      %---Check that the new system is valid
      Properflag = LocalCheckProper(udRL.Model.Plant.Object,Comp,...
         udRL.Model.Sensor.Object,udRL.Model.Structure);
      if ~Properflag,
         warndlg(['The system you tried to create is not compatible with ',...
               'some of the Control System Toolbox functions and, therefore, ',...
               'is not allowed in the Root Locus Design GUI.  This is usually ',...
               'the result of an improper system in the forward or feedback loop.'],...
            'Erasing Warning');
         return
      end % if ~Properflag
            
      udRL.Compensator.Object = Comp;
      udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
      delete([udAx.Compensator.Poles;udAx.Compensator.Zeros]);
      CompPoles=[];
      for ctP=1:length(P),
         CompPoles(ctP,1) = line(real(P(ctP)),imag(P(ctP)),'LineStyle','none',...
            'Marker','x','Color',udAx.Preferences.Compensator,'MarkerSize',9,'Tag','CompPoles', ...
            'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
            'ButtonDownFcn','rlfcn(''compbuttondown'');');
      end % for ctP
      CompZeros=[];
      for ctZ=1:length(Z),
         CompZeros(ctZ,1) = line(real(Z(ctZ)),imag(Z(ctZ)),'LineStyle','none',...
            'Marker','o','Color',udAx.Preferences.Compensator,'Tag','CompZeros', ...
            'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
            'ButtonDownFcn','rlfcn(''compbuttondown'');');
      end % for ctZ
      
      udAx.Compensator.Poles = CompPoles;
      udAx.Compensator.Zeros = CompZeros;
      set(udRL.Handles.LTIdisplayAxes,'UserData',udAx);
      
      set(RLfig,'CurrentAxes',udRL.Handles.LTIdisplayAxes)
      LocalUpdateText('num',Z,udRL.Handles.NumText,udRL);
      LocalUpdateText('den',P,udRL.Handles.DenText,udRL);
      [udRL,StatusStr] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
      if isempty(StatusStr),
         StatusStr = {'The edited compensator has been entered'};
      end
      
      %---Have Plot Axes rescale, if a pole/zero was added outside of visible range
      Xlim = get(udRL.Handles.LTIdisplayAxes,'Xlim');
      Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');
      if any([real(P);real(Z)] <= Xlim(1)) | ...
            any([real(P);real(Z)] >= Xlim(2)) | ...
            any([imag(P);imag(Z)] <= Ylim(1)) | ...
            any([imag(P);imag(Z)] >= Ylim(2)),
         rlfcn('unzoom',RLfig);
      end
      
   end % if ~isequal(oldComp...
   
   %---Store new Compensator/Closed-loop system, etc. in UserData
   set(RLfig,'UserData',udRL)
      
case 'editcancel',
   %---The callback figure is the Edit Compensator figure = RLfig
   udEdit = get(RLfig,'UserData');
   
   %---Close any Numerator/Denominator windows
   kids = udEdit.Children(ishandle(udEdit.Children));
   close(kids);
      
   delete(gcbf)
   
case 'showclpoles',
   %---Callback for the List Closed-loop Poles menu
   LocalShowClosedLoop(RLfig,udRL);
   
case 'showplant',
   %---Callback for the plant patch or List Plant Poles/Zeros menu
   StatusStr=[{'Click on the Poles/Zeros text to see the corresponding '};
      {'Denominator or Numerator representation'}];
   LocalShowPlant(RLfig,udRL);
   
case 'endshow',
   %---Callback for the OK button on the Show Plant window
   
   ShowFig=RLfig; % Callback figure was the Show Plant window
   udShow = get(ShowFig,'UserData');
   RLfig = udShow.Parent;
   udRL=get(RLfig,'UserData');
   
   %---Read new model names
   OldModelName = udRL.Model.Name;
   udRL.Model.Name = get(findobj(ShowFig,'Tag','ModelEdit'),'String');
   set(RLfig,'Name',['Root Locus Design: ',udRL.Model.Name])
   
   udRL.Model.Plant.Name = get(findobj(ShowFig,'Tag','PlantEdit'),'String');
   udRL.Model.Sensor.Name = get(findobj(ShowFig,'Tag','SensorEdit'),'String');
   udRL.Model.Filter.Name = get(findobj(ShowFig,'Tag','FilterEdit'),'String');
   
   %---Change any open LTI Viewer system names to match model
   ViewFig = findobj(udRL.Figure.Children(ishandle(udRL.Figure.Children)),...
      'Tag','ResponseGUI');
   if ~isempty(ViewFig),
      set(ViewFig,'Name',['LTI Viewer for Root Locus Design: ',udRL.Model.Name]);
      ViewerObj = get(ViewFig,'UserData');
      OldNames = get(ViewerObj,'SystemNames');
      OldNames = strvcat(OldNames{:});
      NewNames = cell(size(OldNames,1),1);
      NewNames(:)={udRL.Model.Name};
      NewNames = cellstr([strvcat(NewNames{:}),OldNames(:,length(OldModelName)+1:end)]);
      set(ViewerObj,'SystemNames',NewNames)
   end
   
   %---Close any Numerator/Denominator windows
   kids = udShow.Children(ishandle(udShow.Children));
   close(kids);
   
   close(ShowFig)
   set(RLfig,'UserData',udRL);
   
case 'view'
   %---Response checkbox callback to open the LTI Viewer
   %---Find which button was checked
   RB = gcbo;
   PlotType = lower(get(RB,'String'));
   val = get(RB,'Value');
   
   if ~val, % Unchecking a box, remove this plottype from the Viewer
      ViewFig = get(RB,'UserData');
      LocalRemoveResponse(ViewFig,RB,PlotType,udRL);
      StatusStr='Ready';
      
   else, % Open an LTI Viewer
      %---Compute the open- and closed-loop models
      OLsys = LocalComputeSystem(udRL,'openloop');
      CLsys = LocalComputeSystem(udRL,'closedloop');
      Systems = cell(2,1);
      SystemNames = cell(2,1);
      StatusStr = cell(2,1);
      NumSys = 0;
      SysVis={'on';'on'};
      if isstatic(OLsys),
         StatusStr{1} = 'The open-loop system contains no dynamics.'; 
      elseif isproper(OLsys), % Add Open-loop system to Viewer
         NumSys = NumSys+1;
         Systems{1} = OLsys;
         SystemNames{1} = [udRL.Model.Name,'_openloop'];
         if any(strcmpi(PlotType,{'step';'impulse'})),
            SysVis{NumSys}='off';
         end
      else
         StatusStr{1} = 'The improper open-loop system is not shown in the Viewer.'; 
      end
      
      if isstatic(CLsys),
         StatusStr{2-NumSys} = 'The closed-loop system contains no dynamics.'; 
      elseif isproper(CLsys), % Add Open-loop system to Viewer
         NumSys = NumSys+1;
         Systems{NumSys} = CLsys;
         SystemNames{NumSys} = [udRL.Model.Name,'_closedloop'];
         if ~any(strcmpi(PlotType,{'step';'impulse'})),
            SysVis{NumSys}='off';
         end
      else
         StatusStr{2-NumSys} = 'The improper closed-loop system is not shown in the Viewer.'; 
      end
      
      [fignum,udRL] = LocalAddResponse(RLfig,udRL,RB,PlotType,...
         Systems(1:NumSys),SystemNames(1:NumSys),SysVis(1:NumSys));
      
   end % if/else val
   
case 'closeviewer',
   %---Callback to remove any deleted LTI Viewer handle from the RLfig Userdata
   %---This callback is actually initiated from the LTI Viewer
   Tag = get(RLfig,'Tag');
   if strcmp(Tag,'RootLocusDesignFig'),
      udRL = get(RLfig,'UserData'); 
      udRL.Figure.Children = udRL.Figure.Children(ishandle(udRL.Figure.Children));
      ViewFig = findobj(udRL.Figure.Children,'Tag','ResponseGUI');
   else
      ViewFig = RLfig;
   end
   ViewerObj = get(ViewFig,'UserData');
   RLfig = get(ViewerObj,'Parent');
   if ishandle(RLfig),
      udRL = get(RLfig,'UserData');
      set([udRL.Handles.StepButton;udRL.Handles.ImpulseButton; ...
            udRL.Handles.BodeButton;udRL.Handles.NyquistButton; ...
            udRL.Handles.NicholsButton],'Value',0,'UserData',[]);
      kids = udRL.Figure.Children;
      kids = kids(ishandle(kids));
      inddelete=find(isequal(ViewFig,kids));
      kids(inddelete)=[];
      udRL.Figure.Children=kids;
      set(RLfig,'UserData',udRL);
   end
   
   StatusStr = 'Ready';
   
case 'config',
   %---Change Configuration menu callback
   StatusStr = 'Ready';
   
   NewStr=[{'Indicate the feedback structure to use or use the --> button '};
      {'to flip through the available feedback structures.'}];
   set(udRL.Handles.StatusText,'String',NewStr);
   
   NewStructNum = loopstruct('initialize',RLfig,udRL.Model.Structure,1);
   if ~isequal(NewStructNum,udRL.Model.Structure),
      udRL.Model.Structure = NewStructNum;
      rlfcn('configapply',RLfig,udRL);
   end
   
case 'configapply',
   %---Callback for the Apply button on the Closed-loop configuration window   
   set(udRL.Handles.ChangeConfig,'UserData',udRL.Model.Structure);
   
   %---Redraw the configuration
   OldHandles = struct2cell(udRL.Handles.Configuration);
   delete([OldHandles{1:end-1}])
   Handles = loopstruct('drawconfig',udRL.Handles.ConfigurationAxes,...
      udRL.Model.Structure,1);
   Handles.SignText = udRL.Handles.Configuration.SignText;
   
   udRL.Handles.Configuration = Handles;
   set([Handles.PlantPatch,Handles.SensorPatch,Handles.FilterPatch,...
         Handles.PlantText,Handles.SensorText,Handles.FilterText],...
      'ButtonDownFcn','rlfcn(''showplant'');');
   set([Handles.CompPatch,Handles.CompText],'ButtonDownFcn',...
      'rlfcn(''editcomp'');');
   
   %---Update the closed-loop system
   udRL.ClosedLoopModel.Object = LocalComputeSystem(udRL,'closedloop');
   
   %---Update the history
   udRL.History = [udRL.History;
      {['The feedback structure is set to number ', ...
               num2str(udRL.Model.Structure)]}];
   set(RLfig,'UserData',udRL)
   
   %---Update any responses
   [StatusStr] = LocalUpdateViewer(RLfig,udRL);
   
   if isempty(StatusStr),
      StatusStr = [{['The feedback structure changed to number ',...
                  num2str(udRL.Model.Structure),'. To view all']};
         {'feedback structures, select "Change Feedback Structure" under Tools.'}];
   end
   
case 'setaxes',
   %---Set axis preferences menu callback
   LocalAxesPref(RLfig)
   
case 'applypref',
   %---Callback for the apply button on the Axis preference window
   StatusStr = {'New Root Locus Axes preferences have been applied.'};
   Importfig=gcbf;
   Ymin = str2double(get(findobj(Importfig,'Tag','YminEdit'),'String'));
   Xmin = str2double(get(findobj(Importfig,'Tag','XminEdit'),'String'));
   Ymax = str2double(get(findobj(Importfig,'Tag','YmaxEdit'),'String'));
   Xmax = str2double(get(findobj(Importfig,'Tag','XmaxEdit'),'String'));
   
   if isnan(Ymin) | isnan(Xmin) | isnan(Ymax) | isnan(Xmax),
      warndlg('One of the axis limits has not been specified', ...
         'Axis Setting Warning');
      return
   end
   
   if (Ymax<=Ymin) | (Xmax<=Xmin),
      warndlg('The upper axis limit must be greater then the lower axis limit', ...
         'Axis Setting Warning');
      return
   end
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   equalval = get(findobj(Importfig,'Tag','AxesEqualBox'),'Value');
   squareval = get(findobj(Importfig,'Tag','AxesSquareBox'),'Value');
   
   %---Determine what to do with the Equal and Square values
   if ~isequal(squareval,udAx.Preferences.Square),
      rlfcn('axissquare',RLfig);
   end
   
   if ~isequal(equalval,udAx.Preferences.Equal),
      rlfcn('axisequal',RLfig);
   end
   
   ColorOrder=[{'b'};{'r'};{'g'};{'m'};{'c'};{'y'};{'k'}];
   MarkerOrder=[{'+'};{'*'};{'s'};{'d'};{'v'}];
   LocusColor = get(findobj(Importfig,'Tag','LocusMenu'),'Value');
   CompColor = get(findobj(Importfig,'Tag','CompMenu'),'Value');
   CLColor = get(findobj(Importfig,'Tag','CLColorMenu'),'Value');
   CLMarker= get(findobj(Importfig,'Tag','CLMarkMenu'),'Value');
   
   udAx.Preferences.Y = [Ymin,Ymax];
   udAx.Preferences.X = [Xmin,Xmax];
   udAx.Preferences.Equal = equalval;
   udAx.Preferences.Square = squareval;
   udAx.Preferences.Model = ColorOrder{LocusColor};
   udAx.Preferences.Compensator = ColorOrder{CompColor};
   udAx.Preferences.ClosedLoop = [ColorOrder{CLColor},MarkerOrder{CLMarker}];
   
   %---Square and equal takes precedence over Limit Preferences
   if ~squareval | ~equalval,
      set(udRL.Handles.LTIdisplayAxes,'Xlim',[Xmin,Xmax],'Ylim',[Ymin,Ymax]);
      udRL = LocalAxisLines(udRL);
   else, % If both are turned on, use the default limits
      StatusStr=[{'Setting the axis to both square and equal overrides the'};
         {'preferred axis limits settings'}];
   end
   
   if ~isempty(udAx.Locus),
      set(udAx.Locus,'Color',ColorOrder{LocusColor});
   end
   
   if ~isempty(udAx.Model.Poles) | ~isempty(udAx.Model.Zeros),
      set([udAx.Model.Poles;udAx.Model.Zeros;udAx.FilterPoles],...
         'Color',ColorOrder{LocusColor});
   end
   if ~isempty(udAx.Compensator.Poles) | ~isempty(udAx.Compensator.Zeros),
      set([udAx.Compensator.Poles;udAx.Compensator.Zeros],'Color',ColorOrder{CompColor});
   end
   
   if ~isempty(udAx.ClosedLoopPoles) | ~isempty(udAx.FilterPoles)
      set([udAx.ClosedLoopPoles';udAx.FilterPoles],'MarkerEdgeColor',ColorOrder{CLColor},...
         'MarkerFaceColor',ColorOrder{CLColor},...
         'Marker',MarkerOrder{CLMarker});
   end
   
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx)
   set(RLfig,'CurrentAxes',udRL.Handles.LTIdisplayAxes)
   
case 'grid',
   %---Grid Configuration menu callback
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   LocalEditGrid(RLfig,udAx)
   
case 'constraintbox',
   %---Callback linking the Grid/Constrait checkboxes and text fields 
   val = strmat(get(gcbo,'String'));
   ud=get(gcbo,'UserData');
   
   if isnan(val)
      set(gcbo,'String',num2str(ud.Revert));
   else
      ud.Revert=val;
      set(ud.Button,'Value',1);
      set(gcbo,'UserData',ud)
   end
   
case 'applygrid',
   %---Apply button callback for the Grid configuration window
   GridFig = gcbf;
   RLfig  = get(GridFig,'UserData');
   udRL = get(RLfig,'UserData');
   
   %---Get the LTIdisplayAxes Userdata
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   
   %---Read the values off the Grid configuration window
   StateGrid = get(findobj(GridFig,'Tag','GridBox'),'Value');
   StateTs = get(findobj(GridFig,'Tag','TsButton'),'Value');
   StateWn = get(findobj(GridFig,'Tag','WnButton'),'Value');
   StateZeta = get(findobj(GridFig,'Tag','ZetaButton'),'Value');
   ValTs = get(findobj(GridFig,'Tag','TsEdit'),'String');
   ValWn = get(findobj(GridFig,'Tag','WnEdit'),'String');
   ValZeta = get(findobj(GridFig,'Tag','ZetaEdit'),'String');
   
   RB = [findobj(GridFig,'Tag','SgridButton');findobj(GridFig,'Tag','POButton')];
   RBvals = get(RB,'value');
   RBvals = cat(1,RBvals{:});
   GridVal = find(RBvals==1);
   
   %---Reset the axis userData
   udAx.Grid.State=StateGrid;
   set(udRL.Handles.GridBox,'Value',StateGrid);
   udAx.Grid.Value = GridVal;
   
   udAx.Constraints.Damping.State=StateZeta;
   udAx.Constraints.Damping.Value=strmat(ValZeta);
   udAx.Constraints.NaturalFrequency.State=StateWn;
   udAx.Constraints.NaturalFrequency.Value=strmat(ValWn);
   udAx.Constraints.SettlingTime.State=StateTs;
   udAx.Constraints.SettlingTime.Value=strmat(ValTs);
   
   set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
   
   %---Plot the new grid and constraints
   LocalPlotGrid(RLfig,udRL.Handles.LTIdisplayAxes,udAx);
   
   StatusStr = {'The desired grid and constraints have been added'};
   
case 'importmodel',
   %---Callback for Import Model menu
   ModelData = importlti('initialize',RLfig,udRL.Model.Structure,...
      [1 2],udRL.Model.Name);
   
   if ~isempty(ModelData),
      ErrFlag=0;
      if hasdelay(ModelData.Sensor.Object),
         if ModelData.Sensor.Object.Ts,
            % Map delay times to poles at z=0 in discrete-time case
            ModelData.Sensor.Object= delay2z(ModelData.Sensor.Object);
         else
            ErrFlag=1;
         end      
      end
      if hasdelay(ModelData.Filter.Object),
         if ModelData.Filter.Object.Ts,
            % Map delay times to poles at z=0 in discrete-time case
            ModelData.Filter.Object= delay2z(ModelData.Filter.Object);
         else
            ErrFlag=1;
         end      
      end
      if hasdelay(ModelData.Plant.Object),
         if ModelData.Plant.Object.Ts,
            % Map delay times to poles at z=0 in discrete-time case
            ModelData.Plant.Object= delay2z(ModelData.Sensor.Object);
         else
            ErrFlag=1;
         end      
      end
      
      if ErrFlag,
         errordlg('Cannot import a continuous-time delay systems.', ...
            'Import Model Error')
         return
      end      
      
      %---Make sure none of the systems have a gain of zero
      [z,p,ks]=zpkdata(ModelData.Sensor.Object);
      [z,p,kf]=zpkdata(ModelData.Filter.Object);
      [z,p,kp]=zpkdata(ModelData.Plant.Object);
      if ~all([ks(:);kf(:);kp(:)]),
         warndlg({'At least one of you model components had a zero gain.'; ...
               ''; ...
               'LTI Objects with zero gain are not allowed in the Root Locus'; ...
               'design tool. Return to the Import window to enter in different'; ...
               'model data.'}, ...
            'Import Warning');
         return
      end
            
      %---Check sample time consistency
      Comp = udRL.Compensator.Object;
      Comp.k = udRL.Compensator.Gain;
      [Comp,StatusStr,ErrorFlag]=LocalCheckSampleTime(ModelData,Comp);
      
      if ErrorFlag
         %---Conversion couldn't be done....bail out of import   
         return
      else
         udRL.Compensator.Gain = Comp.k;
         Comp.k=1;
         udRL.Compensator.Object = Comp;
         if ~isempty(StatusStr)
            set(udRL.Handles.StatusText,'String',StatusStr)
            udRL.History = [udRL.History;StatusStr];
         end
      end
      
      ProperFlag = LocalCheckProper(ModelData.Plant.Object,udRL.Compensator.Object,...
         ModelData.Sensor.Object,ModelData.Structure);
      if ~ProperFlag,
         warndlg(['The model you tried to import would yield a system that ',...
               'is not compatible with some of the Control System Toolbox ',...
               'functions and, therefore, is not allowed in the ',...
               'Root Locus Design GUI.  This is usually ',...
               'the result of an improper system in the forward or feedback loop.'],...
            'Import Warning');
         return
      end
      
      %---Squeeze any blanks out of Simulink block names
      PlantStr=ModelData.Plant.Name;
      NewStr=[];
      while ~isempty(PlantStr),
         [str,PlantStr]=strtok(PlantStr);
         NewStr = [NewStr,str];
      end
      ModelData.Plant.Name=NewStr;
      
      SensorStr=ModelData.Sensor.Name;
      NewStr=[];
      while ~isempty(SensorStr),
         [str,SensorStr]=strtok(SensorStr);
         NewStr = [NewStr,str];
      end
      ModelData.Sensor.Name=NewStr;
      
      FilterStr=ModelData.Filter.Name;
      NewStr=[];
      while ~isempty(FilterStr),
         [str,FilterStr]=strtok(FilterStr);
         NewStr = [NewStr,str];
      end
      ModelData.Filter.Name=NewStr;
      
      %---Finish the import
      %---Update the Feedback Structure, if necessary
      if ~isequal(ModelData.Structure,udRL.Model.Structure),
         %---Redraw the configuration
         OldHandles = struct2cell(udRL.Handles.Configuration);
         delete([OldHandles{1:end-1}])
         Handles = loopstruct('drawconfig',udRL.Handles.ConfigurationAxes,...
            ModelData.Structure,1);
         Handles.SignText = udRL.Handles.Configuration.SignText;
         
         udRL.Handles.Configuration = Handles;
         set([Handles.PlantPatch,Handles.SensorPatch,Handles.FilterPatch,...
               Handles.PlantText,Handles.SensorText,Handles.FilterText],...
            'ButtonDownFcn','rlfcn(''showplant'');');
         set([Handles.CompPatch,Handles.CompText],'ButtonDownFcn',...
            'rlfcn(''editcomp'');');
         
      end % if ~isequal(Structure...   
      
      %---Make sure to keep the previous feedback sign
      ModelData.FeedbackSign = udRL.Model.FeedbackSign;
      udRL.Model = ModelData;
      rlfcn('finishimport',RLfig,udRL);
   end
   
case 'importcomp',
   %---Callback for Import Compensator menu
   CompData = importcomp('initialize',RLfig,udRL.Compensator.Name,[1 1]);
   
   if ~isempty(CompData),
      if hasdelay(CompData.Object),
         if CompData.Object.Ts,
            % Map delay times to poles at z=0 in discrete-time case
            CompData.Object= delay2z(CompData.Object);
         else
            errordlg('Cannot import a continuous-time delay systems.', ...
               'Import Compensator Error')
            return
         end      
      end
      
      %---Check sample time consistency
      [Comp,StatusStr,ErrorFlag]=LocalCheckSampleTime(udRL.Model,CompData.Object);
      
      if ErrorFlag
         %---Conversion couldn't be done....bail out of import   
         return
      else
         CompData.Object = Comp;
         if ~isempty(StatusStr)
            set(udRL.Handles.StatusText,'String',StatusStr)
            udRL.History = [udRL.History;StatusStr];
         end
      end
      
      %---Check that the imported compensator does not result in an invalid system
      ProperFlag = LocalCheckProper(udRL.Model.Plant.Object,CompData.Object,...
         udRL.Model.Sensor.Object,udRL.Model.Structure);
      if ~ProperFlag,
         warndlg(['The compensator you tried to import would yield a system that ',...
               'is not compatible with some of the Control System Toolbox ',...
               'functions and, therefore, is not allowed in the ',...
               'Root Locus Design GUI.  This is usually ',...
               'the result of an improper system in the forward or feedback loop.'],...
            'Import Warning');
         return
      end
      
      %---Finish the import
      CompData.Object= zpk(CompData.Object);
      CompData.Gain = CompData.Object.k;
      CompData.Object.k=1;
      udRL.Compensator = CompData;
      rlfcn('finishimport',RLfig,udRL);
   end
   
case 'finishimport'
   %---Callback to finish importing a model/compensator
   
   %---Make the Figure name contain the current model name
   set(RLfig,'Name',['Root Locus Design: ',udRL.Model.Name])
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'Userdata');
   
   %---Remove the old model poles and zeros and Filter Closed-loop poles
   delete([udAx.Model.Poles;udAx.Model.Zeros;udAx.FilterPoles])
   
   %---Plot the original model, if entered
   [PlantPoles,PlantZeros] = pzmap(udRL.Model.Plant.Object);
   [SensorPoles,SensorZeros] = pzmap(udRL.Model.Sensor.Object);
   [FilterPoles,FilterZeros] = pzmap(udRL.Model.Filter.Object);
   Poles = [PlantPoles;SensorPoles;FilterPoles];
   Zeros = [PlantZeros;SensorZeros;FilterZeros];
   olZeros=[];olPoles=[];
   
   %---Add Model Zeros (these should never change unless a new model is entered)
   for ctZ = 1:length(Zeros)
      olZeros(ctZ,1) = line(real(Zeros(ctZ)),imag(Zeros(ctZ)),'LineStyle','none',...
         'Marker','o','Color',udAx.Preferences.Model,'Tag','ModelZeros',...
         'EraseMode','xor','Parent',udRL.Handles.LTIdisplayAxes,...
         'ButtonDownFcn','rlfcn(''showplant'',gcbf);');
   end
   
   %---Add Model Poles
   for ct=1:length(Poles),
      olPoles(ct,1) = line(real(Poles(ct)),imag(Poles(ct)),'LineStyle','none',...
         'Marker','x','MarkerSize',8,'Color',udAx.Preferences.Model,...
         'Tag','ModelPoles','Parent',udRL.Handles.LTIdisplayAxes,...
         'ButtonDownFcn','rlfcn(''showplant'',gcbf);');
   end
   
   %---Add Closed_loop Poles due to Filter
   [Wn,Zeta,r]=damp(udRL.Model.Filter.Object);
   clFilterPoles=[];
   for ct=1:length(FilterPoles),
      clFilterPoles(ct,1) = line(real(r(ct)),imag(r(ct)),...
         'LineStyle','none','Marker',udAx.Preferences.ClosedLoop(2),...
         'MarkerSize',5,'MarkerEdgeColor',udAx.Preferences.ClosedLoop(1),...
         'MarkerFaceColor',udAx.Preferences.ClosedLoop(1),...
         'ButtonDownFcn','rlfcn(''filterpole'',gcbf);',...
         'Tag','FilterPoles','Parent',udRL.Handles.LTIdisplayAxes,...
         'UserData',struct('Damping',Zeta(ct),'NaturalFrequency',Wn(ct)));
   end
   udAx.FilterPoles = clFilterPoles;
   
   %---Delete the old compensator and plot the new compensator, if entered
   [P,Z] = pzmap(udRL.Compensator.Object);
   CompZeros=[];CompPoles=[];
   delete([udAx.Compensator.Poles;udAx.Compensator.Zeros]);
   for ctP=1:length(P),
      CompPoles(ctP,1)=line(real(P(ctP)),imag(P(ctP)),'LineStyle','none',...
         'Marker','x','Color',udAx.Preferences.Compensator,'MarkerSize',9,'Tag','CompPoles', ...
         'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
         'ButtonDownFcn','rlfcn(''compbuttondown'');');
   end
   for ctZ=1:length(Z),
      CompZeros(ctZ,1)=line(real(Z(ctZ)),imag(Z(ctZ)),'LineStyle','none',...
         'Marker','o','Color',udAx.Preferences.Compensator,'Tag','CompZeros', ...
         'Parent',udRL.Handles.LTIdisplayAxes,'EraseMode','xor',...
         'ButtonDownFcn','rlfcn(''compbuttondown'');');
   end
   
   udAx.Model.Poles = olPoles;
   udAx.Model.Zeros = olZeros;
   udAx.Compensator.Poles = CompPoles;
   udAx.Compensator.Zeros = CompZeros;
   set(udRL.Handles.LTIdisplayAxes,'UserData',udAx,'XlimMode','auto','YlimMode','auto')
   
   %---Turn the menu items on
   if ~isempty(Poles) | ~isempty(Zeros),
      set(udRL.Handles.Menus.Options.Clear,'Enable','on')
      set(udRL.Handles.Menus.Options.Show,'Enable','on')
      set(udRL.Handles.Menus.Options.Convert,'Enable','on')
   end
   
   [z,p,k]=zpkdata(udRL.Compensator.Object,'v');
   LocalUpdateText('num',z,udRL.Handles.NumText,udRL);
   LocalUpdateText('den',p,udRL.Handles.DenText,udRL);
   set(udRL.Handles.GainEdit,'String',num2str(udRL.Compensator.Gain))
   
   [udRL,StatusStr2] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   if isempty(StatusStr),
      StatusStr=StatusStr2;
   end
   
   set(RLfig,'UserData',udRL);
   
   %---Have Plot Axes rescale to show all   
   rlfcn('unzoom',RLfig);
   
case 'export',
   %---Callback for the Export menu
   
   %---Make the ExportData
   ExportData = export('getdata');
   ExportData.MatName='RLdata';
   
   %---Add Design Model
   ExportData.DesignModels.Names = {udRL.Model.Name};
   ExportData.DesignModels.Objects= {udRL.Model};
   
   %---Add OpenLoopModel
   ExportData.OpenLoop.Names={[udRL.Model.Name,'_ol']};
   ExportData.OpenLoop.Objects={LocalComputeSystem(udRL,'openloop')};
   
   %---Add ClosedLoopModel
   ExportData.ClosedLoop.Names={[udRL.Model.Name,'_cl']};
   ExportData.ClosedLoop.Objects={udRL.ClosedLoopModel.Object};
   
   %---Add Compensator
   ExportData.Compensators.Names={udRL.Compensator.Name};
   ExportData.Compensators.Objects={udRL.Compensator.Object};
   ExportData.Compensators.Objects{1}.k=udRL.Compensator.Gain;
   
   export('initialize',RLfig,ExportData);
   
case 'clearmodel',
   %---Clear Model menu callback
   udRL.Model.Name='sys';
   udRL.Model.Plant.Name = 'P';
   udRL.Model.Plant.Object=zpk([],[],1,udRL.Compensator.Object.Ts);
   udRL.Model.Sensor.Name = 'H';
   udRL.Model.Sensor.Object=zpk([],[],1,udRL.Compensator.Object.Ts);
   udRL.Model.Filter.Name = 'F';
   udRL.Model.Filter.Object=zpk([],[],1,udRL.Compensator.Object.Ts);
   
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   delete([udAx.Model.Poles;udAx.Model.Zeros;udAx.FilterPoles]);
   udAx.Model.Poles=[];
   udAx.Model.Zeros=[];
   udAx.FilterPoles=[];
   set(udRL.Handles.LTIdisplayAxes,'Userdata',udAx);
   [udRL,StatusStr] = LocalPlotRlocus(udRL.Handles.LTIdisplayAxes,udRL);
   set(udRL.Handles.Menus.Options.Convert,'Enable','off');
   set(udRL.Handles.Menus.Options.Clear,'Enable','off');
   set(udRL.Handles.Menus.Options.Show,'Enable','off');
   set(RLfig,'UserData',udRL);
   
   %---Rescale the Plot Axes
   rlfcn('unzoom',RLfig)
   
case 'clearcomp',
   %---Clear compensator menu callback
   udRL.Compensator.Name = 'comp';
   udRL.Compensator.Object=zpk(1);
   udRL.Compensator.Gain = 1;
   
   %---Change Compensator gain back to 1
   set(udRL.Handles.GainEdit,'String',1,'UserData','1');
   
   rlfcn('finishimport',RLfig,udRL)
   
case 'discretize',
   %---Callback for the Convert to Discrete/Continuous menu
   Ts = udRL.Model.Plant.Object.Ts;
   if Ts;
      DiscreteFlag =1;
   else
      DiscreteFlag = 0;
   end
   LocalDiscretizeModel(RLfig,udRL,DiscreteFlag,Ts)
   
case 'discreteradiobutton',
   %---Callback for the radio buttons on the Discretize model figure
   ud = get(gcbo,'UserData');
   val = get(gcbo,'Value');
   tag = get(gcbo,'Tag');
   
   if val,
      set(ud(1),'Value',0);
      if strcmp(tag,'ContinuousButton');
         set(ud(2),'Enable','off');
      else
         set(ud(2),'Enable','on');
      end
   else
      set(gcbo,'Value',1);
   end
   
case 'changemethod',
   %---Callback for the method popupmenu on the Discretize model figure
   val = get(gcbo,'Value');
   Ud=get(gcbo,'UserData');
   if strcmp(Ud{val},'prewarp'),
      set(findobj(gcbf,'Tag','CritFreqEdit'),'Enable','on');
   else
      set(findobj(gcbf,'Tag','CritFreqEdit'),'Enable','off');
   end
   
case 'discreteapply',
   %---Callback for the OK button on the Discretize model window
   DiscreteFig = RLfig;
   RLfig = udRL;
   udRL = get(RLfig,'UserData');
   Model = udRL.Model.Plant.Object;
   Comp = udRL.Compensator.Object;
   Comp.k=udRL.Compensator.Gain;
   Ts = Model.Ts;
   
   if Ts;
      %--See if a resampling is being done
      if get(findobj(DiscreteFig,'Tag','DiscreteButton'),'Value');
         DiscreteFlag=0;
      else
         DiscreteFlag =1;
      end
   else
      DiscreteFlag = 0;
   end
   
   MethodVal = get(findobj(DiscreteFig,'Tag','MethodMenu'),'Value');
   AllMethods = get(findobj(DiscreteFig,'Tag','MethodMenu'),'UserData');
   
   CritFreq=[];
   if strcmp(AllMethods{MethodVal},'prewarp'), 
      CritFreq = str2double(get(findobj(DiscreteFig,'Tag','CritFreqEdit'),'String'));
      if isnan(CritFreq) |  (CritFreq<=0),
         warndlg('A valid critical frequency greater then zero must be entered', ...
            'Conversion Warning');
         return
      end
   end
   
   try
      if ~DiscreteFlag, % Convert to discrete
         SampleTime = str2double(get(findobj(DiscreteFig,'Tag','SampleTimeEdit'),'String'));
         if isnan(SampleTime) |  (SampleTime<=0 & SampleTime~=(-1)),
            warndlg(['A valid sample time must be entered. ',...
                  'Use zero to indicate an unspecified sample time'], ...
               'Conversion Warning');
            return
            
         else
            %---Check if the Conversion is c2d or d2d
            if ~Ts, % c2d
               NewModel = c2d(Model,SampleTime,AllMethods{MethodVal},CritFreq);
               NewSensor = c2d(udRL.Model.Sensor.Object,...
                  SampleTime,AllMethods{MethodVal},CritFreq);
               NewFilter = c2d(udRL.Model.Filter.Object,...
                  SampleTime,AllMethods{MethodVal},CritFreq);
               NewComp = c2d(Comp,SampleTime,AllMethods{MethodVal},CritFreq);
               
               HistoryText = {['The model has been discretized with a sample time of ',...
                        num2str(SampleTime)]};
            else, % d2d
               NewModel = d2d(Model,SampleTime);
               NewSensor = d2d(udRL.Model.Sensor.Object,SampleTime);
               NewFilter = d2d(udRL.Model.Filter.Object,SampleTime);
               NewComp = d2d(Comp,SampleTime);
               HistoryText = {['The model has been resampled with a sample time of ',...
                        num2str(SampleTime)]};
            end, % if/else ~Ts
            
         end % if/else SampleTime
         
      else, % Convert to continuous
         NewModel = d2c(Model,AllMethods{MethodVal},CritFreq);
         NewSensor = d2c(udRL.Model.Sensor.Object,AllMethods{MethodVal},CritFreq);
         NewFilter = d2c(udRL.Model.Filter.Object,AllMethods{MethodVal},CritFreq);
         NewComp = d2c(Comp,AllMethods{MethodVal},CritFreq);
         HistoryText = {'The model has been converted to a continous system'};
      end % if/else ~DiscreteFlag
      
      if DiscreteFlag 
         %---Being changed to continuous, disable To Continuous button
         set(findobj(DiscreteFig,'Tag','ContinuousButton'),'Enable','off');
      else
         %---Being changed to discrete, enable To Continuous button
         set(findobj(DiscreteFig,'Tag','ContinuousButton'),'Enable','on');
      end
   
   catch         
      errStr=lasterr;
      errordlg(errStr,'Conversion Error');
      return
   end % try/catch errors in conversion
   
   %---Reset the Root Locus Figure UserData
   udRL.Model.Plant.Object = NewModel;
   udRL.Model.Sensor.Object = NewSensor;
   udRL.Model.Filter.Object = NewFilter;
   udRL.Compensator.Gain = NewComp.k;
   NewComp.k=1;
   udRL.Compensator.Object = NewComp;
   
   %---Update the History Text
   udRL.History = [udRL.History;HistoryText];
   set(RLfig,'UserData',udRL);
   
   %---Close the Discretize window and update the Root Locus Window
   rlfcn('finishimport',RLfig,udRL);
   udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');
   LocalPlotGrid(RLfig,udRL.Handles.LTIdisplayAxes,udAx),
   
case 'close'
   %---Close menu callback
   badhandles = find(~ishandle(udRL.Figure.Children));
   udRL.Figure.Children(badhandles)=[];
   close(udRL.Figure.Children);
   close(RLfig);
   return
   
case 'closekids',
   %---DeleteFcn of the Root Locus Design GUI
   ChildFigs = udRL.Figure.Children;
   GoodFigs = ChildFigs(ishandle(ChildFigs));
   if ~isempty(GoodFigs)
      close(GoodFigs);
   end
   StatusStr='Ready';
   
case 'childclose',
   %---Generic CloseRequestFcn for the Root Locus Design GUI children
   ChildFig = RLfig;
   RLfig = get(ChildFig,'UserData');
   if ishandle(RLfig),
      udRL = get(RLfig,'UserData');
      kids = udRL.Figure.Children(find(ishandle(udRL.Figure.Children)));
      if ~isempty(kids),
         indkid = find(ChildFig==kids);
         if ~isempty(indkid)
            kids(indkid)=[];
         end % if ~isempty(indkid)
      end % if ~isempty(kids
      udRL.Figure.Children = kids;
      set(RLfig,'Userdata',udRL);
   end % if ishandle
   
   delete(ChildFig)
   StatusStr = 'Ready';
   
case 'drawdiagram'
   %---Callback from the Draw Simulink Diagram menu
   
   %---Check if the User has Simulink
   SimFlag=exist('simulink');
   if ~SimFlag,
      WarnStr = ['Simulink must be included in your MATLAB path before',...
            ' requesting a Simulink diagram of the closed-loop system'];
      warndlg(WarnStr,'Drawing a Simulink diagram');
      
   else
      
      switch questdlg(...
            {'Before the diagram can be drawn, the Model and '
            'Compensator data must be exported to the workspace.'
            ' '
            'The data will be stored in the variable names ' 
            'used in the Root Locus Design GUI and may overwrite.'
            'data currently in the Workspace.'
            ' '
            'Do you wish to continue?'},...
            'Drawing Simulink Diagrams','Yes','No','Yes');
         
      case 'Yes'
         overwriteOK = 1;
      case 'No'
         overwriteOK = 0;
      end % switch questdlg
      
      if overwriteOK,
         LocalDrawDiagram(udRL);
      end
      
   end % if/else ~SimFlag
case 'sendcomp',
   
case 'print'
   MyTag = get(gcbo,'Tag');
   
   %---Print menu callback...this prints only the Root Locus Axes
   printfig = figure('visible','off');
   h=copyobj(udRL.Handles.LTIdisplayAxes,printfig);
   set(h,'Xcolor',[0 0 0],'Ycolor',[0 0 0])
   pos=get(0,'defaultaxesposition');
   set(h,'unit','norm','Position',pos)
   set(get(h,'Title'),'visible','on');
   
   %---Turn any buttondown functions off.
   set(findobj(printfig,'type','line'),'ButtonDownFcn','');
   set(printfig,'visible','on');
  
   switch MyTag,
   case 'PrintMenu',
      printdlg(printfig);
      
      if isunix,
         kids = allchild(0);
         waitfor(kids(1));
      end   
      
      close(printfig)
      
   case 'FigureMenu',
      %---Place-holder so otherwise is not called for the FigureMenu
   otherwise
      close(printfig);
   end
   
case 'history'
   %---Callback for the History menu
   msgbox(udRL.History);
   
case 'radiocallback'
   %---Callback for mutually exclusive radio buttons
   val = get(gcbo,'Value');
   ud = get(gcbo,'UserData');
   
   if val,
      set(ud,'Value',0);
   else
      set(gcbo,'Value',1);
   end
   
case 'resize',
   %---Resize Function Callback
   [StatusStr] = LocalResizeFunction(RLfig);
   
end % switch action

if ~isempty(StatusStr) & ishandle(RLfig),
   StatusText = findobj(RLfig,'Tag','StatusText');
   set(StatusText,'String',StatusStr);
end

%-------------------------Internal Functions-----------------------
%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalAddResponse %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function [ViewFig,udRL] = LocalAddResponse(RLfig,udRL,RB,PlotType,Systems,SystemNames,SystemVis);

ViewFig = udRL.Figure.Children;
ViewFig = ViewFig(ishandle(ViewFig));
ViewFig = findobj(ViewFig,'Tag','ResponseGUI');

SysStr='';
for ctSys=1:length(Systems),
   eval([SystemNames{ctSys},'=Systems{ctSys};']);
   SysStr = [SysStr,',',SystemNames{ctSys}];
end

if isempty(ViewFig), % Make an initial LTI Viewer
   if isempty(SysStr),
      ViewFig = ltiview;
   else
      eval(['ViewFig = ltiview(''',PlotType,'''',SysStr,');'])   
   end
   ViewerObj = get(ViewFig,'UserData');
   set(ViewerObj,'SystemNames',SystemNames)
   CF = get(ViewFig,'CloseRequestFcn');
   set(ViewFig,'CloseRequestFcn',['rlfcn(''closeviewer'',gcbf);',CF]);
   
   set(ViewFig,'Name',[get(ViewFig,'Name'),' for ',get(RLfig,'Name')]);
   
   udRL.Figure.Children = [udRL.Figure.Children;ViewFig];
else % Reconfigure the existing Viewer
   ViewerObj = get(ViewFig,'UserData');
   AllProps = get(ViewerObj);
   [garb,indresp]=setdiff(AllProps.PlotTypeOrder,PlotType);
   NewOrder = [cellstr(PlotType);AllProps.PlotTypeOrder(sort(indresp))];
   
   set(ViewerObj,'PlotTypeOrder',NewOrder,...
      'Configuration',AllProps.Configuration+1);
   
end

%---For Defaults, set step/impulse to show closed-loop, and all others show open-loop
if ~isempty(SysStr)
   UImenus = get(ViewerObj,'UIContextMenu');
   RespObj = get(UImenus(1),'UserData');
   set(RespObj,'SystemVisibility',SystemVis);
   
   %---Hide the Viewer Controls
   showguis(ViewerObj,'off');
end

set(RLfig,'UserData',udRL)
set(RB,'UserData',ViewFig);

%%%%%%%%%%%%%%%%%%%%%
%%% LocalAxesPref %%% %---Open the Axis Preferences window
%%%%%%%%%%%%%%%%%%%%%
function LocalAxesPref(Parent);

StdColor = get(0,'defaultuicontrolbackgroundcolor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'point';

ax = findobj(Parent,'Tag','LTIdisplayAxes');
DARmode = get(ax,'DataAspectRatioMode');
PBARmode = get(ax,'PlotBoxAspectRatioMode');
udAx = get(ax,'UserData');
ColorOrder=[{'b'};{'r'};{'g'};{'m'};{'c'};{'y'};{'k'}];
MarkerOrder = [{'+'};{'*'};{'s'};{'d'};{'v'}];

a = figure('Color',[0.8 0.8 0.8], ...
   'MenuBar','none', ...
   'Name','Root Locus Axes Preferences', ...
   'NumberTitle','off', ...
   'IntegerHandle','off', ...
   'Position',[145 145 312 276], ...
   'Resize','off', ...
   'UserData',Parent, ...
   'WindowStyle','modal', ...
   'Tag','AxesPrefFig');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[8 154 296 110], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',... 
   'TooltipStr','Preferred Root Locus Axes limits',...
   'Position',PointsToPixels*[103 238 96 20], ...
   'String','Limits', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[14 206 50 40], ...
   'String','Y-axis: From', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[14 175 50 40], ...
   'String','X-axis: From', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[167 215 26 20], ...
   'String','To', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[167 184 26 20], ...
   'String','To', ...
   'Style','text');

if isempty(udAx.Preferences.X),
   udAx.Preferences.X = get(ax,'Xlim');
   udAx.Preferences.Y = get(ax,'Ylim');
end

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'HorizontalAlign','left',...
   'Position',PointsToPixels*[90 215 60 20], ...
   'Style','edit', ...
   'String',num2str(udAx.Preferences.Y(1)), ...
   'UserData',num2str(udAx.Preferences.Y(1)), ...
   'Tag','YminEdit');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'HorizontalAlign','left',...
   'Position',PointsToPixels*[211 215 60 20], ...
   'String',num2str(udAx.Preferences.Y(2)), ...
   'UserData',num2str(udAx.Preferences.Y(2)), ...
   'Style','edit', ...
   'Tag','YmaxEdit');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'HorizontalAlign','left',...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'Position',PointsToPixels*[90 185 60 20], ...
   'Style','edit', ...
   'String',num2str(udAx.Preferences.X(1)), ...
   'UserData',num2str(udAx.Preferences.X(1)), ...
   'Tag','XminEdit');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'HorizontalAlign','left',...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'Position',PointsToPixels*[211 185 60 20], ...
   'Style','edit', ...
   'String',num2str(udAx.Preferences.X(2)), ...
   'UserData',num2str(udAx.Preferences.X(2)), ...
   'Tag','XmaxEdit');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[14 156 110 20], ...
   'String',' Axis Equal?', ...
   'Style','checkbox', ...
   'Value',udAx.Preferences.Equal, ...
   'Tag','AxesEqualBox');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[174 156 110 20], ...
   'String',' Axis Square?', ...
   'Style','checkbox', ...
   'Value',udAx.Preferences.Square, ...
   'Tag','AxesSquareBox');

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[8 41 296 105], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...   
   'Position',PointsToPixels*[126 121 80 20], ...
   'String','Colors', ...
   'TooltipStr','Colors on Root Locus Axes',...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold',...   
   'Position',PointsToPixels*[215 121 80 20], ...
   'String','Markers', ...
   'TooltipStr','Symbol for closed-loop poles',...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[15 102 98 20], ...
   'String','Root Locus', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[15 76 98 20], ...
   'String','Compensator', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[15 51 98 20], ...
   'String','Closed-loop poles', ...
   'Style','text');

LocusVal = strmatch(udAx.Preferences.Model,ColorOrder);
CompVal = strmatch(udAx.Preferences.Compensator,ColorOrder);
CLcolVal = strmatch(udAx.Preferences.ClosedLoop(1),ColorOrder);
CLmarkVal = strmatch(udAx.Preferences.ClosedLoop(2),MarkerOrder);

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Position',PointsToPixels*[126 101 80 20], ...
   'String',[{'blue'};{'red'};{'green'};{'magenta'};{'cyan'};{'yellow'};{'black'}], ...
   'Style','popupmenu', ...
   'Tag','LocusMenu', ...
   'Value',LocusVal);
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Position',PointsToPixels*[126 75 80 20], ...
   'String',[{'blue'};{'red'};{'green'};{'magenta'};{'cyan'};{'yellow'};{'black'}], ...
   'Style','popupmenu', ...
   'Tag','CompMenu', ...
   'Value',CompVal);
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Position',PointsToPixels*[126 50 80 20], ...
   'String',[{'blue'};{'red'};{'green'};{'magenta'};{'cyan'};{'yellow'};{'black'}], ...
   'Style','popupmenu', ...
   'Tag','CLColorMenu', ...
   'Value',CLcolVal);
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Position',PointsToPixels*[214 50 80 20], ...
   'String',[{'plus'};{'star'};{'square'};{'diamond'};{'triangle'}], ...
   'Style','popupmenu', ...
   'Tag','CLMarkMenu', ...
   'Value',CLmarkVal);

CallStr = ['rlfcn(''applypref'',get(gcbf,''UserData''));'];
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[9 7 60 25], ...
   'String','OK', ...
   'Callback',[CallStr,'rlfcn(''childclose'',gcbf);'], ...
   'Tag','OKButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[87 7 60 25], ...
   'String','Cancel', ...
   'UserData',Parent,...
   'Callback','rlfcn(''childclose'',gcbf);', ...
   'Tag','CloseButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[166 7 60 25], ...
   'String','Help', ...
   'Callback','rlhelp(''axes'');', ...
   'Tag','HelpButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[244 7 60 25], ...
   'String','Apply', ...
   'Callback',CallStr, ...
   'Tag','ApplyButton');

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalAxisLines %%% %---Make sure the axis lines fill the current axis limits
%%%%%%%%%%%%%%%%%%%%%%
function udRL = LocalAxisLines(udRL);

Xlim = get(udRL.Handles.LTIdisplayAxes,'Xlim');
Ylim = get(udRL.Handles.LTIdisplayAxes,'Ylim');

if ishandle(udRL.Handles.XaxisLine) & ishandle(udRL.Handles.YaxisLine),
   set(udRL.Handles.XaxisLine,'Xdata',Xlim);
   set(udRL.Handles.YaxisLine,'Ydata',Ylim);
   set(udRL.Handles.LTIdisplayAxes,'Xlim',Xlim,'Ylim',Ylim)
else
   Ylim = [min([-1,Ylim(1)]),max([1,Ylim(2)])];
   Xlim = [min([-1,-1*abs(Xlim(1)),-1*abs(Xlim(2))]),max([1,abs(Xlim(2)),abs(Xlim(2))])];
   udRL.Handles.XaxisLine = line(Xlim,[0 0],'Color',[.7 .7 .7], ...
      'LineStyle',':','Parent',udRL.Handles.LTIdisplayAxes,'Tag','XaxisLine');
   udRL.Handles.YaxisLine = line([0 0],Ylim,'Color',[.7 .7 .7], ...
      'LineStyle',':','Parent',udRL.Handles.LTIdisplayAxes,'Tag','YaxisLine');
   
   %---Reorder children so Axis lines are on botton
   kids = get(udRL.Handles.LTIdisplayAxes,'Children');
   AxesLines = [udRL.Handles.XaxisLine;udRL.Handles.YaxisLine];
   Otherkids = setdiff(kids,AxesLines);
   set(udRL.Handles.LTIdisplayAxes,'Children',[Otherkids;AxesLines])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalChangeClosedLoopPoles %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function udRL = LocalChangeClosedLoopPoles(RLfig,udRL);
%---Read the necessary data from the RLfig UserData
udAx = get(udRL.Handles.LTIdisplayAxes,'UserData');

%---Compute the appropriate characteristic equation
clsys = LocalComputeSystem(udRL,'cl_locus');
udRL.ClosedLoopModel.Object = udRL.Model.Filter.Object*clsys;

[Wn,Zeta,r]=damp(clsys);
for ct=1:length(r),
   set(udAx.ClosedLoopPoles(ct),'Xdata',real(r(ct)),'Ydata',imag(r(ct)), ...
      'UserData',struct('Damping',Zeta(ct),'NaturalFrequency',Wn(ct)));
end

%---Update the LTI Viewer
StatusStr = LocalUpdateViewer(RLfig,udRL);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckProper %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function Properflag = LocalCheckProper(Plant,Comp,Sensor,FdbkConfig);

%---LocalCheckProper looks for systems that will have an improper aguement
%-----into the FEEDBACK command used in LocalComputeSystem. Since thise
%-----causes a command line error that will break the GUI, these systems
%-----are not allowed. This does not limit the design of improper compensators.

%---Protect against improper state space conversions,
%-----If the compensator is improper and the plant
%-----is state space, convert the plant ss to a zpk. This traps errors
%-----resulting when attempting to conver improper systems to ss. 
if ~isproper(Comp) & isa(Plant,'ss'),
   Plant=zpk(Plant);
end

switch FdbkConfig,
case 1,
   Properflag = isproper(Plant*Comp);   
case 2,
   Properflag = isproper(Comp*Sensor);
end % switch FdbkConfig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckSampleTime %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Comp,StatusStr,ErrorFlag]=LocalCheckSampleTime(Model,Comp);
%---Check if the Compensator does not have the same sample time as the model
%----If it does not, convert the Compensator and return the appropriate StatusStr

TsModel= max([Model.Plant.Object.Ts;Model.Sensor.Object.Ts;Model.Filter.Object.Ts]);
TsComp = Comp.Ts;
ErrorFlag=0;
StatusStr=[];

%---Check both model and compensator are discrete/continuous
if ~isequal(TsModel,TsComp),
   try
      if ~TsModel, % Plant = Continuous, Comp = Discrete,
         StatusStr = [{'Warning: your discrete compensator was converted to continuous'};
            {'    to be consistent with the plant'}];
         Comp = d2c(Comp);
      elseif ~TsComp, % Plant = Discrete, Comp = Continuous,
         StatusStr = [{'Warning: your continuous compensator was discretized'};
            {'    to be consistent with the plant'}];
         Comp = c2d(Comp,TsModel);
      else, % Both are discrete with different sample times
         StatusStr = [{'Warning: your discrete compensator was resampled'};
            {'    to be consistent with the plant'}];
         Comp = d2d(Comp,TsModel);
      end, % if/else TsModel         
   catch
      StatusStr = [{'Your compensator could not be converted to match your system.'};
         {'All data in the GUI must have the same sample times.'}];
      ErrorFlag=1; % Trip the Error Flag!
      ErrStr = lasterr;
      errordlg(ErrStr,'Conversion Error')
   end % try/catch
end, % if ~isequal(TsModel...

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalComputeSystem %%% %---Return the desired open-closed or root locus system
%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys = LocalComputeSystem(udRL,type);

Plant = udRL.Model.Plant.Object;
Sensor = udRL.Model.Sensor.Object;
Filter = udRL.Model.Filter.Object;
Comp = udRL.Compensator.Object;
Gain = udRL.Compensator.Gain;
FdbkSign = udRL.Model.FeedbackSign;

%---Protect against improper state space conversions,
%-----If the compensator is improper and the plant
%-----is state space, convert the plant ss to a zpk. This traps errors
%-----resulting when attempting to conver improper systems to ss. 
if ~isproper(Comp),
   if  isa(Plant,'ss'), 
      Plant=zpk(Plant);
   end
   if isa(Sensor,'ss'),
      Sensor = zpk(Sensor);
   end	
   if isa(Filter,'ss'),
      Filter = zpk(Filter);
   end
end

switch type
case 'rlocus'
   sys = -1*FdbkSign*Plant*Sensor*Comp;
   
case 'openloop'
   sys = Gain*Comp*Plant*Sensor;
   
case 'closedloop';
   switch udRL.Model.Structure
   case 1,
      sys = Filter*feedback(Gain*Plant*Comp,Sensor,FdbkSign);
   case 2,
      sys = Filter*feedback(Plant,Gain*Comp*Sensor,FdbkSign);
   end   
   
case 'cl_locus';
   if Gain,
      switch udRL.Model.Structure
      case 1,
         sys = feedback(Gain*Plant*Comp,Sensor,FdbkSign);
      case 2,
         sys = feedback(Plant,Gain*Comp*Sensor,FdbkSign);
      end   
   else, % Return the Open Loop system
      sys = -1*FdbkSign*Plant*Sensor*Comp;
   end % if/else Gain
end % switch type

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalDiscretizeModel %%% %---Open the Discretize model window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalDiscretizeModel(Parent,udRL,DiscreteFlag,Ts);

%---DiscreteFlag indicates if d2c or c2d conversion
%---0 = c2d; 1  = d2c;

StdColor = get(0,'DefaultUIcontrolBackgroundColor');
StdUnit = 'point';
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
MenuStr = [{'Zero-order Hold'};{'First-order Hold'};
   {'Tustin'};{'Tustin w/Prewarping'};{'Matched pole-zero'}];
MenuUD = [{'zoh'};{'foh'};{'tustin'};{'prewarp'};{'matched'}];

if DiscreteFlag
   MenuStr = MenuStr([1,3:5]);
   MenuUD = MenuUD([1,3:5]);
end

a = figure('Color',[0.8 0.8 0.8], ...
   'IntegerHandle','off', ...
   'MenuBar','none', ...
   'Name','Convert Model/Compensator', ...
   'NumberTitle','off', ...
   'Position',[135 135 250 205], ...
   'Tag','DiscretizeFig', ...
   'WindowStyle','modal', ...
   'UserData',Parent);
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Position',PointsToPixels*[10 140 231 55], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 40 231 95], ...
   'Style','frame');
ContinuousButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'Callback','rlfcn(''discreteradiobutton'');', ...
   'Position',PointsToPixels*[22 170 211 20], ...
   'Horizontal','left', ...   
   'String','To continuous', ...
   'Enable','off', ...
   'Style','radiobutton', ...
   'Tag','ContinuousButton');
DiscreteButton = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'Horizontal','left', ...   
   'Callback','rlfcn(''discreteradiobutton'');', ...
   'Position',PointsToPixels*[22 146 211 20], ...
   'String','To discrete', ...
   'Style','radiobutton', ...
   'Tag','DiscreteButton', ...
   'Value',1);

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[23 104 54 20], ...
   'String','Method:', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'Position',PointsToPixels*[87 108 146 20], ...
   'String',MenuStr, ...
   'Style','popupmenu', ...
   'Tag','MethodMenu', ...
   'Callback','rlfcn(''changemethod'');', ...
   'UserData',MenuUD,...   
   'Value',1);
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[22 75 98 20], ...
   'String','Sample time (sec):', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[22 49 124 20], ...
   'String','Critical freq. (rad/sec):', ...
   'Style','text');
SampleTimeEdit = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[153 75 80 20], ...
   'Style','edit', ...
   'String','1', ...
   'UserData','1', ...
   'Tag','SampleTimeEdit');

set(DiscreteButton,'UserData',[ContinuousButton,SampleTimeEdit]);
set(ContinuousButton,'UserData',[DiscreteButton,SampleTimeEdit]);

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editedit'');',...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[153 49 80 20], ...
   'Enable','off',...
   'Style','edit', ...
   'Tag','CritFreqEdit');

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Callback','rlfcn(''discreteapply'');rlfcn(''childclose'',gcbf);', ...
   'Position',PointsToPixels*[10 6 50 25], ...
   'String','OK', ...
   'Tag','OKButton');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'UserData',Parent,...
   'Callback','rlfcn(''childclose'',gcbf);', ...
   'Position',PointsToPixels*[70 6 50 25], ...
   'String','Cancel', ...
   'Tag','CloseButton');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Callback','rlhelp(''discretize'');', ...
   'Position',PointsToPixels*[130 6 50 25], ...
   'String','Help', ...
   'Tag','HelpButton');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Callback','rlfcn(''discreteapply'');', ...
   'Position',PointsToPixels*[190 6 50 25], ...
   'String','Apply', ...
   'Tag','ApplyButton');

if DiscreteFlag,
   set(ContinuousButton,'Enable','on');
   set(DiscreteButton,'String','To discrete with new sample time');
end

%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalDrawDiagram %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function LocalDrawDiagram(udRL);

%---Open a New Simulink diagram
AllDiagrams=find_system('Type','block_diagram');
DiagramName = udRL.Model.Name;
if ~isempty(AllDiagrams)
   %---Look first for an exact match
   ExactMatch = strmatch(DiagramName,AllDiagrams,'exact');
   if ~isempty(ExactMatch)
      AllDiagrams(ExactMatch)=[];
      UsedInds = strmatch(DiagramName,AllDiagrams);
      if ~isempty(UsedInds)
         %---Look for minimum available number to use
         UsedNames = strvcat(AllDiagrams{UsedInds});
         %---Weed out names that don't end in scalar values.
         strVals = real(UsedNames(:,length(DiagramName)+1:end));
         strVals(find(strVals(:,1)<48 | strVals(:,1)>57),:)=[];
         RealVals = zeros(size(strVals,1),1);
         for ctR=1:size(strVals,1),
            RealVals(ctR,1) = str2double(char(strVals(ctR,:)));
         end
         if ~isnan(RealVals),
            NextInd = setdiff(1:max(RealVals)+1,RealVals);
            NextInd = NextInd(1);
         else
            NextInd=1;
         end
      else
         NextInd=1;
      end % if/else isempty(UsedInds)
      DiagramName = [DiagramName,num2str(NextInd)];
   end % if ~isempty(ExactMatch)
end, % if ~isempty(AllDiagrams)

NewDiagram = new_system;
set_param(NewDiagram,'Name',DiagramName);

assignin('base',udRL.Model.Plant.Name,udRL.Model.Plant.Object);
assignin('base',udRL.Model.Sensor.Name,udRL.Model.Sensor.Object);
assignin('base',udRL.Model.Filter.Name,udRL.Model.Filter.Object);
udRL.Compensator.Object.k = udRL.Compensator.Gain;
assignin('base',udRL.Compensator.Name,udRL.Compensator.Object);

%---Open CSTBLOCKS, if not already open
BlockOpenFlag = find_system('Name','cstblocks');
if isempty(BlockOpenFlag)
   load_system('cstblocks');
end

CompBlock = add_block('cstblocks/LTI System',[DiagramName,'/Compensator']);
set_param(CompBlock,'MaskValueString',[udRL.Compensator.Name,'|[]']);
InBlock = add_block('built-in/SignalGenerator',[DiagramName,'/Input']);
OutBlock = add_block('built-in/Scope',[DiagramName,'/Output']);
SumBlock = add_block('built-in/Sum',[DiagramName,'/Sum']);
PlantBlock = add_block('cstblocks/LTI System',[DiagramName,'/Plant']);
set_param(PlantBlock,'MaskValueString',[udRL.Model.Plant.Name,'|[]']);
SensorBlock = add_block('cstblocks/LTI System',[DiagramName,'/Sensor Dynamics']);
set_param(SensorBlock,'MaskValueString',[udRL.Model.Sensor.Name,'|[]']);
FilterBlock = add_block('cstblocks/LTI System',[DiagramName,'/Pre-filter']);
set_param(FilterBlock,'MaskValueString',[udRL.Model.Filter.Name,'|[]']);

%---Close CSTBLOCKS, if it wasn't open before
if isempty(BlockOpenFlag),
   close_system('cstblocks')
end

DiagramLocation = [70, 200, 549, 415];
OutPosition = [335, 41, 360, 70];
SumPosition = [75, 37, 105, 68];

if udRL.Model.FeedbackSign>0,
   SumStr='++';
else
   SumStr='+-';
end	

set_param(SumBlock,'Position',[165, 42, 195, 73],'Inputs',SumStr)
set_param(OutBlock,'Position',[440, 45, 465, 75])
set_param(InBlock,'Position',[15, 35, 45, 65])
set_param(NewDiagram,'Location',DiagramLocation)
set_param(FilterBlock,'Position',[65, 32, 130, 68])
set_param(SensorBlock,'Orientation','left');

open_system(NewDiagram)

switch udRL.Model.Structure
case 1 % Feedback
   PlantPos = [315, 42, 380, 78];
   SensorPos = [285, 112, 350, 148];
   CompPos = [220, 42, 285, 78];
   LinePos=[{[50 50; 60 50]};
      {[135 50; 160 50]};
      {[280 130; 150 130; 150 65; 160 65]};
      {[200 60;215 60]};
      {[290 60;310 60]};
      {[385 60;435 60]};
      {[400 60; 400 130;355 130]}];
   
case 2 % Forward
   PlantPos = [255, 42, 320, 78];
   SensorPos = [310, 112, 375, 148];
   CompPos = [200, 112, 265, 148];
   set_param(CompBlock,'Orientation','left')
   LinePos=[{[305 130;270 130]};
      {[200 60;250 60]};
      {[195 130;150 130;150 65;160 65]};
      {[50 50;60 50]};
      {[135 50;160 50;]};
      {[325 60; 435 60]};
      {[400 60; 400 130; 380 130]}];
end % switch udRL.Model.Structure

set_param(PlantBlock,'Position',PlantPos)
set_param(SensorBlock,'Position',SensorPos)
set_param(CompBlock,'Position',CompPos)

for ctLine = 1:length(LinePos)
   add_line(NewDiagram,LinePos{ctLine});
end

open_system(NewDiagram);

%%%%%%%%%%%%%%%%%%%%%
%%% LocalEditComp %%% %---Open the Edit Compensator window
%%%%%%%%%%%%%%%%%%%%%
function [a] = LocalEditComp(RLfig,udRL);

Comp = udRL.Compensator.Object;
[P,Z] = pzmap(Comp);
P=cplxpair(P); Z=cplxpair(Z);
complexPoles = find(imag(P)~=0);
complexPoles = complexPoles(2:2:end);
realPoles = find(imag(P)==0);
P=P([complexPoles;realPoles]);

complexZeros = find(imag(Z)~=0);
complexZeros = complexZeros(2:2:end);
realZeros = find(imag(Z)==0);
Z=Z([complexZeros ;realZeros]);

%---See if a previous Edit Compensator Window is open,
ChildFigs = udRL.Figure.Children;
GoodFigs = find(ishandle(ChildFigs));
ChildFigs = ChildFigs(GoodFigs);
if ~isempty(ChildFigs)
   Names = get(ChildFigs,{'Name'});
   indEdit = strmatch('Edit Compensator',Names);
   if ~isempty(indEdit)
      EditParent = get(ChildFigs(indEdit),'UserData');
      if isequal(EditParent,RLfig),
         %---If an old one is open, close it and open a new one
         %----This ensures the current number and location of compensator
         %----poles shown on the figure is correct
         delete(ChildFigs(indEdit));
      end
   end
end

StdUnit='points';
StdColor = get(0,'DefaultUicontrolBackgroundColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
FigHeight = (130+25*max([length(P),length(Z)]));
FrameHeight = (45 + 25*max([length(P),length(Z)]));

a = figure('Color',[0.8 0.8 0.8], ...
   'MenuBar','none', ...
   'Name','Edit Compensator', ...
   'Units',StdUnit, ...
   'Resize','off', ...
   'IntegerHandle','off', ...
   'HandleVisibility','callback',...
   'UserData',struct('Parent',RLfig,'Children',[]),...
   'CloseRequestFcn','rlfcn(''editcancel'',gcf);', ...
   'NumberTitle','off', ...
   'Position',PointsToPixels*[130 130 413 FigHeight], ...
   'Tag','EditCompensator', ...
   'WindowStyle','modal');

udRL.Figure.Children=[udRL.Figure.Children;a];
set(RLfig,'UserData',udRL)

%---Name controls
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[3 FigHeight-40 406 35], ...
   'Tag','NameFrame', ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[10 FigHeight-35 50 20], ...
   'String','Name:', ...
   'Horiz','left', ...
   'FontWeight','Bold', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Callback','rlfcn(''editcompname'');', ...
   'Position',PointsToPixels*[64 FigHeight-35 150 25], ...
   'String',udRL.Compensator.Name, ...
   'Horiz','left', ...
   'BackgroundColor',[1 1 1],...
   'Tag','NameEdit', ...
   'UserData',udRL.Compensator.Name, ...
   'Style','Edit');

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[208 41 200 FrameHeight], ...
   'Tag','ResizeFrame', ...
   'enable','inactive',...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'enable','inactive',...
   'Tag','ResizeFrame', ...
   'Position',PointsToPixels*[3 41 200 FrameHeight], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[254 23+FrameHeight 100 15], ...
   'String','Poles', ...
   'FontWeight','Bold', ...
   'Enable','inactive',...
   'ButtonDownFcn','rlfcn(''comptext'');', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[54 23+FrameHeight 100 15], ...
   'String','Zeros', ...
   'Enable','inactive',...
   'FontWeight','bold', ...
   'ButtonDownFcn','rlfcn(''comptext'');', ...
   'Style','text');

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[10 2+FrameHeight 52 19], ...
   'Horizontal','left',...
   'String','Delete', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[211 2+FrameHeight 52 19], ...
   'String','Delete', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[53 2+FrameHeight 54 19], ...
   'String','Real', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[255 2+FrameHeight 54 19], ...
   'String','Real', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[127 2+FrameHeight 60 19], ...
   'String','Imaginary',...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[330 2+FrameHeight 60 19], ...
   'String','Imaginary', ...
   'Style','text');

for ctP=1:length(P)
   realb(ctP) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'HorizontalAlignment','left', ...
      'String',num2str(real(P(ctP))), ...
      'Position',PointsToPixels*[253 FrameHeight-(ctP*25) 60 20], ...
      'UserData',num2str(real(P(ctP))), ...
      'Style','edit');
   
   b = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[314 FrameHeight-(ctP*25) 15 20], ...
      'String',char(177), ...
      'Style','text');
   
   imagb(ctP) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'HorizontalAlignment','left', ...
      'Position',PointsToPixels*[330 FrameHeight-(ctP*25) 60 20], ...
      'String',num2str(imag(P(ctP))), ...
      'Tag','Imag', ...
      'UserData',num2str(imag(P(ctP))), ...
      'Style','edit');
   
   b = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[390 -2+FrameHeight-(ctP*25) 15 20], ...
      'String','i', ...
      'Style','text');
   
   checkP(ctP) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[225 FrameHeight-(ctP*25) 20 20], ...
      'UserData',[realb(ctP),imagb(ctP)], ...
      'Tag','PoleCheck', ...
      'Style','checkbox');
end

for ctZ = 1:length(Z);
   realb(ctZ) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'HorizontalAlignment','left', ...
      'Position',PointsToPixels*[50 FrameHeight-(ctZ*25) 60 20], ...
      'String',num2str(real(Z(ctZ))), ...
      'UserData',num2str(real(Z(ctZ))), ...
      'Style','edit');
   
   b = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[110 FrameHeight-(ctZ*25) 15 20], ...
      'String',char(177), ...
      'Style','text');
   
   imagb(ctZ) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'HorizontalAlignment','left', ...
      'BackgroundColor',[1 1 1], ...
      'CallBack','rlfcn(''editedit'');', ...
      'Position',PointsToPixels*[125 FrameHeight-(ctZ*25) 60 20], ...
      'String',num2str(imag(Z(ctZ))), ...
      'Tag','Imag', ...
      'UserData',num2str(imag(Z(ctZ))), ...
      'Style','edit');
   
   b = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[185 -2+FrameHeight-(ctZ*25) 15 20], ...
      'String','i', ...
      'Style','text');
   
   checkZ(ctZ) = uicontrol('Parent',a, ...
      'Units',StdUnit, ...
      'Position',PointsToPixels*[21 FrameHeight-(ctZ*25) 20 20], ...
      'UserData',[realb(ctZ),imagb(ctZ)], ...
      'Tag','ZeroCheck', ...
      'Style','checkbox');
end

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[3 3 406 33], ...
   'Tag','MoveFrame', ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[8 7 67 25], ...
   'Callback','rlfcn(''editaddzero'');', ...
   'String','Add Zero');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Callback','rlfcn(''editaddpole'');', ...
   'Position',PointsToPixels*[79 7 67 25], ...
   'String','Add Pole');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[151 7 60 25], ...
   'Callback','rlfcn(''editapply'');rlfcn(''editcancel'',gcbf);', ...
   'String','OK');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'UserData',RLfig,...
   'Position',PointsToPixels*[216 7 60 25], ...
   'Callback','rlfcn(''editcancel'',gcbf);', ...
   'String','Cancel');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[280 7 60 25], ...
   'Callback','rlhelp(''editcomp'');', ...
   'String','Help');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[345 7 60 25], ...
   'Callback','rlfcn(''editapply'');', ...
   'String','Apply');

%%%%%%%%%%%%%%%%%%%%%
%%% LocalEditGrid %%% %---Open the Grid/Constraints window
%%%%%%%%%%%%%%%%%%%%%
function LocalEditGrid(Parent,udAx);

StdColor = get(0,'defaultuicontrolbackgroundcolor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');
StdUnit = 'point';

a = figure('Units',StdUnit, ...
   'Color',[0.8 0.8 0.8], ...
   'MenuBar','none', ...
   'unit','pixel', ...
   'Name','Grid and Constraint Options', ...
   'IntegerHandle','off', ...
   'NumberTitle','off', ...
   'Resize','off',...
   'Position',[187 188 270 252], ...
   'UserData',Parent, ...
   'WindowStyle','modal', ...
   'Tag','GridFig');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[5 36 260 107], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[5 151 260 92], ...
   'Style','frame');
%---Grid
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[15 217 230 20], ...
   'String','Plot grid using constant:', ...
   'Style','text');
radioB(1) = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 200 250 20], ...
   'String','Damping Ratio and Natural Frequency', ...
   'Style','radiobutton', ...
   'Horizontal','left', ...
   'Callback','rlfcn(''radiocallback'');', ...
   'Tag','SgridButton');
radioB(2) = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 179 250 20], ...
   'String','Peak Overshoot (PO)', ...
   'Horizontal','left', ...
   'Callback','rlfcn(''radiocallback'');', ...
   'Style','radiobutton', ...
   'Tag','POButton');

set(radioB(udAx.Grid.Value),'Value',1);
set(radioB(1),'UserData',[radioB(2)]);
set(radioB(2),'UserData',[radioB(1)]);

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 155 75 20], ...
   'String','Grid on?', ...
   'Horizontal','left', ...
   'Style','checkbox', ...
   'Value',udAx.Grid.State, ...
   'Tag','GridBox');
%----Constraints
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[45 114 168 20], ...
   'String','Add constraints for:', ...
   'Style','text');
ZetaButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 71 150 20], ...
   'Horizontal','left', ...
   'String','Damping Ratio =', ...
   'Style','checkbox', ...
   'Value',udAx.Constraints.Damping.State, ...
   'Tag','ZetaButton');
TsButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 94 150 20], ...
   'Horizontal','left', ...
   'String','Settling Time =', ...
   'Style','checkbox', ...
   'Tag','TsButton', ...
   'Value',udAx.Constraints.SettlingTime.State);
WnButton = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[10 47 150 20], ...
   'Horizontal','left', ...
   'String','Natural Frequency =', ...
   'Style','checkbox', ...
   'Value',udAx.Constraints.NaturalFrequency.State, ...
   'Tag','WnButton');
TsEdit = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''constraintbox'');', ...
   'HorizontalAlign','left', ...
   'Position',PointsToPixels*[164 94 90 20], ...
   'Style','edit', ...
   'String',num2str(udAx.Constraints.SettlingTime.Value), ...
   'UserData',struct('Button',TsButton,'Revert',udAx.Constraints.SettlingTime.Value), ...
   'Tag','TsEdit');
ZetaEdit = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''constraintbox'');', ...
   'HorizontalAlign','left', ...
   'Position',PointsToPixels*[164 69 90 20], ...
   'String',num2str(udAx.Constraints.Damping.Value), ...
   'Style','edit', ...
   'UserData',struct('Button',ZetaButton,'Revert',udAx.Constraints.Damping.Value), ...
   'Tag','ZetaEdit');
WnEdit = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''constraintbox'');', ...
   'HorizontalAlign','left', ...
   'Position',PointsToPixels*[164 47 90 20], ...
   'Style','edit', ...
   'String',num2str(udAx.Constraints.NaturalFrequency.Value), ...
   'UserData',struct('Button',WnButton,'Revert',udAx.Constraints.NaturalFrequency.Value), ...
   'Tag','WnEdit');

b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[5 5 50 25], ...
   'String','OK', ...
   'Callback','rlfcn(''applygrid'');rlfcn(''childclose'',gcbf);', ...
   'Tag','OKButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'UserData',Parent,...
   'Position',PointsToPixels*[76 5 50 25], ...
   'String','Cancel', ...
   'Callback','rlfcn(''childclose'',gcbf);', ...
   'Tag','CloseButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[146 5 50 25], ...
   'String','Help', ...
   'Callback','rlhelp(''grid'');', ...
   'Tag','HelpButton');
b = uicontrol('Parent',a, ...
   'Units',StdUnit, ...
   'Position',PointsToPixels*[215 5 50 25], ...
   'String','Apply', ...
   'Callback','rlfcn(''applygrid'');', ...
   'Tag','ApplyButton');

%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotGrid %%% %---Add the desired grid and constraints
%%%%%%%%%%%%%%%%%%%%%
function LocalPlotGrid(RLfig,ax,udAx),

WS = warning;
warning off;
figure(RLfig)
set(RLfig,'CurrentAxes',ax);
udRL = get(RLfig,'UserData');
Ts = udRL.Model.Plant.Object.Ts; % Model Sampling time

set(ax,'XlimMode','manual','YlimMode','manual');
Xlim = get(ax,'Xlim');
Ylim = get(ax,'Ylim');
kids = get(ax,'Children');
ZetaLines = findobj(kids,'Tag','ZetaConstraints');
WnLines = findobj(kids,'Tag','WnConstraints');
TsLines = findobj(kids,'Tag','TsConstraints');
TextKids = findobj(kids,'Tag','ConstPOlabels');
deletekids = findobj(kids,'Tag','RLgridLines');
delete([deletekids;ZetaLines;WnLines;TsLines;TextKids]);

NanMat = NaN;

%---Plot Grid
if udAx.Grid.State,
   switch udAx.Grid.Value, % Look for selected grid type
   case 1, % Normal S/Zgrid
      if isct(udRL.Model.Plant.Object), % Sgrid
         gridlines = sgrid;
      else, % Zgrid
         gridlines = zgrid;
      end
      set(gridlines,'tag','RLgridLines');
   case 2, % Peak Overshoot
      wn = 0:1:10;
      zeta = [ 0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];
      ConstPO = 100*exp((-1*pi*zeta)./sqrt(1-zeta.^2));   
      limits = [Xlim Ylim];
      [w,z] = meshgrid([0;wn(:);2*max(limits(:))]',zeta);
      w = w';
      z = z';
      [mcols, nrows] = size(z);
      NanRow = NanMat(ones(1,nrows));
      re = [-w.*z; NanRow];
      re = re(:);
      im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
      im = im(:);
      line([re; re],[im; -im],'LineStyle',':','Color',[.7 .7 .7],'Parent',ax);
      n = mcols+1;
      for i = 1:nrows,
         text(re(n*(i-1)+nrows),im(n*(i-1)+nrows),sprintf('%.3g',ConstPO(nrows-i+1)), ...
            'Color',[.7 .7 .7],'Parent',ax,'Tag','ConstPOlabels')
      end
      
   end % switch Grid.Value
end, % if Grid.State

%---Plot Constraints
if udAx.Constraints.Damping.State
   if ~isempty(udAx.Constraints.Damping.Value),
      % Plot continuous damping line
      if ~Ts
         limits = [Xlim Ylim];
         wn = 0:1:10;
         [w,z] = meshgrid([0;wn(:);2*max(limits(:))]',udAx.Constraints.Damping.Value);
         w = w';
         z = z';
         [mcols, nrows] = size(z);
         NanRow = NanMat(ones(1,nrows));
         re = [-w.*z; NanRow];
         re = re(:);
         im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
         im = im(:);
         l=line([re; re],[im; -im],'LineStyle','-', ...
            'Color',[0.5 .5 .5],'Parent',ax,'Tag','ZetaConstraints');
         
      else
         % Plot discrete damping line
         I = sqrt(-1);
         m = tan(asin(udAx.Constraints.Damping.Value)) +sqrt(-1);
         Ones = ones(1,length(m));
         zz = [exp((0:pi/20:pi)'*(-m)); NanMat(Ones)];
         zz = zz(:);
         rzz = real(zz);
         izz = imag(zz);
         l=line([rzz; rzz],[izz; -izz],'LineStyle','-','Color',[.5 .5 .5], ...
            'Parent',ax,'Tag','ZetaConstraints');
      end % if/else ~Ts
      
   end, % if ~isempty(Damping.Value)
end % if Damping State

if udAx.Constraints.NaturalFrequency.State
   if ~isempty(udAx.Constraints.NaturalFrequency.Value),
      if ~Ts,
         %---Plot continuous natural frequency lines
         zx = 0:.01:1;
         [w,z] = meshgrid(udAx.Constraints.NaturalFrequency.Value,zx);
         [mcols, nrows] = size(z);
         NanRow = NanMat(ones(1,nrows));
         re = [-w.*z; NanRow];
         re = re(:);
         im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
         im = im(:);
         l=line([re; re],[im; -im],'LineStyle','-', ...
            'Color',[.5 .5 .5],'Parent',ax,'Tag','WnConstraints');
         
      else
         %---Plot discrete natural frequency lines
         e_itheta = exp(sqrt(-1)*(pi/2:pi/20:pi)');
         e_r = exp(udAx.Constraints.NaturalFrequency.Value);
         Ones = ones(1,length(e_r));        
         zz = [(ones(length(e_itheta),1)*e_r).^(e_itheta*Ones); NanMat(Ones)];
         zz = zz(:);
         rzz = real(zz);
         izz = imag(zz);
         line([rzz; rzz],[izz; -izz],'LineStyle','-','Color',[.5 .5 .5], ...
            'Parent',ax,'Tag','WnConstraints');
      end % if/else ~Ts
      
   end, % if ~isempty(NaturalFrequency.Value)
end % if NaturalFrequency State

if udAx.Constraints.SettlingTime.State
   %---Assume a 2% setting time, (for 5%, change coefficient to 3)
   TimeConstant = -4./udAx.Constraints.SettlingTime.Value;
   if ~Ts,
      %---Plot continuous Settling time lines
      for ctTs=1:length(TimeConstant),
         line(ones(1,2)*TimeConstant(ctTs),Ylim,'Color',[.5 .5 .5], ...
            'LineStyle','-','Parent',ax,'Tag','TsConstraints');
      end, % for ctTs
   else
      %---Plot discrete Settling time lines
      if isequal(Ts,-1), % Must have a specified sampling time
         warndlg(['The settling time constraints cannot be shown when ', ...
               'the sampling time is unspecified'],'Constraint Warning');
      else
         radius = Ts./TimeConstant;
         theta = 0:pi/20:2*pi;
         for ctTs=1:length(TimeConstant),
            X = radius(ctTs)*cos(theta);
            Y = radius(ctTs)*sin(theta);
            line(X,Y,'Color',[.5 .5 .5], ...
               'LineStyle','-','Parent',ax,'Tag','TsConstraints');
         end, % for ctTs
      end % if/else isequal(Ts,-1)
   end
end % if SettlingTimeState

%---Reorder the children so the grid/constraint lines are on the bottom
kids = get(ax,'Children');
locus = findobj(kids,'Tag','LocusLines');
Comp = [findobj(kids,'Tag','CompPoles');findobj(kids,'Tag','CompZeros')];
Clpoles = findobj(kids,'Tag','CurrentClosedPoles');
Model = [findobj(kids,'Tag','ModelPoles');findobj(kids,'Tag','ModelZeros')];
AxesLines = [findobj(kids,'Tag','XaxisLine');findobj(kids,'Tag','YaxisLine');
   findobj(kids,'Tag','ZetaConstraints');findobj(kids,'Tag','WnConstraints');
   findobj(kids,'Tag','TsConstraints')];
Otherkids = setdiff(kids,[Comp;Model;Clpoles;locus;AxesLines]);
set(ax,'Children',[Comp;Model;Clpoles;locus;AxesLines;Otherkids])

feval('warning',WS);

%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPlotRlocus %%% %---Draws the root locus diagram
%%%%%%%%%%%%%%%%%%%%%%%
function [udRL,StatusStr] = LocalPlotRlocus(varargin);

ni=nargin;
ax = varargin{1};
udRL = varargin{2};
watchfig=watchon;

StatusStr=[];

%---Read the necessary data from the RLfig UserData
udAx = get(ax,'UserData');

%---Compute and store the new Closed-loop system
CheckSys = LocalComputeSystem(udRL,'closedloop');
if isempty(CheckSys)
   return
end

udRL.ClosedLoopModel.Object=CheckSys;

%---Update the LTI Viewer
StatusStr = LocalUpdateViewer(get(ax,'Parent'),udRL);

%---Turn the Clear Compensator menu on if a Compensator is available
if isstatic(udRL.Compensator.Object)
   set(udRL.Handles.Menus.Options.ClearComp,'Enable','off');
else
   set(udRL.Handles.Menus.Options.ClearComp,'Enable','on');
   set(udRL.Handles.Menus.Options.Convert,'Enable','on');
end

%---Compute the appropriate characteristic equation
sys = LocalComputeSystem(udRL,'rlocus');

%---Delete the old locus
kids=get(ax,'Children');
deletekids = [findobj(kids,'Tag','LocusLines');
   findobj(kids,'Tag','CurrentClosedPoles')];
delete(deletekids);

udAx.ClosedLoopPoles=[];
udAx.Locus=[];

%---Check if no model or compensator is in the GUI
[z,p,k]=zpkdata(sys);
if isempty(sys) | isstatic(sys),
   StatusStr = [{'No root locus can be drawn for the current system set-up'}];
   udAx.Locus = [];
   udAx.ClosedLoopPoles=[];
   set(ax,'UserData',udAx)
   udRL = LocalAxisLines(udRL); % Resize the Axes lines
   watchoff(watchfig)
   return
end

%---Compute the new locus
[locus,gains]=rlocus(sys);
locus=locus';

%---Save the gains in the axis MoveData
udAx.MoveData.GainVector = gains;

%---plot the original Root Locus
linekids=line(real(locus),imag(locus),'Tag','LocusLines','Parent',ax, ...
   'EraseMode','xor','Color',udAx.Preferences.Model,'ButtonDownFcn',...
   'rlfcn(''selectgain'');'); 

%---Get closed-loop poles for Root locus only (excludes filter poles)
clsys = LocalComputeSystem(udRL,'cl_locus'); % Get closed-loop system without filter

[Wn,Zeta,r]=damp(clsys);

for ct=1:length(r),
   NewCLpole(ct) = line(real(r(ct)),imag(r(ct)),'Parent',ax, ...
      'LineStyle','none','Marker',udAx.Preferences.ClosedLoop(2),'MarkerSize',5,'MarkerFaceColor','r', ...
      'Tag','CurrentClosedPoles','MarkerEdgeColor',udAx.Preferences.ClosedLoop(1),...
      'MarkerFaceColor',udAx.Preferences.ClosedLoop(1),...
      'ButtonDownFcn','rlfcn(''pzbuttondown'');', ...
      'UserData',struct('Damping',Zeta(ct),'NaturalFrequency',Wn(ct)));
end

%---Rescale the AxisLines
udRL = LocalAxisLines(udRL);

%---Reset the axis userdata
udAx.Locus=linekids;
udAx.ClosedLoopPoles = NewCLpole;
set(ax,'UserData',udAx)

%---Reset any axis buttondown functions
watchoff(watchfig)
states=[get(udRL.Handles.AddPoleButton,'Value'),...
      get(udRL.Handles.AddZeroButton,'Value'),...
      get(udRL.Handles.EraseButton,'Value')];
LocalSetButtonState(states,ax,1,udRL);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalPointerData %%% %---Change the pointer to reflect the current RL mode
%%%%%%%%%%%%%%%%%%%%%%%%
function LocalPointerData(RLfig,indOn),

PointerShapeHotSpot = [1 1];

if indOn,
   
   switch indOn,
   case 1, % arrow with an x
      
      P=[1 NaN NaN NaN 1 NaN NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
         NaN 1 NaN NaN 1 NaN NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
         NaN 2 1 2 NaN NaN 1 NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
         NaN 1 2 1 NaN NaN 1 1 NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
         1 NaN NaN NaN 1 NaN 1 2 1 NaN  NaN  NaN  NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 1 NaN  NaN  NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 2 1 NaN  NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 2 2 1 NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 2 2 2 1 NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 2 2 2 2 1 NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 2 2 2 1 1 1 NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 2 1 2 2 1 NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 1 NaN  1 2 1 NaN  NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN 1 NaN  NaN  NaN  1 2 1 NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN NaN NaN  NaN  NaN  1 2 1 NaN  NaN  NaN  
         NaN NaN NaN NaN NaN NaN NaN NaN  NaN  NaN  NaN  1 1 1 NaN  NaN ];      
         
   case 2, % Arrow with a zero
         P=[NaN 1 1 1 NaN NaN NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
            1 1 2 1 1 NaN NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
            1 2 2 2 1 NaN 1 NaN NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
            1 2 2 2 1 NaN 1 1 NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  
            NaN 1 1 1 NaN NaN 1 2 1 NaN  NaN  NaN  NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 1 NaN  NaN  NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 2 1 NaN  NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 2 2 1 NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 2 2 2 1 NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 2 2 2 2 1 NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 2 2 2 1 1 1 NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 2 1 2 2 1 NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 1 NaN  1 2 1 NaN  NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN 1 NaN  NaN  NaN  1 2 1 NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN NaN NaN  NaN  NaN  1 2 1 NaN  NaN  NaN  
            NaN NaN NaN NaN NaN NaN NaN NaN  NaN  NaN  NaN  1 1 1 NaN  NaN ];      
            
   case 3, % eraser
            P = [1 1 1 1 1 1 1 NaN NaN NaN NaN NaN NaN NaN NaN NaN;
               1 1 1 NaN  NaN  NaN  NaN  1 NaN NaN NaN NaN NaN NaN NaN NaN;      
               1 1 NaN NaN NaN  NaN NaN NaN 1 NaN NaN NaN NaN NaN NaN NaN;
               1 NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN NaN NaN NaN NaN NaN;      
               1 NaN NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN NaN NaN NaN NaN;
               NaN 1 NaN NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN NaN NaN NaN;
               NaN NaN 1 NaN NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN NaN NaN;
               NaN NaN NaN 1 NaN NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN NaN;
               NaN NaN NaN NaN 1 NaN NaN 1 NaN NaN NaN NaN NaN NaN 1 NaN;
               NaN NaN NaN NaN NaN 1 NaN NaN 1 1 1 1 1 1 1 1;
               NaN NaN NaN NaN NaN NaN 1 NaN 1 NaN NaN NaN NaN NaN NaN 1;
               NaN NaN NaN NaN NaN NaN NaN 1 1 1 1 1 1 1 1 1;
               NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ;
               NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ;
               NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ;
               NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
               
            end % switch indOn
            
            set(RLfig,'PointerShapeCdata',P, ...
               'PointerShapeHotSpot',PointerShapeHotSpot);
            
else
	set(RLfig,'Pointer','arrow');
            
end % if/else

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalRemoveResponse %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalRemoveResponse(ViewFig,RB,PlotType,udRL);

ViewerObj = get(ViewFig,'UserData');
AllProps = get(ViewerObj);

if isequal(AllProps.Configuration,1);
   if ishandle(ViewFig),
      close(ViewFig);
      set(RB,'UserData',[]);
   end % if ishandle(ViewFig)
   
else
   [garb,indresp]=setdiff(AllProps.PlotTypeOrder,PlotType);
   NewOrder = [AllProps.PlotTypeOrder(sort(indresp));cellstr(PlotType)];
   set(ViewerObj,'PlotTypeOrder',NewOrder,...
      'Configuration',AllProps.Configuration-1);
end % if/else isequal(Configuration,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalResizeFunction %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StatusStr = LocalResizeFunction(RLfig);
%---Resize function for the Root Locus Design GUI
udRL = get(RLfig,'UserData');
udRL.Handles.Menus=[];

StatusStr = 'Ready';

LTIdisplayAxes = findobj(RLfig,'Tag','LTIdisplayAxes');
PointsToPixel = 72/get(0,'ScreenPixelsPerInch');

%---Get the new figure position
FigUnit = get(RLfig,'Unit');
set(RLfig,'Unit','pixel');
FigPos = get(RLfig,'Position');

%---Set the minimum figure width and height
MinFigHeight = 200;
MinFigWidth = 350; 
ResizeFlag = 0;

if (FigPos(3) < MinFigWidth) 
   FigPos(3)=MinFigWidth;
   ResizeFlag=1;
end
if (FigPos(4) < MinFigHeight),
   FigPos(4)=MinFigHeight;
   ResizeFlag=1;
end
if ResizeFlag
   set(RLfig,'Position',FigPos)
end

%---Set the LTIdisplayAxes size
AxisHeight = FigPos(4)-180;
AxisWidth = FigPos(3)-40;
posAx = get(udRL.Handles.LTIdisplayAxes,'Position');
set(udRL.Handles.LTIdisplayAxes,'Position',...
   [posAx(1:2),PointsToPixel*(AxisWidth),PointsToPixel*(AxisHeight)])

%---Scale the width of the UIcontrols
StatusPos = get(udRL.Handles.StatusFrame,'Position');
set(udRL.Handles.StatusFrame,'Position', ...
   [StatusPos(1:2),PointsToPixel*(FigPos(3)-27),StatusPos(4)]);
StatusPos = get(udRL.Handles.StatusText,'Position');
set(udRL.Handles.StatusText,'Position',...
   [StatusPos(1:2),PointsToPixel*(FigPos(3)-37),StatusPos(4)]);

%---Response Preferences
ResponsePos = get(udRL.Handles.ResponseFrame,'Position');
set(udRL.Handles.ResponseFrame,'Position',...
   [ResponsePos(1:2),PointsToPixel*(FigPos(3)-27),ResponsePos(4)]);
ButtonOffset = (FigPos(3)-27)/5;
set(udRL.Handles.StepButton,'Position',PointsToPixel*[18 37 56 19]);

ResponsePos = get([udRL.Handles.ImpulseButton,...
      udRL.Handles.BodeButton,...
      udRL.Handles.NyquistButton,...
      udRL.Handles.NicholsButton],'Position');
ResponsePos=cat(1,ResponsePos{:});
NewPos=PointsToPixel*(13+([1;2;3;4]*ButtonOffset));
ResponsePos(:,1)=NewPos;
ResponsePos=num2cell(ResponsePos,2);
set([udRL.Handles.ImpulseButton,...
      udRL.Handles.BodeButton,...
      udRL.Handles.NyquistButton,...
      udRL.Handles.NicholsButton],{'Position'},ResponsePos);

%---Zoom Controls
ZoomControls=[udRL.Handles.ZoomAxes;
   udRL.Handles.ZoomText;
   udRL.Handles.XYzoomButton;
   udRL.Handles.XzoomButton;
   udRL.Handles.YzoomButton;
   udRL.Handles.FullViewButton];
ZoomPos = get(ZoomControls,'Position');
ZoomPos=cat(1,ZoomPos{:});
NewPos=PointsToPixel*[FigPos(3)-155;
   FigPos(3)-144;
   FigPos(3)-118.6+(21*[1;2;3;4])];   
ZoomPos(:,1)=NewPos;
ZoomPos =num2cell(ZoomPos,2);

set(ZoomControls,{'Position'},ZoomPos);

%---Root Locus Controls
RLControls=[udRL.Handles.PZAxes;
   udRL.Handles.DefaultLocusFcn;
   udRL.Handles.AddPoleButton;
   udRL.Handles.AddZeroButton;
   udRL.Handles.EraseButton];
PZAxesPos = get(RLControls,'Position');
PZAxesPos =cat(1,PZAxesPos{:});
NewPos=PointsToPixel*[(96+AxisHeight+7.35);
   [1;1;1;1]*(96+AxisHeight+8.72)];
PZAxesPos(:,2)=NewPos;
PZAxesPos=num2cell(PZAxesPos,2);
set(RLControls,{'Position'},PZAxesPos);

GridPos = get(udRL.Handles.GridFrame,'Position');
set(udRL.Handles.GridFrame,'Position',...
   [PointsToPixel*(FigPos(3)-77),PointsToPixel*(98+AxisHeight+6.52),GridPos(3:4)]);
GridPos = get(udRL.Handles.GridBox,'Position');
set(udRL.Handles.GridBox,'Position',...
   [PointsToPixel*(FigPos(3)-75),PointsToPixel*(98+AxisHeight+9.79),GridPos(3:4)]);
GainPos = get(udRL.Handles.GainText,'Position');
set(udRL.Handles.GainText,'Position',...
   [GainPos(1),PointsToPixel*(98+AxisHeight+7.19),GainPos(3:4)]);
GainPos = get(udRL.Handles.GainEdit,'Position');
set(udRL.Handles.GainEdit,'Position',...
   [GainPos(1),PointsToPixel*(98+AxisHeight+7.19),GainPos(3:4)]);
GainPos = get(udRL.Handles.GainFrame,'Position');
set(udRL.Handles.GainFrame,'Position',...
   [GainPos(1),PointsToPixel*(98+AxisHeight+6.52),GainPos(3:4)]);

%---Compensator/Configuration

CompFramePos = get(udRL.Handles.CompensatorFrame,'Position');
set(udRL.Handles.CompensatorFrame,'Position',...
   [CompFramePos(1),PointsToPixel*(99+AxisHeight+31.31),PointsToPixel*(FigPos(3)-169.07),CompFramePos(4)]);
CompTextPos = get(udRL.Handles.CompensatorText,'Position');
set(udRL.Handles.CompensatorText,'Position',...
   [CompTextPos(1),PointsToPixel*(99+AxisHeight+64.32),PointsToPixel*(FigPos(3)-172.5),CompTextPos(4)]);
GcTextPos = get(udRL.Handles.GcText,'Position');
set(udRL.Handles.GcText,'Position',...
   [GcTextPos(1),PointsToPixel*(99+AxisHeight+40.39),GcTextPos(3:4)]);
DenTextPos = get(udRL.Handles.DenText,'Position');
set(udRL.Handles.DenText,'Position',...
   [DenTextPos(1),PointsToPixel*(99+AxisHeight+34.59),PointsToPixel*(FigPos(3)-199.2),DenTextPos(4)]);
NumTextPos = get(udRL.Handles.NumText,'Position');
set(udRL.Handles.NumText,'Position',...
   [NumTextPos(1),PointsToPixel*(99+AxisHeight+50.85),PointsToPixel*(FigPos(3)-199.2),NumTextPos(4)]);
FracTextPos = get(udRL.Handles.FractionText,'Position');
set(udRL.Handles.FractionText,'Position',...
   [FracTextPos(1),PointsToPixel*(99+AxisHeight+45.52),PointsToPixel*(FigPos(3)-199.2),FracTextPos(4)]);

ConfigPos = get(udRL.Handles.ConfigurationAxes,'Position');
set(udRL.Handles.ConfigurationAxes,'Position',...
   [PointsToPixel*(FigPos(3)-140),PointsToPixel*(99+AxisHeight+31.3),ConfigPos(3:4)]);
if isfield(udRL.Handles,'ChangeConfig'), % Only if allowing structure toggling
   ChangePos = get(udRL.Handles.ChangeConfig,'Position');
   set(udRL.Handles.ChangeConfig,'Position',...
      [PointsToPixel*(FigPos(3)-36),PointsToPixel*(99+AxisHeight+31.3),ChangePos(3:4)]);
end
SignPos = get(udRL.Handles.ChangeSign,'Position');
set(udRL.Handles.ChangeSign,'Position',...
   [PointsToPixel*(FigPos(3)-139.9),PointsToPixel*(99+AxisHeight+31.3),SignPos(3:4)]);

%---Reset the original figure units
set(RLfig,'Unit',FigUnit);
[z,p,k] = zpkdata(udRL.Compensator.Object,'v');
LocalUpdateText('den',p,udRL.Handles.DenText,udRL);
LocalUpdateText('num',z,udRL.Handles.NumText,udRL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalSetButtonState %%% %---Sets ButtonDownFcns based on the current RL mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StatusStr = LocalSetButtonState(states,ax,defaultflag,UdRL);

ni=nargin;

StatusStr=[];
udAx = get(ax,'UserData');
kids = get(ax,'Children');
linekids = findobj(kids,'Type','line');
set([ax;linekids],'ButtonDownFcn','');         

%---Sort out the axis children
locus = findobj(kids,'Tag','LocusLines');
Comp = [findobj(kids,'Tag','CompPoles');findobj(kids,'Tag','CompZeros')];
FilterPoles = findobj(kids,'Tag','FilterPoles');
Clpoles = findobj(kids,'Tag','CurrentClosedPoles');
Model = [udAx.Model.Poles;udAx.Model.Zeros];
AxesLines = [UdRL.Handles.XaxisLine;UdRL.Handles.YaxisLine;
   findobj(kids,'Tag','ZetaConstraints');findobj(kids,'Tag','WnConstraints');
   findobj(kids,'Tag','TsConstraints')];
Otherkids = setdiff(kids,[Comp;Model;Clpoles;FilterPoles;locus;AxesLines]);
set(ax,'Children',[Comp;FilterPoles;Model;Clpoles;locus;AxesLines;Otherkids])

indOn = find(states);
if isempty(indOn),
   indOn=0;
end

switch indOn,
   
case 0, % Restore all defaults
   if ~isempty(udAx.ClosedLoopPoles),
      set(udAx.ClosedLoopPoles,'ButtondownFcn','rlfcn(''pzbuttondown'');');
   end
   if ~isempty(locus),
      set(locus,'ButtondownFcn','rlfcn(''selectgain'');');
   end
   if ~isempty(Comp),
      set(Comp,'ButtonDownFcn','rlfcn(''compbuttondown'');');
   end
   if ~isempty(FilterPoles),
      set(FilterPoles,'ButtonDownFcn','rlfcn(''filterpole'');');
   end
   if ~isempty(Model)
      set(Model,'ButtonDownFcn','rlfcn(''showplant'',gcbf);');
   end
   if ~isempty([AxesLines;Otherkids])
      set([AxesLines;Otherkids],'ButtonDownFcn','');
   end
   
   StatusStr = {'Default axis mode restored.'};
   
case 1, % Adding Pole
   set([ax;linekids],'ButtonDownFcn','rlfcn(''plotpole'');');
   StatusStr = {'Select the desired location for a compensator pole.'};
   
case 2, % Adding Zero
   set([ax;linekids],'ButtonDownFcn','rlfcn(''plotzero'');');
   StatusStr = {'Select the desired location for a compensator zero.'};
   
case 3, % Erasing
   set([udAx.Compensator.Poles;udAx.Compensator.Zeros],'ButtonDownFcn',...
      'rlfcn(''erasecomp'');');
   StatusStr = [{'Select the compensator pole or zero to remove.'};
      {'Plant poles and zeros cannot be erased.'}];
end % switch indOn

if ~defaultflag, % Turn off default buttondownfcns
   set([udAx.ClosedLoopPoles';locus;Comp],'buttondownfcn','');
end % if ~defaultflag

LocalPointerData(get(ax,'Parent'),indOn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalShowClosedLoop %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalShowClosedLoop(RLfig,udRL);

Plant = udRL.ClosedLoopModel.Object;
if isempty(Plant),
   P=[];
   Z=[];
else
   [P,Z]=pzmap(Plant);
end

StdColor = get(0,'DefaultUIcontrolBackgroundColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');

if isempty(P),
   BaseHeight = 90;
else
   BaseHeight = 75;
end
FigureHeight=BaseHeight+20*length(P);

a = figure('Color',[0.8 0.8 0.8], ...
   'IntegerHandle','off', ...
   'MenuBar','none', ...
   'UserData',RLfig,...
   'WindowStyle','modal',...
   'Name','Root Locus Design', ...
   'NumberTitle','off', ...
   'Visible','off',...
   'Position',[95 284 175 FigureHeight]);
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'Position',PointsToPixels*[5 35 165 FigureHeight-40], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'FontWeight','Bold', ...
   'Position',PointsToPixels*[15 FigureHeight-30 145 17], ...
   'String','Closed-loop Poles', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Position',PointsToPixels*[62.5 5 50 25], ...
   'Callback','close(gcbf)',...
   'String','OK');

%----Add the Poles
if isempty(P),
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
      'HorizontalAlignment','center', ...
      'Position',PointsToPixels*[15 FigureHeight-50 145 17], ...
      'String','<None>', ...
      'Style','text');
else
   for ctP=1:length(P),
      b = uicontrol('Parent',a, ...
         'Units','points', ...
         'BackgroundColor',StdColor, ...
         'HorizontalAlignment','left', ...
         'Position',PointsToPixels*[15 FigureHeight-30-(ctP*20) 145 17], ...
         'String',num2str(P(ctP)), ...
         'Style','text');
   end
end

set(a,'visible','on')

%%%%%%%%%%%%%%%%%%%%%%
%%% LocalShowPlant %%%
%%%%%%%%%%%%%%%%%%%%%%
function LocalShowPlant(RLfig,udRL);

Plant = udRL.Model.Plant.Object;
[Zp,Pp,Kp]=zpkdata(udRL.Model.Plant.Object,'v');
[Zs,Ps,Ks]=zpkdata(udRL.Model.Sensor.Object,'v');
[Zf,Pf,Kf]=zpkdata(udRL.Model.Filter.Object,'v');
AllPoles=[{Pp};{Ps};{Pf}];
AllZeros=[{Zp};{Zs};{Zf}];
AllGains=[{Kp};{Ks};{Kf}];

StdColor = get(0,'DefaultUIcontrolBackgroundColor');
PointsToPixels = 72/get(0,'ScreenPixelsPerInch');

Heights = [75+20*max([length(Pp),length(Zp)]); % Plant
	75+20*max([length(Ps),length(Zs)]);         % Sensor
	75+20*max([length(Pf),length(Zf)])];	     % Filter

FigureHeight=80+sum(Heights);
ScreenSize=get(0,'ScreenSize');

a = figure('Color',[0.8 0.8 0.8], ...
   'IntegerHandle','off', ...
   'MenuBar','none', ...
   'UserData',struct('Parent',RLfig,'Children',[]),...
   'Name',['Root Locus Plant: ',udRL.Model.Name], ...
   'Visible','off',...
   'NumberTitle','off', ...
   'WindowStyle','modal',...
   'Position',[66 ScreenSize(4)-30-FigureHeight 300 FigureHeight]);

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'enable','inactive',...
   'Position',PointsToPixels*[5 FigureHeight-30 290 25], ...
   'Style','frame');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',StdColor, ...
   'HorizontalAlignment','left', ...
   'FontWeight','Bold', ...
   'Position',PointsToPixels*[15 FigureHeight-28 150 17], ...
   'String','Design Model Name: ', ...
   'Style','text');
b = uicontrol('Parent',a, ...
   'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'Callback','rlfcn(''editcompname'');', ...
   'HorizontalAlignment','left', ...
   'Position',PointsToPixels*[160 FigureHeight-28 120 20], ...
   'String',udRL.Model.Name, ...
   'Tag','ModelEdit',...
   'UserData',udRL.Model.Name,...
   'Style','edit');

NameText={'Plant Name: ';'Sensor Name: ';'Filter Name: '};
NameTags = {'PlantEdit';'SensorEdit';'FilterEdit'};
ButtonTags = {'Plant';'Sensor';'Filter'};
Names = {udRL.Model.Plant.Name;udRL.Model.Sensor.Name;udRL.Model.Filter.Name};
Types = {upper(class(udRL.Model.Plant.Object));
	upper(class(udRL.Model.Sensor.Object));
	upper(class(udRL.Model.Filter.Object))};

FrameBottom=30;
for ct=1:3,
   FrameBottom=FrameBottom+Heights(ct)+5;
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
      'enable','inactive',...
      'Position',PointsToPixels*[5 FigureHeight-FrameBottom 290 Heights(ct)], ...
      'Style','frame');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'Position',PointsToPixels*[100 FigureHeight+5-FrameBottom 100 20], ...
      'Callback','rlfcn(''showobj'',gcbf);',...
      'Tag',ButtonTags{ct},...
      'String','Show Model');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
      'HorizontalAlignment','left', ...
      'FontWeight','Bold', ...
      'Position',PointsToPixels*[10 FigureHeight-FrameBottom+Heights(ct)-25 95 17], ...
      'String',NameText{ct}, ...
      'Style','text');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'Callback','rlfcn(''editcompname'');', ...
      'HorizontalAlignment','left', ...
      'Position',PointsToPixels*[100 FigureHeight-FrameBottom+Heights(ct)-25 100 20], ...
      'String',Names{ct}, ...
      'Tag',NameTags{ct},...
      'UserData',Names{ct},...
      'Style','edit');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
      'HorizontalAlignment','left', ...
      'FontWeight','Bold', ...
      'Position',PointsToPixels*[210 FigureHeight-FrameBottom+Heights(ct)-25 40 17], ...
      'String','Type:', ...
      'Style','text');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
     'HorizontalAlignment','left', ...
      'Position',PointsToPixels*[250 FigureHeight-FrameBottom+Heights(ct)-25 40 17], ...
      'String',Types{ct}, ...
      'Style','text');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'UserData',struct('Roots',AllZeros{ct},'Gain',AllGains{ct}),...
      'BackgroundColor',StdColor, ...
      'ButtonDownFcn','rlfcn(''planttext'');',...
      'HorizontalAlignment','left', ...
      'Enable','inactive',...
      'FontWeight','Bold', ...
      'Position',PointsToPixels*[15 FigureHeight-FrameBottom+Heights(ct)-45 40 17], ...
      'String','Zeros:', ...
      'Style','text');
   b = uicontrol('Parent',a, ...
      'Units','points', ...
      'BackgroundColor',StdColor, ...
      'ButtonDownFcn','rlfcn(''planttext'');',...
      'Enable','inactive',...
      'FontWeight','Bold', ...
      'HorizontalAlignment','left', ...
      'UserData',struct('Roots',AllPoles{ct},'Gain',[]),...
      'Position',PointsToPixels*[145 FigureHeight-FrameBottom+Heights(ct)-45 40 17], ...
      'String','Poles:', ...
      'Style','text');
   
   %----Add the Poles and Zeros
   for ctZ=1:length(AllZeros{ct}),
      b = uicontrol('Parent',a, ...
         'Units','points', ...
         'BackgroundColor',StdColor,...
         'HorizontalAlignment','left', ...
         'Position',PointsToPixels*[15 ...
            FigureHeight-FrameBottom+Heights(ct)-45-(ctZ*20) 130 17], ...
         'String',num2str(AllZeros{ct}(ctZ),'%0.3g'), ...
         'ToolTipStr','Click Zeros text to show full numerator',...
         'Style','text');
   end % for ctZ
   for ctP=1:length(AllPoles{ct}),
      b = uicontrol('Parent',a, ...
         'Units','points', ...
         'BackgroundColor',StdColor, ...
         'HorizontalAlignment','left', ...
         'Position',PointsToPixels*[145 ...
            FigureHeight-FrameBottom+Heights(ct)-45-(ctP*20) 130 17], ...
         'ToolTipStr','Click Poles text to show full denominator',...
         'String',num2str(AllPoles{ct}(ctP),'%0.3g'), ...
         'Style','text');
   end % for ctP
   
end % for ct

b = uicontrol('Parent',a, ...
   'Units','points', ...
   'Position',PointsToPixels*[125 5 50 25], ...
   'Callback','rlfcn(''endshow'',gcbf);',...
   'String','OK');

set(a,'visible','on')

%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalUpdateIcon %%%  --Update the icon
%%%%%%%%%%%%%%%%%%%%%%%
function LocalUpdateIcon(Hicon);

iconData = get(Hicon,'Cdata');
iconRdata = iconData(:,:,1);
iconGdata = iconData(:,:,2);
iconBdata = iconData(:,:,3);
IndRed = find(iconRdata==1); % Red pixels
GreyPix=find(iconRdata==0.4267);
iconRdata(GreyPix)=1;iconRdata(IndRed)=0.4267;
iconGdata(GreyPix)=0;iconGdata(IndRed)=0.4267;
iconBdata(GreyPix)=0;iconBdata(IndRed)=0.4267;
iconData(:,:,1)=iconRdata;iconData(:,:,2)=iconGdata;iconData(:,:,3)=iconBdata;
set(Hicon,'Cdata',iconData)

%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalUpdateText %%% %---Update the Current Compensator text
%%%%%%%%%%%%%%%%%%%%%%%
function varargout = LocalUpdateText(texttype,NewPole,TextHandle,udRL);

no=nargout;

str=[];
ConfigType = udRL.Model.Structure;
Ts = max([udRL.Model.Plant.Object.Ts;udRL.Model.Sensor.Object.Ts; ...
      udRL.Model.Filter.Object.Ts;]);

if Ts;
   VarType ='z';
else
   VarType = 's';
end

NewPole=cplxpair(NewPole); 
if ~isempty(NewPole)
   complexPolesInd = find(imag(NewPole)~=0);
   complexPoles = NewPole(complexPolesInd);
   numcomplex=length(complexPoles)/2;
   realPoles = NewPole(find(imag(NewPole)==0));
   NewPole=[complexPoles(2:2:end);realPoles];
end

indzero = find(~NewPole);
if ~isempty(indzero),
   if length(indzero)>1,
      str=[VarType,'^',num2str(length(indzero))];
   else 
      str = VarType;
   end
   NewPole(indzero)=[];
end

for ct = 1:length(NewPole)
   RealStr = num2str(abs(real(NewPole(ct))),'%2.2f');
   ImagStr = num2str(abs(imag(NewPole(ct))),'%2.2f');
   if ~imag(NewPole(ct)),
      PoleStr=RealStr;
   else
      PoleStr=[RealStr,char(177),ImagStr,'i'];
   end
   if real(NewPole(ct))>0,
      str = [str,'(',VarType,'-',PoleStr,')'];
   else
      str = [str,'(',VarType,'+',PoleStr,')'];
   end
end

if strmatch('num',texttype),
   str = ['Gain',str];
end

if isempty(str)
   str = '1';
end

set(TextHandle,'String',str)
TextExtent = get(TextHandle,'extent');
TextPos = get(TextHandle,'Position');

if ~no,
   if TextExtent(3)>TextPos(3), % Text is too long
      switch texttype,
      case 'num', 
         set(TextHandle,'String','numK');
      case 'den',
         set(TextHandle,'String','denK');
      end, % switch texttype
   end, % if TextExtent
else,
   varargout{1}= str;
end 

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalUpdateViewer %%% %---Update any open Viewers
%%%%%%%%%%%%%%%%%%%%%%%%%
function StatusStr = LocalUpdateViewer(RLfig,udRL);

StatusStr = [];
if any([get(udRL.Handles.StepButton,'Value'); ...
         get(udRL.Handles.ImpulseButton,'Value'); ...
         get(udRL.Handles.BodeButton,'Value'); ...
         get(udRL.Handles.NyquistButton,'Value'); ...
         get(udRL.Handles.NicholsButton,'Value')]),
   
   CurrentPointer = get(RLfig,'Pointer');
   set(RLfig,'Pointer','watch');
   
   CLsys = LocalComputeSystem(udRL,'closedloop');
   OLsys = LocalComputeSystem(udRL,'openloop');
   
   NumSys = 0; OLind=0; CLind=0;
   if isstatic(OLsys),
      StatusStr{1} = 'The open-loop system contains no dynamics';
   elseif isproper(OLsys), % Add Open-loop system to Viewer
      OLind=1;
      NumSys = NumSys+1;
      Systems{1} = OLsys;
      SystemNames{1} = [udRL.Model.Name,'_openloop'];
   else
      StatusStr{1} = 'The improper open-loop system (K*P*H) is not shown in the Viewer.'; 
   end
   
   if isstatic(CLsys),
      StatusStr{2-NumSys} = 'The closed-loop system contains no dynamics';
   elseif isproper(CLsys), % Add Open-loop system to Viewer
      NumSys = NumSys+1;
      CLind = NumSys;
      Systems{NumSys} = CLsys;
      SystemNames{NumSys} = [udRL.Model.Name,'_closedloop'];
   else
      StatusStr{2-NumSys} = 'The improper closed-loop system is not shown in the Viewer.'; 
   end
   
   udRL.Figure.Children = udRL.Figure.Children(ishandle(udRL.Figure.Children));
   ViewFig = findobj(udRL.Figure.Children,'Tag','ResponseGUI');
   if NumSys,
      SysStr='';
      for ctSys=1:NumSys,
         eval([SystemNames{ctSys},'=Systems{ctSys};']);
         SysStr = [SysStr,SystemNames{ctSys},','];
      end
      udRL.Figure.Children = udRL.Figure.Children(ishandle(udRL.Figure.Children));
      
      %---Check if an initial response plot is being put on the Viewer
      ViewerObj = get(ViewFig,'UserData');
      UImenu = get(ViewerObj,'UIcontextMenu');
      SetVisFlag=0;
      if isempty(UImenu),
         SetVisFlag=1;
      end   
      eval(['ltiview(''current'',',SysStr,'ViewFig);'])
      ViewerObj = get(ViewFig,'UserData');
      showguis(ViewerObj,'off');
      
      if SetVisFlag,
         UImenus = get(ViewerObj,'UIcontextMenu');
         RespObjs = get(UImenus,{'UserData'});
         for ct=1:length(RespObjs)
            SysVis={'on';'on'};
            if any(strcmpi(get(RespObjs{ct},'ResponseType'),{'nyquist';'nichols';'bode'})) & ...
                  CLind,
               SysVis{CLind}='off';
            elseif any(strcmpi(get(RespObjs{ct},'ResponseType'),{'step';'impulse'})) & ...
                  OLind,
               SysVis{OLind}='off';
            end
            set(RespObjs{ct},'SystemVisibility',SysVis(1:NumSys));
         end % for ct
      end % if SetVisFlag
   else
      %---Nothing can be shown
      ltiview('clear',ViewFig);
   end % if/else NumSys
   
   set(RLfig,'Pointer',CurrentPointer);
end % if any

function v2 = matchlsq(v1,v2)
%MATCHLSQ Matches two vectors.  Used in RLOCUS subroutines.
%
%   V2S = MATCHLSQ(V1,V2) matches two complex vectors 
%   V1 and V2, returning V2S with consists of the elements 
%   of V2 sorted so that they correspond to the elements 
%   in V1 in a least squares sense.
%
%   V2 can also be a matrix, in which case the match is
%   performed wrt first column of V2 and all rows of V2
%   are reordered consistently with V1.

%   Author(s): A. Potvin, 9-1-95

p = length(v1);
vones = ones(p,1);
vv = v2;
v21 = v2(:,1).';

% Form gap matrix
Mdiff = abs(v21(vones,:) - v1(:,vones));
Mdiff(isnan(Mdiff)) = Inf;
v1ind = 1:p;
v2ind = 1:p;

while length(v1ind)>1,
   [m,i] = min(Mdiff(v1ind,v2ind));
   if all(filter([1 -1],1,sort(i))),  % fast diff
      % Quick exit condition
      v2(v1ind(i),:) = vv(v2ind,:);
      return
   end
   [trash,j] = min(m);
   i = i(j);
   v2(v1ind(i),:) = vv(v2ind(j),:);
   % indices = [indices; v1ind(i) v2ind(j)];
   v1ind(i) = [];
   v2ind(j) = [];
end
% Here's the last point.
v2(v1ind,:) = vv(v2ind,:);

% end matchlsq


         
