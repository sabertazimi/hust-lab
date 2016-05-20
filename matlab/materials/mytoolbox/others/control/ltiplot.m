function [RespObj,varargout]=ltiplot(varargin);	
%LTIPLOT Plot an LTI system response without opening an LTI Viewer.
%   LTIPLOT(PLOTTYPE,SYS) plots the type of LTI system response
%   indicated by the string PLOTTYPE (e.g. 'step','bode') for
%   each LTI system in the cell array SYS. (For a single system, SYS
%   does not have to be a cell array.) The result will be an array of 
%   plots, one for each I/O channel, on the current axis.
%
%   LTIPLOT(PLOTTYPE,SYS,H,Y,X) uses the response data in Y and X
%   when plotting the response.  For 'impulse','sigma','nyquist' and 'nichols' 
%   Y and X are cell arrays containing the Y and X-axis data for each system 
%   in SYS.  For 'bode', each cell of Y should, in turn, be the cell array
%   [{MAGNITUDE},{PHASE}]. For 'step', each cell of Y should be the cell array 
%   [{AMPLITUDE},{DCGAIN}].
%
%   LTIPLOT(PLOTTYPE,SYS,H,Y,X,plotstr) passes a cell array of colors,
%   linesytles, and markers (e.g.'r-o') for each response plot.

%---Expanded for Context Menu applications
%   RESPOBJ=LTIPLOT(...) returns the handle of the resulting Response Object.
%
%   [RespObj] = ...
%       LTIPLOT(PLOTTYPE,SYS,R,Y,X,plotstr,'PropertyName',PropertyValue) 
%       allows other properties of the response object to be set. 
%
%   Supported properties include:
%       1) 'SystemNames': A cell array of length SYS, containing the names
%              to use in the Systems context menu. (Default names: {'sys#'})
%       2) 'SystemVisibility': A cell array of length SYS indicating if the
%              system's plot should be visible {'on'} or invisible ('off').
%       3) 'SelectedChannels': A matrix of size(SYS) containing ones and zeros 
%              indicating which I/O channels are plotted ({1}=visible, 0=invisible)
%       4) 'SelectedModels': A cell array of size(SYS) where each cell contains
%              an ND array of ones and zeros indicating which models of the LTI 
%              array are plotted ({1}=visible, 0=invisible)
%       5) 'AxesGrouping': String indicating the grouping preference for the
%              Response axes ({'none'},'inputs','outputs','all')

%   Karen Gondoly, 9-30-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.31.1.2 $

ni=nargin;
if ni<2 | isequal(ni,4),
   error('Wrong number of input arguments')
end

%---Process input arguments
plottype=varargin{1};
sys=varargin{2};
if ~iscell(sys);
   sys = {sys};
end

%---Increase number of rows in Response Object for Magnitude/Phase plots
[NumRows,NumColumns]=size(sys{1});
switch plottype,
case 'bode';
   NumRows=NumRows*2;
case 'margin',
   NumRows=2;
   NumColumns=1;
case {'sigma';'pzmap'};
   NumRows=1;
   NumColumns=1;
case {'lsim';'initial'},
   NumColumns=1;
end

if ni>2,
   BackAx=varargin{3};
   if ~ishandle(BackAx) | ~strcmp('axes',get(BackAx,'type')),
      % Need to update if Response Plots become HG Objects
      error('An invalid axes handle was passed to LTIPLOT.');
   elseif isempty(BackAx),
      BackAx=gca;
   end
else
   BackAx=gca;
end % if/else ni>2

%---If the BackAx is an LTIDisplayAxes, get its parent
if strcmp(get(BackAx,'Tag'),'LTIdisplayAxes'),
   udax=get(BackAx,'UserData');
   BackAx=udax.Parent;
end

if ni>3,
   Ydata=varargin{4};
   Xdata=varargin{5};
   
   %---Check that X/Ydata is entered for each system
   [Xdata,Ydata,ErrFlag,ErrStr]=LocalCheckData(plottype,sys,Ydata,Xdata);
   if ErrFlag
      error(ErrStr)
   end
else
   Xdata = cell(size(sys));
   Ydata = cell(size(sys));
end

