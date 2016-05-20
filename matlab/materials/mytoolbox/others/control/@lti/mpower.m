function L = mpower(L,k)
%MPOWER  Repeated product of LTI models.
%
%   MPOWER(SYS,K) is invoked by SYS^K where SYS is any 
%   LTI model with the same number of inputs and outputs, 
%   and K must be an integer.  The result is the LTI model
%     * if K>0, SYS * ... * SYS (K times) 
%     * if K<0, INV(SYS) * ... * INV(SYS) (K times)
%     * if K=0, the static gain EYE(SIZE(SYS)).
%
%   The syntax SYS^K is useful to specify transfer functions
%   in a pseudo-symbolic manner. For instance, you can specify
%             - (s+2) (s+3)
%      H(s) = ------------
%             s^2 + 2s + 2
%   by typing
%      s = tf('s')
%      H = -(s+2)*(s+3)/(s^2+2*s+2) .
%
%   See also TF, PLUS, MTIMES, LTIMODELS.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/04/14 21:11:45 $

[ny,nu] = size(L.ioDelayMatrix(:,:,1));

% Update time delay
if k==0,
   L.InputDelay = zeros(nu,1);
   L.OutputDelay = zeros(ny,1);
   L.ioDelayMatrix = zeros(ny,nu);
else
   % Below SYS is always SISO and K>0
   L.ioDelayMatrix = ...
      k * (L.ioDelayMatrix + L.InputDelay + L.OutputDelay) - (L.InputDelay + L.OutputDelay);
end
