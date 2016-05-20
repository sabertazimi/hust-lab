function v = eig(sys)
%EIG  Find the poles of an LTI system.
%
%   P = EIG(SYS)  returns the poles of SYS  (P is a column vector).
%
%   For state-space models, the poles are the eigenvalues of the A 
%   matrix or the generalized eigenvalues of the (A,E) pair in the 
%   descriptor case.
%
%   See also  DAMP, ESORT, DSORT, PZMAP, TZERO.

%       Author(s): A. Potvin, 3-1-94, 11-10-95, P. Gahinet, 5-1-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.3 $  $Date: 1997/12/01 22:04:40 $

% Call POLE
v = pole(sys);

% end ../@lti/eig.m
