function sys = linsub(model,hin,hout,varargin)
%LINSUB  Linearizes part of a SIMULINK diagram
%
%   SYS = LINSUB('MODEL',HIN,HOUT)  obtains a linearized state-space 
%   model SYS for some subsystem of the SIMULINK diagram 'MODEL'.
%   The subsystem inputs are defined by the InputPoint blocks with
%   handles HIN, and its outputs by the OutputPoint blocks with
%   handles HOUT.  The state variables and inputs are set to zero.
%
%   SYS = LINSUB('MODEL',HIN,HOUT,T,X,U)  further specifies a
%   linearization point (T,X,U) for the entire diagram, where T is
%   the time, X the structure of state variable names and values and 
%   U the vector of external inputs.  Set X=[] or U=[] as shorthand 
%   for the zero vector of appropriate dimensions.
%
%   When specifying the state variable values, the structure must
%   have the following two fields.
%      Names = cell array of state names
%      Values = vector of state values, in order of state names
%
%   SYS = LINSUB('MODEL',HIN,HOUT,...,OPTIONS)  allows linearization
%   options to be set.  OPTIONS is a structure with field names:
%      Perturbation  - perturbation level for numerical linearization
%                      (default = 1e-5)
%      SampleTime    - sampling time to use for discrete systems
%                      (default is LCM of all sample times found)
%
%   See also  LINMOD, DLINMOD

%   Authors: K. Gondoly, A. Grace, R. Spada, and P. Gahinet
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.11 $

ni = nargin;
error(nargchk(3,7,ni))
switch ni
case 3
   t = 0;  x = [];  u = [];  options = [];
case 4
   t = varargin{1};  x = [];  u = [];  options = [];
case 5
   [t,x] = deal(varargin{1:2});  u = [];  options = [];
case 6
   [t,x,u] = deal(varargin{1:3});  options = [];
end
if isempty(options),
   options = struct('Perturbation',1e-5);
end

% Parameters
nu_sub = length(hin);   % number of InputPoint Blocks
ny_sub = length(hout);  % number of OutputPoint Blocks

% Hin and Hout must be handles of InputPoint or OutputPoint blocks
if ~nu_sub | ~all(ishandle(hin)) | ...
      ~all(strcmp('InputPoint',get_param(hin,'MaskType'))),
   error('HIN must contain handles to InputPoint blocks.')
elseif ~ny_sub | ~all(ishandle(hout)) | ...
      ~all(strcmp('OutputPoint',get_param(hout,'MaskType'))),
   error('HOUT must contain handles to InputPoint blocks.')
end

%--- Resize the Constant Blocks in the Input Points
%--- This must be done while the model is NOT running.
LocalResetConstantBlocks(hin,model,'start');

%--- Prepare OutputPoint blocks for linearization ----

% Replace Terminator by S-function "SIGPROBE" in OutputPoint blocks
% and set output variable names
for i=1:ny_sub
   set_param(hout(i),'SigprobeOutputIndex',num2str(i), ...
      'LinearizationMode','on')
end

% Pre-compile the model
warning_state=warning;
warning('on')
feval(model, [], [], [], 'lincompile');

%--- Determine if the model is discrete or continuous ---
[sizes x0 x_str ts tsx]=feval(model,[],[],[],'sizes');
stateNames = LocalCheckStateNames(x_str); % Check for blocks with multiple states
discflag = (sizes(2) > 0);

%--- Reorder the Initial State Vector, if necessary
if isstruct(x),
   [garb,indOld,indNew]=intersect(x.Names,stateNames);
   x = x.Values;
   if ~isequal(indOld,indNew),
      x(indNew) = x(indOld);
   end
end % if isstruct(x)

%--- Linearize -----------

% Run the linearization algorithm as a subfunction so we can trap errors and <CTRL-C>
lasterr('')
errmsg='';

if discflag
  eval('[A,B,C,D,inNames,outNames,st]=dlinalg(model,hin,hout,t,x,u,options);','errmsg=lasterr;')
