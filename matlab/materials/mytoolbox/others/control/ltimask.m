function varargout=ltimask(Action,varargin)
%LTIMASK Initialize Mask for LTI block.
%  This function is meant to be called only by the LTI Block
%  in SIMULINK.  Please see the Controls Toolbox block library.
%
%  See also TF, SS, ZPK.

%   Kevin Kohrt
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.19 $ $Date: 1999/01/05 15:21:33 $

switch Action,
case 'AssignData',
   error(nargchk(4,4,nargin));
   [varargout{1:9}]=LocalAssignData(varargin{:});
   
case 'MaskLTICallback',
   error(nargchk(2,2,nargin));
   [MaskVals,ChangeFlag]=LocalCheckLTIMaskValue(varargin{1});
   
   %---Always update data
   set_param(varargin{1},'MaskValues',MaskVals) 
   
case 'MaskICCallback',
   error(nargchk(2,2,nargin));
   [MaskVals,ChangeFlag]=LocalCheckICMaskValue(varargin{1});
   
   %---Always update data
   set_param(varargin{1},'MaskValues',MaskVals) 
   
case 'UpdateDiagram',
   error(nargchk(5,5,nargin));
   LocalUpdateDiagram(varargin{:});
   
case 'InitializeVars',
   %---This is an obsoleted callback from versions 4.0.1,4.1 versions of 
   % the LTI block. It is now used to update this blocks to the current
   % LTI block in the cstblocks.mdl library
   
   %---For now, just warn the user that they need to update their diagram
   h = msgbox({'Your Simulink model uses an old version of the LTI Block.'; ...
         ''; ...
         'Use the function CSTUPDATE to update all LTI Blocks in the '; ...
         'Simulink model.'}, ...
     'LTI Block Warning','replace');

   
otherwise,  
   error('Invalid Action for LTIMASK.');
   
end

%-------------------------------Internal Functions----------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalCheckLTIMaskValue %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MaskVal,ChangeFlag]=LocalCheckLTIMaskValue(CB)

MaskVal = get_param(CB,'MaskValues');
MaskStr = get_param(CB,'MaskValueString');
sysstr = deblank(MaskVal{1});
%---Strip off any ending semicolons
if strcmp(sysstr(end),';');
   sysstr = sysstr(1:end-1);
end
MaskVal{1} = sysstr;
sys = evalin('base',MaskVal{1},'[]');
ErrFlag = 0;
ChangeFlag = 0;

% Check type and dimension of LTI object
if ~isa(sys,'lti'),
   ErrFlag = 1;
elseif isa(sys,'frd') % FRDs not supported
   ErrFlag = 8;
elseif ndims(sys)>2, % LTI Arrays not supported
   ErrFlag = 7;
end

if ErrFlag,
   LocalLTIError(ErrFlag);
   [MaskVal{1},MaskVal{2}] = strtok(MaskStr,'|');
   MaskVal{2}=MaskVal{2}(2:end);
else
   
   % Check Transport delay 
   DelayData = get(sys,{'inputdelay','outputdelay','iodelay'});
   [Tdi,Tdo,Tdio] = deal(DelayData{:});
   Tdi = Tdi';
   Tdo = Tdo';
   
   if any(Tdio(:)), % | any(Tdout(:)), % allow output delays
      ErrFlag = 6;
   elseif any(Tdi<0) | any(Tdo<0), 
      % If there is a negative time delay
      ErrFlag = 4;
   end % if ~isempty
   
   if ErrFlag,
      LocalLTIError(ErrFlag);
      [MaskVal{1},MaskVal{2}] = strtok(MaskStr,'|');
      MaskVal{2}=MaskVal{2}(2:end);
   else
      % Check if enable state of IC edit box needs to be changed
      EnableStr = get_param(CB,'MaskEnableString');
      if ( isa(sys,'tf') | isa(sys,'zpk') ) & isempty(findstr(EnableStr,'off')),
         set_param(CB,'MaskValues',{MaskVal{1};'[0]'},'MaskEnableString','on,off')
      elseif isa(sys,'ss') & ~isempty(findstr(EnableStr,'off')),
         % Enable it, IC will be zero unless it was set via set_param
         % in which case we'll end up checking the IC later..
         set_param(CB,'MaskEnableString','on,on')
      else
         IC = evalin('base',MaskVal{2},'[]');
         if (length(IC)~=1 & length(IC)~=size(sys,'order'))
            MaskVal{2}='[0]';
         end
      end % if/else isa(sys,'tf'...
   end % if/else inner ErrFlag
end % if/else ErrFlag

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalCheckICMaskValue %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MaskVal,ChangeFlag] = LocalCheckICMaskValue(CB)

