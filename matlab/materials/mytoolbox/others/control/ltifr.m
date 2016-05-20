%LTIFR	Linear time-invariant frequency response kernel.
%
%	G = LTIFR(A,b,S) calculates the frequency response of the
%	system:
%		 G(s) = (sI - A)\b
%
%	for the complex frequencies in vector S. Column vector b
%	must have as many rows as matrix A. Matrix G is returned
%	with SIZE(A) rows and LENGTH(S) columns.
%	Here is what it implements, in high speed:
%
%		function g = ltifr(a,b,s)
%		ns = length(s); na = length(a);
%		e = eye(na); g = sqrt(-1) * ones(na,ns);
%		for i=1:ns
%		    g(:,i) = (s(i)*e-a)\b;
%		end
%

%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.4 $  $Date: 1999/01/05 15:21:32 $

% built-in function
