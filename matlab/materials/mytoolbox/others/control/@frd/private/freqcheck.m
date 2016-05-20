function [freqs,units] = freqcheck(freqsLHS,unitsLHS,freqsRHS,unitsRHS)
%FREQCHECK  Check compatibility of frequency vectors, considering units.
%           If either system has units of rad/s, return frequencies in
%           rad/s, otherwise, return frequencies in Hz.

%   Author: S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/08/25 22:08:25 $


freqs = freqsLHS;
units = unitsLHS;
reltol = 1e3*eps;

% Unit alignment
if ~strcmpi(unitsLHS,unitsRHS)
   % Convert units to rad/sec
   if strncmpi(unitsRHS,'h',1)
      freqsRHS = freqsRHS*2*pi;
   else
      freqsLHS = freqsLHS*2*pi;
      freqs = freqsRHS;
      units = unitsRHS;
   end
end

% The frequency points in FREQLHS and FREQRHS should now match
% up to round-off errors of level RELTOL
if length(freqsLHS) ~= length(freqsRHS)
   error('Size mismatch. Length of frequency vectors must match.')
elseif any(abs(freqsLHS-freqsRHS)>reltol*(1+freqsLHS))
   error('Frequency points don''t match (taking units into account).');
end