% Initial State (IC) validation
MaskVal = get_param(CB,'MaskValues');
MaskStr = get_param(CB,'MaskValueString');
sys = evalin('base',MaskVal{1},'[]');
IC = evalin('base',MaskVal{2},'[]');
ChangeFlag=0;

if isa(sys,'ss') & (length(IC)~=1 & length(IC)~=size(sys,'order')), 
   % Error: IC vector size != # states
   LocalLTIError(3);
   [garb,MaskVal{2}] = strtok(MaskStr,'|');
   MaskVal{2}=MaskVal{2}(2:end);
   ChangeFlag=1;
   
elseif (isa(sys,'tf') | isa(sys,'zpk')) & (IC | length(IC)~=1),
   %---Reset initial states to zero
   LocalLTIError(2);
   MaskVal{2}='[0]';
   ChangeFlag=1;
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalAssignData %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,B,C,D,Xo,Tdi,Tdo,Ts,sysname]=LocalAssignData(CB,sys,IC);

A=[];B=[];C=[];D=1;Tdi=0;Tdo=0;Ts=0;Xo=0;sysname='???';

% Check ICs, in case they were entered with a set_param
[MaskVal,ChangeFlag] = LocalCheckICMaskValue(CB);
if ChangeFlag, 
   set_param(CB,'MaskValues',{MaskVal{1};'[0]'}) 
end

% Check LTI object, in case they were entered with a set_param
[MaskVal,ChangeFlag] = LocalCheckLTIMaskValue(CB);
if ChangeFlag, 
   set_param(CB,'MaskValues',{MaskVal{1};'[0]'}) 
end

MaskVal = get_param(CB,'MaskValues');
if ~isempty(sys) & isa(sys,'lti')  
   sysname=MaskVal{1};
   Xo=evalin('base',MaskVal{2},'0');
   if ~isct(sys)			% discrete, use delay2z
      old_order = size(sys,'order');
      sys = delay2z(sys);
      new_order = size(sys,'order');
      % Only pad Xo if there is something nonzero already there..
      % Otherwise, a zero is fine
      if ~isequal(Xo,0)
        Xo = [Xo; zeros(new_order-old_order,1)];
      end
      [A,B,C,D,Ts]=ssdata(sys);
      Tdi = 0;
      Tdo = 0; 
   else					% continuous, use transport delay
      [A,B,C,D,Ts]=ssdata(sys);
      Tdi = get(sys,'InputDelay');
      Tdi = Tdi';
      Tdo = get(sys,'OutputDelay');
      Tdo = Tdo';
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalUpdateDiagram %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalUpdateDiagram(CB,sys,Tdi,Tdo);

blk=[CB,'/Internal'];
BlockName=find_system(CB,'FollowLinks','on','LookUnderMasks', 'all', 'name','Internal');

if isempty(BlockName) | isempty(sys) | ~isa(sys,'lti'),
   % Must be (1) model load (block not yet rendered),
   %      or (2) underlying block has been renamed from 'Internal'.  Ick.
   return
end

% Handle cell-array for degenerate case of top-level block
% being names "Internal", in addition to the child block
CB_name=get_param(CB,'name');  % parent name
if strcmp(CB_name, 'Internal'),
   % there had better be 2 blocks found with name 'Internal' now
   if length(BlockName)~=2, return; end  % Probably loading - child not loaded!
   BlockName=BlockName(2);
end
if length(BlockName)>1,
   return  % Hosed
end

IsContBlock = strcmp(get_param(BlockName{:},'blocktype'),'StateSpace');

