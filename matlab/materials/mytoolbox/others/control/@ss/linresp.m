function [y,t,x] = linresp(sys,Ts,u,t,x0)
%LINRESP   Time response simulation for LTI model.
%
%   [Y,T,X] = LINRESP(SYS,TS,U,T,X0) simulates 
%   the time response of the LTI model SYS to the 
%   input U and initial condition X0.  TS is the 
%   sample time of SYS and T is the vector of time
%   stamps.
%
%   LOW-LEVEL UTILITY, CALLED BY LSIM.

%   Author: P. Gahinet, 4-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/09/01 14:11:57 $

dthresh = 0.45;    % threshold for discontinuity detection
tolint = 1e4*eps;  % detection of fractional delays
method = 'zoh';    % default
dt = t(2)-t(1);    % sampling time
ComputeX = (nargout>2);

% Dimensions
[ny,nu] = size(sys.d); 
nx = size(sys.a,1);

% Check initial condition
if isempty(x0)
   % Set initial condition to zero if not provided
   x0 = zeros(nx,1);
elseif length(x0)~=nx, 
   error('Length of X0 does not match number of states.')
end

% Preprocessing for continuous case: determine whether to use ZOH or FOH
if Ts==0,
   % Estimate if signal is smooth or discontinuous (continuous time)
   % After normalizing amplitude, declare the input smooth if the max.
   % variation per sample does not exceeds 45% of amplitude range
   range = max(max(u)-min(u));
   du = abs(diff(u));
   if ~isempty(du) & max(du(:))<dthresh*range,
      method = 'foh';
   end
end

% Check for undersampling
trange = t(end)-t(1);
if Ts==0 & nx>0 & dt>trange/1000,
   % Refine sampling if system is continuous and has resonant modes 
   % beyond the nyquist frequency
   nf = pi/dt;
   r = eig(sys.a);
   r = r(imag(r)>0 & abs(real(r))<0.2*abs(r));   % resonant modes
   mf = max(abs(r));        % frequency of fastest resonant mode

   if mf > nf/2,
      % Resample input
      t0 = t;
      dtopt = max(pi/2/mf,trange/1000);   % optimal sample period
      OverSampling = 2^max(1,nextpow2(round(dt/dtopt)));
      dt = dt/OverSampling;
      t = (t(1):dt:t(end)+0.1*dt)';

      % Inperpolate original input data 
      if nu==0,
         u = zeros(length(t),0);
      elseif strcmp(method,'foh')
         % Continuous signal: perform linear interpolation
         u = interp1(t0,u,t);
      else  
         % Signal may contain pulses or steps: use linear interpolation
         % where continuous and zoh interpolation elsewhere
         u = interpd(t0,u,du,t,dt,dthresh);
      end
   end   
end
lt = length(t);


% Simulation starts
if strcmp(method,'zoh'),
   % Discrete-time model or ZOH discretization of continuous-time model
   if Ts==0,
      % ZOH discretization
      sys = c2d(sys,dt);
      x0 = [x0 ; zeros(size(sys.a,1)-nx,1)];  % watch for state augmentation by C2D
   end
   
   % Extract state-space matrices and discrete delay data 
   [a,b,c,d] = ssdata(sys);
   DelayData = get(sys.lti,{'inputdelay','outputdelay','iodelay'});
   [id,od,iod] = deal(DelayData{:});
   ziod = all(~iod,1);  % input channels w/o I/O delays
   
   % Simulate with SIMRESP (LTITR)
   % First simulate channels w/o I/O delays
   [y,x] = simresp(a,b(:,ziod),c,d(:,ziod),id(ziod),od,u(:,ziod),x0);
   
   % Now simulate each input channel with internal I/O delays and 
   % superpose outputs. Note: x0 and ComputeX are both zero in this case
   for j=find(~ziod),
      tdj = id(j) + od + iod(:,j); % total delay
      tdmin = min(tdj);
      [aj,bj,cj] = smreal(a,b(:,j),c,[]);
      y = y + simresp(aj,bj,cj,d(:,j),...
                       tdmin,tdj-tdmin,u(:,j),zeros(size(aj,1),1));
   end
   
   % Extract original states (watch for augmented state dimension)
   if ComputeX,
      x = x(:,1:nx); 
   end    
   