if ni>=5,
   PlotStr=varargin{6};   
   %---In the case of Margin, the sixth input argument is reserved for
   %-----inputing the margins. Margin can not be called with a plot string argument
   
   %---Remember to convert the gain margin to dB
   if strcmp(plottype,'margin');
      MarginVals = struct('System',sys,...
         'GainMargin',{20*log10(PlotStr(1))},...
         'GMFrequency',{PlotStr(3)},...
         'PhaseMargin',{PlotStr(2)},...
         'PMFrequency',{PlotStr(4)});
      PlotStr='';
   end
   if ~iscell(PlotStr),
      PlotStr=cellstr(PlotStr);
   end
else
   PlotStr=cell(size(sys));
end % if/else ni>=5

sysname = cell(length(sys),1); 
sysname(:)={''};
NewSC = []; NewSM = []; NewSV = []; % Use Defaults
if ni>6,
   Pnames = varargin(7:2:end);
   Pvalues = varargin(8:2:end);
   if ~isequal(length(Pnames),length(Pvalues)),
      error('Property names and values must be entered in pairs');
   end
   
   %---Remove properties that will be set as part of InitData
   SysNameFlag = find(strncmpi('systemnames',Pnames,11));
   if ~isempty(SysNameFlag),
      sysname = cellstr(Pvalues{SysNameFlag});
      sysname = sysname(:); % Make sure it's a column vector
   end
   ChannelFlag = find(strncmpi('selectedc',Pnames,9));
      if ~isempty(ChannelFlag), NewSC = Pvalues{ChannelFlag}; end
   ModelFlag = find(strncmpi('selectedm',Pnames,9));
      if ~isempty(ModelFlag), NewSM = Pvalues{ModelFlag}; end 
   SysVisFlag = find(strncmpi('systemvis',Pnames,9));
      if ~isempty(SysVisFlag), NewSV = Pvalues{SysVisFlag}; end 
   RemoveInd = [SysNameFlag,ChannelFlag,ModelFlag,SysVisFlag];
   varargin(6+[RemoveInd,RemoveInd+1])=[];
end

%---Make set of LTIdisplayAxes
[RespObj,RespObjFlag] = LocalMakeAxes(NumRows,NumColumns,BackAx,plottype);

%---Get the current ContextMenu
BackAx = get(RespObj,'BackgroundAxes');
ContextMenu = get(RespObj,'UIContextMenu');
set(RespObj,'ResponseType',plottype)

%---See if Names have been entered, otherwise, make default names
if RespObjFlag,
   OldNames = get(RespObj,'SystemNames');
   NumOldSys = length(OldNames);
else,
   NumOldSys=0;
end

