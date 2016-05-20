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
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.6 $  $Date: 1998/05/05 13:53:41 $

error(nargchk(2,2,nargin))
if length(s)~=1,
   error('Use FREQRESP for vectors of frequencies.')
end

% Evaluate rational part of the response
num = sys.num;
den = sys.den;
sizes = size(num);
fresp = zeros(sizes);
for k=1:prod(sizes),
   fresp(k) = polyval(num{k},s)/polyval(den{k},s);
end

% Extract I/O delays and add their contribution
Td = totaldelay(sys);
if any(Td(:)),
   % Make all delay matrices ND
   sizes = size(sys.num);
   Td = repmat(Td,[1 1 sizes(1+ndims(Td):end)]);
   
   % Add delay contribution
   if isct(sys),
      fresp = exp(-s*Td) .* fresp;
   else
      fresp = s.^(-Td) .* fresp;
   end
end
