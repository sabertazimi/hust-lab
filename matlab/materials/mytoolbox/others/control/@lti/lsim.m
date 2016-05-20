function [ys,ts,xs] = lsim(varargin)
%LSIM  Simulate time response of LTI models to arbitrary inputs.
%
%   LSIM(SYS,U,T) plots the time response of the LTI model SYS to the
%   input signal described by U and T.  The time vector T consists of 
%   regularly spaced time samples and U is a matrix with as many columns 
%   as inputs and whose i-th row specifies the input value at time T(i).
%   For example, 
%           t = 0:0.01:5;   u = sin(t);   lsim(sys,u,t)  
%   simulates the response of a single-input model SYS to the input 
%   u(t)=sin(t) during 5 seconds.
%
%   For discrete-time models, U should be sampled at the same rate as SYS
%   (T is then redundant and can be omitted or set to the empty matrix).
%   For continuous-time models, choose the sampling period T(2)-T(1) small 
%   enough to accurately describe the input U.  LSIM checks for intersample 
%   oscillations and resamples U if necessary.
%         
%   LSIM(SYS,U,T,X0) specifies an additional nonzero initial state X0
%   (for state-space models only).
%
%   LSIM(SYS1,SYS2,...,U,T,X0)  simulates the response of multiple LTI
%   models SYS1,SYS2,... on a single plot.  The initial condition X0 
%   is optional.  You can also specify a color, line style, and marker 
%   for each system, as in  
%      lsim(sys1,'r',sys2,'y--',sys3,'gx',u,t).
%
%   When invoked with left-hand arguments,
%      [YS,TS] = LSIM(SYS,U,T)
%   returns the output history YS and time vector TS used for simulation.
%   No plot is drawn on the screen.  The matrix YS has LENGTH(TS) rows 
%   and as many columns as outputs in SYS.
%   WARNING: TS contains more points than T when U is resampled to reveal
%   intersample oscillations.  To get the response at the samples T only,
%   extract YS(1:d:end,:) where d=round(length(TS)/length(T)).
%
%   For state-space models, 
%      [YS,TS,XS] = LSIM(SYS,U,T,X0) 
%   also returns the state trajectory XS, a matrix with LENGTH(TS) rows
%   and as many columns as states.
%
%   See also GENSIG, STEP, IMPULSE, INITIAL, LTIMODELS.

%   To compute the time response of continuous-time systems, LSIM uses linear 
%   interpolation of the input between samples for smooth signals, and 
%   zero-order hold for rapidly changing signals like steps or square waves. 
%   When the system dynamics are likely to cause intersample oscillations, 
%   LSIM first resamples the input using linear interpolation where the signal
%   is smooth and zero-order hold near pulses or steps. Since poorly sampled
%   periodic signals may look discontinuous, the sampling rate should always
%   be high enough to reflect the nature of the signal.

%	J.N. Little 4-21-85
%	Revised 7-31-90  Clay M. Thompson
%       Revised A.C.W.Grace 8-27-89 (added first order hold)
%	                    1-21-91 (test to see whether to use foh or zoh)
%	Revised 12-5-95 Andy Potvin
%       Revised 5-8-96  P. Gahinet
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.34 $  $Date: 1998/10/01 20:12:25 $

ni = nargin;
no = nargout;


