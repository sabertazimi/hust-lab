function y=sinc(x)
%SINC Sin(pi*x)/(pi*x) function.
%   SINC(X) returns a matrix whose elements are the sinc of the elements 
%   of X, i.e.
%        y = sin(pi*x)/(pi*x)    if x ~= 0
%          = 1                   if x == 0
%   where x is an element of the input matrix and y is the resultant
%   output element.
%
%   See also SQUARE, SIN, COS, CHIRP, DIRIC, GAUSPULS, PULSTRAN, RECTPULS,
%   and TRIPULS.

%   Author(s): T. Krauss, 1-14-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1998/07/13 19:02:12 $

y=ones(size(x));
i=find(x);
y(i)=sin(pi*x(i))./(pi*x(i));
