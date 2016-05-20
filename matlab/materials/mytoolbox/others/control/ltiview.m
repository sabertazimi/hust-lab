function varargout=ltiview(varargin);
%LTIVIEW Open the LTI Viewer
%   LTIVIEW issued from the command line initializes an empty LTI Viewer.
%   The LTI Viewer is an interactive user-interface for performing the
%   various Control System Toolbox response functions for any state space, 
%   transfer function, or zero-pole-gain LTI object in the workspace.
%
%   LTIVIEW(PLOTTYPE) opens an LTI Viewer initialized with the response
%   types listed in PLOTTYPE.  The response of a random 4 state, 2 input,
%   2 output state space LTI Object is plotted.
%
%   PLOTTYPE may be any of the following strings.
%
%          1) 'step'
%          2) 'impulse'
%          3) 'bode'
%          4) 'nyquist'
%          5) 'nichols'
%          6) 'sigma'
%          7) 'pzmap'
%          8) 'lsim'
%          9) 'initial'
%
%   PLOTTYPE can also be a cell array of up to 6 of the previous plot type 
%   strings.  The LTI Viewer will contain one response area for each plot type
%   listed in PLOTTYPE.
%
%   Examples:
%     ltiview({'step';'impulse'});
%
%   LTIVIEW(PLOTTYPE,SYS1,SYS2,...SYSN) initializes a new LTI Viewer with the
%   responses of the LTI objects SYS#.  You can also specify a color, line 
%   style, and marker for each system, as in
%   LTIVIEW(PLOTTYPE,SYS1,PLOTSTR1,SYS2,PLOTSTR2,...SYSN,PLOTSTRN) 
%
%   Examples:
%     sys1 = rss(3,2,2);
%     sys2 = rss(4,2,2);
%     ltiview('step',sys1,'r-*',sys2,'m--');
%
%   LTIVIEW(PLOTTYPE,SYS,OPTIONS) allows the additional input 
%   arguments supported by the different response types to be entered.
%   See the appropriate HELP text for each response type for more
%   details on the format of these extra arguments. In the case of LSIM
%   and INITIAL, the OPTIONS field must include the input signal or
%   initial condition, respectively. OPTIONS can not be added when
%   PLOTTYPE is a cell array.
%
%   Two additional options for the PLOTTYPE string are available for 
%   manipulating previously opened LTI Viewers:
%
%   LTIVIEW('clear',Hviewers) clears the plots and data from the LTI Viewers
%   with the handles provided in Hviewers.
%
%   LTIVIEW('current',SYS1,PLOTSTR1,SYS2,PLOTSTR2,...SYSN,PLOTSTRN,Hviewers)
%   appends the responses for the systems in SYS# to the LTI Viewers with the
%   handles provided in Hviewers, if the systems have the same dimensions as
%   those currently in the LTI Viewer. If the dimensions are different, the LTI 
%   Viewer is first cleared and only the new responses are shown. 

%   See also STEP, IMPULSE, BODE, NYQUIST, NICHOLS, SIGMA, LSIM, INITIAL

%   Karen Gondoly, 8-6-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.31 $

NumberOfSys=0;
NumPlotStr=0;
fignum=[];

ni=nargin;
no = nargout;

Parent = gcbf;
if isempty(Parent),
   Parent = 0;
end

