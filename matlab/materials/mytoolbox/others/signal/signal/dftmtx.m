function b = dftmtx(n)
%DFTMTX Discrete Fourier transform matrix.
%   DFTMTX(N) is the N-by-N complex matrix of values around
%   the unit-circle whose inner product with a column vector
%   of length N yields the discrete Fourier transform of the
%   vector.  DFTMTX(LENGTH(X))*X is the same as FFT(X).
%
%   The inverse discrete Fourier transform matrix is
%   CONJ(DFTMTX(N))/N.   See also FFT and IFFT.

%   Author(s): C. Denham, 7-21-88
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:25 $

f = 2*pi/n;     % Angular increment.
w = (0:f:2*pi-f/2).' * i;   % Column.
x = 0:n-1;      % Row.
b = exp(-w*x);  % Exponentiation of outer product.

