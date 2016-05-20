function [a,e] = arcov( x, p)
%ARCOV   AR parameter estimation via covariance method.
%   A = ARCOV(X,ORDER) returns the polynomial A corresponding to the AR
%   parametric signal model estimate of vector X using the Covariance method.
%   ORDER is the model order of the AR system.
%
%   [A,E] = ARCOV(...) returns the variance estimate E of the white noise
%   input to the AR model.
%
%   See also PCOV, ARMCOV, ARBURG, ARYULE, LPC, PRONY.

%   Ref: S. Kay, MODERN SPECTRAL ESTIMATION,
%              Prentice-Hall, 1988, Chapter 7
%        P. Stoica and R. Moses, INTRODUCTION TO SPECTRAL ANALYSIS,
%              Prentice-Hall, 1997, Chapter 3

%   Author(s): R. Losada and P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/07/20 18:27:49 $

error(nargchk(2,2,nargin))
[mx,nx] = size(x);
if isempty(x) | length(x) < 2*p | min(mx,nx) > 1,
   error('X must be a vector with length greater than twice the model order.');
elseif isempty(p) | ~(p == round(p))
   error('Model order must be an integer.')
end
if issparse(x),
   error('Input signal cannot be sparse.')
end

x  = x(:);
N  = length(x);

% Generate N+p-1 by p convolution matrix
XM = convmtx(x,p);
Xc = XM(p:N-1, :);
X1 = XM(p+1:N, 1);

% Coefficients estimated via the covariance method
a = [1; -Xc\X1];


% Estimate the input white noise variance
Cz = X1'*Xc;
e = 1/(N-p)*(X1'*X1 + Cz*a(2:end));
e = real(e); %ignore the possible imaginary part due to numerical errors

a = a(:).'; % By convention all polynomials are row vectors