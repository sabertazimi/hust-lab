function [Phi, Gamma] = c2d(a, b, t)
%C2D  Conversion of continuous-time models to discrete time.
%
%   SYSD = C2D(SYSC,TS,METHOD) converts the continuous-time LTI 
%   model SYSC to a discrete-time model SYSD with sample time TS.  
%   The string METHOD selects the discretization method among the 
%   following:
%      'zoh'       Zero-order hold on the inputs.
%      'foh'       Linear interpolation of inputs (triangle appx.)
%      'tustin'    Bilinear (Tustin) approximation.
%      'prewarp'   Tustin approximation with frequency prewarping.  
%                  The critical frequency Wc is specified as fourth 
%                  input by C2D(SYSC,TS,'prewarp',Wc).
%      'matched'   Matched pole-zero method (for SISO systems only).
%   The default is 'zoh' when METHOD is omitted.
%
%   For state-space models SYS and the 'zoh' or 'foh' methods,
%      [SYSD,G] = C2D(SYSC,TS,METHOD)
%   also returns a matrix G that maps continuous initial conditions
%   into discrete initial conditions.  Specifically, if x0,u0 are
%   initial states and inputs for SYSC, then equivalent initial
%   conditions for SYSD are given by
%      xd0 = G * [x0;u0],     ud0 = u0 .
%
%   See also D2C, D2D, LTIMODELS.

%Other syntax
%C2D	Conversion of state space models from continuous to discrete time.
%	[Phi, Gamma] = C2D(A,B,T)  converts the continuous-time system:
%		.
%		x = Ax + Bu
%
%	to the discrete-time state-space system:
%
%		x[n+1] = Phi * x[n] + Gamma * u[n]
%
%	assuming a zero-order hold on the inputs and sample time T.
%
%	See also D2C.

%	J.N. Little 4-21-85
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.9 $  $Date: 1999/01/05 12:08:27 $

error(nargchk(3,3,nargin));
error(abcdchk(a,b));

[m,n] = size(a);
[m,nb] = size(b);
s = expm([[a b]*t; zeros(nb,n+nb)]);
Phi = s(1:n,1:n);
Gamma = s(1:n,n+1:n+nb);

% end c2d