indEN = find(strcmpi('',sysname));
if ~isempty(indEN),
   if NumOldSys
      OldUntitled = find(strncmpi('untitled',OldNames,8));
      if ~isempty(OldUntitled),
         UsedInds = char(OldNames(OldUntitled));
         UsedInds = str2double(UsedInds(:,9:end));
         AvailInds = 1:(length(sys) + max(UsedInds));
         AvailInds(UsedInds)=[];
         SysInd = cellstr(strjust(num2str(AvailInds(1:length(sys))'),'left'));
      else
         SysInd = cellstr(strjust(num2str([1:length(indEN)]'),'left'));
      end
   else
      SysInd = cellstr(strjust(num2str([1:length(indEN)]'),'left'));
   end
   systext (1:length(indEN),1)={'untitled'};
   sysname(indEN) = cellstr([strvcat(systext {:}),strvcat(SysInd{:})]);
end

switch plottype
case 'step',
   %---Pass data to STEPPLOT to make a step object
   RespObj = stepplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'impulse'
   RespObj = impplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'initial',
   RespObj = icplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'lsim',
   RespObj = lsimplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'bode',
   RespObj = bodplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'margin',
   RespObj = margplot(RespObj,sys,sysname,Xdata,Ydata,MarginVals);   
   
case 'nyquist',
   RespObj = nyplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'nichols',
   RespObj = nicplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'sigma',
   RespObj = svplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);
   
case 'pzmap',
   RespObj = pzplot(RespObj,sys,sysname,Xdata,Ydata,PlotStr);   
   
end % switch plottype

%---If any of the systems are arrays, turn on the SelectArray menu
for ctSys=1:length(sys),
   SizeSys = size(sys{ctSys});
   if length(SizeSys)>2,
		set(ContextMenu.ArrayMenu,'visible','on');      
      break
   end % if length(SizeSys)
end % for ctSys

%---Set SelectedChannels Properties value
if ~strcmp(plottype,'margin'),
   SizeSys=size(sys{1});
else
   SizeSys = [1 1];
end

if isempty(NewSC),
   if RespObjFlag,
      NewSC=get(RespObj,'SelectedChannels');
   else 
      NewSC=ones(SizeSys(1:2));
      %---for Sigma and PZmap, change SC to a scalar
      switch plottype
      case {'sigma';'pzmap';'margin'},
         NewSC=1;
      case {'lsim';'initial'},
         NewSC = ones(SizeSys(1),1);
      end
   end % if/elseif RespObjFlag
end

if RespObjFlag,
   SMold = get(RespObj,'SelectedModels');
   SVold = get(RespObj,'SystemVisibility');
else
   SMold = []; SVold = [];
end

%---Set SelectedModels and SystemVisibility Properties values
if isempty(NewSM)
   NewSM = cell(length(Xdata),1);
   for ctSys=1:length(NewSM),
      SizeSys = size(Xdata{ctSys});
      if strcmp(plottype,'pzmap'),
         switch length(SizeSys),
         case 2,
            SizeSys=[1 1];
         case 3,
            SizeSys = [SizeSys(3),1];
         otherwise,
            SizeSys = SizeSys(3:end);
         end % switch length
      elseif strcmp(plottype,'margin');
         SizeSys = size(MarginVals.GainMargin);
      end % if strcmp
      NewSM{ctSys}=ones(SizeSys);
   end
end
ModelVis=[SMold;NewSM];

if isempty(NewSV)
   if ~strcmp(plottype,'margin'),
      NewSV = cell(length(sys),1);
      NewSV(:)={'on'};
   else
      NewSV = {'on'};
   end
end
SysVis=[SVold;NewSV];

%---Store and set data for initializing plots
InitData = struct('SystemVisibility',{SysVis},...
   'SelectedChannels',NewSC,'SelectedModels',{ModelVis});
set(RespObj,'InitializeResponse',InitData);

if length(varargin) > 6,
   %---Modify any additional Response Object Properties
   set(RespObj,varargin{7:end})
end

if RespObjFlag, % Check for any displayed Plot Options
   RespObj = LocalCheckOptions(plottype,RespObj,[NumOldSys+1:NumOldSys+length(sys)]);
end

%---Store the Reponse Object in the ContextMenu
set(ContextMenu.Main,'UserData',RespObj)

%---Make the BackgroundAxes the figure's current axes
set(get(BackAx,'Parent'),'CurrentAxes',BackAx);

%--------------------------Internal Functions-----------------------
%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckData %%%
%%%%%%%%%%%%%%%%%%%%%%
function [Xdata,Ydata,ErrFlag,ErrString] = LocalCheckData(plottype,sys,Ydata,Xdata);

ErrFlag=0;
ErrString='';

%---Take care of pzmap input
%-----Problem checking size of X/Ydata for systems with singular dimensions
if strcmp(plottype,'pzmap'),
%   for ctSys = 1:length(sys),
%      if (~isempty(Ydata{ctSys}) & ~isequal(ndims(Ydata{ctSys}),ndims(sys{ctSys})) ) | ...
%            (~isempty(Xdata{ctSys}) & ~isequal(ndims(Xdata{ctSys}),ndims(sys{ctSys})) ) ,
%         ErrFlag = 1;
%         ErrString = 'The dimensions of all systems and their pole-zero data do not match.'; 
%      end % if
%   end % for
   return   
end % if strcmp(pzmap

if ~strcmp(plottype,'margin')
   if ~isequal(length(Xdata),length(sys)),
      ErrFlag=1;
      ErrString = 'The amount of data does not match the number of systems in LTIPLOT.';
      return   
   end
   
   SizeSys = ndims(sys{1});
   
   if isequal(SizeSys,2),
      %---Check if data is in old format (Not in cell arrays)
      for ctX=1:length(Xdata),
         if ~iscell(Xdata{ctX}),
            Xdata(ctX)={Xdata(ctX)};
         end
      end
      for ctY=1:length(Ydata),
         switch plottype
         case {'sigma','impulse','initial','lsim','nyquist'}
            if ~iscell(Ydata{ctY}),
               Ydata(ctY)={Ydata(ctY)};
            end
         case {'bode','nichols','margin'}
            if ~iscell(Ydata{ctY}{1}),
               Ydata{1}{ctY}= {Ydata{1}{ctY}};
               Ydata{2}{ctY}= {Ydata{2}{ctY}};
            end
         case 'step',
            if ~iscell(Ydata{ctY}{1})
               Ydata{ctY}{1}= {Ydata{ctY}{1}};
            end
         end  % switch plottype
      end % for ctY
   end % if isequal
   
else
   Xdata = {Xdata};
   Ydata = {Ydata};
end % if/else ~strcmp(margin)
%---May want to do additional data checking here

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckOptions %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function RespObj = LocalCheckOptions(plottype,RespObj,IndShow)

if any(strcmpi(plottype,{'step';'impulse';'initial'})),
   if strcmp(get(RespObj,'PeakResponse'),'on');
      RespObj= respfcn('showpeak',RespObj,IndShow);   
   end
   if strcmp(get(RespObj,'SettlingTime'),'on');
      RespObj= respfcn('showsettling',RespObj,IndShow);   
   end
end

if strcmp(plottype,'step')
   if strcmp(get(RespObj,'RiseTime'),'on');
      RespObj = respfcn('showrise',RespObj,IndShow);   
   end   
   if strcmp(get(RespObj,'SteadyState'),'on');
      RespObj = respfcn('showsteady',RespObj,IndShow);   
   end
end

if any(strcmpi(plottype,{'bode';'nyquist';'nichols'})),
   if strcmp(get(RespObj,'StabilityMargin'),'on');
      RespObj= respfcn('showmargin',RespObj,IndShow);   
   end
   
end

if any(strcmpi(plottype,{'bode','sigma'}));
   if strcmp(get(RespObj,'PeakResponse'),'on');
      RespObj= respfcn('showpeak',RespObj,IndShow);   
   end
end

%%%%%%%%%%%%%%%%%%%%%
%%% LocalMakeAxes %%%
%%%%%%%%%%%%%%%%%%%%%
function [RespObj,RespObjFlag] = LocalMakeAxes(NumRows,NumColumns,BackAx,plottype);

L = findobj(BackAx,'Tag','BackgroundResponseObjectLine');
RespObjFlag=0;
if ~isempty(L), % A Response Object
   ContextMenu = get(L,'UserData');
   RespObj = get(ContextMenu,'UserData');
   %---Check the current NextPlot Value
   HoldValue = get(RespObj,'NextPlot');
   OtherHoldVal = {'replace';'add'};
   OtherHoldVal(strmatch(HoldValue,OtherHoldVal))=[]; % cell array
   
   NewLTIAxes = get(RespObj,'PlotAxes');
   
   %---Check if the NextPlot Value was toggled at the command line
   AllAxes = [BackAx;NewLTIAxes(:)];
   AllHold=get(AllAxes,'NextPlot');
   if ~isequal(length(strmatch(HoldValue,AllHold)),length(AllAxes)), % A NextPlot was changed
      HoldValue = OtherHoldVal{1};
      set(RespObj,'NextPlot',HoldValue);
      set(AllAxes,'NextPlot',HoldValue);
   end
   
   if strcmp(HoldValue,'add'); % Hold is on
      OldPlotType = get(RespObj,'ResponseType');
      if ~strcmp(OldPlotType,plottype),
         %---Can only overlay plots of same dimension and plot type
         error('Different response types can not be placed on held axes.');
      elseif ~isequal(size(NewLTIAxes),[NumRows,NumColumns]),
         %---Can not plot systems of different dimensions
         error('Systems of different dimensions can not be placed on held axes.')
      end
      RespObjFlag=1; % Valid Response Object to add plots to
   else
      %---Reinitialize the Response Object
      cla(RespObj);
      RespObj = response(NumRows,NumColumns,BackAx);
   end % if/else strcmp(HoldValue)
   
else, % Try to make into a response Object
   %---Need some protection when menus/controls are associated with the figure/axis?
   RespObj = response(NumRows,NumColumns,BackAx);
end % if/else ~isempty(L)
