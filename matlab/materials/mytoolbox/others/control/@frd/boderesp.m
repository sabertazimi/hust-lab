function [mag,phase,w] = boderesp(sys,w,NoW)
%BODERESP   Computes the Bode response MAG and PHASE of the single
%           FRD model SYS over the frequency grid w.
%
%    WARNING: BODERESP MAY MODIFY W (WHEN W IS UNSPECIFIED).
%
%    LOW-LEVEL FUNCTION.

%   Author(s)  S. Almy, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/08/25 22:08:27 $

% Retrieve complex frequency response (ignore delays at this point)
% NOTE: w always in rad/s
try 
   h = freqresp(sys,w);
catch
   error(lasterr)
end

% Calculate mag and phase
mag = abs(h);
% Comment out only one of next two lines for (un)wrapping
% Note that phase unwrapping will not always work; it is
% only a "guess" as to whether +-360 should be added to the phase 
% to make it more aesthetically pleasing.  (See UNWRAP.M)
%phase = (180/pi)*atan2(imag(h),real(h));
phase = (180/pi)*unwrap(atan2(imag(h),real(h)),[],3);
