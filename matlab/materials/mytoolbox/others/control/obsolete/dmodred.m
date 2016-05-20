function [ab,bb,cb,db] = dmodred(a,b,c,d,elim)
%DMODRED Discrete-time model state reduction.
%   [Ab,Bb,Cb,Db] = DMODRED(A,B,C,D,ELIM) reduces the order of a model
%   by eliminating the states specified in vector ELIM.  The state
%   vector is partioned into X1, to be kept, and X2, to be eliminated,
%
%       A = |A11  A12|      B = |B1|    C = |C1 C2|
%           |A21  A22|          |B2|
%       
%       x[n+1] = Ax[n] + Bu[n],   y[n] = Cx[n] + Du[n]
%
%   X2[n+1] is set to X2[n], and the resulting equations solved for
%   X1.  The resulting system has LENGTH(ELIM) fewer states and can be
%   envisioned as having set the ELIM states to be infinitely fast.
%
%   See also DBALREAL, BALREAL and MODRED

%   J.N. Little 9-4-86
%   Revised 8-26-87 JNL
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:22:08 $

error(nargchk(5,5,nargin));
rsys = modred(ss(a,b,c,d,-1),elim);
[ab,bb,cb,db] = ssdata(rsys);

% end modred