% Parse input list
t = [];  
nsys = 0;      % counts LTI systems
nstr = 0;      % counts plot style strings 
nutx = 0;
sys = cell(1,ni);
sysname = cell(1,ni);
systype = zeros(1,ni);
Ts = zeros(1,ni);  % sample times
PlotAxes = [];
PlotStyle = cell(1,ni);
x0 = [];
for j=1:ni,
   argj = varargin{j};
   if j==1 & ishandle(argj),
      % LSIM(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      if ~isproper(argj),
         error('Not available for improper systems.')
      else
         nsys = nsys+1;   
         sys{nsys} = argj;
         Ts(nsys) = argj.Ts;
         sysname{nsys} = inputname(j);
         systype(nsys) = isa(argj,'ss')-isa(argj,'tf');
      end
   elseif isa(argj,'char')
      nstr = nstr+1;   PlotStyle{nstr} = argj;
   else
      switch nutx
      case 0
          u = argj;
      case 1
          t = argj(:);
      case 2
          x0 = argj(:);
      otherwise
          error('Must use same U,T,X0 for all systems.')
      end
      nutx = nutx+1;
   end
end
Ts = Ts(1:nsys);
ComputeX = (no>2) & isa(sys{1},'ss');

% Error checking
if nsys==0,
   if no,  
      ys = [];  ts = [];  xs = [];
   else
      warning('All models are empty: no plot drawn.');
   end
   return
elseif no & (nsys>1 | ndims(sys{1})>2),
   error('LSIM with output arguments: can only handle single model.')
elseif nutx==0,
   error('Missing input vector U.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each system or not at all.')
elseif nutx==1 & any(Ts==0)
   error('Time vector T must be supplied for continuous-time models.');
elseif ComputeX & any(sys{1}.ioDelayMatrix(:)),
   error('State trajectory only available for models with zero ioDelayMatrix.')
end  

% Check system dimension compatibility and get sample times
[ny,nu] = size(sys{1});
for j=1:nsys,
   [nyj,nuj] = size(sys{j});
   if nyj~=ny | nuj~=nu,
      error('All models must have the same number of inputs and outputs.')
   end
end

% Check input vector
if isempty(u),
   % Convenience for systems w/o input
   u = zeros(max([size(u),length(t)]),0);
elseif size(u,2)~=nu,
   % Transpose U (users often supply a row vector for SISO systems)
   u = u.';
end
su = size(u);  % #rows = #time samples, #cols = nu
if length(su)>2,
   error('U must be a 2D array.');
elseif su(2)~=nu,
   error('U must have as many columns as the number of inputs.')
elseif length(t)>0 & length(t)~=su(1),
   error('U must have LENGTH(T) rows (number of time samples).')
elseif su(1)<2,
   error('U must have at least two rows (two samples).')
end

% Check time vector
if isempty(t),
   dt = abs(Ts(1));
   if all(Ts==-1) | (dt>0 & all(Ts==dt)),
      % All sample times are equal
      t = dt * (0:1:su(1)-1)';
   else
      error('Discrete-time models must have matching sample times.')
   end
else
   % T supplied 
   t = t(:);
   dt = t(2)-t(1);
   if any(abs(diff(t)-dt) > 1e-3*dt+1e3*eps*abs(t(2:end)))
      error('Time vector T must be evenly spaced.');
   elseif any(Ts>0 & abs(Ts-dt)>1e5*eps*dt),
      error('Sample time of discrete systems must match sampling period of time vector T.')
   elseif abs(t(1))>1e-5*dt,
      % Issue warning if t(1)~=0
      warning('Simulation will start at the nonzero initial time T(1).')
   end
end

% Set initial condition for state-space models
xinit = cell(1,nsys);
if ~isempty(x0),
   ssmodels = find(systype(1:nsys)==1);
   for k=ssmodels,
      if any(sys{k}.ioDelayMatrix(:)),
         error('X0 is ambiguous for state-space models with nonzero ioDelayMatrix.')
      end
   end
   xinit(ssmodels) = {x0};
end


% Convert all models to state-space (simulated with SS/LINRESP)
% except discrete-time TF (simulated with TF/LINRESP)
for j=find(Ts==0 | systype(1:nsys)~=-1),
   sys{j} = ss(sys{j});
end

% Simulate the time response to input U
% Use try/catch due to local error checking on initial condition
if no,
   % Call with output arguments
   try
      if ComputeX,   
         % State vector required
         [ys,ts,xs] = linresp(sys{1},Ts,u,t,x0);
      else
         [ys,ts] = linresp(sys{1},Ts,u,t,x0);
         xs = [];
      end
   catch
      error(lasterr)
   end
   
   if length(ts)>length(t),
      warning('Input U has been resampled to show intersample oscillations.')
   end
   
else
   % Call with graphical output: using LTIPLOT
   if isempty(PlotAxes),
      PlotAxes = get(gcf,'CurrentAxes');
   end
   Ydata = cell(nsys,1);
   tvecs = cell(nsys,1);
   
   % Compute and plot the time response for each system
   for k=1:nsys,
      sk = size(sys{k});
      Ydata{k} = cell([sk(3:end) 1 1]);
      tvecs{k} = cell([sk(3:end) 1 1]);
      try
         for j=1:prod(sk(3:end)),
            [Ydata{k}{j},tvecs{k}{j}] = linresp(sys{k}(:,:,j),Ts(k),u,t,xinit{k});
            
            % Massage data for staircase plot in discrete time
            if Ts(k),
               [tkj,Ydata{k}{j}] = stairs(tvecs{k}{j},Ydata{k}{j});
               tvecs{k}{j} = tkj(:,1);
            end
         end
      catch 
         error(sprintf('Length of X0 does not match state dimension of model #%d.',k))
      end
   end
   
   %---Pass cell array data to LTIPLOT
   LsimRespObj = ltiplot('lsim',sys(1:nsys),PlotAxes,Ydata,tvecs(1:nsys),...
      PlotStyle(1:nsys),'SystemNames',sysname(1:nsys));
   
end



