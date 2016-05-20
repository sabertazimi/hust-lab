function w = hanning(n_est,sflag)
%HANNING Hanning window.
%   HANNING(N) returns the N-point symmetric Hanning window 
%   in a column vector.  Note that the first and last zero-
%   weighted window samples are not included.
%
%   HANNING(N,'symmetric') returns the same result as HANNING(N).
%
%   HANNING(N,'periodic') returns the N-point periodic Hanning
%   window, and includes the first zero-weighted window sample.
%
%   See also BARTLETT, BLACKMAN, BOXCAR, CHEBWIN, HAMMING, KAISER
%   and TRIANG.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/11/10 18:47:45 $

error(nargchk(1,2,nargin));

[n,w,trivalwin] = check_order(n_est);
if trivalwin, return, end;

% Set sflag to default if it's not already set:
if nargin == 1,
   sflag = 'symmetric';
end

switch lower(sflag),
case 'periodic'
   w = [0;sym_hanning(n-1)];
case 'symmetric'
   w = sym_hanning(n);
otherwise
	error('Sampling must be either ''symmetric'' or ''periodic''');
end

function w = sym_hanning(n)
w = .5*(1 - cos(2*pi*(1:n)'/(n+1)));

% [EOF] hanning.m
