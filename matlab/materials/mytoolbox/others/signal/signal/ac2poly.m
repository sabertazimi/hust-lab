function [a,efinal]=ac2poly(R)
%AC2POLY  Convert autocorrelation sequence to prediction polynomial.
%   [A,Efinal]=AC2POLY(R) returns the prediction polynomial, A, and the final 
%   prediction error, Efinal, based on the autocorrelation sequence, R.
%
%   See also POLY2AC, POLY2RC, RC2POLY, RC2AC, AC2RC. 


%   References: S. Kay, Modern Spectral Estimation,
%               Prentice Hall, N.J., 1987, Chapter 6.
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/07/13 19:03:23 $

% Use levinson recursion for this. Note that matrix inversion 
% could be used for small orders.

[a,efinal] = levinson(R);

% [EOF] ac2poly.m         


