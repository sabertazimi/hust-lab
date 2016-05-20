function ob = obsv(a,c)
%OBSV  Compute the observability matrix.
%
%   OB = OBSV(A,C) returns the observability matrix [C; CA; CA^2 ...]
%
%   CO = OBSV(SYS) returns the observability matrix of the 
%   state-space model SYS with realization (A,B,C,D).  This is 
%   equivalent to OBSV(sys.a,sys.c).
%
%   For ND arrays of state-space models SYS, OB is an array with N+2
%   dimensions where OB(:,:,j1,...,jN) contains the observability 
%   matrix of the state-space model SYS(:,:,j1,...,jN).  
%
%   See also OBSVF, SS.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1999/01/05 12:09:02 $

error(nargchk(2,2,nargin))

n = size(a,1);
ob = c;
for i=1:n-1
    ob = [c; ob*a];
end

