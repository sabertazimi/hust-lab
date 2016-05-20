function co = ctrb(a,b)
%CTRB  Compute the controllability matrix.
%
%   CO = CTRB(A,B) returns the controllability matrix [B AB A^2B ...].
%
%   CO = CTRB(SYS) returns the controllability matrix of the 
%   state-space model SYS with realization (A,B,C,D).  This is
%   equivalent to CTRB(sys.a,sys.b).
%
%   For ND arrays of state-space models SYS, CO is an array with N+2
%   dimensions where CO(:,:,j1,...,jN) contains the controllability 
%   matrix of the state-space model SYS(:,:,j1,...,jN).  
%
%   See also CTRBF, SS.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1999/01/05 12:08:31 $

error(nargchk(2,2,nargin))

n = size(a,1);
co = b;
for i=1:n-1,
   co = [b a*co];
end
