function [gpeak,fpeak] = dnorminf(a,b,c,d,e,tol)
%DNORMINF  Compute the peak gain GPEAK of the discrete-time frequency 
%      response:
%                                        -1
%                  G (z) = D + C (zE - A)  B .
%
%      The norm is finite if and only if (A,E) has no eigenvalue on the 
%      unit circle.  TOL is the desired relative accuracy on GPEAK, 
%      and FPEAK is the frequency such that:
%
%                               j*FPEAK
%                       || G ( e        ) ||  =  GPEAK
%
%      See  NORM.

%    Based on the algorithm described in
%        Bruisma, N.A., and M. Steinbuch, ``A Fast Algorithm to Compute
%        the Hinfinity-Norm of a Transfer Function Matrix,'' Syst. Contr. 
%        Letters, 14 (1990), pp. 287-293.

%   Author(s):  P. Gahinet, 5-13-95.
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.1 $  $Date: 1998/02/12 22:28:21 $


% Tolerance for detection of unit circle modes 
toluc = sqrt(eps);

% Problem dimensions
[ny,nu] = size(d);
nx = size(a,1);
desc = isempty(e);
if desc, 
   e = eye(nx);
end

% Quick exits
if nx==0 | norm(b,1)==0 | norm(c,1)==0,
   gpeak = norm(d); fpeak = 0;
   return
end

% Reduce (A,E) to (generalized) upper-Hessenberg form for
% fast frequency response computation and compute the poles
% Revisit: need generalized Hessenberg form
if desc,
   % Descriptor case
   [aa,ee,q,z] = qz(a,e);
   bb = q*b;     
   cc = c*z;
   r = diag(aa)./diag(ee);
else
   [u,aa] = hess(a);   ee = e;
   bb = u'*b;    
   cc = c*u;
   r = eig(a);
end
  

% Look for unit-circle modes (infinite norm)
[ucdist,i] = min(abs(1-abs(r)));
if ucdist < 1000*eps,
   gpeak = Inf;  fpeak = abs(angle(r(i)));
   return
end

% Build a vector TESTFRQ of test frequencies containing the peaking 
% frequency for each mode (or an appx thereof for non-resonant modes).
sr = log(r(r~=0));                           % equivalent jw-axis modes:
asr2 = abs(real(sr));                        % magnitude of real part
w0 = abs(sr);                                % fundamental frequency
ikeep = find(imag(sr)>=0 & w0>0);
testfrq = w0(ikeep).*sqrt(max(0.25,1-2*(asr2(ikeep)./w0(ikeep)).^2));

% Back to unit circle, and add z = exp(0) and z = exp(pi)
testz = [exp(sqrt(-1)*testfrq) ; -1 ; 1];

% Compute lower estimate GMIN as max. gain over test frequencies
% RE: the norm is always greater then norm(d) (cf. LMI characterization
%     requires B'*X*B+D'*D-g^2*I < 0).  However the value norm(d) may
%     not be achieved at any frequency, so we don't include it.
gmin = 0;
for z=testz.',
   gw = norm(d+(cc/(z*ee-aa))*bb);
   if gw > gmin,
      gmin = gw;  fpeak = abs(angle(z));   
   end
end
if gmin==0,
   gpeak = 0;  fpeak = 0; 
   return
end

% Set up Hamiltonian pencil for Bruisma-Steinbuch algorithm 
nb = norm(b,1);
h11 = [a zeros(nx) ; zeros(nx) e'];
h12 = [b zeros(nx,ny) ; zeros(nx,nu) c']/nb;
h21 = [zeros(nu,2*nx) ; c zeros(ny,nx)]*nb;
j11 = [e zeros(nx) ; zeros(nx) a'];
j21 = [zeros(nu,nx) b'; zeros(ny,2*nx)]*nb;


% Modified gamma iterations start:
OK = 1;
while OK,
   % Test if G = (1+TOL)*GMIN qualifies as upper bound
   g = (1+tol) * gmin;
   h22 = [eye(nu) , d'/g ; d/g , eye(ny)];

   % Use QZ algorithm with preliminary deflation to compute eigs of 
   % symplectic pencil
   [q,junk] = qr([h12 ; h22]);
   q = q(:,nu+ny+(1:2*nx));
   heigs = qzeig(q'*[h11 ; h21/g] , q'*[j11 ; j21/g]);

   % Detect unit-circle eigenvalues
   uceig = heigs(abs(1-abs(heigs)) < toluc * sqrt(100+max(abs(heigs))));

   if isempty(uceig),   
      % No unit-circle eigenvalues for G = GMIN*(1+TOL): we're done
      gpeak = gmin;
      return
   end
  
   % Compute frequencies where gain G is attained and 
   % generate new test frequencies
   ang = angle(uceig).';
   ang = unique(max(eps,ang(ang>0)));
   lan = length(ang);
   if lan==1,
      gpeak = gmin;
      return
   end

   % Form the vector of mid-points and compute
   % gain at new test frequencies
   gmin0 = gmin;   % save current lower bound
   testz = exp(sqrt(-1)*(ang(1:lan-1)+ang(2:lan))/2);
   for z=testz,
      gw = norm(d+(cc/(z*ee-aa))*bb);
      if gw > gmin,
         gmin = gw;  fpeak = abs(angle(z));   
      end
   end

   % If lower bound has not improved, exit (safeguard against undetected 
   % unit-circle eigenvalues).
   if gmin < gmin0 * (1+tol/10), 
      gpeak = gmin;
      return, 
   end

end %while


% end dnorminf.m
