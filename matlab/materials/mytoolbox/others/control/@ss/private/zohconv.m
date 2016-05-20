function [ad,bd,cd,dd,sn,gic] = zohconv(a,b,c,d,Ts,fid,fod,sn)
%ZOHCONV  ZOH discretization of a single state-space model
%         with fractional input and output delays.
%
%   [AD,BD,CD,DD,SN] = ZOHCONV(A,B,C,D,TS,FID,FOD,SN) discretizes 
%   the state-space model (A,B,C,D) with (normalized) fractional 
%   input delays FID and fractional output delays FOD using the 
%   ZOH method.  FID and FOD are vectors of length NU and NY, 
%   respectively.
%
%   See also C2D.

%   Author: P. Gahinet  2-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/18 22:38:18 $

% TOLINT: tolerance for comparing delay times
tolint = 1e4*eps;

% Dimensions
[ny,nu] = size(d);
nx = size(a,1);

% Determine the I/O channels with zero fractional 
% delay for all models.
fid = reshape(fid,[1 nu]);
fod = reshape(fod,[1 ny]);
zfid = (fid<=tolint);
zfod = (fod<=tolint);
jdelay = find(~zfid);  % delayed input channels
nid = length(jdelay);  % number of nonzero input delays

% Use ZOHND when no fractional delays
if all(zfid) & all(zfod),
   [ad,bd] = zohnd(a,b,Ts);
   cd = c;   
   dd = d; 
   gic = [eye(nx) zeros(nx,nu)];
   return
end

% Perform ZOH discretization
Tmat = [a , b ; zeros(nu,nx+nu)];  % transition mat.
cd = [c , d];

% Initialize the piecewise integration at t=0, and update the 
% linear relation
%    X(t) = E(t) * Xk + F(t) * Uk
%    Y(t) = G(t) * Xk + H(t) * Uk
% where
%   * X(t) = [ x(t) ; u1(t-id(1)) ; ... ; um(t-id(m)) ]  
%   * Xk = [ x[k] ; us[k-1] ]  where s=find(id)
%   * Uk  = [ u1[k] ; ... ; um[k] ]
% Initial E,F matrices pertain to
%    X(0) = E * Xk + F * Uk
E = blkdiag(eye(nx),zeros(nu,nid));
E(nx+jdelay,nx+1:nx+nid) = eye(nid);
F = [zeros(nx,nu) ; diag(zfid)];
G = zeros(ny,nx+nid);  
H = zeros(ny,nu);

% Y updates for delay-free outputs
G(zfod,:) = [c(zfod,:) , d(zfod,~zfid)];
H(zfod,zfid) = d(zfod,zfid);

% Sort the integration events
Events = sort([0 fid 1-fod 1]);
Events(:,diff([-1,Events])<=tolint) = [];
fod(zfod) = -1;  % to prevent output update at t=1

% Piecewise integration over each interval [Events(j),Events(j+1)]
for j=1:length(Events)-1,
   t0 = Events(j);
   t1 = Events(j+1);
   
   % Integrate state equation on [T0,T1]
   h = (t1-t0)*Ts;
   ehTmat = expm(h*Tmat);
   E(1:nx,:) = ehTmat(1:nx,:) * E;
   F(1:nx,:) = ehTmat(1:nx,:) * F;
   
   % Find inputs updated at t=T1, and update E,F accordingly
   iu = find(abs(fid-t1)<=tolint);
   E(nx+iu,:) = 0;    
   F(nx+iu,iu) = eye(length(iu));
   
   % Find delayed outputs updated at t=T1, and update G,H accordingly
   % Note: gives value of y[k+1] 
   iy = find(abs(1-fod-t1)<=tolint);
   G(iy,:) = cd(iy,:) * E;    
   H(iy,:) = cd(iy,:) * F;
end

% Extract relevant rows of final E,F matrices
xkeep = [1:nx , nx+jdelay];
E = E(xkeep,:);
F = F(xkeep,:); 

% Apply z^-1 shift to all output channels with fractional delays
sn(nx+1:nx+nid,1) = {''};
[ad,bd,cd,dd,junk,sn] = delayios(E,F,G,H,[],zeros(nu,1),~zfod',sn);

% Map from continuous initial conditions (xc0,uc0) to xd0
gic = blkdiag(eye(nx),zeros(size(ad,1)-nx,nu));


%%%%%%%%%%%%%%%%%%%%%%

function [ad,bd] = zohnd(a,b,Ts)
%ZOHND  ZOH discretization of a single delay-free state-space model.
%
%   [AD,BD] = ZOHND(A,B,TS) discretizes
%        dx/dt = Ax + Bu 
%   using the ZOH method.
%
%   See also C2D.

[nx,nu] = size(b);
s = expm([[a b]*Ts; zeros(nu,nx+nu)]);
ad = s(1:nx,1:nx);
bd = s(1:nx,nx+1:nx+nu);
