function [kr,R0]=poly2rc(a,efinal)
%POLY2RC  Convert prediction polynomial to reflection coefficients. 
%   K = POLY2RC(A) returns the reflection coefficients, K, based on the 
%   prediction polynomial, A.
%
%   If A(1) is not equal to 1, POLY2RC normalizes the prediction
%   polynomial by A(1).
%
%   [K,R0] = POLY2RC(A,Efinal) returns the zero lag autocorrelation, R0, 
%   based on the final prediction error, Efinal. 
%
%   See also RC2POLY, POLY2AC, AC2POLY, RC2AC, AC2RC and TF2LATC.

%   References: S. Kay, Modern Spectral Estimation,
%               Prentice Hall, N.J., 1987, Chapter 6.
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/07/27 21:31:46 $

if (nargout == 2) & (nargin < 2),
    error('Final prediction error not specified.');
end

a = a(:);               % Convert to column vector if not already so
if a(1)~=1,
   a = a./a(1);         % Normalize when a(1) is not unity
end

% At this point nargin will be either 1 or 2.

p = length(a)-1;       % The leading one does not count

if nargin < 2,
    e(p) = 0;          % Default value when efinal is not specified
else
    e(p) = efinal;
end

kr(p) = a(end);

for k = p-1:-1:1,
    [a,e(k)] = levdown(a,e(k+1));
    kr(k) = a(end);
end 

% R0 is simply the zero order prediction error when 
% the prediction error filter, A(z) = 1. 
R0 = e(1)./(1-kr(1)'.*kr(1));

% Force kr to be a column vector
kr = kr(:); 

% [EOF] poly2rc.m
