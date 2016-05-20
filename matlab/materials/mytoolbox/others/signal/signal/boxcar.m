function w = boxcar(n_est)
%BOXCAR Boxcar window.
%   W = BOXCAR(N) returns the N-point rectangular window.
%
%   See also BARTLETT, BLACKMAN, CHEBWIN, HAMMING, HANNING, KAISER
%   and TRIANG.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1998/07/13 19:02:10 $

[n,w,trivalwin] = check_order(n_est);
if trivalwin, return, end;

w = ones(n,1);

