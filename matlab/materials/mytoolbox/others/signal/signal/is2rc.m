function k = is2rc(inv_sin)
%IS2RC  Convert inverse sine parameters to reflection coefficients.
%   K = IS2RC(INV_SIN) returns the reflection coefficients corresponding 
%   to the inverse sine parameters, INV_SIN. 
%
%   See also RC2IS, POLY2RC, AC2RC, LAR2RC.

%   Reference: J.R. Deller, J.G. Proakis, J.H.L. Hansen, "Discrete-Time 
%   Processing of Speech Signals", Prentice Hall, Section 7.4.5.
%
%   Author(s): A. Ramasubramanian
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/07/24 16:12:13 $

if ~isreal(inv_sin),
    error('Inverse sine parameters must be real.');
end

k = sin(inv_sin*pi/2);

% [EOF] is2rc.m