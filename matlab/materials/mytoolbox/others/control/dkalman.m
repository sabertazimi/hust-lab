%KALMAN  Continuous or discrete Kalman estimator
%
%     Additional help on discrete-time Kalman estimators
%     --------------------------------------------------
%
%   [KEST,L,P,M,Z] = KALMAN(SYS,Qn,Rn,Nn)  produces a discrete 
%   Kalman estimator KEST when the LTI plant SYS is discrete.
%   Given the plant
%
%      x[n+1] = Ax[n] + Bu[n] + Gw[n]           {State equation}
%      y[n]   = Cx[n] + Du[n] + Hw[n] + v[n]    {Measurements}
%
%   with known inputs u, process noise w, measurement noise v, 
%   and noise covariances
%
%      E{ww'} = Qn,     E{vv'} = Rn,     E{wv'} = Nn,
%
%   the resulting Kalman estimator
%
%      x[n+1|n] = Ax[n|n-1] + Bu[n] + L(y[n] - Cx[n|n-1] - Du[n])
%
%       y[n|n]  = Cx[n|n] + Du[n]
%       x[n|n]  = x[n|n-1] + M(y[n] - Cx[n|n-1] - Du[n])
%
%   generates optimal output and state estimates  y[n|n] and x[n|n] 
%   using u[n] and y[n] as inputs (in this order).  The estimator 
%   state x[n|n-1] is the best estimate of x[n] given the past 
%   measurements y[n-1], y[n-2],...
%
%   Also returned are the estimator and innovation gains L and M, 
%   and the steady-state error covariances
%
%       P = E{(x - x[n|n-1])(x - x[n|n-1])'}   (Riccati solution)
%       Z = E{(x - x[n|n])(x - x[n|n])'}       (Updated estimate)

%   Author(s): P. Gahinet  8-1-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:21:14 $

% end dkalman
