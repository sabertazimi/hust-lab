function [y,t,x] = impresp(sys,Ts,t,t0)
%IMPRESP  Impulse response of a single LTI model
%
%   [Y,T,X] = IMPRESP(SYS,TS,T,T0) computes the impulse response
%   of the LTI model SYS with sample time TS at the time stamps
%   T (starting at t=0).  The response from t=0 to t=T0 is 
%   discarded if T0>0.
%
%   LOW-LEVEL UTILITY, CALLED BY IMPULSE.

%	 Author: P. Gahinet, 4-98
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.2 $  $Date: 1998/05/18 22:38:20 $

ComputeX = (nargout>2);
lt = length(t);
dt = t(2)-t(1);
nx = size(sys.a,1);  % true number of states
[ny,nu] = size(sys.d);

% Pre-allocate outputs
y = zeros(lt,ny,nu);
if ComputeX, 
   x = zeros(lt,nx,nu);  
end

% Extract delay data for continuous-time case
DelayData = get(sys.lti,{'inputdelay','outputdelay','iodelay'});
[id,od,iod] = deal(DelayData{:});

% Handle various cases
u = zeros(lt,1);
if Ts,
   % Discrete-time case
   [a,b,c,d] = ssdata(sys);
   if ComputeX,
      % State trajectory required -> no I/O delays
      Tdin = id';
      Tdout = repmat(od,[1 nu]);
   else
      % Get cumulative I/O delays
      iods = iod + id(:,ones(1,ny))' + od(:,ones(1,nu));
      Tdin = min(iods,[],1);              % input delays for each input channel
      Tdout = iods - Tdin(ones(1,ny),:);  % output delays for each input channel
   end
   
   % Simulate response of each input channel to u = [1 0 0 0...]
   u(1) = 1;
   for j=find(Tdin<lt),
      [y(:,:,j),xj] = impsim(a,b(:,j),c,d(:,j),u,zeros(nx,1),Tdin(j),Tdout(:,j));
      if ComputeX & nx>0,
         % Note: Delays consist of input + output delays when ComputeX=1
         x(:,:,j) = xj(:,1:nx);  
      end
   end
   
else
   % Continuous-time case
   % Simulate the impulse response of the j-th channel as the free
   % response of
   %      dz/dt = A z               
   %      yj(i) = C z(t-iods(i,j))
   % with initial condition z(0) = B(:,j).
   x0 = sys.b;
   iods = iod + id(:,ones(1,ny))' + od(:,ones(1,nu));
   variod = diff(iods,1,2);
   if all(abs(variod(:))<1e4*eps),
      % Keep only on copy of output Y when discretizing
      sysd = c2d(ss(sys.a,zeros(nx,1),sys.c,zeros(ny,1),...
                                      'outputdelay',iods(:,1)),dt);
   else
      % Append Y's for each input channel
      sysd = c2d(ss(sys.a,[],repmat(sys.c,[nu 1]),[],'outputdelay',iods(:)),dt);
   end
   nxd = size(sysd.a,1);
   nyd = size(sysd.c,1);
   Tdout = get(sysd.lti,'outputdelay');
   
   % Simulate impulse response of each input channel
   for j=1:nu,
      if nyd==ny,
         yjsel = 1:ny;
      else
         yjsel = (j-1)*ny+1:j*ny;
      end
      [y(:,:,j),xj] = impsim(sysd.a,zeros(nxd,1),sysd.c(yjsel,:),zeros(ny,1),...
                                    u,[x0(:,j);zeros(nxd-nx,1)],0,Tdout(yjsel));
      if ComputeX & ~id(j),
         x(:,:,j) = xj(:,1:nx);
      end
   end
   
   % If needed, compute the state trajectory for delayed input channels as
   % the output response of 
   %      dz/dt = A z               
   %      xj    = z (t-id(j))
   % with initial condition z(0) = B(:,j).
   if ComputeX,
      for j=find(id'),
         sysxd = c2d(ss(sys.a,[],eye(nx),[],'outputdelay',id(j)),dt);
         nxd = size(sysxd.a,1);
         xj = impsim(sysxd.a,zeros(nxd,1),sysxd.c,zeros(nx,1),u,...
                     [x0(:,j);zeros(nxd-nx,1)],0,get(sysxd.lti,'outputdelay'));
         x(:,:,j) = xj(:,1:nx);        
      end
   end       
   
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,x] = impsim(a,b,c,d,u,x0,Tdin,Tdout)
%IMPSIM  Simulate impulse response of single-input model

lt = length(u);
ny = size(c,1);
y = zeros(lt,ny);

% Simulate with LTITR
x = ltitr(a,b,u(1:lt-Tdin),x0);

% Compute output trajectory
ctr = c.';
Tdio = Tdout + Tdin;  % I/O delays 

if any(diff(Tdio)),
   for i=1:ny,
      y(Tdio(i)+1:lt,i) = x(1:lt-Tdio(i),:) * ctr(:,i);
      % Add impulse at t=0 (discrete-time case)
      y(Tdio(i)+1,i) = y(Tdio(i)+1,i) + d(i);
   end
else
   y(Tdio(1)+1:lt,:) = x(1:lt-Tdio(1),:) * ctr;
   y(Tdio(1)+1,:) = y(Tdio(1)+1,:) + d.';
end

% Set X output
x = [zeros(Tdin,size(x,2)) ; x];


