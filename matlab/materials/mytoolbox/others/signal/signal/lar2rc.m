function k = lar2rc(g)
%LAR2RC Convert log area ratios to reflection coefficients.
%   K = LAR2RC(G) returns the reflection coefficients, K, based on the 
%   log area ratios, G.
%
%   See also RC2LAR, POLY2RC, AC2RC, IS2RC.

%   References:
%   [1] J. Makhoul, "Linear Prediction: A Tutorial Review," Proc. IEEE,
%   Vol.63, No.4, pp.561-580, Apr 1975.
%   [2] ITU-T Recommendation G.729 (03/96)
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/07/24 16:12:13 $

if ~isreal(g),
    error('Log area ratios must be real.');
end

% Use the relation, tanh(x) = (1-exp(2x))/(1+exp(2x))
k = -tanh(-g/2);

% [EOF] lar2rc.m