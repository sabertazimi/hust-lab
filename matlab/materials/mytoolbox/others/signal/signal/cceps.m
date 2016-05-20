function [xhat,nd,xhat1] = cceps(x,n)
%CCEPS Complex cepstrum.
%   CCEPS(x) returns the complex cepstrum of the (assumed real) sequence x.
%   The input is altered to have no phase discontinuity at +/- pi radians
%   by the application of a linear phase term (that is, it is circularly
%   shifted (after zero-padding) by some samples if necessary to have zero 
%   phase at pi radians).
%
%   [xhat,nd] = CCEPS(x) returns the number of samples nd of (circular)
%   delay added to x prior to finding the complex cepstrum.
%
%   [xhat,nd,xhat1] = CCEPS(x) returns the complex cepstrum in XHAT1 using 
%   an alternate rooting algorithm. XHAT1 can be used to verify XHAT for 
%   short sequences that can be rooted and do not have zeros on the unit circle.
%
%   CCEPS(x,n) zero-pads x to length n, and returns the length
%   n complex cepstrum of x.
%
%   See also ICCEPS, RCEPS, HILBERT, and FFT.

%   Author(s): L. Shure, 6-9-88
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:12 $

%   References: 
%     [1] A.V. Oppenheim and R.W. Schafer, Digital Signal 
%         Processing, Prentice-Hall, 1975.
%     [2] Programs for Digital Signal Processing, IEEE Press,
%         John Wiley & Sons, 1979, algorithm 7.1.

if nargin < 2
    h = fft(x);
else
    h = fft(x,n);
end
[ah,nd] = rcunwrap(angle(h));
logh = log(abs(h))+i*ah;
xhat = real(ifft(logh));

if nargout==3
% use alternate rooting algorithm to check original result
% Oppenheim & Schafer, p.795
%   - doesn't work with zeros on the unit circle
%   - only works for short sequences that can be rooted 
    r = roots(x);
    xx = poly(r);
    ind = find(xx~=0);
    A = mean(x(ind)./xx(ind));

    % n > 0 contributions are from zeros inside the unit circle
    a = r(find(abs(r)<=1));
    n = 1:length(x)-1;
    [a,n]=meshgrid(a,n');
    xhat1 = [log(abs(A)); -((a.^n)./n)*ones(size(a,2),1)];

    % n < 0 contributions are from zeros outside the unit circle
    b = 1./r(find(abs(r)>1));
    n = -(length(x)-1):-1;
    [b,n]=meshgrid(b,n');
    xhat1 = xhat1 + [0; ((b.^(-n))./n)*ones(size(b,2),1)];

    if size(x,1)==1
        xhat1 = xhat1';
    end
end

function [y,nd] = rcunwrap(x)
%RCUNWRAP Phase unwrap utility used by CCEPS.
%   RCUNWRAP(X) unwraps the phase and removes phase corresponding
%   to integer lag.  See also: UNWRAP, CCEPS.

%   Author(s): L. Shure, 1988
%   	   L. Shure and help from PL, 3-30-92, revised

n = length(x);
y = unwrap(x);
nh = fix((n+1)/2);
nd = round(y(nh+1)/pi);
y(:) = y(:)' - pi*nd*(0:(n-1))/nh;

