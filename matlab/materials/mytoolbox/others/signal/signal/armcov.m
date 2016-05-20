function [a,e] = armcov( x, p)
%ARMCOV   AR parameter estimation via modified covariance method.
%   A = ARMCOV(X,ORDER) returns the polynomial A corresponding to the AR
%   parametric signal model estimate of vector X using the Modified Covariance
%   method. ORDER is the model order of the AR system. 
%
%   [A,E] = ARMCOV(...) returns the variance estimate E of the white noise
%   input to the AR model.
%
%   See also PMCOV, ARCOV, ARBURG, ARYULE, LPC, PRONY.

%   References:
%     [1] S. Lawrence Marple, DIGITAL SPECTRAL ANALYSIS WITH APPLICATIONS,
%              Prentice-Hall, 1987, Chapter 8
%     [2] Steven M. Kay, MODERN SPECTRAL ESTIMATION THEORY & APPLICATION,
%              Prentice-Hall, 1988, Chapter 7

%   Author(s): R. Losada and P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/07/20 18:27:49 $

error(nargchk(2,2,nargin))
[mx,nx] = size(x);
if isempty(x) | length(x) < 3*p/2 | min(mx,nx) > 1,
   error('X must be a vector with length greater than three halves of the model order.');
elseif isempty(p) | ~(p == round(p))
   error('Model order must be an integer.')
end
if issparse(x),
   error('Input signal cannot be sparse.')
end

x = x(:);
N = length(x);

% Generate the Modified matrix using the following summation:
%           N-1
%rx(k,l) =  SUM[x(n-l)x*(n-k)+x*(n-p+l)x(n-p+k)]           % * = conjugate
%           n=p
%
XM = toeplitz(x(p+1:N),x(p+1:-1:1));
xR  = XM'*XM;
Rp = xR+flipud(XM.')*fliplr(conj(XM));
Rp1 = Rp(2:end,2:end);
R1 = Rp(2:end,1);

% Coefficients estimated via the modified covariance method
a = [1; -Rp1\R1];


% Estimate the input white noise variance
Ck = xR(1,1)+xR(end,end);
Cz = xR(1,2:end) + x(1:N-p).'*conj(XM(:,end-1:-1:1));
e = 0.5/(N-p)*(Ck + Cz*a(2:end));
e = real(e); %ignore the possible imaginary part due to numerical errors

a = a(:).'; % By convention all polynomials are row vectors

