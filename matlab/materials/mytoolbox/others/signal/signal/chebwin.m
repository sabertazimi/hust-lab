function w = chebwin(n_est, r)
%CHEBWIN Chebyshev window.
%    W = CHEBWIN(N,R) returns the N-point Chebyshev window 
%        with R decibels of ripple.
%
%   See also BARTLETT, BLACKMAN, BOXCAR, HAMMING, HANNING, KAISER
%   and TRIANG.

%   Author: James Montanaro
%   Reference: E. Brigham, "The Fast Fourier Transform and its Applications" 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/07/13 19:02:10 $

[n,w,trivalwin] = check_order(n_est);
if trivalwin, return, end;

w = chebwinx(n,r);
