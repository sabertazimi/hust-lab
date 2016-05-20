function [ab,bb,cb,db] = modred(a,b,c,d,elim)
%MODRED  Model state reduction.
%
%   RSYS = MODRED(SYS,ELIM) or RSYS = MODRED(SYS,ELIM,'mdc') reduces 
%   the order of the state-space model SYS by eliminating the states 
%   specified in vector ELIM.  The state vector is partitioned into X1, 
%   to be kept, and X2, to be eliminated,
%
%       A = |A11  A12|      B = |B1|    C = |C1 C2|
%           |A21  A22|          |B2|
%       .
%       x = Ax + Bu,   y = Cx + Du  (or discrete time counterpart).
%
%   The derivative of X2 is set to zero, and the resulting equations
%   solved for X1.  The resulting system has LENGTH(ELIM) fewer states
%   and can be envisioned as having set the ELIM states to be infinitely 
%   fast.  The original and reduced models have matching DC gains 
%   (steady-state response).
%
%   RSYS = MODRED(SYS,ELIM,'del') simply deletes the states X2.  This
%   typically produces a better approximation in the frequency domain,
%   but the DC gains are not guaranteed to match.
%
%   If SYS has been balanced with BALREAL and the gramians have M 
%   small diagonal entries, you can reduce the model order by 
%   eliminating the last M states with MODRED.
%
%   See also BALREAL, SS.

% Old help
%warning(['This calling syntax for ' mfilename ' will not be supported in the future.'])
%MODRED Model state reduction.
%   [Ab,Bb,Cb,Db] = MODRED(A,B,C,D,ELIM) reduces the order of a model
%   by eliminating the states specified in vector ELIM.  The state
%   vector is partioned into X1, to be kept, and X2, to be eliminated,
%
%       A = |A11  A12|      B = |B1|    C = |C1 C2|
%           |A21  A22|          |B2|
%       .
%       x = Ax + Bu,   y = Cx + Du
%
%   The derivative of X2 is set to zero, and the resulting equations
%   solved for X1.  The resulting system has LENGTH(ELIM) fewer states
%   and can be envisioned as having set the ELIM states to be 
%   infinitely fast.
%
%   See also BALREAL and DMODRED

%   J.N. Little 9-4-86
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.6 $  $Date: 1999/01/05 12:08:54 $

error(nargchk(5,5,nargin));
rsys = modred(ss(a,b,c,d),elim);
[ab,bb,cb,db] = ssdata(rsys);

% end modred

