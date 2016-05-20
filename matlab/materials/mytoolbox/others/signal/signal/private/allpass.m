function [DH,DW] = allpass(N, F, GF, W)
%ALLPASS Desired frequency response for allpass filters.
%   CREMEZ(N,F,'allpass', ...) designs a nonlinear phase allpass filter
%   using CREMEZ by adding a quadratic component (4/pi)*(omega)^2 to the
%   usual linear phase found in a symmetric FIR filter .
%
%   See also CREMEZ.

%   Authors: J. McClellan
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/08/28 18:35:42 $

error(nargchk(4,4,nargin));

DH = exp(-1i*pi*GF*N/2 + 1i*pi*pi*sign(GF).*GF.*GF*(4/pi));
DW = ones(size(GF));

% [EOF] allpass.m
