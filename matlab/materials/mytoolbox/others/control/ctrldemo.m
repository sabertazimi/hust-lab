echo off
%   CTRLDEMO shows the use of some of the control system design
%   and analysis tools available in MATLAB.

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.6 $  $Date: 1999/01/05 15:20:41 $
clc
clf
help ctrldemo
echo on
pause % Strike any key to continue.
clc
% Suppose we start with a plant description in transfer function
% form:                  
%                          2
%                     0.2 s  +  0.3 s  +  1
%        H(s)  =  ----------------------------
%                   2
%                 (s  +  0.4 s  +  1) (s + 0.5)
%
% The numerator is represented by the row vector of its coefficients.
% The denominator is the product of two polynomials.  This product is
% formed with the CONV command (convolution of polynomials):

num = [.2  .3  1];

p1 = [1 .4  1];
p2 = [1 .5];
den = conv(p1,p2);     % p1(s)*p2(s)

pause % Strike any key to continue.
clc
% Next we specify this plant as an LTI model with transfer function 
% H(s).  This is done with the function TF:

H = tf(num,den)


pause % Strike any key to continue.
clc
% We can look at the natural frequencies and damping factors of the
% plant poles:

damp(H)

% A root-locus of 1/(1 + k H(s)) can be obtained with RLOCUS

% Press any key to continue ...

rlocus(H); pause  % Press any key after plot ...

clc
% The step response of this LTI model is found by using the 
% STEP command:

step(H)

pause % Press any key after plot

clc
% The frequency response is found by using the BODE command:

bode(H)

pause % Press any key after plot
clc
% We can also design a linear-quadratic state-feedback regulator
% for this plant.  First we derive a state-space representation
%       .
%       x = Ax + Bu
%       y = Cx + Du
%
% using the SS command, and extract the state-space matrices with
% SSDATA:

Pss = ss(H)

[a,b,c,d] = ssdata(Pss);


pause % Strike any key to continue.
clc
% For the control and state weighting matrices

r = 1;
q = eye(size(a))

% the optimal LQ gain, the associated Riccati solution,
% and the closed-loop eigenvalues are given by

[k,s,e] = lqr(a,b,q,r)

echo off

% end ctrldemo
