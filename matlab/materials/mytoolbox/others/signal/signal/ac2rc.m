function [k,R0]=ac2rc(R)
%AC2RC  Convert autocorrelation sequence to reflection coefficients. 
%   [K,R0] = AC2RC(R) returns the reflection coefficients, K, and the zero lag
%   autocorrelation, R0, based on the autocorrelation sequence, R.
%
%   See also RC2AC, POLY2RC, RC2POLY, POLY2AC, AC2POLY.

%   References: S. Kay, Modern Spectral Estimation,
%               Prentice Hall, N.J., 1987, Chapter 6.
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/08/24 16:04:34 $

[a_unused,efinal,k] = levinson(R);
R0 = R(1);

% [EOF] ac2rc.m

