function x = dlyap(a,c)
%DLYAP	Discrete Lyapunov equation solver.
%
%    X = DLYAP(A,Q) solves the discrete Lyapunov equation:
%
%		A*X*A' - X + Q = 0
%
%    See also  LYAP.

%	J.N. Little 2-1-86, AFP 7-28-94
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.6 $  $Date: 1999/01/05 15:21:16 $

% How to prove the following conversion is true.  Re: show that if
%         (1) Ad X Ad' + Cd = X             Discrete lyaponuv eqn
%         (2) Ac = inv(Ad + I) (Ad - I)     From dlyap
%         (3) Cc = (I - Ac) Cd (I - Ac')/2  From dlyap
% Then
%         (4) Ac X + X Ac' + Cc = 0         Continuous lyapunov
% 
% Step 1) Substitute (2) into (3)
%         Use identity 2*inv(M+I) = I - inv(M+I)*(M-I) 
%                                 = I - (M-I)*inv(M-I) to show
%         (5) Cc = 4*inv(Ad + I)*Cd*inv(Ad' + I)
% Step 2) Substitute (2) and (5) into (4)
% Step 3) Replace (Ad - I) with (Ad + I -2I)
%         Replace (Ad' - I) with (Ad' + I -2I)
% Step 4) Multiply through and simplify to get
%         X -inv(Ad+I)*X -X*inv(Ad'+I) +inv(Ad+I)*Cd*inv(Ad'+I) = 0
% Step 5) Left multiply by (Ad + I) and right multiply by (Ad' + I)
% Step 6) Simplify to (1)

[m,n] = size(a);
a = (a+eye(m))\(a-eye(m));
c = (eye(m)-a)*c*(eye(m)-a')/2;
x = lyap(a,c);

% end dlyap
