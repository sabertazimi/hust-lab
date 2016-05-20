function [k,s,e] = dlqry(a,b,c,d,q,r,varargin)
%DLQRY  Linear quadratic regulator design with output weighting for 
%   discrete-time systems.
%
%   [K,S,E] = DLQRY(A,B,C,D,Q,R)  calculates the optimal feedback gain
%   matrix K such that the feedback law  u[n] = -Kx[n]  minimizes the
%   cost function
%
%       J = Sum {y'Qy + u'Ru}
%
%   subject to the constraint equation:   
%
%       x[n+1] = Ax[n] + Bu[n] 
%         y[n] = Cx[n] + Du[n]
%                
%   Also returned is S, the steady-state solution to the associated 
%   discrete matrix Riccati equation and the closed loop eigenvalues
%   E = EIG(A-B*K).
%
%   The controller can be formed with DREG.
%
%   See also: DLQR, LQRD, and DREG.

%   Clay M. Thompson  7-23-90
%   Revised: P. Gahinet  7-25-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:22:06 $

ni = nargin;
error(nargchk(6,7,nargin));

% Check dimensions 
error(abcdchk(a,b,c,d));

% Call lti/lqry
[k,s,e] = lqry(ss(a,b,c,d,-1),q,r,varargin{:});

% end dlqry
