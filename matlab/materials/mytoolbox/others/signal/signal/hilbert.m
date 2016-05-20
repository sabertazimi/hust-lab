function y = hilbert(x)
%HILBERT Hilbert transform.
%   HILBERT(X) is the Hilbert transform of the real part
%   of vector X.  The real part of the result is the original
%   real data; the imaginary part is the actual Hilbert
%   transform.  See also FFT and IFFT.
%
%   If X is a signal matrix, HILBERT(X) transforms the columns
%   of X independently.

%   Author(s): C. Denham, 1-7-88
%   	   L. Shure, 11-19-88, 5-22-90 - revised
%   	   K. Creager, 3-19-92, modified to use power of 2 FFT
%   	   T. Krauss, 11-4-92, revised
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:52 $

%   Reference(s):
%     [1] Jon Claerbout, Introduction to Geophysical Data Analysis.

[r,c] = size(x);
if r == 1
	x = x.';   % make it a column
end;
[n,cc] = size(x);
m = 2^nextpow2(n);
y = fft(real(x),m);
if m ~= 1
   h = [1; 2*ones(fix((m-1)/2),1); ones(1-rem(m,2),1); zeros(fix((m-1)/2),1)];
   y(:) = y.*h(:, ones(1,cc) );
end
y = ifft(y,m);
y = y(1:n,:);
if r == 1
   y = y.';
end

