function tvecs = trange(PlotType,Tf,x0,varargin)
%TRANGE   Generate time vectors for time response of multiple systems
%
%   TVECS = TRANGE(PLOTTYPE,TFINAL,X0,SYS1,...,SYSk) generates time
%   vectors TVECS{1},...,TVECS{k}  for simulation of the time response
%   of the LTI systems SYS1,...,SYSk.   All these vectors start at t=0
%   and end at the same time TFINAL.  The common duration TFINAL is
%   automatically generated when not specified.

%   Author: P. Gahinet, 4-18-96
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.12 $  $Date: 1998/10/01 20:12:33 $

minptsc = 50;            % min. number of samples for continuous systems
maxptsc = 5000;          % max. number of samples for continuous systems
maxptsd = 50000;         % max. number of samples for discrete systems
nsys = nargin-3;         % number of systems
NoTf = isempty(Tf);      % no final time supplied
Tfmax = 0;               % keep track of max. settling time

dt = cell(1,nsys);       % spacing between time samples
ctflag = zeros(1,nsys);  % 1 for continuous systems

% Determine adequate time constants (final time, and sampling rate 
% for continous-time models)
for k=1:nsys,
   sys = varargin{k};
   Ts = abs(sys.Ts);
   ctflag(k) = (Ts==0);
   
   % Handle various cases
   if Ts==0,
      % Find appropriate time range and sample time
      [dt{k},tset] = crange(sys,x0,Tf,PlotType);
   elseif NoTf,
      % Discrete with unspecified final time: find appropriate # samples
      dt{k} = Ts;
      tset = drange(sys,Ts,x0,Tf,PlotType);
   else
      % Discrete with specified final time
      dt{k} = Ts;
      sizes = size(sys);
      tset = Tf(1,ones(1,prod(sizes(3:end))));
   end
   
   % Take delay times into account
   if NoTf & ~isempty(sys),  
      Tdio = totaldelay(sys);
      if Ts,
         Tdio = Tdio * Ts;
      end
      tset = tset + max(max(Tdio(:,:,:),[],1),[],2);
   end
   
   % Update max. settling time
   Tfmax = max(Tfmax,max(tset));
end


% Adjust final time and sampling rate of continuous systems
% to limit number of samples to less that MAXPTS
if NoTf,
   % Set final time (limit to MAXPTS * min. sample time)
   Tf = min([Tfmax maxptsd*[dt{~ctflag}]]);
   % Round Tf to convenient value for plot
   Tf = tchop(Tf); 
else
   % Ensure minimum of MINPTSC points
   for k=find(ctflag),
      dt{k} = min(dt{k},Tf/minptsc);
   end   
end

% Limit sampling rate of continuous systems
for k=find(ctflag),
   dt{k} = max(dt{k},Tf/maxptsc);
end

% Generate time vectors
tvecs = cell(1,nsys);    % time vectors
for k=1:nsys,
   sk = size(varargin{k});  % size of k-th model
   tvecs{k} = cell([sk(3:end) 1 1]);
   for j=1:prod(sk(3:end)),
      dts = dt{k}(min(j,end));
      tvecs{k}{j} = dts * (0:1:floor(Tf/dts))';
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
function [dt,tset] = crange(sys,x0,Tf,PlotType)
%CRANGE  Call to TIMSCALE to generate the time constant 
%        (continuous case)

sizes = size(sys);
nmodels = prod(sizes(3:end));
dt = zeros(1,nmodels);
tset = zeros(1,nmodels);

switch PlotType(1:2),
case 'st'   
   % Step response
   for j=1:nmodels,
      [a,b,c] = ssdata(sys(:,:,j));
      [dt(j),tset(j)] = timscale(a,b,c,[],Tf);
   end
case 'im'
   % Impulse response
   for j=1:nmodels,
      [a,b,c] = ssdata(sys(:,:,j));
      [dt(j),tset(j)] = timscale(a,[],c,b,Tf);
   end
case 'in'
   % Response to initial conditions
   for j=1:nmodels,
      [a,b,c] = ssdata(sys(:,:,j));
      if sizes(1)==0,  
         c = eye(size(a));  
      end      
      [dt(j),tset(j)] = timscale(a,[],c,x0,Tf);
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tset = drange(sys,Ts,x0,Tf,PlotType)
%DRANGE  Call to DTIMSCALE to generate adequate number of samples 
%        (discrete case)

sizes = size(sys);
nmodels = prod(sizes(3:end));
tset = zeros(1,nmodels);

switch PlotType(1:2),
case 'st'   
   % Step response
   for j=1:nmodels,
      [a,b,c] = ssdata(sys(:,:,j));
      tset(j) = Ts * dtimscale(a,b,c,0,[],Ts);
   end
case 'im'
   % Impulse response
   for j=1:nmodels,
      [a,b,c,d] = ssdata(sys(:,:,j));
      tset(j) = Ts * dtimscale(a,[],c,d,b,Ts);
   end
case 'in'
   % Response to initial conditions
   for j=1:nmodels,
      [a,b,c] = ssdata(sys(:,:,j));
      if sizes(1)==0,  
         c = eye(size(a));  
      end
      tset(j) = Ts * dtimscale(a,[],c,0,x0,Ts);
   end
end


       