else
  eval('[A,B,C,D,inNames,outNames]=linalg(model,hin,hout,t,x,u,options);','errmsg=lasterr;')
  st = 0;
end

% Release the compiled model
feval(model, [], [], [], 'term');

%--- Reset the Constant Blocks in the Input Points to '0'
%--- Resetting the blocks allows the diagram to be changed and relinearized
LocalResetConstantBlocks(hin,model,'stop');

error(errmsg);
warning(warning_state)

%--- Build minimal state-space model

% Build SS model
%stateNames = uniqname(x_str);
inNames = uniqname(inNames);
outNames = uniqname(outNames);
sys = ss(A,B,C,D,'InputName',inNames,'OutputName',outNames,...
                 'StateName',stateNames,'Ts', st);

% Eliminate nonminimal states
sys = sminreal(sys);


%--- Restore original state of OutputPoint blocks ----
for i=1:ny_sub,
   set_param(hout(i),'LinearizationMode','off')
end


% end linsub



%%%%%%%%%% Local functions  %%%%%%%%%%%%%%%%


%------ LINALG ---------


function [A,B,C,D,inNames,outNames] = linalg(model,hin,hout,t,x,u,options)
%LINALG  Performs the partial linearization

%--- Get model dimensions and set operating point -----

sizes = feval(model, [], [], [], 'sizes');
sizes=[sizes(:); zeros(6-length(sizes),1)];
nx = sizes(1);
nu_ext = sizes(4);
ny_ext = sizes(3);

% Consistency checking and set X,U
if isempty(x),
   x = zeros(nx,1);
elseif length(x)~=nx,
   error(sprintf('X must be a vector of length %d.',nx))
end

if isempty(u),
   u = zeros(nu_ext,1);
elseif length(u)~=nu_ext,
   error(sprintf('U must be a vector of length %d.',nu_ext))
end

%--- Perform the partial linearization -----

% Find how many signals are associated with each Input/OutputPoint

InputPorts = get_param(hin,'CompiledPortWidths');
if iscell(InputPorts),
   InputPorts = cat(1,InputPorts{:});
end
nu_sub = sum([InputPorts.Outport]);  % total number of subsystem inputs

OutputPorts = get_param(hout,'CompiledPortWidths');
if iscell(OutputPorts),
   OutputPorts = cat(1,OutputPorts{:});
end
ny_sub = sum([OutputPorts.Outport]);  % total number of subsystem outputs

A = zeros(nx,nx);      B = zeros(nx,nu_sub); 
C = zeros(ny_sub,nx);  D = zeros(ny_sub,nu_sub);
inNames=cell(nu_sub,1);
outNames=cell(ny_sub,1);

ystr = '[';
numout=0;
for i=1:length(hout),
   Hout_name = getfullname(hout(i));
   outNames(numout+1:numout+OutputPorts(i).Outport)={Hout_name};
   numout = numout+OutputPorts(i).Outport;
   ystr = [ystr 'y' num2str(i) ';'];
end
ystr = [ystr(1:end-1) ']'];
pert = options.Perturbation;

% Evaluate the A and C matrices by perturbing x
% RE: uses centered differences for o(h^2) accuracy in nonlinear case
xpert = pert * (1 + 0.001 * abs(x));
for i=1:nx;
   xp = x;   
   
   % Perturb x(i) -> x(i) + dx(i) and evaluate dX/dt and Y
   xp(i) = xp(i) + xpert(i);
   junk = feval(model, t, xp, u, 'outputs');
   yp = eval(ystr);
   dxp = feval(model, t, xp, u, 'derivs');
   
   % Perturb x(i) -> x(i) - dx(i) and evaluate dX/dt and Y
   xp(i) = xp(i) - 2 * xpert(i);
   junk = feval(model, t, xp, u, 'outputs');
   ym = eval(ystr);
   dxm = feval(model, t, xp, u, 'derivs');
   
   % Get A(:,i) and C(:,i)
   A(:,i) = (dxp-dxm)/(2*xpert(i));
   C(:,i) = (yp-ym)/(2*xpert(i));
end


