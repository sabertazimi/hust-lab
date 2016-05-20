function [yout,t,x] = impulse(varargin)
%IMPULSE  Impulse response of LTI models.
%
%   IMPULSE(SYS) plots the impulse response of the LTI model SYS (created 
%   with either TF, ZPK, or SS).  For multi-input models, independent
%   impulse commands are applied to each input channel.  The time 
%   range and number of points are chosen automatically.  For continuous 
%   systems with direct feedthrough, the infinite pulse at t=0 is 
%   disregarded.
%
%   IMPULSE(SYS,TFINAL) simulates the impulse response from t=0 to the 
%   final time t=TFINAL.  For discrete-time systems with unspecified 
%   sampling time, TFINAL is interpreted as the number of samples.
%
%   IMPULSE(SYS,T) uses the user-supplied time vector T for simulation. 
%   For discrete-time models, T should be of the form  Ti:Ts:Tf  
%   where Ts is the sample time.  For continuous-time models, 
%   T should be of the form  Ti:dt:Tf  where dt will become the sample 
%   time of a discrete approximation to the continuous system.  The
%   impulse is always assumed to arise at t=0 (regardless of Ti).
%
%   IMPULSE(SYS1,SYS2,...,T) plots the step response of multiple
%   LTI models SYS1,SYS2,... on a single plot.  The time vector T is 
%   optional.  You can also specify a color, line style, and marker 
%   for each system, as in  
%      impulse(sys1,'r',sys2,'y--',sys3,'gx').
%
%   When invoked with left-hand arguments,
%      [Y,T] = IMPULSE(SYS) 
%   returns the output response Y and the time vector T used for 
%   simulation.  No plot is drawn on the screen.  If SYS has NY
%   outputs and NU inputs, and LT=length(T), Y is an array of size
%   [LT NY NU] where Y(:,:,j) gives the impulse response of the 
%   j-th input channel.
%
%   For state-space models, 
%      [Y,T,X] = IMPULSE(SYS, ...) 
%   also returns the state trajectory X which is an LT-by-NX-by-NU 
%   array if SYS has NX states.
%
%   See also  STEP, INITIAL, LSIM, LTIVIEW, LTIMODELS.

%	J.N. Little 4-21-85
%	Revised: 8-1-90  Clay M. Thompson, 2-20-92 ACWG, 10-1-94 
%	Revised P. Gahinet, 4-24-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.29 $  $Date: 1998/10/01 20:12:24 $

ni = nargin;
no = nargout;
if ni==0, 
   eval('exresp(''impulse'')')
   return
end