else
   % Continuous-time system + FOH discretization.
   % FOH discretization produces the model
   %     z[k+1] = exp(A*dt) * z[k] + Bd * u[k]
   %       y[k] =     Cd    * z[k] + Dd * u[k]
   % where z[k] = x[k] - G * u[k]
   % For simulation, the initial condition must be set to z[0]=x0-G*u(1),
   % and the state trajectory is obtained as z[k] + G * u[k].
   % Note: Direct FOH simulation runs into trouble for delayed input 
   % channels with nonzero u(1) (FOH implicitly interpolates the
   % input between u=0 at t=-dt and the first value u=u(1) at t=0).
   % Addressed by setting u(1)=0 for such channels and simulating
   % the response to the step offset w(t)=u(1) with ZOH method.
   
   % Minimize the number of nonzero continuous input delays when x0=0
   Cdelays = get(sys.lti,{'inputdelay','outputdelay','iodelay'});
   [cid,cod,ciod] = deal(Cdelays{:});
   if ~any(x0) & ~any(ciod(:)),
      cidmin = min(cid);
      cid = cid - cidmin;
      cod = cod + cidmin;
      sys.lti = set(sys.lti,'inputdelay',cid,'outputdelay',cod);
   end
   
   % FOH discretization
   [sysfoh,gic] = c2d(sys,dt,'foh');
    
   % Extract SS data and discrete delays 
   [af,bf,cf,df] = ssdata(sysfoh);
   Ddelays = get(sysfoh.lti,{'inputdelay','outputdelay','iodelay'});
   [id,od,iod] = deal(Ddelays{:});
   ziod = all(~iod,1);  % input channels w/o I/O delays
   nzfod = (cod>(od+tolint)*dt); % output channels with fract. delay
   
   % Determine if additional ZOH simulation is necessary
   zohsim = ((cid'>0 | ~ziod) & u(1,:));
   if any(zohsim),
      % ZOH discretization
      if ComputeX,
         % Make sure to match FOH state dimension
         [az,bz,cz,dz] = ssdata(c2d(sys,dt));
         bz = bz(:,zohsim);   dz = dz(:,zohsim);
      else
         systmp = sminreal(subsref(sys,substruct('()',{':' zohsim})));
         [az,bz,cz,dz] = ssdata(c2d(systmp,dt));
      end
      idz = id(zohsim);
      % Save first input value
      u0 = u(1,zohsim);
      u(:,zohsim) = u(:,zohsim) - u0(ones(1,lt),:);
   end
   
   % FOH simulation of channels without internal I/O delays.
   % Note: u(1,j) set to zero for channels with input delay
   z0 = gic(:,[1:nx nx+find(ziod)]) * [x0 ; u(1,ziod)'];
   [y,z] = simresp(af,bf(:,ziod),cf,df(:,ziod),id(ziod),od,u(:,ziod),z0,nzfod);
   
   % Superpose ZOH simulation of response to steps u(1,ZOHSIM) 
   % (with zero initial condition)
   xu0 = 0;
   if any(ziod & zohsim),
      sel = find(ziod(zohsim));
      [yu0,xu0] = ...
         simresp(az,bz(:,sel),cz,dz(:,sel),idz(sel),od,u0(ones(1,lt),sel),0);
      y = y + yu0;
   end
   
   % Simulate each input channel with internal I/O delays and 
   % superpose outputs. Note: x0=0 when there are I/O delays, 
   % and u(1,j) is set to zero for such channels.
   for j=find(~ziod),
      tdj = id(j) + od + iod(:,j); % total discrete delay
      % Squeeze subsystem order and simulate
      [afj,bfj,cfj] = smreal(af,bf(:,j),cf,[]);
      y = y + simresp(afj,bfj,cfj,df(:,j),0,tdj,u(:,j),0);
      % Additional ZOH simulation if u(1,j)~=0
      if zohsim(j),
         sel = sum(zohsim(1:j));
         [azj,bzj,czj] = smreal(az,bz(:,sel),cz,[]);
         y = y + simresp(azj,bzj,czj,dz(:,j),0,tdj,u0(ones(1,lt),j),0);
      end
   end
      
   % Derive trajectory of original CT state
   % Note: ComputeX=1 implies ioDelayMatrix=0
   if ComputeX,
      for j=1:nu,
         u(:,j) = [zeros(min(id(j),lt),1) ; u(1:lt-id(j),j)];
      end
      x = z - u * gic(:,nx+1:nx+nu).' + xu0;
      x = x(:,1:nx); 
   end    
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,x] = simresp(a,b,c,d,id,od,u,x0,nzfod)
%SIMRESP  Simulation with discrete-time response

lt = size(u,1);  % number of samples
if ~any(x0),
   x0 = zeros(size(a,1),1);
end

% Delay j-th input by j-th input delay ID(j)
for j=find(id(:))',
   u(:,j) = [zeros(min(id(j),lt),1) ; u(1:lt-id(j),j)];
end

% Simulate response with LTITR
x = ltitr(a,b,u,x0);
y = x * c.' + u * d.';

% In FOH case, zero out y(1) for the output channels with
% fractional delays (for an output delayed by tau, the FOH
% simulation yields y(1) = Cx[-tau] where x[-tau] is computed 
% assuming a linear input u(t) with value 0 at t=-dt and u(1)
% at t=0, whereas the true input is 0 for t<0.
if nargin>8,
   y(1,nzfod) = 0;
end

% Delay i-th output by i-th output delay OD(i)
for i=find(od(:))',
   y(:,i) = [zeros(min(od(i),lt),1) ; y(1:lt-od(i),i)];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u = interpd(t0,u0,du0,t,dt,dthresh)
%INTERPD   Interpolates the original input U0 at the new sample times T.
%          ZOH interpolation is used near discontinuities.

nu = size(u0,2);
u = zeros(length(t),nu);
t1 = t(1);

for j=1:nu,
   tj = t0;
   uj = u0(:,j);
   duj = du0(:,j);
   rgj = max(uj)-min(uj);
   istep = 1+find(duj >= dthresh*rgj);

   % ISTEP marks the discontinuities in U(:,J)
   for i=istep',
      % Add point t(i)-dt with value uj(i-1)
      tji = t(round((tj(i)-t1)/dt));
      tj = [tj; tji];
      uj = [uj; uj(i-1)];
   end

   % Sort resulting time vector
   [tj,iperm] = sort(tj);
   uj = uj(iperm);

   % Interpolate extended data linearly
   u(:,j) = interp1(tj,uj,t);
end


