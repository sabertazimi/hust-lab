function [a,efinal]=rc2poly(kr,R0)
%RC2POLY Convert reflection coefficients to prediction polynomial.
%   A = RC2POLY(K) computes the prediction polynomial, A, based on the
%   reflection coefficients, K.
%
%   [A,Efinal] = RC2POLY(K,R0) returns the final prediction error, Efinal, 
%   based on the zero lag autocorrelation, R0.
%
%   See also POLY2RC, RC2AC, AC2RC, AC2POLY, POLY2AC.

%   References: S. Kay, Modern Spectral Estimation,
%               Prentice Hall, N.J., 1987, Chapter 6.
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/07/27 21:31:46 $

% Initialize the recursion
kr = kr(:);               % Force kr to be a column vector.
p = length(kr);           % p is the order of the prediction polynomial.
a = [1 kr(1)];            % a is a true polynomial.

if (nargout == 2) & (nargin < 2),
    error('Zero lag autocorrelation, R0, not specified.');
end

% At this point nargin will be either 1 or 2
if nargin < 2,
    e0 = 0;  % Default value when e0 is not specified
else
    e0 = R0;
end
e(1) = e0.*(1-kr(1)'.*kr(1));

% Continue the recursion for k=2,3,...,p, where p is the order of the 
% prediction polynomial.

for k = 2:p,  
    [a,e(k)] = levup(a,kr(k),e(k-1));
end

efinal = e(end);

% [EOF] rc2poly.m

