function fresp = evalfr(sys,s)
%EVALFR  Evaluate frequency response at a single (complex) frequency.
%
%   FRESP = EVALFR(SYS,X) evaluates the transfer function of the 
%   continuous- or discrete-time LTI model SYS at the complex 
%   number S=X or Z=X.  For state-space models, the result is
%                                   -1
%       FRESP =  D + C * (X * E - A)  * B   .
%
%   EVALFR is a simplified version of FREQRESP meant for quick 
%   evaluation of the response at a single point.  Use FREQRESP 
%   to compute the frequency response over a grid of frequencies.
%
%   See also FREQRESP, BODE, SIGMA, LTIMODELS.

%   Author(s):  P. Gahinet  5-13-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/05/18 22:33:15 $

error(nargchk(2,2,nargin))
if length(s)~=1,
   error('Use FREQRESP for the vector case.')
end
sizes = size(sys.d);

% Set the E matrix
e = sys.e;
if isempty(e),
   e = eye(size(sys.a,1));
end

% Evaluate rational part of the response at S
fresp = zeros(sizes);
for k=1:prod(sizes(3:end)),
   nx = sys.Nx(min(k,end));
   fresp(:,:,k) = sys.d(:,:,k) + sys.c(:,1:nx,k) * ...
      ((s*e(1:nx,1:nx,min(k,end))-sys.a(1:nx,1:nx,k))\sys.b(1:nx,:,k));
end

% Extract delays
Td = totaldelay(sys);
if any(Td(:)),
   % Make all delay matrices ND
   Td = repmat(Td,[1 1 sizes(1+ndims(Td):end)]);
   
   % Add delay contribution
   if isct(sys),
      fresp = exp(-s*Td) .* fresp;
   else
      fresp = s.^(-Td) .* fresp;
   end
end