% Parse input list
t = [];   
Tfinal = [];   % final time
nsys = 0;      % counts LTI systems
nstr = 0;      % counts plot style strings 
ntvec = 0;     % counts time vector inputs
sys = cell(1,ni);
sysname = cell(1,ni);
systype = zeros(1,ni);
Ts = zeros(1,ni);  % sample times
PlotAxes = [];
PlotStyle = cell(1,ni);
for j=1:ni,
   argj = varargin{j};
   if j==1 & ishandle(argj),
      % IMPULSE(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      if ~isproper(argj),
         error('Not available for improper systems.')
      elseif ~isempty(argj)
         nsys = nsys+1;   
         sys{nsys} = argj;
         Ts(nsys) = argj.Ts;
         sysname{nsys} = inputname(j);
         systype(nsys) = ~isa(argj,'tf');
      end   
   elseif ischar(argj)
      nstr = nstr+1;   PlotStyle{nstr} = argj;
   elseif isequal(size(argj),[1 1]),
      ntvec = ntvec+1;   Tfinal = argj; 
   else
      ntvec = ntvec+1;   t = argj(:);
   end
end
Ts = Ts(1:nsys);
ComputeX = (no>2) & isa(sys{1},'ss');

% Error checking
if nsys==0,
   % Quick exit for empty systems
   if no,  
      yout = [];  t = [];  x = [];
   else
      warning('All models are empty: no plot drawn.');
   end
   return
elseif no & (nsys>1 | ndims(sys{1})>2),
   error('IMPULSE with output arguments: can only handle single model.')
elseif ntvec>1,
   error('Must use same time vector or final time for all models.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each model or not at all.')
elseif isempty(t) & any(Ts==-1) & any(Ts~=-1),
   error('Cannot mix specified and unspecified sample times unless you specify T.')
elseif ComputeX & any(any(diff(diff(sys{1}.ioDelayMatrix,[],1),[],2))),
   error('State trajectory only available for models with zero ioDelayMatrix.')
elseif ~isempty(t),
   % Supplied time vector T
   if any(diff(t)<=0),
      error('Time samples T must be monotonically increasing.')
   elseif any(abs(Ts(Ts>0)/(t(2)-t(1))-1)>1e-4),
      error('Spacing of time samples T should match sample period of discrete models.')
   end
elseif ~isempty(Tfinal),
   % Supplied final time TFINAL
   if Tfinal<=0,
      error('Final time must be positive.')
   elseif all(Ts==-1) & ~isequal(Tfinal,round(Tfinal))
      error('Final time must be an integer (No. of samples) when sample times are unspecified.');
   end
end  

% Check system dimension compatibility and get sample times
[ny,nu] = size(sys{1});
for j=2:nsys,
   [nyj,nuj] = size(sys{j});
   if nyj~=ny | nuj~=nu,
      error('All models must have the same number of inputs and outputs.')
   end
end

% Check time vector T if supplied, generate it otherwise
if isempty(t), 
   % Generate time vectors TVECS for each model
   if all(Ts==-1),
      % Adjust TFINAL when all sample times are unspecified
      % N samples -> simulate from 0 to N-1 (note: harmless when TFINAL=[])
      Tfinal = Tfinal-1;   % n samples -> 0 to n-1
   end

   % Generate appropriate time vector for each system
   tvecs = trange('impulse',Tfinal,[],sys{1:nsys});
   t0 = 0;

else
   % Supplied time vector T 
   t0 = t(1);       % to handle case T(1) is not zero
   dt = t(2)-t(1);
   
   % Override T if not evenly spaced
   nt0 = round(t0/dt);
   t0 = nt0*dt;
   t = dt * (0:1:nt0+length(t)-1)';
   
   % Create TVECS (store one copy of T per model)
   tvecs = cell(1,nsys);
   for k=1:nsys,
      sk = size(sys{k});
      tvecs{k} = repmat({t},[sk(3:end) 1 1]);
   end
end


% Convert all models to state-space (simulated with SS/STEPRESP)
% except discrete-time TF (simulated with TF/STEPRESP)
for j=find(Ts==0 | systype(1:nsys)),
   sys{j} = ss(sys{j});
end

% Simulate the impulse response
if no,
   % Call with output arguments
   t = tvecs{1}{1};
   if ComputeX,   
      % State vector required
      [yout,t,x] = impresp(sys{1},Ts,t,t0);
   else
      [yout,t] = impresp(sys{1},Ts,t,t0);
      x = [];
   end

else
   % Call with graphical output: plot using LTIPLOT
   if isempty(PlotAxes),
      PlotAxes = get(gcf,'CurrentAxes');
   end
   Ydata = cell(nsys,1);

   % Compute and plot the step response for each system
   for k=1:nsys,
      sk = size(sys{k});
      Ydata{k} = cell([sk(3:end) 1 1]);
      for j=1:prod(sk(3:end)),
         [Ydata{k}{j},tvecs{k}{j}] = impresp(sys{k}(:,:,j),Ts(k),tvecs{k}{j},t0);
      
         % Massage data for staircase plot in discrete time
         if Ts(k),
            sy = size(Ydata{k}{j});
            [tkj,ykj] = stairs(tvecs{k}{j},Ydata{k}{j}(:,:));
            tvecs{k}{j} = tkj(:,1);
            Ydata{k}{j} = reshape(ykj,[size(tkj,1) sy(2:end)]);
         end
      end
   end
      
   %---Pass cell array data to LTIPLOT
   ImpRespObj = ltiplot('impulse',sys(1:nsys),PlotAxes,Ydata,tvecs(1:nsys),PlotStyle(1:nsys),...
      'SystemNames',sysname(1:nsys));

end


