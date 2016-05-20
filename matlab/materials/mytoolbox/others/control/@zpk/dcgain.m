function g = dcgain(sys)
%DCGAIN  DC gain of LTI models.
%
%   K = DCGAIN(SYS) computes the steady-state (D.C. or low frequency)
%   gain of the LTI model SYS.
%
%   If SYS is an array of LTI models with dimensions [NY NU S1 ... Sp],
%   DCGAIN returns an array K with the same dimensions such that
%      K(:,:,j1,...,jp) = DCGAIN(SYS(:,:,j1,...,jp)) .  
%
%   See also NORM, EVALFR, FREQRESP, LTIMODELS.

%       Author(s): A. Potvin, 12-1-95
%       Revised: P. Gahinet, 4-1-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.11 $  $Date: 1998/03/16 21:13:21 $


tol = sqrt(eps);
[z,p,k,Ts] = zpkdata(sys);
sizes = size(k);
g = zeros(sizes);
RealSys = 1;  % 1 if data is real

if Ts==0,
   s = 0;  % Evaluate at s=0 for continuous-time models
else
   s = 1;  % Evaluate at z=1 for discrete-time models
end

for i=find(k(:))',
   ki = k(i);
   zi = z{i};
   pi = p{i};

   RealSys = RealSys & isequal(sort(zi(imag(zi)>0)),sort(conj(zi(imag(zi)<0)))) ...
                     & isequal(sort(pi(imag(pi)>0)),sort(conj(pi(imag(pi)<0))));

   % Discrete-time: denoise multiple roots near 1
   if Ts~=0,
      indz = find(abs(zi-1)<0.01);
      indp = find(abs(pi-1)<0.01);
      errtol = 1e-6;
      zi(indz,1) = mroots(zi(indz),'roots',errtol);
      pi(indp,1) = mroots(pi(indp),'roots',errtol);
   end

   % Look for cases where num(s)=0 or den(s)=0
   indz = find(abs(zi-s)<tol);
   indp = find(abs(pi-s)<tol);
   if  length(indp)>length(indz),
      g(i) = Inf;
   elseif length(indp)<length(indz),
      g(i) = 0;
   else
      zi(indz) = [];
      pi(indp) = [];
      g(i) = ki * prod(s-zi) / prod(s-pi);
   end

end

if RealSys,  g = real(g);  end

