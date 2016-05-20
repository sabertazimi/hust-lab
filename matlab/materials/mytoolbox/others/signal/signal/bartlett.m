function w = bartlett(n_est)
%BARTLETT Bartlett window.
%   W = BARTLETT(N) returns the N-point Bartlett window.
%
%   See also BLACKMAN, BOXCAR, CHEBWIN, HAMMING, HANNING, KAISER
%   and TRIANG.


%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1998/07/13 19:02:10 $

[n,w,trivalwin] = check_order(n_est);
if trivalwin, return, end;

w = 2*(0:(n-1)/2)/(n-1);
if rem(n,2)
	% It's an odd length sequence
	w = [w w((n-1)/2:-1:1)]';
else
	% It's even
	w = [w w(n/2:-1:1)]';
end


