function sys = d2d(sys,Ts,Nd)
%D2D  Resample discrete LTI system.
%
%   SYS = D2D(SYS,TS) resamples the discrete-time LTI model SYS 
%   to produce an equivalent discrete system with sample time TS.
%
%   See also D2C, C2D, LTIMODELS.

%	Andrew C. W. Grace 2-20-91, P. Gahinet 8-28-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1998/11/17 18:11:52 $

ni = nargin;
error(nargchk(2,3,ni));

% Trap 4.0 syntax D2D(SYS,[],Nd) where Nd = input delays
if ni==3,
   if any(abs(Nd-round(Nd))>1e3*eps*abs(Nd)),
      error('Last argument ND must be a vector of integers.')
   elseif ~isequal(size(Nd),[1 1]) & length(Nd)~=size(sys,2),
      error('Length of ND must match number of inputs.')
   end
   set(sys,'inputdelay',round(Nd));
   % Call DELAY2Z
   sys = delay2z(sys);
   return
end

% Dimensions
sizes = size(sys.d);
ny = sizes(1);
nu = sizes(2);
nsys = prod(sizes(3:end));
Nx = nxarray(sys);
Ts0 = getst(sys);

% Error checking
if isempty(sys.a)
   % Static gain
   set(sys,'ts',Ts);   
   return
elseif Ts0==0,
   error('Input system SYS must be discrete.')
elseif Ts0<0,
   % Unspecified sample time
   error('Sample time of input system SYS is unspecified (Ts=-1).')
elseif hasdelay(sys),
   % REVISIT: add code for the case where Ts/Ts0 is integer (see true
   % feasibility test below)
   error('Not supported for delay systems.')
end

% Sample time ratio
rTs = Ts/Ts0;
if abs(round(rTs)-rTs)<sqrt(eps)*rTs,
   rTs = round(rTs);
elseif hasdelay(sys),
   error('Cannot resample delay systems when TS is not a multiple of SYS.Ts.')
end

% Loop over each model
Nx0 = sys.Nx;
s = warning;
warning off
for k=1:nsys,
   % Get data for k-th model
   sysk = subsref(sys,substruct('()',{':' ':' k}));
   [a,b,c,d] = ssdata(sysk);
   
   % Look for real negative poles
   p = eig(a);
   if any(imag(p)==0 & real(p)<=0) & rem(rTs,1),
      % Negative real poles with fractional resampling: let D2C handle it
      [a,b,c,d] = ssdata(c2d(d2c(sysk),Ts));
      nx = size(a,1);
      sys.a(1:nx,1:nx,k) = a;
      sys.b(1:nx,:,k) = b;
      sys.c(:,1:nx,k) = c;
      sys.d(:,:,k) = d;
      sys.Nx(k) = nx;
   else
      % Proceed directly
      % REVISIT: need dedicated code for delay case
      nx = size(a,1);
      M = [a b;zeros(nu,nx) eye(nu)]^rTs;
      sys.a(1:nx,1:nx,k) = M(1:nx,1:nx);
      sys.b(1:nx,:,k) = M(1:nx,nx+1:nx+nu);
   end
end
warning(s)

% Check state dimensions
if any(sys.Nx(:)>Nx0(:)),
   warning('Model order was increased to handle real negative poles.')
   sys.Nx = nxcheck(sys.Nx);
   gap = size(sys.a,1)-max(Nx0(:));
   sys.StateName(end+1:end+gap,1) = {''};
end

% Reset sample time
sys.lti = set(sys.lti,'ts',Ts);
