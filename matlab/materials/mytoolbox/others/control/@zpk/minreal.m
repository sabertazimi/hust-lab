function sysr = minreal(sys,tol)
%MINREAL  Minimal realization and pole-zero cancellation.
%
%   MSYS = MINREAL(SYS) produces, for a given LTI model SYS, an
%   equivalent model MSYS where all cancelling pole/zero pairs
%   or non minimal state dynamics are eliminated.  For state-space 
%   models, MINREAL produces a minimal realization MSYS of SYS where 
%   all uncontrollable or unobservable modes have been removed.
%
%   MSYS = MINREAL(SYS,TOL) further specifies the tolerance TOL
%   used for pole-zero cancellation or state dynamics elimination. 
%   The default value is TOL=SQRT(EPS) and increasing this tolerance
%   forces additional cancellations.
%
%   For a state-space model SYS=SS(A,B,C,D),
%      [MSYS,U] = MINREAL(SYS)
%   also returns an orthogonal matrix U such that (U*A*U',U*B,C*U') 
%   is a Kalman decomposition of (A,B,C). 
%
%   See also SMINREAL, BALREAL, MODRED.

%   J.N. Little 7-17-86
%   Revised A.C.W.Grace 12-1-89, P. Gahinet 8-28-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/07/16 20:04:03 $

ni = nargin;
error(nargchk(1,2,ni))
if ni==1,
   tol = sqrt(eps);
end

% Look for pole/zero cancellations in each channel
sysr = sys;
for j=1:prod(size(sys.k)),
   % Perform reduction (denoise multiple roots to improve cancellation rate)
   [sysr.z{j},sysr.p{j}] = ...
      reducezp(mroots(sys.z{j},'roots',tol),mroots(sys.p{j},'roots',tol),tol);
end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zr,pr] = reducezp(z,p,tol)
%REDUCEZP   Cancels matching pairs of poles and zeros
%           (within the relative tolerance TOL)
%           The system is assumed to be real


% Init
zr = zeros(0,1);
pr = p;
cz = z(imag(z)>0,1);
rz = z(imag(z)==0,1);

% Process complex conjugate zeros first, making sure 
% that each cancellation preserves the symmetry of PR
ikeep = ones(size(cz));
for m=1:length(cz),
   % Find pole in PR closest to ZM = CZ(M)
   zm = cz(m);
   [dmin,imin] = min(abs(pr-zm));

   if dmin<tol*(1+abs(zm)),
      % Cancel pair zm,pm and monitor complex/real simplifications
      ikeep(m) = 0;
      pm = pr(imin);

      if imag(pm), 
         % PM is complex: cancel (ZM,PM) and their conjugates
         icjg = find(pr==conj(pm));
         pr([imin , icjg(1)],:) = [];
      else
         % PM is real: add Z=(PM+2*REAL(ZM))/3 to RZ
         rz = [rz ; (pm+2*real(zm))/3];
         pr(imin,:) = [];
      end
   end
end

cz = cz(logical(ikeep),:);


% Process real zeros
ikeep = ones(size(rz));
for m=1:length(rz),
   % Find pole closest to ZM = RZ(M)
   zm = rz(m);
   [dmin,imin] = min(abs(pr-zm));

   if dmin<tol*(1+abs(zm)),
      % Cancel pair zm,pm and monitor real/complex simplifications
      ikeep(m) = 0;
      pm = pr(imin);

      if imag(pm), 
         % PM is complex: replace its conjugate by P=(ZM+2*REAL(PM))/3
         icjg = find(pr==conj(pm));
         pr(icjg(1)) = (zm+2*real(pm))/3;
      end
      pr(imin,:) = [];
   end
end

rz = rz(logical(ikeep),:);


% Put ZR together
ncz = length(cz);
zr(1:2:2*ncz,1) = cz;
zr(2:2:2*ncz,1) = conj(cz);
zr = [zr ; rz];

