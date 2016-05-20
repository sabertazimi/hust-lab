function y = dividenowarn(num,den)
% DIVIDENOWARN Divides two polynomials while supressing warnings.
% DIVIDENOWARN(NUM,DEN) array divides two polynomials but supresses warnings 
% to avoid "Divide by zero" warnings.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/08/21 15:08:36 $

s = warning; % Cache warning state
warning off  % Avoid "Divide by zero" warnings
y = (num./den);
warning(s);  % Reset warning state

% [EOF] dividenowarn.m