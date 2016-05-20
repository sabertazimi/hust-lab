function w = blackman(n_est,sflag)
%BLACKMAN Blackman window.
%   W = BLACKMAN(N) returns the N-point symmetric Blackman window
%       in a column vector.
%   W = BLACKMAN(N,SFLAG) generates the N-point Blackman window 
%       using SFLAG window sampling. SFLAG may be either 'symmetric' 
%       or 'periodic'. By default, 'symmetric' window sampling is used. 
%
%   See also BARTLETT, BOXCAR, CHEBWIN, HAMMING, HANNING, KAISER
%   and TRIANG.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1998/07/13 19:02:10 $

error(nargchk(1,2,nargin));

[n,w,trivalwin] = check_order(n_est);
if trivalwin, return, end;

% Set sflag to default if it's not already set:
if nargin == 1,
   sflag = 'symmetric';
end

switch lower(sflag),
case 'periodic'
   w = sym_blackman(n+1);
   w = w(1:end-1);
case 'symmetric'
   w = sym_blackman(n);
otherwise
	error('Sampling must be either ''symmetric'' or ''periodic''');
end

function w = sym_blackman(n)
w = (.42 - .5*cos(2*pi*(0:n-1)/(n-1)) + .08*cos(4*pi*(0:n-1)/(n-1)))';

