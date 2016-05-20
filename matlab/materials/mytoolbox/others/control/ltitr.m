%LTITR	Linear time-invariant time response kernel.
%
%   X = LTITR(A,B,U) calculates the time response of the
%   system:
%           x[n+1] = Ax[n] + Bu[n]
%
%   to input sequence U.  The matrix U must have as many columns as
%   there are inputs u.  Each row of U corresponds to a new time 
%   point.  LTITR returns a matrix X with as many columns as the
%   number of states x, and with LENGTH(U) rows.
%
%   LTITR(A,B,U,X0) can be used if initial conditions exist.
%   Here is what it implements, in high speed:
%
%	for i=1:n
%          x(:,i) = x0;
%          x0 = a * x0 + b * u(i,:).';
%	end
%	x = x.';

%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.5 $  $Date: 1999/01/05 15:21:35 $

% built-in function
