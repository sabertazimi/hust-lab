function [ad,bd,cd,dd,sn,gic] = fohconv(a,b,c,d,Ts,fid,fod,sn)
%FOHCONV  FOH discretization of a single state-space model
%         with fractional input and output delays.
%
%   [AD,BD,CD,DD,SN] = FOHCONV(A,B,C,D,TS,FID,FOD,SN) discretizes 
%   the state-space model (A,B,C,D) with (normalized) fractional 
%   input delays FID and fractional output delays FOD using the 
%   FOH method.  FID and FOD are vectors of length NU and NY, 
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

% Use FOHND when no fractional delays
if all(zfid) & all(zfod),
   [ad,bd,cd,dd,gic] = fohnd(a,b,c,d,Ts);
   return
end

% Perform FOH discretization
Tmat = [a , b , zeros(nx,nu)  ; ...
        zeros(nu,nx+nu)  eye(nu)/Ts ; ...
        zeros(nu,nx+2*nu)];      % transition matrix
cd = [c , d];

% Initialize the piecewise integration at t=0, and update the 
% linear relation
%    X(t) = E(t) * Xk + F1(t) * U[k] + F2(t) * (U[k+1]-U[k])
%    Y(t) = G(t) * Xk + H1(t) * U[k] + H2(t) * (U[k+1]-U[k])
% where
%   * X(t) = [x(t) ; uj(t-id(j)) ; Ts * dt/dt(uj(t-id(j))) ],  j=1:m
%   * Xk = [ x[k] ; us[k-1] ]  where s=find(id)
%   * U[k]  = [ u1[k] ; ... ; um[k] ]
% Initial E,F1,F2 matrices pertain to
%    X(0) = E * Xk + F1 * U[k] + F2 * (U[k+1]-U[k])
nxaug = nx+nid;
E = blkdiag(eye(nx),zeros(2*nu,nid));
E(nx+jdelay,nx+1:nxaug) = diag(fid(~zfid));
E(nx+nu+jdelay,nx+1:nxaug) = -eye(nid);
F1 = [zeros(nx,nu) ; diag(1-fid) ; diag(~zfid)];
F2 = [zeros(nx+nu,nu) ; diag(zfid)];
G = zeros(ny,nxaug);  
H1 = zeros(ny,nu);
H2 = zeros(ny,nu);

% Y updates for delay-free outputs
G(zfod,:) = [c(zfod,:) , d(zfod,:)*E(nx+1:nx+nu,nx+1:nxaug)];
H1(zfod,:) = d(zfod,:) * F1(nx+1:nx+nu,:);

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
   ehTmat = ehTmat(1:nx+nu,:);
   E(1:nx+nu,:) = ehTmat * E;
   F1(1:nx+nu,:) = ehTmat * F1;
   F2(1:nx+nu,:) = ehTmat * F2;
   
   % Find inputs updated at t=T1, and update E,F1,F2 accordingly
   iu = find(abs(fid-t1)<=tolint);
   liu = length(iu);
   E([nx+iu,nx+nu+iu],:) = 0;    
   F1([nx+iu,nx+nu+iu],iu) = [eye(liu) ; zeros(liu)];
   F2(nx+nu+iu,iu) = eye(liu);
   
   % Find delayed outputs updated at t=T1, and update G,H accordingly
   % Note: gives value of y[k+1] 
   iy = find(abs(1-fod-t1)<=tolint);
   G(iy,:) = cd(iy,:) * E(1:nx+nu,:);    
   H1(iy,:) = cd(iy,:) * F1(1:nx+nu,:);
   H2(iy,:) = cd(iy,:) * F2(1:nx+nu,:);
end

% Extract relevant rows of final E,F1,F2 matrices
% and build coefficients of the recursion
%   Xk+1 = E * Xk + F1 * U[k] + F2 * (U[k+1]-U[k])
E = E([1:nx , nx+jdelay],:);
F1 = [F1(1:nx,:) ; zeros(nid,nu)];
F1(nx+1:nxaug,~zfid) = eye(nid);
F2 = [F2(1:nx,:) ; zeros(nid,nu)]; 

% Reduce state equation to
%   Zk+1 = E * Zk + F * Uk  where Zk = Xk - F2 * U[k+1]
F = F1 + E*F2 - F2;

% Apply z^-1 shift to all output channels with fractional delays
% Note: work with output equation
%         Y[k+1] - H2 * U[k+1] = G * Zk + (G*F2+H1-H2) U[k]
sn(nx+1:nxaug,1) = {''};
[ad,bd,cd,dd,junk,sn] = delayios(E,F,G,G*F2+H1-H2,[],zeros(nu,1),~zfod',sn);
dd = dd + H2;

% Map from continuous initial conditions (xc0,uc0) to xd0
gic = [[eye(nxaug,nx) -F2] ; zeros(size(ad,1)-nxaug,nx+nu)];


%%%%%%%%%%%%%%%%%%%%%%

function [ad,bd,cd,dd,gic] = fohnd(a,b,c,d,Ts)
%FOHND  FOH discretization of a single delay-free state-space model.
%
%   [AD,BD,CD,DD] = FOHND(A,B,C,D,TS) discretizes
%        dx/dt = Ax + Bu 
%          y   = Cx + Du
%   using the FOH method.
%
%   See also C2D.

[nx,nu] = size(b);
M = [a , b , zeros(nx,nu)  ; ...
     zeros(nu,nx+nu)  eye(nu)/Ts ; ...
     zeros(nu,nx+2*nu)];
s = expm(M*Ts);
f1 = s(1:nx,nx+1:nx+nu);
f2 = s(1:nx,nx+nu+1:nx+2*nu);

% Discrete-time matrices
ad = s(1:nx,1:nx);
bd = f1 + ad*f2 - f2;
cd = c;
dd = d + c*f2;

% Continuous to discrete initial condition map
gic = [eye(nx) , -f2];
