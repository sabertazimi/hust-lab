function [xhat, yhat] = rceps(x)
%RCEPS Real cepstrum.
%   RCEPS(x) returns the real cepstrum of the sequence x.
%   [xh, yh] = RCEPS(x) returns both the real cepstrum and a
%   minimum phase signal derived from x.
%   See also CCEPS, HILBERT, and FFT.

%   Author(s): L. Shure, 6-9-88
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:43:35 $

%   References: 
%     [1] A.V. Oppenheim and R.W. Schafer, Digital Signal 
%         Processing, Prentice-Hall, 1975.
%     [2] Programs for Digital Signal Processing, IEEE Press,
%         John Wiley & Sons, 1979, algorithm 7.2.

n = length(x);
xhat = real(ifft(log(abs(fft(x)))));
if nargout > 1
   odd = fix(rem(n,2));
   wn = [1; 2*ones((n+odd)/2-1,1) ; ones(1-rem(n,2),1); zeros((n+odd)/2-1,1)];
   yhat = zeros(size(x));
   yhat(:) = real(ifft(exp(fft(wn.*xhat(:)))));
end

