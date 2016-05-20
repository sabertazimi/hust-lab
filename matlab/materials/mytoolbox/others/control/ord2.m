function [a,b,c,d] = ord2(wn, z)
%ORD2   Generate continuous second order system.
%
%   [A,B,C,D] = ORD2(Wn, Z) returns the A,B,C,D representation of the
%   continuous second order system with natural frequency Wn and 
%   damping factor Z.
%
%   [NUM,DEN] = ORD2(Wn,Z) returns the polynomial transfer function of
%   the second order system.
%
%   See also: RMODEL, RSS.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:23:00 $

error(nargchk(2,2,nargin));

if nargout==4,      % Generate state space system
  a = [0 1;-wn*wn, -2*z*wn];
  b = [0;1];
  c = [1 0];
  d = 0;
else
  a = 1;
  b = [1 2*z*wn wn*wn];
end