% Evaluate the B and D matrices by perturbing the subsystem inputs
numin=0;
for i=1:length(hin), %nu_sub,
   Hin_name = getfullname(hin(i));
   for ctIn=1:InputPorts(i).Inport,
      numin=numin+1;
      inNames{numin} = Hin_name;
      % Perturb Usub(i) -> pert
      Upert = zeros(1,InputPorts(i).Inport);
      Upert(ctIn)=pert;
      set_param(hin(i),'PerturbationValue',['[',mat2str(Upert),']']);
      junk = feval(model, t, x, u, 'outputs');
      yp = eval(ystr);
      dxp = feval(model, t, x, u, 'derivs');
      
      % Perturb Usub(i) -> -pert
      set_param(hin(i),'PerturbationValue',['[',mat2str(-Upert),']']);
      junk = feval(model, t, x, u, 'outputs');
      ym = eval(ystr);
      dxm = feval(model, t, x, u, 'derivs');
      
      % Get B(:,i) and D(:,i)
      B(1:nx,numin) = (dxp-dxm)/(2*pert);
      D(1:ny_sub,numin) = (yp-ym)/(2*pert);
   end % for ctIn
   set_param(hin(i),'PerturbationValue',...
      ['[',mat2str(zeros(1,InputPorts(i).Inport)),']']);
end % for i

% end linalg


%------ DLINALG ---------


function [A,B,C,D,inNames,outNames,st] = dlinalg(model,hin,hout,t,x,u,options)
%DLINALG  Performs the partial linearization

%--- Get model dimensions and set operating point -----

[sizes x0 x_str ts tsx]=feval(model,[],[],[],'sizes');
sizes=[sizes(:); zeros(6-length(sizes),1)];
nx = sizes(1);
nxz = sizes(1)+sizes(2);
nu_ext = sizes(4);
ny_ext = sizes(3);

if ~isempty(tsx), tsx = tsx(:,1); end

% Consistency checking and set X,U
if isempty(x),
   x = zeros(nxz,1);
elseif length(x)~=nxz,
   error(sprintf('X must be a vector of length %d.',nxz))
end

if isempty(u),
   u = zeros(nu_ext,1);
elseif length(u)~=nu_ext,
   error(sprintf('U must be a vector of length %d.',nu_ext))
end

%--- Perform the partial linearization -----

% Find how many signals are associated with each Input/OutputPoint
InputPorts = get_param(hin,'CompiledPortWidths');
if iscell(InputPorts),
   InputPorts = cat(1,InputPorts{:});
end
OutputPorts = get_param(hout,'CompiledPortWidths');
if iscell(OutputPorts),
   OutputPorts = cat(1,OutputPorts{:});
end

nu_sub = sum([InputPorts.Inport]);   % total number of subsystem inputs
ny_sub = sum([OutputPorts.Outport]);  % total number of subsystem outputs

A = zeros(nxz,nxz);     B = zeros(nxz,nu_sub); 
C = zeros(ny_sub,nxz);  D = zeros(ny_sub,nu_sub);
inNames=cell(nu_sub,1);
outNames=cell(ny_sub,1);

ystr = '[';
numout=0;
for i=1:length(hout),
   Hout_name = getfullname(hout(i));
   outNames(numout+1:numout+OutputPorts(i).Outport)={Hout_name};
   numout = numout+OutputPorts(i).Outport;
   ystr = [ystr 'y' num2str(i) ';'];
end
ystr = [ystr(1:end-1) ']'];
pert = options.Perturbation;

% REVISIT after propagating option.SampleTime into calling functions
if isfield(options,'SampleTime')
  st = options.SampleTime;
else
  st = -1;
end

ts = [0 0; ts];

% Eliminate sample times that are the same with different offsets.
tsnew = unique(ts(:,1));
[nts] = length(tsnew);

% LCM of all sampling times, excluding zero
if st < 0
  % we wouldn't be here if there wasn't a discrete block..
  st = local_vlcm(tsnew(find(tsnew>0)));
  if st > 100*max(tsnew)
    warnc={'Least common multiple of all sample times is',...
           'significantly larger than the largest sample',...
           'time found.',...
           '',...
           'Important dynamics may be lost.'};
    warndlg(warnc,'Simulink LTI Viewer Warning');
  end
