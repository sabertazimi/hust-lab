function [yout,t,x] = initial(varargin)
%INITIAL  Initial condition response of state-space models.
%
%   INITIAL(SYS,X0) plots the undriven response of the state-space 
%   model SYS with initial condition X0 on the states.  This 
%   response is characterized by the equations
%                        .
%     Continuous time:   x = A x ,  y = C x ,  x(0) = x0 
%
%     Discrete time:  x[k+1] = A x[k],  y[k] = C x[k],  x[0] = x0 .
%
%   The time range and number of points are chosen automatically.  
%
%   INITIAL(SYS,X0,TFINAL) simulates the time response from t=0 
%   to the final time t=TFINAL.  For discrete-time models with 
%   unspecified sample time, TFINAL should be the number of samples.
%
%   INITIAL(SYS,X0,T) specifies a time vector T to be used for 
%   simulation.  For discrete systems, T should be of the form  
%   0:Ts:Tf where Ts is the sample time.  For continuous-time models,
%   T should be of the form 0:dt:Tf where dt will become the sample
%   time of a discrete approximation of the continuous model.
%
%   INITIAL(SYS1,SYS2,...,X0,T) plots the response of multiple LTI 
%   models SYS1,SYS2,... on a single plot.  The time vector T is 
%   optional.  You can also specify a color, line style, and marker 
%   for each system, as in  
%      initial(sys1,'r',sys2,'y--',sys3,'gx',x0).
%
%   When invoked with left hand arguments,
%      [Y,T,X] = INITIAL(SYS,X0)
%   returns the output response Y, the time vector T used for simulation, 
%   and the state trajectories X.  No plot is drawn on the screen.  The
%   matrix Y has LENGTH(T) rows and as many columns as outputs in SYS.
%   Similarly, X has LENGTH(T) rows and as many columns as states.
%	
%   See also IMPULSE, STEP, LSIM, LTIVIEW, LTIMODELS.

%	Clay M. Thompson  7-6-90
%	Revised ACWG 6-21-92
%	Revised PG 4-25-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.21 $  $Date: 1998/10/01 20:12:31 $


ni = nargin;
no = nargout;
if ni==0,
   eval('exresp(''initial'',1)')
   return
end

% Parse input list
t = [];   
Tfinal = [];
nsys = 0;      % counts LTI systems
nstr = 0;      % counts plot style strings 
ndb = 0;
sys = cell(1,ni);
sysname = cell(1,ni);
Ts = zeros(1,ni);  % sample times
PlotAxes = [];
PlotStyle = cell(1,ni);
for j=1:ni,
   argj = varargin{j};
   if j==1 & ishandle(argj),
      % INITIAL(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      sj = size(argj);
      if ~isa(argj,'ss')
         error('INITIAL is only applicable to state-space models.')
      elseif length(size(argj,'order'))>1,
         error('Models in state-space array must have uniform number of states.') 
      elseif any(argj.ioDelayMatrix(:)),
         error('INITIAL is only applicable to models with input or output delays.')
      elseif all(sj(3:end)) & (sj(1) | no>2)
         % Note: allow for free response of dx/dt=Ax with output args
         nsys = nsys+1;   
         sys{nsys} = argj;
         Ts(nsys) = argj.Ts;
         sysname{nsys} = inputname(j);
      end   
   elseif isa(argj,'char')
      nstr = nstr+1;   PlotStyle{nstr} = argj;
   elseif ndb==0,
      ndb = ndb+1;   x0 = argj(:);
   elseif isequal(size(argj),[1 1]),
      ndb = ndb+1;   Tfinal = argj; 
   else
      ndb = ndb+1;   t = argj;
   end
end
Ts = Ts(1:nsys);

% Error checking
if nsys==0,
   if no==0, 
      warning('All models are empty: no plot drawn.'); 
   else
      yout = [];  t = [];  x = [];   
   end
   return
elseif no & (nsys>1 | ndims(sys{1})>2),
   error('INITIAL with output arguments: can only handle single model.')
elseif ndb==0,
   error('Missing initial state vector X0.')
elseif ndb>2,
   error('Must use same initial condition X0 and time vector T for all systems.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each system or not at all.')
elseif isempty(t) & any(Ts==-1) & any(Ts~=-1),
   error('Cannot mix specified and unspecified sample times unless you specify T.')
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
sizes = size(sys{1});
ny = sizes(1);
nu = sizes(2);
nx = size(sys{1},'order');
for j=2:nsys,
   sj = size(sys{j});
   if ~isequal([ny nx],[sj(1) size(sys{j},'order')])
      error('All models must have the same number of outputs and states.')
   end
end

% Check initial condition X0
if ~isreal(x0) | ndims(x0)>2 | length(x0)~=nx,
   error(sprintf('X0 should be a vector of length %d.',nx))
end
x0 = x0(:);

% Check time vector T if supplied, generate it otherwise
if isempty(t), 
   % Generate time vectors TVECS for each model
   if all(Ts==-1),
      % Adjust TFINAL when all sample times are unspecified
      % N samples -> simulate from 0 to N-1 (note: harmless when TFINAL=[])
      Tfinal = Tfinal-1;   % n samples -> 0 to n-1
   end

   % Generate appropriate time vector for each system
   tvecs = trange('initial',Tfinal,x0,sys{1:nsys});
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


% Simulate the initial response
if no,
   % Call with output arguments
   t = tvecs{1}{1};
   [yout,t,x] = initresp(sys{1},Ts,t,t0,x0);

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
         [Ydata{k}{j},tvecs{k}{j}] = initresp(sys{k}(:,:,j),Ts(k),tvecs{k}{j},t0,x0);
      
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
   InitRespObj = ltiplot('initial',sys(1:nsys),PlotAxes,Ydata,tvecs(1:nsys),PlotStyle(1:nsys),...
      'SystemNames',sysname(1:nsys));

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,t,x] = initresp(sys,Ts,t,t0,x0)
%INITRESP  Initial response of a single LTI model
%
%   [Y,T,X] = INITRESP(SYS,TS,T,T0,X0) computes the initial response
%   of the LTI model SYS with sample time TS at the time stamps T
%   (starting at t=0).  The response from t=0 to t=T0 is discarded 
%   if T0>0.

lt = length(t);
dt = t(2)-t(1);
[ny,nu] = size(sys);
nx = size(sys,'order');

% Discretize if continuous
if Ts==0,
   sys.InputDelay = zeros(nu,1);
   sys = c2d(sys,dt);
end

% Simulate state trajectory with LTITR
[a,b,c] = ssdata(sys);
nxd = size(a,1);
x = ltitr(a,zeros(nxd,1),zeros(lt,1),[x0;zeros(nxd-nx,1)]);

% Compute output
Tdout = sys.OutputDelay;
if ~any(Tdout),
   y = x * c.';
else
   ctr = c.';
   y = zeros(lt,ny);
   for i=1:ny,
      y(Tdout(i)+1:lt,i) = x(1:lt-Tdout(i),:) * ctr(:,i);
   end
end

% Truncate state vector if augmented by C2D
if nxd>nx,
   x = x(:,1:nx);
end

% Clip response if T0>0
if t0>0,  
   keep = find(t>=t0);
   y = y(keep,:,:);   
   t = t(keep);  
   if ComputeX,
      x = x(keep,:,:);
   end
end
      