try, % Wrap whole LTIView in a try catch
   
   if ~ni,
      plottype = {'step'};
      action = plottype{1};
      a = viewgui(plottype,Parent);
      LTIViewerFig = get(a,'Handle');
      set(LTIViewerFig,'UserData',a);
      if no,
         varargout(1)={LTIViewerFig};
      end
      return
   else 
      plottype=varargin{1};
      %init action for error catch
      action = 'error';
      %---Error checking for first input argument;
      if ~iscellstr(plottype) & ~ischar(plottype),
         error('PLOTTYPE must be a valid LTI Viewer string or cell array.');
      end
      
      %---Make signle plottype into a cell array
      if ~iscell(plottype),
         plottype=cellstr(plottype);
      end % if iscell
      
      %---Check number of desired plots
      if length(plottype)>6,
         error('PLOTTYPE may contain no more then six entries.');
      end
      
      ValidStrings = {'step';
         'impulse';
         'bode';
         'nyquist';
         'nichols';
         'sigma';
         'pzmap';
         'lsim';
         'initial';
         'timedata';
         'current';
         'clear'};
      
      AllValid = all(ismember(plottype,ValidStrings));
      if ~AllValid,
         error('Each entry in PLOTTYPE must be a valid LTIVIEW string.');
      end
      
      action = plottype{1};
      
      if ni>1, % Read remaining data based on PLOTTYPE
         switch action,
         case 'current'
            ViewerHandles=varargin{end};
            if any(~ishandle(ViewerHandles)),
               error(['The CURRENT option require Valid LTI Viewer handles.'])
            end
            
            %---Read new system data
            [SystemData,ExtraArg,ErrStr] = LocalReadSystems(varargin{2:end-1});
            if ~isempty(ExtraArg)
               ErrStr='Invalid input arguments for the CURRENT option.';
            end
            if ~isempty(ErrStr),
               error(ErrStr);
            end
            
         case 'clear'
            error(nargchk(2,2,ni))
            ViewerHandles=varargin{2};
            if any(~ishandle(ViewerHandles)),
               error('The CLEAR option requires Valid LTI Viewer handles.')
            end
            
         case 'timedata'
            
         otherwise % Read system data
            [SystemData,ExtraArg,ErrStr] = LocalReadSystems(varargin{2:end});
            
            if length(plottype)>1 & ~isempty(ExtraArg),
               ErrStr='Extra input arguments only allowed when PLOTTYPE has a single entry.';
            end
            if ~isempty(ErrStr),
               error(ErrStr);
            end
            
         end % switch plottype{1}
      elseif isequal(ni,1)
         ExtraArg=[];
         RandomSS = rss(4,2,2);
         SystemData = struct('Names',{{'RandomSS'}},...
            'Systems',{{RandomSS}},...
            'PlotStrs',{{''}},...
            'FRDindices',[]);
         varargin{2}=RandomSS;
      end % if ni>1
      
   end % if/else ni
   
   switch action
      
   case 'clear',
      %----Clear any old systems out of the specified LTI Viewers
      for ctViewer=1:length(ViewerHandles),
         ViewerObj = get(ViewerHandles(ctViewer),'UserData');
         
         %---Erase Systems from LTI Viewer
         Systems = get(ViewerObj,'Systems');
         ViewerObj = deletesys(ViewerObj,1:length(Systems));
         
      end % for ctViewer
      fignum=ViewerHandles;
      
   case 'current',
      if ~isempty(SystemData),
         [NewNumIn,NewNumOut]=size(SystemData.Systems{1});
         
         %----Update the specified LTI Viewers with the new systems
         for ctViewer=1:length(ViewerHandles),
            ViewerObj = get(ViewerHandles(ctViewer),'UserData');
            OldSystems = get(ViewerObj,'Systems');
            if ~isempty(OldSystems),
               [OldNumIn,OldNumOut]= size(OldSystems{1});
               if ~isequal(OldNumIn,NewNumIn) | ~isequal(OldNumOut,NewNumOut),
                  %---Reset the Viewer UserData to only show new systems
                  ltiview('clear',ViewerHandles(ctViewer))
               end
            end
            
            %---Add the plots to the Viewer
            rguifcn('addsystems',ViewerHandles(ctViewer),SystemData);
            
         end % for ctViewers
      end, % if NumberOfSys
      fignum=ViewerHandles;   
      
   otherwise
      %---Open a new Viewer showing the specified plottypes
      a = viewgui(plottype,Parent,SystemData);
      fignum = get(a,'Handle');
      SystemData.PlotStrs=get(a,'PlotStrings');
      
      if ~isempty(ExtraArg),
         a = initparams(a,ExtraArg,plottype{1}); % Only possible for single plottypes
      end
      
      set(a,'InitializeViewer',SystemData)
      
   end % switch action
   
   if no,
      varargout(1)={fignum};
   end
   
catch
   %---If an error is caught for an action other then 'current' or 'clear',
   %    close the Viewer
   if ~any(strcmpi(action,{'current';'clear'})) & ishandle(fignum),
      close(fignum)
   end
   error(lasterr)

end % try/catch 

%--------------------------------Internal Functions----------------------------
%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalReadSystems %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function [SystemData,ExtraArg,ErrStr] = LocalReadSystems(varargin);

ModelNames = cell(length(varargin),1);
ModelObjects = cell(length(varargin),1);
PlotStr = cell(length(varargin),1);
PlotStr (:)={''};
FRDi = zeros(length(varargin),1);
ExtraArg = cell(length(varargin),1);
ErrStr=[];
AllSizes = zeros(length(varargin),2);

SystemData = struct('Names',[],...
   'Systems',[],...
   'PlotStrs',[],...
   'FRDindices',[], ...
   'ExtraArg',[]);
sArg=0;

%---Check that first second input argument is an LTI Object
if ~isa(varargin{1},'lti'),
   ErrStr='The second input argument must be an LTI Object for the current PLOTTYPE.';
   return
end

NumPlotStr=0;
NumberOfSys=0;
for ct=1:length(varargin),
   if isa(varargin{ct},'lti'),
      NumberOfSys = NumberOfSys+1;
      sizetemp = size(varargin{ct});
      AllSizes(NumberOfSys,:) = sizetemp(1:2);
      if ~isempty(inputname(ct)),
         ModelNames{NumberOfSys}=inputname(ct);
      else
         ModelNames{NumberOfSys}='';
      end, % if/else ~isempty(inputname(2))
      
      if isa(varargin{ct},'frd')
         FRDi(NumberOfSys) = NumberOfSys;
      end
      
      ModelObjects{NumberOfSys}=varargin{ct};
      if ~isproper(ModelObjects{NumberOfSys}),
         ErrStr='Not available for improper systems.';
         return
      end   
      [numNewIn(NumberOfSys),numNewOut(NumberOfSys)]=size(ModelObjects{NumberOfSys});
      
   elseif isa(varargin{ct},'char'),
      NumPlotStr=NumPlotStr+1;
      PlotStr{NumPlotStr}=varargin{ct};
   else
      sArg=sArg+1;
      ExtraArg{sArg}=varargin{ct};
   end % if/else isa(varargin...
end % for ct

if ~isequal(NumberOfSys,NumPlotStr) & NumPlotStr,
   ErrStr='The plot string must be defined for each system';
   return
end

if ~all(AllSizes(1,2)==AllSizes(1:NumberOfSys,2)) | ...
      ~all(AllSizes(1,1)==AllSizes(1:NumberOfSys,1))
   ErrStr='All models must have the same number of inputs and outputs.';
   return
end

ExtraArg = ExtraArg(1:sArg);
SystemData.Names = ModelNames(1:NumberOfSys);
SystemData.Systems = ModelObjects(1:NumberOfSys);
SystemData.PlotStrs = PlotStr(1:NumberOfSys);
SystemData.FRDindices= FRDi(find(FRDi));