end

% Initialize A and B, prepare for loop over sample times
A = zeros(nxz,nxz); B = zeros(nxz, nu_sub); Acd = A; Bcd = B;
Aeye = eye(nxz,nxz);

% Starting with smallest sample time, convert those models to the
% next smallest sample time.  Each pass through the loop removes a
% sample time from the list (and from the model).  Stop when the
% system is single-rate.

for m = 1:nts
  % Choose the next sample time
  if length(tsnew) > 1
    stnext = min(st, tsnew(2));
  else
    stnext = st;
  end
  storig = tsnew(1);
  index = find(tsx == storig);          % states with Ts = storig
  nindex = find(tsx ~= storig);         % states with another Ts
  oldA = Acd;
  oldB = Bcd;

  %% Begin linearization algorithm 

  %% This code block performs the simple linearization based on perturbations
  %% about x0, u0.  A sample time is specified not as the time at which the
  %% linearization occurs, but rather as a "granularity" or sampling time over
  %% which we are interested.  Thus, states with long sampling times will not
  %% change due to perturbations/linearization around shorter sampling times.

  %% Here t really is the time at which linearization occurs, same as linmod.
  %% storig is the sampling time for the current linearization

  feval(model, storig, [], [], 'all');    % update blocks with Ts <= storig
  Acd=zeros(nxz,nxz); Bcd=zeros(nxz,nu_sub);
  C=zeros(ny_sub,nxz); D=zeros(ny_sub,nu_sub);

  % Compute unperturbed values (must occur each time through the loop,
  % after the call to 'all' with a given sampling time.  Otherwise, 
  % linearizations about nonzero initial states might get munged.

  % RE: uses centered differences for o(h^2) accuracy in nonlinear case
  xpert = pert * (1 + 0.001 * abs(x));
  for i=1:nxz;
     xp = x;   
   
     % Perturb x(i) -> x(i) + dx(i) and evaluate dX/dt and Y
     xp(i) = xp(i) + xpert(i);
     junk = feval(model, t, xp, u, 'outputs');
     yp = eval(ystr);
     dxp = feval(model, t, xp, u, 'derivs');
     dsp = feval(model, t, xp, u, 'update');
   
     % Perturb x(i) -> x(i) - dx(i) and evaluate dX/dt and Y
     xp(i) = xp(i) - 2 * xpert(i);
     junk = feval(model, t, xp, u, 'outputs');
     ym = eval(ystr);
     dxm = feval(model, t, xp, u, 'derivs');
     dsm = feval(model, t, xp, u, 'update');
   
     % Get A(:,i) and C(:,i)
     Acd(:,i) = ([dxp;dsp]-[dxm;dsm])/(2*xpert(i));
     C(:,i) = (yp-ym)/(2*xpert(i));
  end

  % Evaluate the B and D matrices by perturbing the subsystem inputs
  numin=0;
  for i=1:length(hin), %nu_sub,
     Hin_name = getfullname(hin(i));
    for ctIn=1:InputPorts(i).Inport,
      numin=numin+1;
      inNames{numin} = Hin_name;
      % Perturb Usub(i) -> pert
      Upert = zeros(1,InputPorts(i).Inport);
      Upert(ctIn)=pert;
      set_param(hin(i),'PerturbationValue',['[',mat2str(Upert),']']);
      junk = feval(model, t, x, u, 'outputs');
      yp = eval(ystr);
      dxp = feval(model, t, x, u, 'derivs');
      dsp = feval(model, t, x, u, 'update');
      
      % Perturb Usub(i) -> -pert
      set_param(hin(i),'PerturbationValue',['[',mat2str(-Upert),']']);
      junk = feval(model, t, x, u, 'outputs');
      ym = eval(ystr);
      dxm = feval(model, t, x, u, 'derivs');
      dsm = feval(model, t, x, u, 'update');
      
      % Get B(:,i) and D(:,i)
      Bcd(1:nxz,numin) = ([dxp;dsp]-[dxm;dsm])/(2*pert);
      D(1:ny_sub,numin) = (yp-ym)/(2*pert);
    end % for ctIn
    set_param(hin(i),'PerturbationValue',['[',mat2str(zeros(1,InputPorts(i).Inport)),']']);
  end % for i

  %% End linearization algorithm (formerly LINALL)

  % Update A, B matrices with any new information
  % Any differences between this linearization (Acd) and the last (oldA)
  % get premultiplied by the ZOH B-matrix associated with those states..
  % see the update method for Aeye below.

  A = A + Aeye * (Acd - oldA);
  B = B + Aeye * (Bcd - oldB);
  n = length(index);

  % Convert states at Ts=storig to sample time stnext
  % States with Ts > storig are treated as inputs (since they are constant
  % over one period at storig..) so the relevant columns of A are treated
  % as columns of B instead, via premultiplication by bd2.

  if n & storig ~= stnext
    if storig ~=  0
      if stnext ~= 0
        [ad2,bd2] = d2d(A(index, index),eye(n,n),storig, stnext);
      else
	% we'll never get here unless users can specify a sample rate
        [ad2,bd2] = d2c(A(index, index),eye(n,n),storig);	
      end
    else
      [ad2,bd2] = c2d(A(index, index),eye(n,n),stnext);
    end
    A(index, index)  =  ad2;

    if length(nindex)
      A(index, nindex) = bd2*A(index,nindex);
    end
    if nu_sub
      B(index,:) = bd2*B(index,:);
    end

    % Any further updates to these states also get hit with bd2
    Aeye(index,index) = bd2*Aeye(index,index);
    tsx(index) =  stnext(ones(length(index),1));
  end

  % Remove this sample time (storig) from the list
  tsnew(1) = [];
end

if norm(imag(A), 'inf') < sqrt(eps), A = real(A); end
if norm(imag(B), 'inf') < sqrt(eps), B = real(B); end

% end DLINALG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalResetConstantBlocks %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalResetConstantBlocks(hin,model,SimFlag);

%---When linsub is called from slview, the model should have just
%      been compiled.

switch SimFlag,
case 'start'
   feval(model, [], [], [], 'compile');
   IP = find_system(hin,'LookUnderMasks','all','FollowLinks','on','blocktype','Inport');
   CP = get_param(IP,'CompiledPortWidths');
   feval(model, [], [], [], 'term');

   % Structure in single handle case, cell otherwise.. ugh.
   if ~iscell(CP), CP = {CP}; end
  
   for ct=1:length(hin)
     set_param(hin(ct),'PerturbationValue',mat2str(zeros(1,CP{ct}.Outport)), ...
     		'LinearizationMode','on')
   end

case 'stop',
   for ct=1:length(hin)
     set_param(hin(ct),'PerturbationValue','0', ...
     		'LinearizationMode','off')
   end
end % switch SimFlag


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% local_vlcm         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = local_vlcm(x)
% VLCM  find least common multiple of several sample times

[a,b]=rat(x);
bound = prod(b);
v = b(1):b(1):bound;
for k = 2:length(b), v=intersect(v,b(k):b(k):bound); end
d = min(v);

y = round(d*x);		% integers
bound = prod(y);
v = y(1):y(1):bound;
for k = 2:length(y), v=intersect(v,y(k):y(k):bound); end
M = min(v)/d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalCheckStateNames %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xNames = LocalCheckStateNames(xNames);

%---Append numbers to blocks with multiple states
[xTemp,ix,jx] = unique(xNames);
if length(xTemp) < length(xNames),
   for k=1:length(xNames)
      if jx(k) > 0
         kx = find(jx==jx(k));
         if length(kx) > 1 
            for n=1:length(kx)
               xNames{kx(n)} = [xNames{kx(n)} '(' int2str(n) ')'];
            end
            jx(kx) = zeros(size(kx));
         end
      end % if jx(k)>0
   end % for k
end % if length(xTemp)...   
