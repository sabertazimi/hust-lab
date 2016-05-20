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

%	Andy Potvin  12-1-95
%	Clay M. Thompson  7-6-90
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1998/03/16 21:13:20 $


error(nargchk(1,1,nargin));

% Loop over each model:
sizes = size(sys.d);
g = zeros(sizes);

for k=1:prod(sizes(3:end)),
   g(:,:,k) = dcg(subsref(sys,substruct('()',{':' ':' k})));
end


%%%%%%%%%%%%%% Local function %%%%%%%%%%%%%%%%%%%%%%%%

%DCG   DC gain of a single state-space model
function g = dcg(sys)

[a,b,c,d,e,Ts] = dssdata(sys);
[ny,nu] = size(d);
nx = size(a,1);

if isempty(a) | ~any(b(:)) | ~any(c(:)),
   % Static gain
   g = d;
elseif Ts==0,
   % Continuous-time: evaluate at s = 0
   if rcond(a) < 100*eps,
      % s = 0 is a pole: convert to zpk
      g = dcgain(zpk(sys));
   else
      g = d - c * (a \ b) ;
   end
else
   % Discrete-time: evaluate at z = 1
   if rcond(e-a) < 100*eps,
      % z = 1 is a pole: convert to zpk
      g = dcgain(zpk(sys));
   else
      g = d + c * ((e-a) \ b) ;
   end
end