% Flag for Input Transport Delay
HasDelayBlock = ~isempty(find_system(CB,...
   'FollowLinks','on', ...
   'LookUnderMasks', 'all', ...
   'MaskType','Transport Delay (masked)', ...
   'Tag','InputDelayBlock'));
if ~HasDelayBlock, % It got deleted some how, add it back.
   % In1 may or may not be present ... check?
   delete_line(CB,'In1/1','Internal/1');
   add_block('cstextras/Transport Delay (masked)',[CB '/Tdi'], ...
      'DelayTime', 'Tdi', 'Position', [70 30 100 60],...
      'Tag','InputDelayBlock');
   add_line(CB,'In1/1','Tdi/1'      );
   add_line(CB,'Tdi/1' ,'Internal/1');
end % if ~HasDelayBloc

% Flag for Output Transport Delay
HasDelayBlock = ~isempty(find_system(CB,...
   'FollowLinks','on', ...
   'LookUnderMasks', 'all', ...
   'MaskType','Transport Delay (masked)', ...
   'Tag','OutputDelayBlock')); 
if ~HasDelayBlock, % It got deleted some how, add it back.
      % Out1 may or may not be present ... check?
      delete_line(CB,'Internal/1','Out1/1');
      add_block('cstextras/Transport Delay (masked)',[CB '/Tdo'], ...
         'DelayTime', 'Tdo', 'Position', [255 30 285 60],...
         'Tag','OutputDelayBlock');
      add_line(CB,'Internal/1','Tdo/1');
      add_line(CB,'Tdo/1','Out1/1');
end % if ~HasDelayBlock

% Discrete/Continuous checks
if IsContBlock & ~isct(sys), % If discrete, but has cont block, make change
   Orient=get_param(BlockName{1},'orientation');
   Size=get_param(BlockName{1},'position');
   delete_block(BlockName{1});
   add_block('built-in/DiscreteStateSpace',BlockName{1}, ...
      'Orientation',Orient        , ...
      'Position'   ,Size            ...
   );
   set_param([CB,'/Internal' ], ...
      'A'          ,'A' , ...
      'B'          ,'B' , ...
      'C'          ,'C' , ...
      'D'          ,'D' , ...
      'X0'         ,'Xo', ...
      'Sample time','Ts'  ...
      );
   
elseif ~IsContBlock & isct(sys),  % If cont, but has disc block, make change
   Orient=get_param(BlockName{1},'orientation');
   Size=get_param(BlockName{1},'position');
   delete_block(BlockName{1});
   add_block('built-in/StateSpace',BlockName{1}, ...
      'Orientation',Orient        , ...
      'Position'   ,Size            ...
   );
   set_param([CB,'/Internal' ], ...
      'A'          ,'A' , ...
      'B'          ,'B' , ...
      'C'          ,'C' , ...
      'D'          ,'D' , ...
      'X0'         ,'Xo'  ...
      );
   
end % if isdt


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalLTIError(num)

% LocalLTIError contains error messages used by the LTI System block
% which is shipped with the Control System Toolbox

% Written By: Kevin G Kohrt
% Written On: 8 Nov 1996

if nargin==0, num=-1; end

switch num,
case 1, 
   msg=['The LTI system variable must be a valid LTI model.'];
   
case 2,
   msg={'Initial state values are only valid ' ...
         'for State-Space LTI models.' ...
         '' ...
         'The initial state values have been reset to zero.'};
   
case 3,
   msg={'The Initial State vector length must equal the number of states '; 
      'in the LTI object or be a scalar.'};
   
case 4,
   msg='The LTI block does not support negative time delays.';
   
case 6,
   msg={'I/O delays are ignored in the LTI block. '};
   
case 7
   msg={'The LTI block does not support arrays of LTI models.'};
   
case 8
   msg={'The LTI block does not support FRD models.'};
   
otherwise,
   msg='';
   
end % switch

if ~isempty(msg),
   InitFlag=strcmp(get_param(bdroot(gcb),'SimulationStatus'),'initializing');
   if InitFlag,
      errordlg(msg,'Simulink Initialization Error','replace');
   else,
      errordlg(msg,'LTI Block Error','replace');
   end    
end     
