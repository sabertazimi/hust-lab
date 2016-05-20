function [ltinorm,fpeak] = norm(sys,type,tol)
%NORM  LTI system norms.
%
%   NORM(SYS) is the root-mean-squares of the impulse response of 
%   the LTI model SYS, or equivalently the H2 norm of SYS.
%
%   NORM(SYS,2) is the same as NORM(SYS).
%
%   NORM(SYS,inf) is the infinity norm of SYS, i.e., the peak gain
%   of its frequency response (as measured by the largest singular 
%   value in the MIMO case).
%
%   NORM(SYS,inf,TOL) specifies a relative accuracy TOL for the 
%   computed infinity norm (TOL=1e-2 by default).
%       
%   [NINF,FPEAK] = NORM(SYS,inf) also returns the frequency FPEAK
%   where the gain achieves its peak value NINF.
%
%   For a S1-by...-by-Sp array SYS of LTI models, NORM returns an
%   array N of size [S1 ... Sp] such that
%      N(j1,...,jp) = NORM(SYS(:,:,j1,...,jp)) .  
%
%   See also SIGMA, FREQRESP, LTIMODELS.

%  Reference:
%      Bruisma, N.A., and M. Steinbuch, ``A Fast Algorithm to Compute
%      the Hinfinity-Norm of a Transfer Function Matrix,'' Syst. Contr. 
%      Letters, 14 (1990), pp. 287-293.

%   Author(s): P. Gahinet, 5-10-95.
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/05/05 13:53:41 $

ni = nargin;
error(nargchk(1,3,ni))
if ni<2,
   type = 2;
elseif isequal(lower(type),'inf'),
   type = Inf;
elseif ~isequal(type,2) & ~isequal(type,Inf),
   error('Second argument should be 2 or inf.');
end

% Set tolerance
if ni<3,
   tol = 1e-2;
else
   tol = max(100*eps,tol);
end

% Get sizes
sizes = [size(sys.d) 1 1];
nsys = prod(sizes(3:end));
Ts = getst(sys.lti);

% Look for time delays
Td = totaldelay(sys);
dTd = diff(diff(Td,1,1),1,2);
if type~=2 & any(dTd(:)>1e3*eps*max(Td(:)))
   % Can only compute Linf norm of delay system when I/O delays can be 
   % factored into input and output delays
   if Ts==0,
      error('Cannot compute L-infinity for general I/O delays.')
   else
      % Pull out input+output delays. Remaining delays will be mapped
      % to poles at z=0 for each individual model (to avoid state dim. 
      % inconsistencies
      Td = fiod(Td);
   end
else
   Td = zeros(sizes(1:2));
end

% Balance
sys = ssbal(sys);
Ne = size(sys.e,1);

% Compute norm of each system
ltinorm = zeros(sizes(3:end));
switch type
case 2
   % H2 norm
   fpeak = [];
   for k=1:nsys,
      nx = sys.Nx(min(k,end));
      ne = min(nx,Ne);
      ltinorm(k) = h2norm(sys.a(1:nx,1:nx,k),sys.b(1:nx,:,k),sys.c(:,1:nx,k),...
         sys.d(:,:,k),sys.e(1:ne,1:ne,k),Ts);
   end
   
case Inf
   % Linf norm
   fpeak = zeros(sizes(3:end));
   
   if Ts==0,
      % Continuous-time case
      for k=1:nsys,
         nx = sys.Nx(min(k,end));
         ne = min(nx,Ne);
         [ltinorm(k),fpeak(k)] = ...
            norminf(sys.a(1:nx,1:nx,k),sys.b(1:nx,:,k),sys.c(:,1:nx,k),...
                    sys.d(:,:,k),sys.e(1:ne,1:ne,k),tol);
      end
   else
      % Discrete-time case
      sys.lti = set(sys.lti,'inputdelay',zeros(sizes(2),1),...
                            'outputdelay',zeros(sizes(1),1),...
                            'iodelaymatrix',Td);
      % Map residual delays to poles at z=0
      sys = delay2z(sys);
      
      for k=1:nsys,
         nx = sys.Nx(min(k,end));
         ne = min(nx,Ne);
         [ltinorm(k),fpeak(k)] = ...
            dnorminf(sys.a(1:nx,1:nx,k),sys.b(1:nx,:,k),sys.c(:,1:nx,k),...
                     sys.d(:,:,k),sys.e(1:ne,1:ne,k),tol);
      end
      fpeak = fpeak/abs(Ts);
   end
   
end


%%%%%%%%%%% Local function H2NORM %%%%%%%%%%%%%%%%%%%%%%

function n = h2norm(a,b,c,d,e,Ts)
%H2NORM  Compute H2 norm of single model

% Triangularize A or (A,E)  (need only one Schur 
% decomposition to get poles and solve Lyapunov equations)
if isempty(a) | isempty(e),
   % E = I or A = []
   [u,a] = schur(a);
   b = u'*b;  c = c*u;
   r = eig(a);
else
   % Descriptor case
   [a,e,q,z] = qz(a,e);
   b = q*b;   c = c*z;
   r = diag(a)./diag(e);
end

% REVISIT: generalized Lyapunov needed
if ~isempty(e),
   a = e\a;  b = e\b;
end

if Ts==0,
   % Continuous H2 norm: 
   if any(d(:)),
      warning('Nonzero feedthrough: 2-norm is infinite.')
      n = Inf;
   elseif max(real(r))>=0,
      % Unstable system
      warning('Unstable system: 2-norm is infinite.')
      n = Inf;
   else
      % || G ||^2 = trace(c*P*c') where a*P+P*a'+b*b' = 0
      P = lyap(a,b*b');
      n = sqrt(trace(c*P*c'));
   end
   
else
   % Discrete H2 norm:
   if max(abs(r))>=1,
      % Unstable system
      warning('Unstable system: 2-norm is infinite.')
      n = Inf;
   else
      % || G ||^2 = trace(c*P*c'+d*d') where a*P*a'-P+b*b' = 0
      P = dlyap(a,b*b');
      n = sqrt(trace(c*P*c'+d*d'));
   end 
end

%%%%% SUBFUNCTION FIOD

function Td = fiod(Td)
%FIOD  Remove I/O delays that can be factored out as input or 
%      output delays

[ny,nu] = size(Td(:,:,1));
itail = repmat({':'},[1 ndims(Td)-2]);

if ny<nu,
   % Pull output delays first (cf. OD+1/ID-1 has fewer delay blocks
   % than OD/ID in this case
   od = min(Td,[],2);
   Td = Td - od(:,ones(1,nu),itail{:});
   id = min(Td,[],1);
   Td = Td - id(ones(1,ny),:,itail{:});
else
   id = min(Td,[],1);
   Td = Td - id(ones(1,ny),:,itail{:});
   od = min(Td,[],2);
   Td = Td - od(:,ones(1,nu),itail{:});
end

